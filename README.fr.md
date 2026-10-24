# Lab JupyterLab de science des données avec Docker Compose : pandas, NumPy, Matplotlib et scikit-learn sur un vrai fichier CSV

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml)

Un **lab JupyterLab de science des données** prêt à l’emploi pour la classe, proposé par la [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), où les lycées, les établissements d’enseignement supérieur et les universités donnent à chaque élève ses propres bases de données, conteneurs et terminal dans le navigateur. Chaque élève reçoit son propre **JupyterLab** avec **pandas**, **NumPy**, **Matplotlib** et **scikit-learn** déjà installés, une année de locations de vélos avec la météo, un notebook de départ et cinq petits scripts : il charge les données dans un DataFrame, les résume, compare des groupes, trace un graphique et ajuste une première régression linéaire. Rien à installer, et aucun environnement Python à réparer sur trente ordinateurs.

C’est un seul fichier `docker-compose`, `compose.yaml`, qui tourne de la même façon sur votre machine et sur la plateforme, où chaque élève a une copie privée sans aucun accès à internet.

## Ce qu’il contient

| Service | Image | Mémoire | Ce que c’est |
| --- | --- | --- | --- |
| `jupyter` | [`jupyter/scipy-notebook:2023-10-20`](https://hub.docker.com/r/jupyter/scipy-notebook) | 512 Mo | JupyterLab 4.0.7 sur Python 3.11, avec pandas 2.1, NumPy 1.24, Matplotlib 3.8 et scikit-learn 1.3 |

Le service écrit trois choses dans son dossier de travail, `/home/jovyan/work`, puis lance JupyterLab sur le port 8888 :

- **`hires.csv`**, une ligne pour chaque jour de 2025 (365 lignes) et sept colonnes : `date`, `month`, `weekday`, `weather` (sunny, cloudy ou rainy), `temp_c`, `rain_mm` et `hires`, le nombre de vélos loués ce jour-là. Les chiffres sont inventés à partir d’une graine fixe : chaque copie a exactement les mêmes données, et rien n’est téléchargé.
- **`start.ipynb`**, un notebook de départ qui charge les données, les décrit, compare la météo, trace les locations en fonction de la température et ajuste une régression linéaire, avec une cellule vide à la fin pour la question de l’élève.
- **`steps/`**, de petits scripts qui font la même chose, une idée à la fois. La leçon de base en utilise cinq : `load.py`, `summary.py`, `weather.py`, `picture.py` (qui enregistre `hires.png`) et `model.py` ; les autres servent au module de science des données.

Il est prêt en quelques secondes et utilise environ 75 Mo au repos et environ 235 Mo quand le noyau d’un notebook tourne, bien en dessous de ses 512 Mo.

L’image est celle des Jupyter Docker Stacks, lancée sans modification et figée sur une étiquette datée (jamais `latest`), pour que le lab ne change pas sous une classe d’une séance à l’autre. C’est la dernière étiquette publiée par le projet sur Docker Hub, d’où la plateforme tire les images des labs ; elle est lourde, environ 1,3 Go à télécharger. Rien n’est construit ici et rien de ce dépôt n’y est distribué.

**JupyterLab ne demande ni jeton ni mot de passe.** Sur la plateforme, la page web d’un lab ne s’atteint que par la porte de la plateforme, qui sait déjà qui la demande et ne laisse entrer que l’élève et les enseignants du module. Ne le lancez pas ainsi là où d’autres peuvent l’atteindre : c’est pour cela que `local.yaml` ne le publie que sur `127.0.0.1`.

## L’utiliser sur la plateforme

La [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) donne à chaque élève sa propre copie d’un lab, dans le navigateur, avec un terminal à côté.

**Pour l’essayer :** ouvrez la [page des conteneurs](https://mitsurutech.co.uk/container), trouvez ce lab dans **Sample labs** et appuyez sur Start. Il faut un compte gratuit.

**Pour en faire un travail pour une classe :**

1. Dans votre module, créez une tâche de type **Lab** et choisissez **In a GitHub repository**.
2. Indiquez `https://github.com/mitsurutech/lab-jupyter-data` avec la branche `main`. Le fichier compose est celui par défaut, `compose.yaml`. Faites d’abord un fork du dépôt si vous voulez changer le fichier ou les données.
3. Publiez. Chaque copie d’élève part du commit que vous avez publié : une modification ultérieure ici ne change pas un lab déjà donné.
4. Indiquez dans la tâche ce qu’il faut rendre (voir [Pour les enseignants](#pour-les-enseignants)), et attribuez-la comme n’importe quelle tâche.

Le terminal à côté d’un lab n’a pas de Python à lui : il atteint celui du lab avec `docker exec jupyter`, par exemple `docker exec jupyter python3 steps/load.py`. JupyterLab a aussi son propre terminal, sous File, New, Terminal.

La [page de ce lab](https://mitsurutech.co.uk/fr/help/lab-jupyter-data) dans le manuel et son [guide des labs de conteneurs](https://mitsurutech.co.uk/fr/help/labs) couvrent le reste : ce qu’un fichier compose peut dire, la mémoire d’une copie, et comment un enseignant ouvre, observe et note la copie d’un élève.

Pas encore de compte d’établissement ? [Votre première année est gratuite](https://mitsurutech.co.uk/pricing) jusqu’à 50 élèves, et [s’inscrire](https://mitsurutech.co.uk/signup) ne demande qu’une adresse e-mail.

## Le lancer sur votre machine

Il vous faut Docker avec le plugin Compose. Le premier démarrage télécharge l’image, environ 1,3 Go.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Ouvrez <http://127.0.0.1:8888/lab> et double-cliquez sur `start.ipynb`. Depuis un autre terminal, vous pouvez aussi lancer les scripts :

```bash
docker compose exec jupyter python3 steps/weather.py
```

`local.yaml` publie le port sur `127.0.0.1` seulement : le lab n’est joignable que depuis votre ordinateur. Arrêtez-le avec `Ctrl-C`, et supprimez-le avec `docker compose -f compose.yaml -f local.yaml down -v`.

## Le parcours

1. **Regarder.** `docker exec jupyter ls` liste `hires.csv`, `start.ipynb` et `steps`, et `docker exec jupyter cat steps/load.py` montre qu’un script tient en quatre lignes de Python.
2. **Charger.** `python3 steps/load.py` affiche `(365, 7)`, 365 lignes et 7 colonnes, et les cinq premiers jours : le 1er janvier 2025 était nuageux, 0,9 degré, avec 137 locations.
3. **Résumer.** `python3 steps/summary.py` décrit la colonne `hires` : une moyenne de 270,3 par jour, 41 le jour le plus calme et 487 le plus chargé.
4. **Comparer des groupes.** `python3 steps/weather.py` calcule la moyenne par météo : sunny 312,2, cloudy 267,0, rainy 227,6.
5. **Représenter.** `python3 steps/picture.py` enregistre `hires.png`, un point par jour, la température en abscisse et les locations en ordonnée. Ouvrez-le depuis la liste des fichiers de JupyterLab.
6. **Modéliser.** `python3 steps/model.py` ajuste une régression linéaire à partir de la température et de la pluie : environ 11,2 locations de plus par degré, environ 8,2 de moins par millimètre de pluie, et un R² de 0,776.
7. **Le refaire dans le notebook.** Ouvrez `start.ipynb`, exécutez chaque cellule avec Maj et Entrée, puis posez votre propre question dans la dernière cellule.

## Pour les enseignants

Rien dans ce lab n’est noté automatiquement. L’élève rend ce qu’il a trouvé et vous le notez, comme pour tout autre lab.

**Demandez un notebook et une phrase.** Un notebook à l’élève sur `hires.csv` qui répond à une question de son choix (quelle météo est la plus chargée le week-end, quel mois est le plus calme, si connaître le jour de la semaine améliore le modèle), téléchargé depuis JupyterLab avec File, Download, et une ou deux phrases, de ses propres mots, sur ce que les données ont montré et sur ce qu’elles ne prouvent pas. La formulation vous dit si c’est compris. Pour un travail plus poussé, demandez un graphique qui appuie la réponse et une comparaison avec un modèle plus simple.

**Sa place dans un cours.** Le lab convient aux introductions à la science des données, aux statistiques avec du code et à l’apprentissage automatique : DataFrames, statistiques descriptives et regroupements, graphiques, et une première régression avec une mesure d’ajustement. Vérifiez la formulation exacte dans l’unité de votre propre organisme certificateur ; aucune n’est citée ici.

**Une erreur fréquente à guetter.** Un modèle qui colle bien est souvent pris pour la preuve d’une cause. Ici, les jours chauds sont plus chargés, mais ils sont aussi plus secs et tombent plus souvent un week-end d’été : le mot honnête est « va avec ».

**Qui voit quoi.** Une copie est privée pour l’élève qui l’a lancée. Un membre de l’équipe qui enseigne le module peut l’ouvrir pour voir ce que l’élève a fait, et l’ouverture du travail d’un élève est inscrite au journal d’accès, que l’élève peut lire.

## Ce qui ne marche pas dans un lab

Le lab n’a aucun accès à internet : rien ne peut être installé avec `pip` ni téléchargé, et les bibliothèques sont celles de l’image. Il n’y a pas de GPU, et un modèle ou un jeu de données qui demande beaucoup plus de mémoire que les 512 Mo de la copie échouera. Les données sont inventées et petites : elles enseignent les méthodes et ne disent rien des vraies locations de vélos. **Rien n’est conservé** : arrêter le lab efface tous les fichiers, alors l’élève télécharge son notebook avant de l’arrêter.

## Dépannage

- **JupyterLab n’apparaît pas juste après Start.** Attendez quelques secondes et appuyez de nouveau sur Open : le lab ne se déclare prêt qu’une fois que JupyterLab répond.
- **Le noyau s’arrête pendant qu’une cellule tourne.** La cellule a demandé plus de mémoire que la copie n’en a. Redémarrez le noyau depuis le menu Kernel et travaillez sur une plus petite partie des données.
- **`docker exec` dit que docker n’est pas là.** La commande ne marche que dans le terminal d’un lab sur la plateforme, ou avec `docker compose exec` sur votre machine.
- **Sur votre machine, le port 8888 est déjà pris.** Changez le nombre de gauche dans `local.yaml` et ouvrez ce port à la place.

## Vérifier le lab

`test/check.sh` lance le lab comme le fait le runner de la plateforme pour chaque service (toutes les capacités retirées, `no-new-privileges`, une limite de processus, des limites de mémoire, aucun accès à internet), puis vérifie ce que promet cette page : JupyterLab qui répond sans jeton, chacun des cinq scripts qui affiche les nombres ci-dessus, le graphique enregistré comme un vrai PNG, et le notebook de départ qui s’exécute de bout en bout dans la limite de mémoire. Il faut Docker, et il tourne à chaque push : c’est le badge en haut.

```bash
test/check.sh
```

## Versions et licences

[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) est sous licence BSD-3-Clause. L’image est `jupyter/scipy-notebook:2023-10-20`, avec JupyterLab, pandas, NumPy et scikit-learn (tous sous BSD-3-Clause) et Matplotlib (la licence Matplotlib, fondée sur la licence PSF).

Chaque application à l’intérieur est sous la licence de son propre projet, cité ci-dessus.

## Licence

Ce travail est sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.fr). Vous pouvez le partager et l’adapter pour apprendre et enseigner, à condition de créditer Mitsuru Technologies Ltd, de ne pas l’utiliser à des fins commerciales et de partager ce que vous en tirez sous la même licence. Le texte complet est dans le fichier `LICENSE`.

## À propos

Réalisé par [Mitsuru Technologies](https://mitsurutech.co.uk) pour la [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) : Python, Java, Go, Node, SQL et Linux dans le navigateur pour les établissements, avec des labs de conteneurs, des applications web déployées depuis GitHub et des quiz qui se corrigent tout seuls. Essayez du code sans compte dans le [playground](https://mitsurutech.co.uk/playground).

D’autres labs du même endroit : [lab-spark](https://github.com/mitsurutech/lab-spark), [lab-hadoop](https://github.com/mitsurutech/lab-hadoop), [lab-kafka](https://github.com/mitsurutech/lab-kafka), [lab-valkey](https://github.com/mitsurutech/lab-valkey), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin) et [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea).

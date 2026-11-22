# JupyterLab-Lab für Data Science mit Docker Compose: pandas, NumPy, Matplotlib und scikit-learn an einer echten CSV-Datei

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml)

Ein fertiges **JupyterLab-Lab für Data Science** für den Unterricht, von der [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning), auf der Schulen, Colleges und Hochschulen allen Lernenden eigene Datenbanken, Container und ein Terminal im Browser geben. Alle Lernenden erhalten ein eigenes **JupyterLab**, in dem **pandas**, **NumPy**, **Matplotlib** und **scikit-learn** bereits enthalten sind, dazu ein Jahr an Fahrradverleihdaten mit dem Wetter, ein Start-Notebook und fünf kurze Skripte: Sie laden die Daten in einen DataFrame, fassen sie zusammen, vergleichen Gruppen, zeichnen ein Diagramm und passen eine erste lineare Regression an. Nichts zu installieren und keine Python-Umgebung, die auf dreißig Laptops repariert werden muss.

Es besteht aus einer einzigen `docker-compose`-Datei, `compose.yaml`, und läuft auf Ihrem eigenen Rechner genauso wie auf der Plattform, wo alle Lernenden eine private Kopie ohne Weg ins Internet erhalten.

## Was enthalten ist

| Dienst | Image | Speicher | Was er ist |
| --- | --- | --- | --- |
| `jupyter` | [`jupyter/scipy-notebook:2023-10-20`](https://hub.docker.com/r/jupyter/scipy-notebook) | 512 MB | JupyterLab 4.0.7 auf Python 3.11, mit pandas 2.1, NumPy 1.24, Matplotlib 3.8 und scikit-learn 1.3 |

Der eine Dienst schreibt drei Dinge in seinen Arbeitsordner, `/home/jovyan/work`, und startet dann JupyterLab auf Port 8888:

- **`hires.csv`**, eine Zeile für jeden Tag des Jahres 2025 (365 Zeilen) mit sieben Spalten: `date`, `month`, `weekday`, `weather` (sonnig, bewölkt oder regnerisch), `temp_c`, `rain_mm` und `hires`, die Zahl der an diesem Tag ausgeliehenen Fahrräder. Die Zahlen sind erfunden, aus einem festen Seed erzeugt, sodass jede Kopie genau dieselben Daten hat und nichts heruntergeladen wird.
- **`start.ipynb`**, ein Start-Notebook, das die Daten lädt, beschreibt, das Wetter vergleicht, die Ausleihen gegen die Temperatur aufträgt und eine lineare Regression anpasst, mit einer leeren Zelle am Ende für eine eigene Frage der Lernenden.
- **`steps/`**, kurze Skripte, die dasselbe Schritt für Schritt tun. Die Basislektion nutzt fünf: `load.py`, `summary.py`, `weather.py`, `picture.py` (das `hires.png` speichert) und `model.py`; die übrigen gehören zum Data-Science-Modul.

Er ist nach wenigen Sekunden einsatzbereit und braucht im Leerlauf etwa 75 MB und mit laufendem Kernel eines Notebooks etwa 235 MB, deutlich innerhalb seiner 512 MB.

Das Image ist das der Jupyter Docker Stacks selbst, unverändert ausgeführt und auf ein datiertes Tag festgelegt (nie `latest`), damit sich das Lab zwischen zwei Unterrichtsstunden nicht unter einer Klasse verändert. Es ist das letzte Tag, das das Projekt auf Docker Hub veröffentlicht hat, von wo die Plattform die Images der Labs bezieht; es ist groß, etwa 1,3 GB zum Herunterladen. Hier wird nichts gebaut, und nichts aus diesem Repository wird darin verteilt.

**JupyterLab fragt nach keinem Token und keinem Passwort.** Auf der Plattform ist die Webseite eines Labs nur über den eigenen Zugang der Plattform erreichbar, der bereits weiß, wer anfragt, und nur die lernende Person und das Personal, das das Modul unterrichtet, hereinlässt. Führen Sie es so nirgends aus, wo andere Menschen es erreichen können: Aus genau diesem Grund veröffentlicht `local.yaml` es nur auf `127.0.0.1`.

## Auf der Plattform verwenden

Die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning) gibt allen Lernenden eine eigene Kopie eines Labs, im Browser, mit einem Terminal daneben.

**Zum Ausprobieren:** Öffnen Sie die [Container-Seite](https://mitsurutech.co.uk/de/container), suchen Sie dieses Lab unter **Beispiel-Labs** und klicken Sie auf „Starten“. Dafür brauchen Sie ein kostenloses Konto.

**Um es einer Klasse als Aufgabe zu stellen:**

1. Erstellen Sie in Ihrem Modul eine Aufgabe vom Typ **Lab** und wählen Sie **In einem GitHub-Repository**.
2. Geben Sie `https://github.com/mitsurutech/lab-jupyter-data` mit dem Branch `main` an. Die Compose-Datei ist die Standarddatei, `compose.yaml`. Forken Sie das Repository zuerst, wenn Sie die Datei oder die Daten ändern möchten.
3. Veröffentlichen Sie. Jede Kopie der Lernenden startet von dem Commit, den Sie veröffentlicht haben, sodass eine spätere Änderung hier kein bereits gestelltes Lab verändert.
4. Schreiben Sie in die Aufgabe, was abzugeben ist (siehe [Für Lehrkräfte](#für-lehrkräfte)), und weisen Sie sie zu wie jede andere Aufgabe.

Das Terminal neben einem Lab hat kein eigenes Python und erreicht daher das des Labs mit `docker exec jupyter`, zum Beispiel `docker exec jupyter python3 steps/load.py`. JupyterLab hat außerdem ein eigenes Terminal, unter File, New, Terminal.

Die [Seite zu diesem Lab](https://mitsurutech.co.uk/de/help/lab-jupyter-data) im Hilfehandbuch und sein [Leitfaden zu Container-Labs](https://mitsurutech.co.uk/de/help/labs) erklären den Rest: was in einer Compose-Datei stehen darf, wie viel Speicher eine Kopie erhält und wie eine Lehrkraft die Kopie von Lernenden öffnet, beobachtet und bewertet.

Noch kein Konto für Ihr College? [Ihr erstes Jahr ist kostenlos](https://mitsurutech.co.uk/de/pricing) für bis zu 50 Lernende, und für die [Registrierung](https://mitsurutech.co.uk/de/signup) genügt eine E-Mail-Adresse.

## Auf dem eigenen Rechner ausführen

Sie brauchen Docker mit dem Compose-Plugin. Beim ersten Start wird das Image heruntergeladen, etwa 1,3 GB.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Öffnen Sie <http://127.0.0.1:8888/lab> und doppelklicken Sie auf `start.ipynb`. Aus einem zweiten Terminal können Sie auch die Skripte ausführen:

```bash
docker compose exec jupyter python3 steps/weather.py
```

`local.yaml` veröffentlicht den Port nur auf `127.0.0.1`, sodass das Lab von Ihrem eigenen Rechner aus erreichbar ist und von nirgendwo sonst. Beenden Sie es mit `Ctrl-C` und entfernen Sie es mit `docker compose -f compose.yaml -f local.yaml down -v`.

## Das Lab durcharbeiten

1. **Umsehen.** `docker exec jupyter ls` listet `hires.csv`, `start.ipynb` und `steps` auf, und `docker exec jupyter cat steps/load.py` zeigt, dass ein Skript aus vier Zeilen Python besteht.
2. **Laden.** `python3 steps/load.py` gibt `(365, 7)` aus, 365 Zeilen und 7 Spalten, und die ersten fünf Tage: Der 1. Januar 2025 war bewölkt, 0,9 Grad, mit 137 Ausleihen.
3. **Zusammenfassen.** `python3 steps/summary.py` beschreibt die Spalte `hires`: im Mittel 270,3 pro Tag, 41 am ruhigsten Tag und 487 am geschäftigsten.
4. **Gruppen vergleichen.** `python3 steps/weather.py` bildet den Mittelwert nach Wetter: sonnig 312,2, bewölkt 267,0, regnerisch 227,6.
5. **Zeichnen.** `python3 steps/picture.py` speichert `hires.png`, einen Punkt für jeden Tag, mit der Temperatur nach rechts und den Ausleihen nach oben. Öffnen Sie es aus der Dateiliste von JupyterLab.
6. **Modellieren.** `python3 steps/model.py` passt eine lineare Regression aus Temperatur und Regen an: etwa 11,2 Ausleihen mehr pro Grad, etwa 8,2 weniger pro Millimeter Regen und ein Bestimmtheitsmaß R² von 0,776.
7. **Im Notebook arbeiten.** Öffnen Sie `start.ipynb` und führen Sie jede Zelle mit Shift und Enter aus, dann stellen Sie in der letzten Zelle eine eigene Frage.

## Für Lehrkräfte

Nichts in diesem Lab wird automatisch bewertet. Die Lernenden geben ab, was sie herausgefunden haben, und Sie bewerten es, so wie jedes andere Lab.

**Verlangen Sie ein Notebook und einen Satz.** Ein eigenes Notebook der Lernenden über `hires.csv`, das eine selbst gewählte Frage beantwortet (welches Wetter am Wochenende am meisten Betrieb bringt, welcher Monat am ruhigsten ist, ob die Kenntnis des Wochentags das Modell verbessert), heruntergeladen aus JupyterLab mit File, Download, und dazu ein oder zwei Sätze in eigenen Worten darüber, was die Daten gezeigt haben und was sie nicht beweisen. An der Formulierung erkennen Sie, ob es verstanden wurde. Für eine anspruchsvollere Arbeit verlangen Sie ein Diagramm, das die Antwort stützt, und einen Vergleich mit einem einfacheren Modell.

**Wo es in einen Kurs passt.** Das Lab passt zu Einführungen in Data Science, Statistik mit Code und maschinelles Lernen: DataFrames, zusammenfassende Statistiken und Gruppierung, Diagramme und eine erste Regression mit einem Maß für die Anpassungsgüte. Prüfen Sie den genauen Wortlaut in der Einheit Ihrer eigenen Prüfungsstelle; hier wird keine zitiert.

**Ein häufiger Fehler, auf den Sie achten sollten.** Ein Modell, das gut passt, wird oft als Beweis für eine Ursache gelesen. In diesen Daten sind warme Tage geschäftiger, aber sie sind auch trockener und häufiger Sommerwochenenden. Das ehrliche Wort ist daher „geht einher mit“.

**Wer was sieht.** Eine Kopie ist privat für die Person, die sie gestartet hat. Ein Mitglied des Personals, das das Modul unterrichtet, kann sie öffnen, um zu sehen, was die Person getan hat, und das Öffnen der Arbeit von Lernenden wird im Zugriffsprotokoll festgehalten, das die Lernenden lesen können.

## Was in einem Lab nicht funktioniert

Das Lab hat keinen Weg ins Internet, daher kann nichts mit `pip` installiert oder hineingeladen werden, und die Bibliotheken sind die, die im Image enthalten sind. Es gibt keine GPU, und ein Modell oder ein Datensatz, der weit mehr Speicher braucht als die 512 MB der Kopie, schlägt fehl. Die Daten sind erfunden und klein: Sie vermitteln die Methoden und sagen nichts über echten Fahrradverleih aus. **Nichts wird gespeichert**: Wenn das Lab stoppt, sind alle Dateien vergessen, daher laden die Lernenden ihr Notebook herunter, bevor sie es stoppen.

## Fehlerbehebung

- **JupyterLab erscheint nicht direkt nach dem Start.** Warten Sie einige Sekunden und klicken Sie erneut auf „Öffnen“: Das Lab meldet sich erst bereit, wenn JupyterLab antwortet.
- **Der Kernel stirbt, während eine Zelle läuft.** Die Zelle hat mehr Speicher verlangt, als die Kopie hat. Starten Sie den Kernel über das Menü Kernel neu und arbeiten Sie mit einem kleineren Teil der Daten.
- **`docker exec` meldet, dass docker hier nicht vorhanden ist.** Der Befehl läuft nur im eigenen Terminal eines Labs auf der Plattform oder mit `docker compose exec` auf Ihrem eigenen Rechner.
- **Auf Ihrem eigenen Rechner ist Port 8888 schon belegt.** Ändern Sie die linke Zahl in `local.yaml` und öffnen Sie stattdessen diesen Port.

## Das Lab prüfen

`test/check.sh` startet das Lab so, wie der Runner der Plattform jeden Dienst startet (alle Capabilities entfernt, `no-new-privileges`, eine Prozessgrenze, Speichergrenzen und kein Weg ins Internet), und prüft dann, was diese Seite verspricht: JupyterLab antwortet ohne Token, jedes der fünf Skripte gibt die Zahlen oben aus, das Diagramm wird als echte PNG-Datei gespeichert, und das Start-Notebook läuft innerhalb der Speichergrenze von oben bis unten durch. Es braucht Docker und läuft bei jedem Push, das ist das Abzeichen oben.

```bash
test/check.sh
```

## Versionen und Lizenzen

[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) steht unter der Lizenz BSD-3-Clause. Das Image ist `jupyter/scipy-notebook:2023-10-20`, mit JupyterLab, pandas, NumPy und scikit-learn (alle BSD-3-Clause) und Matplotlib (die Matplotlib-Lizenz, auf der PSF-Lizenz beruhend).

Jede Anwendung darin steht unter der Lizenz ihres eigenen Projekts, oben verlinkt.

## Lizenz

Dieses Werk steht unter der Lizenz [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Sie dürfen es zum Lernen und Lehren weitergeben und bearbeiten, wenn Sie Mitsuru Technologies Ltd nennen, es nicht kommerziell nutzen und alles, was Sie daraus machen, unter derselben Lizenz weitergeben. Der vollständige Text steht in der Datei `LICENSE`.

## Über uns

Erstellt von [Mitsuru Technologies](https://mitsurutech.co.uk/de) für die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning): Python, Java, Go, Node, SQL und Linux im Browser für Schulen und Colleges, mit Container-Labs, aus GitHub bereitgestellten Web-Apps und Quizzen, die sich selbst bewerten. Probieren Sie Code ohne Konto im [Playground](https://mitsurutech.co.uk/de/playground) aus.

Weitere Labs vom selben Ort: [lab-spark](https://github.com/mitsurutech/lab-spark), [lab-hadoop](https://github.com/mitsurutech/lab-hadoop), [lab-kafka](https://github.com/mitsurutech/lab-kafka), [lab-valkey](https://github.com/mitsurutech/lab-valkey), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin) und [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea).

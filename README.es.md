# Laboratorio JupyterLab de ciencia de datos con Docker Compose: pandas, NumPy, Matplotlib y scikit-learn sobre un archivo CSV real

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml)

Un **laboratorio JupyterLab de ciencia de datos** listo para el aula, de la [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), donde institutos, centros de formación y universidades dan a cada alumno sus propias bases de datos, contenedores y terminal en el navegador. Cada alumno recibe su propio **JupyterLab** con **pandas**, **NumPy**, **Matplotlib** y **scikit-learn** ya instalados, un año de alquileres de bicicletas con el tiempo que hizo, un cuaderno inicial y cinco scripts cortos: carga los datos en un DataFrame, los resume, compara grupos, dibuja un gráfico y ajusta una primera regresión lineal. Nada que instalar, y ningún entorno de Python que arreglar en treinta portátiles.

Es un solo archivo `docker-compose`, `compose.yaml`, y funciona igual en tu máquina que en la plataforma, donde cada alumno tiene una copia privada sin salida a internet.

## Qué contiene

| Servicio | Imagen | Memoria | Qué es |
| --- | --- | --- | --- |
| `jupyter` | [`jupyter/scipy-notebook:2023-10-20`](https://hub.docker.com/r/jupyter/scipy-notebook) | 512 MB | JupyterLab 4.0.7 sobre Python 3.11, con pandas 2.1, NumPy 1.24, Matplotlib 3.8 y scikit-learn 1.3 |

El servicio escribe tres cosas en su carpeta de trabajo, `/home/jovyan/work`, y después inicia JupyterLab en el puerto 8888:

- **`hires.csv`**, una fila por cada día de 2025 (365 filas) con siete columnas: `date`, `month`, `weekday`, `weather` (sunny, cloudy o rainy), `temp_c`, `rain_mm` y `hires`, el número de bicis alquiladas ese día. Los números son inventados a partir de una semilla fija, así que todas las copias tienen exactamente los mismos datos y no se descarga nada.
- **`start.ipynb`**, un cuaderno inicial que carga los datos, los describe, compara el tiempo, dibuja los alquileres frente a la temperatura y ajusta una regresión lineal, con una celda vacía al final para la pregunta del alumno.
- **`steps/`**, scripts cortos que hacen lo mismo, una idea cada vez. La lección básica usa cinco: `load.py`, `summary.py`, `weather.py`, `picture.py` (que guarda `hires.png`) y `model.py`; los demás son del módulo de ciencia de datos.

Está listo en pocos segundos y usa unos 75 MB en reposo y unos 235 MB con el núcleo de un cuaderno en marcha, muy por debajo de sus 512 MB.

La imagen es la de Jupyter Docker Stacks, sin modificar y fijada a una etiqueta con fecha (nunca `latest`), para que el laboratorio no cambie entre una clase y la siguiente. Es la última etiqueta que el proyecto publicó en Docker Hub, que es de donde la plataforma toma las imágenes de los laboratorios; es grande, unos 1,3 GB de descarga. Aquí no se construye nada y nada de este repositorio se distribuye en ella.

**JupyterLab no pide token ni contraseña.** En la plataforma, a la página web de un laboratorio solo se llega por la puerta de la plataforma, que ya sabe quién la pide y solo deja pasar al alumno y al profesorado del módulo. No lo ejecutes así donde otras personas puedan llegar: por eso `local.yaml` solo lo publica en `127.0.0.1`.

## Usarlo en la plataforma

La [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) da a cada alumno su propia copia de un laboratorio, en el navegador, con un terminal al lado.

**Para probarlo:** abre la [página de contenedores](https://mitsurutech.co.uk/container), busca este laboratorio en **Sample labs** y pulsa Start. Hace falta una cuenta gratuita.

**Para ponerlo como trabajo de una clase:**

1. En tu módulo, crea una tarea de tipo **Lab** y elige **In a GitHub repository**.
2. Indica `https://github.com/mitsurutech/lab-jupyter-data` con la rama `main`. El archivo compose es el predeterminado, `compose.yaml`. Haz antes un fork del repositorio si quieres cambiar el archivo o los datos.
3. Publica. La copia de cada alumno parte del commit que publicaste, así que un cambio posterior aquí no altera un laboratorio ya asignado.
4. Indica en la tarea qué hay que entregar (mira [Para el profesorado](#para-el-profesorado)) y asígnala como cualquier otra tarea.

El terminal que hay junto a un laboratorio no tiene Python propio, así que llega al del laboratorio con `docker exec jupyter`, por ejemplo `docker exec jupyter python3 steps/load.py`. JupyterLab también tiene un terminal propio, en File, New, Terminal.

La [página de este laboratorio](https://mitsurutech.co.uk/es/help/lab-jupyter-data) del manual y su [guía de laboratorios de contenedores](https://mitsurutech.co.uk/es/help/labs) cubren el resto: qué puede decir un archivo compose, cuánta memoria tiene una copia y cómo un profesor abre, observa y califica la copia de un alumno.

¿Todavía no tienes cuenta de centro? [El primer año es gratis](https://mitsurutech.co.uk/pricing) hasta 50 alumnos, y [darse de alta](https://mitsurutech.co.uk/signup) solo pide una dirección de correo.

## Ejecutarlo en tu máquina

Necesitas Docker con el complemento Compose. El primer arranque descarga la imagen, de unos 1,3 GB.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Abre <http://127.0.0.1:8888/lab> y haz doble clic en `start.ipynb`. Desde otro terminal también puedes ejecutar los scripts:

```bash
docker compose exec jupyter python3 steps/weather.py
```

`local.yaml` publica el puerto solo en `127.0.0.1`, así que el laboratorio solo es accesible desde tu ordenador. Páralo con `Ctrl-C` y elimínalo con `docker compose -f compose.yaml -f local.yaml down -v`.

## Paso a paso

1. **Mirar.** `docker exec jupyter ls` lista `hires.csv`, `start.ipynb` y `steps`, y `docker exec jupyter cat steps/load.py` muestra que un script son cuatro líneas de Python.
2. **Cargar.** `python3 steps/load.py` muestra `(365, 7)`, 365 filas y 7 columnas, y los cinco primeros días: el 1 de enero de 2025 estuvo nublado, a 0,9 grados, con 137 alquileres.
3. **Resumir.** `python3 steps/summary.py` describe la columna `hires`: una media de 270,3 al día, 41 el día más tranquilo y 487 el más ajetreado.
4. **Comparar grupos.** `python3 steps/weather.py` saca la media por tiempo: sunny 312,2, cloudy 267,0, rainy 227,6.
5. **Dibujarlo.** `python3 steps/picture.py` guarda `hires.png`, un punto por día con la temperatura en horizontal y los alquileres en vertical. Ábrelo desde la lista de archivos de JupyterLab.
6. **Modelarlo.** `python3 steps/model.py` ajusta una regresión lineal a partir de la temperatura y la lluvia: unos 11,2 alquileres más por grado, unos 8,2 menos por milímetro de lluvia y un R² de 0,776.
7. **Hacerlo en el cuaderno.** Abre `start.ipynb`, ejecuta cada celda con Mayús e Intro y añade tu propia pregunta en la última celda.

## Para el profesorado

Nada de este laboratorio se corrige automáticamente. El alumno entrega lo que ha encontrado y usted lo califica, como cualquier otro laboratorio.

**Pida un cuaderno y una frase.** Un cuaderno propio sobre `hires.csv` que responda a una pregunta elegida por el alumno (con qué tiempo hay más alquileres el fin de semana, qué mes es el más tranquilo, si conocer el día de la semana mejora el modelo), descargado desde JupyterLab con File, Download, y una o dos frases con sus propias palabras sobre lo que mostraron los datos y lo que no demuestran. La redacción le dice si lo ha entendido. Para un trabajo más completo, pida un gráfico que apoye la respuesta y una comparación con un modelo más sencillo.

**Dónde encaja en un curso.** El laboratorio sirve para introducciones a la ciencia de datos, a la estadística con código y al aprendizaje automático: DataFrames, estadística descriptiva y agrupaciones, gráficos y una primera regresión con una medida de ajuste. Consulte la redacción exacta en la unidad de su propio organismo certificador; aquí no se cita ninguna.

**Un error frecuente que conviene escuchar.** Un modelo que se ajusta bien se suele tomar como prueba de una causa. En estos datos los días cálidos tienen más alquileres, pero también son más secos y caen más a menudo en fines de semana de verano, así que lo honesto es decir «va unido a».

**Quién ve qué.** Una copia es privada para el alumno que la inició. Un miembro del profesorado del módulo puede abrirla para ver lo que ha hecho, y abrir el trabajo de un alumno queda anotado en el registro de accesos, que el alumno puede leer.

## Lo que no funciona en un laboratorio

El laboratorio no tiene salida a internet, así que no se puede instalar nada con `pip` ni descargar nada, y las bibliotecas son las de la imagen. No hay GPU, y un modelo o un conjunto de datos que necesite mucha más memoria que los 512 MB de la copia fallará. Los datos son inventados y pocos: enseñan los métodos y no dicen nada del alquiler de bicis real. **No se guarda nada**: al parar el laboratorio se pierden todos los archivos, así que el alumno descarga su cuaderno antes de pararlo.

## Solución de problemas

- **JupyterLab no aparece justo después de Start.** Espera unos segundos y vuelve a pulsar Open: el laboratorio solo se declara listo cuando JupyterLab responde.
- **El núcleo se detiene mientras corre una celda.** La celda pidió más memoria de la que tiene la copia. Reinicia el núcleo desde el menú Kernel y trabaja con una parte más pequeña de los datos.
- **`docker exec` dice que docker no está.** La orden solo funciona en el terminal de un laboratorio en la plataforma, o con `docker compose exec` en tu máquina.
- **En tu máquina, el puerto 8888 ya está en uso.** Cambia el número de la izquierda en `local.yaml` y abre ese puerto.

## Comprobar el laboratorio

`test/check.sh` inicia el laboratorio como el runner de la plataforma inicia cada servicio (sin ninguna capacidad, `no-new-privileges`, un límite de procesos, límites de memoria y sin salida a internet) y comprueba lo que promete esta página: JupyterLab responde sin token, cada uno de los cinco scripts muestra los números de arriba, el gráfico se guarda como un PNG de verdad y el cuaderno inicial se ejecuta entero dentro del límite de memoria. Necesita Docker y se ejecuta en cada push, que es la insignia de arriba.

```bash
test/check.sh
```

## Versiones y licencias

[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) tiene licencia BSD-3-Clause. La imagen es `jupyter/scipy-notebook:2023-10-20`, con JupyterLab, pandas, NumPy y scikit-learn (todos BSD-3-Clause) y Matplotlib (la licencia de Matplotlib, basada en la licencia PSF).

Cada aplicación de dentro tiene la licencia de su propio proyecto, enlazado arriba.

## Licencia

Esta obra tiene licencia [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.es). Puedes compartirla y adaptarla para aprender y enseñar, siempre que cites a Mitsuru Technologies Ltd, no la uses con fines comerciales y compartas lo que hagas a partir de ella con la misma licencia. El texto completo está en el archivo `LICENSE`.

## Acerca de

Hecho por [Mitsuru Technologies](https://mitsurutech.co.uk) para la [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning): Python, Java, Go, Node, SQL y Linux en el navegador para centros educativos, con laboratorios de contenedores, aplicaciones web desplegadas desde GitHub y cuestionarios que se corrigen solos. Prueba código sin cuenta en el [playground](https://mitsurutech.co.uk/playground).

Más laboratorios del mismo sitio: [lab-spark](https://github.com/mitsurutech/lab-spark), [lab-hadoop](https://github.com/mitsurutech/lab-hadoop), [lab-kafka](https://github.com/mitsurutech/lab-kafka), [lab-valkey](https://github.com/mitsurutech/lab-valkey), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin) y [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea).

# JupyterLab data science lab with Docker Compose: pandas, NumPy, Matplotlib and scikit-learn on a real CSV file

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml)

A ready-made **JupyterLab data science lab** for classrooms, from the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), where schools, colleges and universities give every student their own databases, containers and terminal in the browser. Each student gets their own **JupyterLab** with **pandas**, **NumPy**, **Matplotlib** and **scikit-learn** already in it, a year of bike hire records with the weather, a starter notebook and five short scripts: they load the data into a DataFrame, summarise it, compare groups, draw a chart and fit a first linear regression. Nothing to install, and no Python environment to fix on thirty laptops.

It is one `docker-compose` file, `compose.yaml`, and it runs the same on your own machine as it does on the platform, where every student gets a private copy with no way out to the internet.

## What is in it

| Service | Image | Memory | What it is |
| --- | --- | --- | --- |
| `jupyter` | [`jupyter/scipy-notebook:2023-10-20`](https://hub.docker.com/r/jupyter/scipy-notebook) | 512 MB | JupyterLab 4.0.7 on Python 3.11, with pandas 2.1, NumPy 1.24, Matplotlib 3.8 and scikit-learn 1.3 |

The one service writes three things into its work folder, `/home/jovyan/work`, and then starts JupyterLab on port 8888:

- **`hires.csv`**, one row for every day of 2025 (365 rows) with seven columns: `date`, `month`, `weekday`, `weather` (sunny, cloudy or rainy), `temp_c`, `rain_mm` and `hires`, the number of bikes hired that day. The numbers are made up, from a fixed seed, so every copy has exactly the same data and nothing is downloaded.
- **`start.ipynb`**, a starter notebook that loads the data, describes it, compares the weather, draws hires against temperature and fits a linear regression, with an empty cell at the end for the student's own question.
- **`steps/`**, short scripts that do the same one idea at a time. The basic lesson uses five: `load.py`, `summary.py`, `weather.py`, `picture.py` (which saves `hires.png`) and `model.py`; the rest belong to the data science module.

It is healthy in a few seconds and uses about 75 MB when idle and about 235 MB with a notebook's kernel running, well inside its 512 MB.

The image is the Jupyter Docker Stacks' own, run unmodified and pinned to a dated tag (never `latest`), so the lab does not change under a class between one lesson and the next. It is the last tag the project published on Docker Hub, which is where the platform pulls lab images from; it is large, about 1.3 GB to download. Nothing is built here and nothing from this repository is distributed in it.

**JupyterLab asks for no token or password.** On the platform a lab's web page is reached only through the platform's own door, which already knows who is asking and lets in only the student and the staff who teach the module. Do not run it this way anywhere other people can reach: `local.yaml` publishes it on `127.0.0.1` only for that reason.

## Using it on the platform

The [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) gives every student their own copy of a lab, in the browser, with a terminal beside it.

**To try it:** open the [container page](https://mitsurutech.co.uk/container), find this lab in **Sample labs** and press Start. It needs a free account.

**To set it as work for a class:**

1. In your module, make a task of type **Lab** and choose **In a GitHub repository**.
2. Give `https://github.com/mitsurutech/lab-jupyter-data` with the branch `main`. The compose file is the default, `compose.yaml`. Fork the repository first if you want to change the file or the data.
3. Publish. Every student's copy starts from the commit you published, so a later change here does not alter a lab already set.
4. Say in the task what to hand in (see [For teachers](#for-teachers)), and assign it like any other task.

The terminal beside a lab has no Python of its own, so it reaches the lab's with `docker exec jupyter`, for example `docker exec jupyter python3 steps/load.py`. JupyterLab also has a terminal of its own, under File, New, Terminal.

The help manual's [page for this lab](https://mitsurutech.co.uk/help/lab-jupyter-data) and its [guide to container labs](https://mitsurutech.co.uk/help/labs) cover the rest: what a compose file may say, how much memory a copy gets, and how a teacher opens, watches and marks a student's copy.

No college account yet? [Your first year is free](https://mitsurutech.co.uk/pricing) for up to 50 students, and [signing up](https://mitsurutech.co.uk/signup) takes an email address.

## Running it on your own machine

You need Docker with the Compose plugin. The first start downloads the image, which is about 1.3 GB.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Open <http://127.0.0.1:8888/lab> and double-click `start.ipynb`. From another terminal you can run the scripts too:

```bash
docker compose exec jupyter python3 steps/weather.py
```

`local.yaml` publishes the port on `127.0.0.1` only, so the lab is reachable from your own computer and from nowhere else. Stop it with `Ctrl-C`, and remove it with `docker compose -f compose.yaml -f local.yaml down -v`.

## Working through it

1. **Look around.** `docker exec jupyter ls` lists `hires.csv`, `start.ipynb` and `steps`, and `docker exec jupyter cat steps/load.py` shows that a script is four lines of Python.
2. **Load.** `python3 steps/load.py` prints `(365, 7)`, 365 rows and 7 columns, and the first five days: 1 January 2025 was cloudy, 0.9 degrees, with 137 hires.
3. **Summarise.** `python3 steps/summary.py` describes the `hires` column: a mean of 270.3 a day, 41 on the quietest day and 487 on the busiest.
4. **Compare groups.** `python3 steps/weather.py` takes the mean by weather: sunny 312.2, cloudy 267.0, rainy 227.6.
5. **Draw it.** `python3 steps/picture.py` saves `hires.png`, a dot for every day with the temperature across and the hires up. Open it from JupyterLab's file list.
6. **Model it.** `python3 steps/model.py` fits a linear regression from temperature and rain: about 11.2 more hires for each degree, about 8.2 fewer for each millimetre of rain, and R squared 0.776.
7. **Do it in the notebook.** Open `start.ipynb` and run each cell with Shift and Enter, then add a question of your own in the last cell.

## For teachers

Nothing in this lab is marked automatically. The student hands in what they found and you mark it, the way you mark any other lab.

**Ask for a notebook and a sentence.** A notebook of the student's own over `hires.csv` that answers one question they chose (which weather is busiest at the weekend, which month is quietest, whether knowing the weekday makes the model better), downloaded from JupyterLab with File, Download, and a sentence or two in their own words on what the data showed and what it does not prove. The wording tells you whether it was understood. For stronger work ask for a chart that supports the answer and a comparison with a simpler model.

**Where it sits in a course.** The lab fits introductions to data science, statistics with code and machine learning: DataFrames, summary statistics and grouping, charts, and a first regression with a measure of fit. Check your own awarding body's unit for the exact wording; none is quoted here.

**A common mistake to listen for.** A model that fits well is often read as proof of a cause. In this data warm days are busier, but they are also drier and more often summer weekends, so the honest word is "goes with".

**Who sees what.** A copy is private to the student who started it. A member of staff who teaches the module can open it to see what the student has done, and opening a student's work is written to the access log, which the student can read.

## What does not work in a lab

The lab has no way out to the internet, so nothing can be installed with `pip` or downloaded into it, and the libraries are the ones in the image. There is no GPU, and a model or a data set that needs far more memory than the copy's 512 MB will fail. The data is made up and small, so it teaches the methods and says nothing about real bike hire. **Nothing is saved**: stopping the lab forgets every file, so a student downloads their notebook before they stop it.

## Troubleshooting

- **JupyterLab does not appear straight after Start.** Wait a few seconds and press Open again: the lab reports itself ready only once JupyterLab answers.
- **The kernel dies while a cell runs.** The cell asked for more memory than the copy has. Restart the kernel from the Kernel menu and work on a smaller piece of the data.
- **`docker exec` says docker is not here.** The command runs only in a lab's own terminal on the platform, or with `docker compose exec` on your own machine.
- **On your own machine, port 8888 is already in use.** Change the left-hand number in `local.yaml` and open that port instead.

## Checking the lab

`test/check.sh` starts the lab the way the platform's runner starts every service (all capabilities dropped, `no-new-privileges`, a process limit, memory limits, and no way out to the internet) and then checks what this page promises: JupyterLab answering with no token, each of the five scripts printing the numbers above, the chart saved as a real PNG, and the starter notebook running from top to bottom inside the memory limit. It needs Docker and runs on every push, which is the badge at the top.

```bash
test/check.sh
```

## Versions and licences

[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) is BSD-3-Clause licensed. The image is `jupyter/scipy-notebook:2023-10-20`, with JupyterLab, pandas, NumPy and scikit-learn (all BSD-3-Clause) and Matplotlib (the Matplotlib licence, based on the PSF licence).

Every application inside is the licence of its own project, linked above.

## Licence

This work is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). You may share it and adapt it for learning and teaching, if you credit Mitsuru Technologies Ltd, do not use it commercially, and share anything you make from it under the same licence. The full text is in the `LICENSE` file.

## About

Made by [Mitsuru Technologies](https://mitsurutech.co.uk) for the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning): Python, Java, Go, Node, SQL and Linux in the browser for schools and colleges, with container labs, web apps deployed from GitHub, and quizzes that mark themselves. Try code with no account in the [playground](https://mitsurutech.co.uk/playground).

More labs from the same place: [lab-spark](https://github.com/mitsurutech/lab-spark), [lab-hadoop](https://github.com/mitsurutech/lab-hadoop), [lab-kafka](https://github.com/mitsurutech/lab-kafka), [lab-valkey](https://github.com/mitsurutech/lab-valkey), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin) and [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea).

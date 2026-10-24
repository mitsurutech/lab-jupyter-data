# Docker Compose で動かす JupyterLab データサイエンスラボ：本物の CSV ファイルで pandas、NumPy、Matplotlib、scikit-learn を学ぶ

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-jupyter-data/actions/workflows/check.yml)

授業ですぐに使える **JupyterLab データサイエンスラボ** です。[MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) が提供しています。このプラットフォームでは、高校・専門学校・大学が、生徒ひとりひとりに専用のデータベース、コンテナー、ターミナルをブラウザーで用意できます。生徒は専用の **JupyterLab** を受け取ります。**pandas**、**NumPy**、**Matplotlib**、**scikit-learn** はすでに入っていて、天気つきの1年分のレンタサイクルの記録、最初のノートブック、5つの短いスクリプトがあります。データを DataFrame に読み込み、まとめ、グループを比べ、グラフを描き、最初の線形回帰を当てはめます。インストールは不要で、30台のノートパソコンで Python の環境を直す必要もありません。

`docker-compose` のファイルは `compose.yaml` ひとつだけです。自分のマシンでもプラットフォームでも同じように動き、プラットフォームでは生徒ごとにインターネットにつながらない専用のコピーができます。

## 中身

| サービス | イメージ | メモリー | 内容 |
| --- | --- | --- | --- |
| `jupyter` | [`jupyter/scipy-notebook:2023-10-20`](https://hub.docker.com/r/jupyter/scipy-notebook) | 512 MB | Python 3.11 上の JupyterLab 4.0.7。pandas 2.1、NumPy 1.24、Matplotlib 3.8、scikit-learn 1.3 つき |

サービスは作業フォルダー `/home/jovyan/work` に3つのものを書き出し、ポート 8888 で JupyterLab を起動します。

- **`hires.csv`**：2025年の1日ごとに1行（365行）、7つの列があります。`date`、`month`、`weekday`、`weather`（sunny、cloudy、rainy）、`temp_c`、`rain_mm`、そしてその日に貸し出した自転車の台数 `hires` です。数値は決まった乱数の種から作ったもので、どのコピーもまったく同じデータになり、何もダウンロードしません。
- **`start.ipynb`**：データを読み込み、要約し、天気を比べ、気温と貸し出し台数の図を描き、線形回帰を当てはめる最初のノートブックです。最後に、生徒が自分の問いを書く空のセルがあります。
- **`steps/`**：同じことをひとつずつ行う短いスクリプトです。基本レッスンでは `load.py`、`summary.py`、`weather.py`、`picture.py`（`hires.png` を保存）、`model.py` の5つを使い、残りはデータサイエンスのモジュールで使います。

数秒で使えるようになり、待機中は約 75 MB、ノートブックのカーネルを動かしているときは約 235 MB で、512 MB に十分収まります。

イメージは Jupyter Docker Stacks のもので、手を加えずに使い、日付つきのタグに固定しています（`latest` は使いません）。授業と授業のあいだにラボが変わらないようにするためです。これはプロジェクトが Docker Hub に公開した最後のタグで、プラットフォームはラボのイメージを Docker Hub から取得します。サイズは大きく、ダウンロードは約 1.3 GB です。ここでは何もビルドせず、このリポジトリのものはイメージに含めて配布していません。

**JupyterLab はトークンもパスワードも求めません。** プラットフォームでは、ラボのウェブページにはプラットフォームの入り口を通らないと届きません。入り口は誰が開こうとしているかを知っていて、生徒本人とそのモジュールの先生だけを通します。ほかの人が届く場所では、この設定で動かさないでください。`local.yaml` が `127.0.0.1` だけに公開するのはそのためです。

## プラットフォームで使う

[MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) は、生徒ひとりひとりにラボのコピーをブラウザーで用意し、横にターミナルを置きます。

**試すには：** [コンテナーのページ](https://mitsurutech.co.uk/container)を開き、**Sample labs** でこのラボを探して Start を押します。無料アカウントが必要です。

**クラスの課題にするには：**

1. モジュールで種類が **Lab** の課題を作り、**In a GitHub repository** を選びます。
2. `https://github.com/mitsurutech/lab-jupyter-data` とブランチ `main` を指定します。compose ファイルは既定の `compose.yaml` です。ファイルやデータを変えたい場合は、先にリポジトリをフォークしてください。
3. 公開します。生徒のコピーは公開したコミットから始まるので、あとでここが変わっても、すでに出したラボは変わりません。
4. 課題に何を提出するかを書き（[教員の方へ](#教員の方へ)を参照）、ほかの課題と同じように配布します。

ラボの横のターミナルには Python がないので、`docker exec jupyter` でラボの Python を使います。たとえば `docker exec jupyter python3 steps/load.py` です。JupyterLab には File、New、Terminal から開ける専用のターミナルもあります。

ヘルプマニュアルの[このラボのページ](https://mitsurutech.co.uk/ja/help/lab-jupyter-data)と[コンテナーラボのガイド](https://mitsurutech.co.uk/ja/help/labs)に、そのほかのことが書いてあります。compose ファイルに書けること、コピーのメモリー、先生が生徒のコピーを開き、見守り、採点する方法です。

学校のアカウントがまだない場合は、[最初の1年は無料](https://mitsurutech.co.uk/pricing)（生徒50人まで）で、[登録](https://mitsurutech.co.uk/signup)にはメールアドレスだけが必要です。

## 自分のマシンで動かす

Docker と Compose プラグインが必要です。最初の起動ではイメージ（約 1.3 GB）をダウンロードします。

```bash
docker compose -f compose.yaml -f local.yaml up
```

<http://127.0.0.1:8888/lab> を開き、`start.ipynb` をダブルクリックします。別のターミナルからスクリプトを実行することもできます。

```bash
docker compose exec jupyter python3 steps/weather.py
```

`local.yaml` はポートを `127.0.0.1` だけに公開するので、自分のコンピューターからしか届きません。`Ctrl-C` で止め、`docker compose -f compose.yaml -f local.yaml down -v` で削除します。

## 進め方

1. **見る。** `docker exec jupyter ls` で `hires.csv`、`start.ipynb`、`steps` が並び、`docker exec jupyter cat steps/load.py` でスクリプトが Python 4行だとわかります。
2. **読み込む。** `python3 steps/load.py` は `(365, 7)`（365行、7列）と最初の5日を表示します。2025年1月1日はくもり、0.9度、貸し出しは137台でした。
3. **まとめる。** `python3 steps/summary.py` は `hires` 列を要約します。平均は1日270.3台、いちばん少ない日は41台、いちばん多い日は487台です。
4. **グループを比べる。** `python3 steps/weather.py` は天気ごとの平均を出します。sunny 312.2、cloudy 267.0、rainy 227.6 です。
5. **図にする。** `python3 steps/picture.py` は `hires.png` を保存します。1日を1つの点にして、横に気温、縦に貸し出し台数をとった図です。JupyterLab のファイル一覧から開きます。
6. **モデルにする。** `python3 steps/model.py` は気温と雨から線形回帰を当てはめます。1度あたり約11.2台増え、雨1ミリあたり約8.2台減り、決定係数（R²）は0.776です。
7. **ノートブックで同じことをする。** `start.ipynb` を開き、Shift と Enter で各セルを実行し、最後のセルに自分の問いを書きます。

## 教員の方へ

このラボに自動採点はありません。生徒が見つけたことを提出し、ほかのラボと同じように先生が採点します。

**ノートブックと一文を求めてください。** `hires.csv` を使い、生徒が選んだ問い（週末にいちばん混むのはどの天気か、いちばん空いている月はいつか、曜日を加えるとモデルはよくなるか）に答える自分のノートブックを JupyterLab の File、Download でダウンロードし、データが何を示し、何を証明しないかを自分のことばで1、2文添えて提出させます。その文から、理解しているかがわかります。より深く取り組ませるなら、答えを支えるグラフと、もっと単純なモデルとの比較を求めてください。

**授業での位置づけ。** データサイエンス、コードを使った統計、機械学習の入門に向いています。DataFrame、記述統計とグループ分け、グラフ、当てはまりの指標つきの最初の回帰です。正確な表現はご自身の認定機関の単元でご確認ください。ここでは引用していません。

**よくある思い込みに注意。** よく当てはまるモデルは、原因の証拠だと受け取られがちです。このデータでは暖かい日ほど混みますが、暖かい日は雨が少なく、夏の週末と重なることも多いので、正直な言い方は「関係がある」です。

**誰が何を見られるか。** コピーは起動した生徒だけのものです。そのモジュールを教える先生は、生徒が何をしたかを見るためにコピーを開けます。生徒の作業を開いたことはアクセスログに記録され、生徒もそれを読めます。

## ラボでできないこと

ラボはインターネットにつながらないので、`pip` で何かをインストールしたり、ダウンロードしたりはできません。ライブラリはイメージに入っているものだけです。GPU はなく、コピーの 512 MB をはるかに超えるメモリーが必要なモデルやデータは失敗します。データは作りもので小さく、手法を学ぶためのもので、実際のレンタサイクルについては何もわかりません。**何も保存されません。** ラボを止めるとすべてのファイルが消えるので、生徒は止める前にノートブックをダウンロードします。

## トラブルシューティング

- **Start のすぐあとに JupyterLab が出てこない。** 数秒待ってから、もう一度 Open を押してください。ラボは JupyterLab が応答してはじめて準備完了になります。
- **セルの実行中にカーネルが止まる。** そのセルがコピーのメモリーより多くを使おうとしました。Kernel メニューからカーネルを再起動し、データの一部だけで作業してください。
- **`docker exec` で docker がないと言われる。** このコマンドはプラットフォームのラボのターミナルでだけ使えます。自分のマシンでは `docker compose exec` を使います。
- **自分のマシンでポート 8888 がすでに使われている。** `local.yaml` の左側の数字を変え、そのポートを開いてください。

## ラボの検証

`test/check.sh` は、プラットフォームの runner がすべてのサービスを起動するのと同じ方法（すべての capability を外し、`no-new-privileges`、プロセス数の上限、メモリーの上限、インターネットへの経路なし）でラボを起動し、このページが約束していることを確かめます。JupyterLab がトークンなしで応答すること、5つのスクリプトがそれぞれ上の数値を表示すること、グラフが本物の PNG として保存されること、最初のノートブックがメモリーの上限の中で最後まで実行できることです。Docker が必要で、push のたびに実行されます。上のバッジがその結果です。

```bash
test/check.sh
```

## バージョンとライセンス

[Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks) は BSD-3-Clause ライセンスです。イメージは `jupyter/scipy-notebook:2023-10-20` で、JupyterLab、pandas、NumPy、scikit-learn（いずれも BSD-3-Clause）と Matplotlib（PSF ライセンスにもとづく Matplotlib ライセンス）が入っています。

中のアプリケーションは、それぞれ上にリンクしたプロジェクトのライセンスに従います。

## ライセンス

この作品は [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.ja) ライセンスです。Mitsuru Technologies Ltd の名前を表示し、営利目的で使わず、これをもとに作ったものを同じライセンスで共有する限り、学習と教育のために共有し、改変できます。全文は `LICENSE` ファイルにあります。

## この演習について

[Mitsuru Technologies](https://mitsurutech.co.uk) が [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) のために作りました。学校向けに Python、Java、Go、Node、SQL、Linux をブラウザーで使えるようにし、コンテナーラボ、GitHub からデプロイする Web アプリ、自動採点のクイズも用意しています。アカウントなしで[プレイグラウンド](https://mitsurutech.co.uk/playground)でコードを試せます。

同じところのほかのラボ：[lab-spark](https://github.com/mitsurutech/lab-spark)、[lab-hadoop](https://github.com/mitsurutech/lab-hadoop)、[lab-kafka](https://github.com/mitsurutech/lab-kafka)、[lab-valkey](https://github.com/mitsurutech/lab-valkey)、[lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin)、[lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea)。

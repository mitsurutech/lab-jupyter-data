#!/usr/bin/env bash
# What the README promises, checked from inside the lab's own network and through docker exec,
# which is how the platform's terminal reaches the lab's Python: run by check.sh.
set -euo pipefail
: "${NET:?run through test/check.sh}"
: "${CID:?run through test/check.sh}"
probe() { docker run --rm --network "$NET" lab-check-probe bash -c "$1"; }
run() { docker exec "$CID" "$@"; }

echo "- JupyterLab answers with no token to type"
probe '
set -eu
code=$(curl -s -o /dev/null -w "%{http_code}" http://jupyter:8888/lab)
[ "$code" = 200 ] || { echo "JupyterLab answered $code" >&2; exit 1; }
curl -fs http://jupyter:8888/api/contents | grep -q "start.ipynb" || { echo "no start.ipynb" >&2; exit 1; }
curl -fs -H "Host: someone-8888.example.com" -H "Origin: https://someone-8888.example.com" \
  http://jupyter:8888/api/kernelspecs | grep -q python3 || { echo "a proxied host is refused" >&2; exit 1; }
echo "- no way out to the internet"
if curl -s -m 4 -o /dev/null https://example.com; then echo "the lab reached the internet" >&2; exit 1; fi
'

echo "- the work folder holds the data, the notebook and the step scripts"
run ls hires.csv start.ipynb steps/load.py steps/summary.py steps/weather.py steps/picture.py steps/model.py >/dev/null
test "$(run wc -l hires.csv | awk '{print $1}')" = 366 || { echo "hires.csv is not 365 days" >&2; exit 1; }

echo "- load.py: 365 rows and 7 columns"
run python3 steps/load.py | grep -q "^(365, 7)$"

echo "- summary.py: a mean of 270.3 hires a day, 41 the quietest and 487 the busiest"
out=$(run python3 steps/summary.py)
echo "$out" | grep -Eq "^mean +270.3$" && echo "$out" | grep -Eq "^min +41.0$" && echo "$out" | grep -Eq "^max +487.0$" \
  || { echo "not the summary the lesson names: $out" >&2; exit 1; }

echo "- weather.py: sunny 312.2, cloudy 267.0, rainy 227.6"
out=$(run python3 steps/weather.py)
for want in "sunny +312.2" "cloudy +267.0" "rainy +227.6"; do
  echo "$out" | grep -Eq "^$want$" || { echo "no $want in: $out" >&2; exit 1; }
done

echo "- picture.py: a PNG is saved beside the data"
run python3 steps/picture.py | grep -q "saved hires.png"
run python3 -c "import sys; sys.exit(open('hires.png', 'rb').read(8) != bytes([137, 80, 78, 71, 13, 10, 26, 10]))"

echo "- model.py: 11.2 hires a degree, -8.2 a millimetre of rain, R squared 0.776"
out=$(run python3 steps/model.py)
echo "$out" | grep -q "one more degree: 11.2 hires" && echo "$out" | grep -q "rain: -8.2 hires" \
  && echo "$out" | grep -q "R squared: 0.776" || { echo "not the model the lesson names: $out" >&2; exit 1; }

echo "- the starter notebook runs from top to bottom inside the memory limit"
run jupyter nbconvert --to notebook --execute start.ipynb --output /tmp/ran.ipynb >/dev/null 2>&1 \
  || { echo "start.ipynb does not run" >&2; exit 1; }
echo "  ok"

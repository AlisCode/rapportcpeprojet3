pandoc -s -N --template eisvogel.tex --filter svgbob.py --filter pandoc-citeproc Rapport.md -o Rapport.pdf

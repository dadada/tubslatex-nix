.PHONY: thesis.pdf all watch clean

all: thesis.pdf

clean:
	latexmk -C thesis.tex

thesis.pdf: thesis.tex
	latexmk -interaction=batchmode -pdf thesis.tex

watch:
	latexmk -pvc -pdf thesis.tex

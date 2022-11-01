.PHONY: thesis.pdf all watch clean

all: thesis.pdf

clean:
	latexmk -C thesis.tex

thesis.pdf: thesis.tex
	latexmk -interaction=batchmode -pdf thesis.tex

watch:
	while true; do \
	  	inotifywait -qr -e modify -e create -e delete -e move *tex; \
	  	$(MAKE); \
	done

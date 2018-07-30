PANDOC = /usr/local/bin/pandoc --quiet
RACKET = /usr/local/bin/racket

all: README.html

%.html: %.md
	${PANDOC} -t slidy --standalone -o $@ $<
	open $@

self-contained: README.md
	${RM} README.html
	${PANDOC} -t slidy --standalone --self-contained -o README.html $<

# find black spots from sample2.png, save it colored to spots.png.
run:
	@echo find black spots from sample2.png, save it colored to spots.png.
	${RACKET} find-black-spots.rkt sample2.png
	open spots.png

# prep to zip this folder.
prep:
	make clean
	make self-contained
	${RM} .gitignore
	${RM} -r .git
	@echo ready to zip!

clean:
	${RM} *.html *.bak spots.png

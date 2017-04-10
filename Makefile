.PHONY: clean help
.DEFAULT: help

help:
	cat Makefile

README.html: README.md
	pandoc README.md -s -o README.html

README.pdf: README.md
	pandoc README.md -s -o README.pdf

clean:
	rm -f README.html README.pdf


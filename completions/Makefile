PREFIX ?= /usr
SHRDIR ?= $(PREFIX)/share
.PHONY = bash install-bash

bash: bash/aur

bash/aur: command_opts.m4 bash/aurutils.in ../lib/*
	m4 $(wordlist 1,2,$^) >$@

install-bash: bash/aur
	@install -Dm644 bash/aur -t $(DESTDIR)$(SHRDIR)/bash-completion/completions

PREFIX ?= /usr
SHRDIR ?= $(PREFIX)/share

bash/aur: command_opts.m4 bash/aurutils.in
	m4 $^ >$@

install: bash/aur
	@install -Dm644 bash/aur $(DESTDIR)$(SHRDIR)/bash-completion/completions

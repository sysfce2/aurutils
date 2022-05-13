PREFIX ?= /usr
SHRDIR ?= $(PREFIX)/share
.PHONY = bash install-bash zsh install-zsh

bash: bash/aur
zsh: zsh/_aur.zsh

bash/aur: bash/aurutils.in ../lib/*
	bash $< >$@

install-bash: bash/aur
	@install -Dm644 bash/aur -t '$(DESTDIR)$(SHRDIR)/bash-completion/completions'

install-zsh: zsh/_aur.zsh
	@install -Dm644 zsh/_aur.zsh '$(DESTDIR)$(SHRDIR)/zsh/site-functions/_aur'
	@install -Dm755 zsh/run-help-aur -t '$(DESTDIR)$(SHRDIR)/zsh/functions/Misc'

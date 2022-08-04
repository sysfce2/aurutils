PREFIX ?= /usr
SHRDIR ?= $(PREFIX)/share
.PHONY = bash install-bash install-zsh

ZSH_SITE_FUNCTIONS = \
	zsh/_aur \
	zsh/_aur_local_packages \
	zsh/_aur_packages \
	zsh/_aur_repositories

bash: bash/aur

bash/aur: bash/aurutils.in ../lib/*
	bash $< >$@

install-bash: bash/aur
	@install -Dm644 bash/aur -t '$(DESTDIR)$(SHRDIR)/bash-completion/completions'

install-zsh: zsh/run-help-aur $(ZSH_SITE_FUNCTIONS)
	@install -Dm644 zsh/run-help-aur -t '$(DESTDIR)$(SHRDIR)/zsh/functions/Misc'

	@install -d '$(DESTDIR)$(SHRDIR)/zsh/site-functions/'
	@install -m644 -t '$(DESTDIR)$(SHRDIR)/zsh/site-functions/' $(ZSH_SITE_FUNCTIONS)

FROM archlinux/base:latest
LABEL Alad Wenter <alad@archlinux.org>

RUN pacman -Syu --noconfirm base base-devel
RUN pacman -Syu --noconfirm jq pacutils git wget shellcheck vim vifm devtools bash-completion parallel
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# unprivileged user
ARG USERNAME=archie
RUN useradd -m -s /bin/bash $USERNAME
RUN install -o $USERNAME -dm755 /home/$USERNAME/.local
RUN install -o $USERNAME -dm755 /home/$USERNAME/.local/bin
ENV PATH "/home/${USERNAME}/.local/bin:$PATH"

# locales
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

# sudoers
RUN echo $USERNAME ALL=\(root\) NOPASSWD: /usr/bin/pacman > /etc/sudoers.d/$USERNAME-pacman \
    && chmod 0440 /etc/sudoers.d/$USERNAME-pacman

# man pages
RUN pacman -Syu --noconfirm man-db man-pages

# local repository
ARG REPO_DB=/home/custompkgs/custom.db.tar.gz
RUN install -o $USERNAME -dm755 /home/custompkgs
RUN sudo -u $USERNAME repo-add $REPO_DB

ARG PACMAN_CONF=/etc/pacman.conf
RUN perl -0777 -pi -e 's/#(\[custom\])\n#(SigLevel.*)\n#(Server.*)\n/$1\n$2\n$3\n/' $PACMAN_CONF
RUN pacsync custom

# aurutils package
RUN cd /home/archie \
    && sudo -u archie git clone https://github.com/AladW/aurutils \
    && cd aurutils/makepkg \
    && sudo -u archie makepkg --install --noconfirm

FROM archlinux

ARG USER_ID
ARG GROUP_ID
ARG JDK

RUN pacman -Sy \
      "archlinux-keyring" \
        --noconfirm \
        --noprogressbar
RUN pacman -Sy \
        --noconfirm \
        --noprogressbar && \
    pacman -S \
      "sudo" \
      "asp" \
      "bash" \
      "base-devel" \
      "wget" \
        --noconfirm \
        --noprogressbar

RUN mkdir -p \
      "/mnt/dlib-java" \
      "/var/lib/make"&& \
    groupadd \
      -g "${GROUP_ID}" \
      "make" && \
    useradd \
      -u "${USER_ID}" \
      -g "${GROUP_ID}" \
      -s "/usr/bin/nologin" \
      -d "/var/lib/make" \
      "make" && \
    mkdir -p "/etc/sudoers.d" && \
      echo 'Defaults:make !requiretty' >>'/etc/sudoers.d/make' && \
      echo 'Defaults:make env_keep += "PATH"'  >>'/etc/sudoers.d/make' && \
      echo 'make ALL=(ALL) NOPASSWD:ALL'  >>'/etc/sudoers.d/make' && \
      chmod 0440 '/etc/sudoers.d/make' && \
    chown -R "make:make" "/var/lib/make"

RUN wget \
      --quiet \
      "https://aur.archlinux.org/cgit/aur.git/snapshot/yay-bin.tar.gz" \
      -O "/tmp/yay-bin.tar.gz" && \
    sudo -u "make" tar xf "/tmp/yay-bin.tar.gz" -C "/tmp" && \
    cd "/tmp/yay-bin" && \
    sudo -u "make" makepkg \
  		--syncdeps \
  		--rmdeps \
  		--noconfirm \
      --install

RUN sudo -u "make" yay -S \
      "${JDK}" \
        --noconfirm \
        --noprogressbar

RUN sudo -u "make" yay -S \
      "maven" \
      "swig" \
        --noconfirm \
        --noprogressbar

ENTRYPOINT ["make"]

FROM archlinux

ARG USER_ID
ARG GROUP_ID
ARG JDK

RUN pacman -Sy --noconfirm && \
    pacman -S \
      "sudo" \
      "asp" \
      "bash" \
      "base-devel" \
      "${JDK}" \
      "wget" \
      "maven" \
      "swig" \
      --noconfirm

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

ENTRYPOINT ["make"]

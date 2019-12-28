FROM archlinux

RUN pacman -Sy --noconfirm && \
    pacman -S "asp" "bash" --noconfirm

RUN pacman -S "sudo" --noconfirm

ARG USER_ID
ARG GROUP_ID
ARG JDK

RUN mkdir -p "/mnt/build"

RUN pacman -S "${JDK}" --noconfirm

RUN pacman -S "base-devel" --noconfirm

RUN groupadd \
  -g "${GROUP_ID}" \
  "builder"

RUN useradd \
  -u "${USER_ID}" \
  -g "${GROUP_ID}" \
  -s "/usr/bin/nologin" \
  -d "/mnt/build" \
  "builder"

RUN mkdir -p "/etc/sudoers.d" && \
    echo 'Defaults:builder !requiretty' >>'/etc/sudoers.d/builder' && \
    echo 'Defaults:builder env_keep += "PATH"'  >>'/etc/sudoers.d/builder' && \
    echo 'builder ALL=(ALL) NOPASSWD:ALL'  >>'/etc/sudoers.d/builder' && \
    chmod 0440 '/etc/sudoers.d/builder'

COPY ["entrypoint", "/usr/bin/entrypoint"]
ENTRYPOINT ["/usr/bin/entrypoint"]

From ubuntu:22.04

RUN apt update && apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    sudo

RUN python3 -m venv /venv && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install open-interpreter

RUN sed -i 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers
RUN groupadd -r --gid 1000 user && \
    useradd -r --gid user --uid 1000 user && \
    usermod -aG sudo user

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]

# use gpt-3.5-turbo
CMD ["interpreter", "--yes", "--fast"]

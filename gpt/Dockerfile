From ubuntu:22.04

RUN apt update && apt install -y \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    git

RUN python3 -m venv /.chatgpt-cli && \
    . /.chatgpt-cli/bin/activate && \
    pip3 install git+https://github.com/marcolardera/chatgpt-cli

RUN python3 -m venv /.open-interpreter && \
    . /.open-interpreter/bin/activate && \
    pip3 install open-interpreter

RUN groupadd --gid 1000 user && \
    useradd --create-home --gid user --uid 1000 user && \
    usermod -aG sudo user

RUN sed -i 's/^%sudo.*/%sudo ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]

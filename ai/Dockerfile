From ubuntu:22.04

RUN apt update && apt install -y \
    python3 \
    python3-pip \
    python3-venv

RUN python3 -m venv /venv && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install open-interpreter

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interpreter", "-y"]

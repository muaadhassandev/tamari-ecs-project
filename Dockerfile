FROM python:3.10-slim AS builder
WORKDIR /build
COPY app/Tamari/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.10-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    libffi8 \
    shared-mime-info \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /install /usr/local
COPY app/Tamari/ .
RUN useradd --create-home appuser \
    && mkdir -p /app/appdata/recipe-photos \
    && chown -R appuser:appuser /app \
    && chmod 755 /app/boot.sh
USER appuser
EXPOSE 4888
CMD ["./boot.sh"]

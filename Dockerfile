# Imagen base mínima
FROM python:3.12-slim

# Evita archivos .pyc y buffers
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

# Crea usuario no-root
RUN useradd -m appuser

# Instala system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential curl \
    && rm -rf /var/lib/apt/lists/*

# Instala deps de Python
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el código
COPY app ./app

# Permisos y user no-root
RUN chown -R appuser:appuser /app
USER appuser

# Expone y ejecuta
EXPOSE 8080
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

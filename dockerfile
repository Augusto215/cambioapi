# Use a imagem base do Python 3.9 Slim Buster
FROM python:3.9-slim-buster

# Configurar variáveis de ambiente para o Chrome WebDriver
ENV CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver \
    FLASK_APP=app.py \
    PORT=8080

# Configurar diretório de trabalho
WORKDIR /app

# Instalar dependências para Chrome WebDriver e limpar cache
RUN apt-get update && \
    apt-get install -y chromium chromium-driver && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R app:app /usr/bin/chromium /usr/bin/chromedriver

# Adicionar usuário
RUN adduser --disabled-password --gecos '' app

# Copiar arquivos para o contêiner
COPY . .

# Instalar dependências Python
RUN pip install -r requirements.txt && \
    pip install gunicorn

# Mudar para o usuário não root
USER app

# Executar a aplicação com timeout configurado
CMD ["gunicorn", "-b", ":8080", "--timeout", "120", "app:app"]
# Use a imagem base do Python 3.9 Slim Buster
FROM python:3.9-slim-buster

# Instalar dependências para Chrome WebDriver
RUN apt-get update && \
    apt-get install -y chromium chromium-driver && \
    rm -rf /var/lib/apt/lists/*

# Configurar variáveis de ambiente para o Chrome WebDriver
ENV CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver

# Adicionar usuário
RUN adduser --disabled-password --gecos '' app

# Alterar propriedade dos arquivos do Chrome para o usuário app
RUN chown app:app /usr/bin/chromium /usr/bin/chromedriver

# Configurar diretório de trabalho
RUN mkdir /app
COPY . /app
WORKDIR /app

# Instalar dependências
RUN pip install -r requirements.txt
RUN pip install gunicorn

# Configurar variáveis de ambiente do Flask
ENV FLASK_APP=app.py
USER app
ENV PORT=8080

# Executar a aplicação
CMD ["gunicorn", "-b", ":8080", "app:app"]

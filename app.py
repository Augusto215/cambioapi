from flask import Flask, jsonify
import asyncio
from playwright.sync_api import sync_playwright

from flask import Flask, jsonify
from flask_cors import CORS  # Importe o CORS
from bs4 import BeautifulSoup
import asyncio
from playwright.sync_api import sync_playwright

app = Flask(__name__)
CORS(app)  # Configure o CORS para a sua aplicação

def scrape():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        page.goto('https://bitcoinp2p.org')
        html_content = page.content()
        browser.close()

    soup = BeautifulSoup(html_content, 'html.parser')
    coinbase_value_raw = soup.text.split('COINBASE: ')[1].split(' ')[0]
    coinbase_value = coinbase_value_raw.replace('USDT', '')  # Substitui 'USDT' por uma string vazia
    usd_value = soup.text.split('USD Spot (Investing): ')[1].split(' ')[0]

    return {
        'coinbase': coinbase_value,
        'usd_value': usd_value
    }

@app.route('/scrape', methods=['GET'])
def get_scrape():
    data = scrape()
    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)

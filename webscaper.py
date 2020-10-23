# This short script was inspired by this article on webscraping below
# https://www.bitcoininsider.org/article/50706/building-web-scraper-start-finish

from bs4 import BeautifulSoup
import requests
import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

url = 'https://www.bowflex.com/selecttech/552/100131.html'
response = requests.get(url, timeout=5)
content = BeautifulSoup(response.content,"html.parser")

htmlContentFound = content.findAll('button', attrs={"class": "add-to-cart"})
currentContent = htmlContentFound[0]
currentContent = str(currentContent).replace("\"","'")

soldOutContent = "<button class='black add-to-cart add-to-cart-disabled' disabled='disabled' id='add-to-cart' title='Select ' type='button' value='Select '><span>Add to Cart</span><issvghelper icon='arrow-right'></issvghelper></button>"

if soldOutContent == currentContent:
    message = Mail(
        from_email='',
        to_emails='',
        subject='Weight Prices Update',
        html_content='<strong>There has been a change in the price of Weights</strong>')
    try:
        sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
        response = sg.send(message)
        print(response.status_code)
        print(response.body)
        print(response.headers)
    except Exception as e:
        print(e.message)
else:
    print('still sold out')



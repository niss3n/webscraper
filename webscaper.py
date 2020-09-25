# https://www.bitcoininsider.org/article/50706/building-web-scraper-start-finish

from bs4 import BeautifulSoup
import requests

url = 'https://www.bowflex.com/selecttech/552/100131.html'
# url = 'https://www.dickssportinggoods.com/p/fitness-gear-300-lbolympic-weight-set-16fgeu300lbstwth7brb/16fgeu300lbstwth7brb'
# url = 'http://ethans_fake_twitter_site.surge.sh/'
response = requests.get(url, timeout=5)
content = BeautifulSoup(response.content,"html.parser")
# print(content)

# text_file = open("sample.html", "w")
# n = text_file.write(str(content))
# text_file.close()

htmlcontentfound = content.findAll('button', attrs={"class": "add-to-cart"})

currentContent = htmlcontentfound[0]

currentContent = str(currentContent).replace("\"","'")

soldOutContent = "<button class='black add-to-cart add-to-cart-disabled' disabled='disabled' id='add-to-cart' title='Select ' type='button' value='Select '><span>Add to Cart</span><issvghelper icon='arrow-right'></issvghelper></button>"

if soldOutContent != currentContent:
    print('there has been a change, send an email!')
else:
    print('still sold out')



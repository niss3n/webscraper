[![Build status](https://dev.azure.com/bradanissen/Github%20Repos/_apis/build/status/Terraform-CI)](https://dev.azure.com/bradanissen/Github%20Repos/_build/latest?definitionId=4)

[Azure Release Pipeline](https://dev.azure.com/bradanissen/Github%20Repos/_release?_a=releases&view=mine&definitionId=1)

# **Welcome to the Webscaper project!**

## **Overview**

Since the beginning of COVID, buying weights has been nearly impossible (for a reasonable price)! I want to search for in-stock alerts from websites, and when they are available to buy, send an email. 

You might be asking... Why not just sign up for email alerts? Because there's no fun in that!

## **How to contribute?**
If you want to conribute, please checkout the Issues tab and find something you want to work on. I'm always open to suggestions if you want to take something and run with it!

<br/>


## **Get Webscraper working locally**

*1. Pull down the code to your local computer*
```
git clone https://github.com/niss3n/webscraper.git 
```

*2. Open your files up in Visual Studo Code (my text editor of choice)*
```
cd webscraper
```

*3a. On MacOS or Linux*
```
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
```

*3b. On Windows*
```
py -m venv env
.\env\Scripts\activate
pip install -r requirements.txt
```

*4. After the virtual environment starts and the packages are installed, try running the code!*
```
python webscraper.py
```

*Run this command to kill the virtual environement (a.k.a, env)*
```
deactivate
```

<br/>

--- 
<br/>

> To create a new Virtual Environemnt, "python3 -m venv virtualenv" <br/>
> To shutdown/stop the virtual environment,  "deactivate"

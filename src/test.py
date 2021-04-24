"""
Created on Mon May 13 13:10:14 2019
@author: Shreyash
"""

from bs4 import BeautifulSoup
import requests
import re
import csv
import pandas as pd
import time
import datetime
recipe = []
howToProceed = pd.read_csv('howToProceed.csv')
ingredients = pd.read_csv('ingredients.csv')
ingrdients_quantities = pd.read_csv('ingredient_quantities.csv')
steps = pd.read_csv('steps.csv')
recipes = pd.read_csv('recipes.csv')
nutrition_values = pd.read_csv('nutrition_values.csv')

#converting the dataframes to list
recipe_table = recipes.values.tolist()
qty_table = ingrdients_quantities.values.tolist()
method_table = steps.values.tolist()
howToProceed_table = howToProceed.values.tolist()
nutrients_table = nutrition_values.values.tolist()
ingridient_table = ingredients.values.tolist()


if len(recipe) == 0 or len(recipe) == 1 :
    a_z=['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    
    
    
    count = 1 #ingredient id as 1
    
    recipe_id = 1 #recipe id as 1
    for az in a_z:
        print("Alpha :", az)
        j = 1
        page = requests.get('https://www.tarladalal.com/RecipeAtoZ.aspx?beginswith=%s&pageindex=%d'%(az,j))
        soup=BeautifulSoup(page.text,'lxml')
        tag=soup('a',{'class':"respglink"})
        
        for t in tag:
            s=str(t)
        s1=re.search('([0-9]+)',s)
        k=int(s1.group(0)) ###### number of pages for a particular Alphabet
        
        while(j<k+1):
            
            print("j : ",j)
            page1 = requests.get('https://www.tarladalal.com/RecipeAtoZ.aspx?beginswith=%s&pageindex=%d'%(az,j))
            soup=BeautifulSoup(page1.text,'lxml')
       #     soup = BeautifulSoup(page1,features="lxml")

            links = soup.find_all('span', {"class": "rcc_recipename"})
        
            for link in links:
                print('https://www.tarladalal.com/' + link.find('a').get('href')) 
                r = 'https://www.tarladalal.com/' + link.find('a').get('href')
                try:
                    page2 = requests.get(r)
                except requests.exceptions.ConnectionError:
                    r.status_code = "Connection refused"
          #  page2 = requests.get(r)
                soup = BeautifulSoup(page2.text,'lxml')
            
            # Extracting the image url
                try:
                    img_link = soup.find('img', {"id":"ctl00_cntrightpanel_imgRecipe"})
                    url = 'https://www.tarladalal.com/'+ img_link['src']
                    #print ('https://www.tarladalal.com/'+ img_link['src'])
                except:
                    pass
            
            # Extracting the number of views 
                try:    
                    views = soup.find('span', {"id": "ctl00_cntrightpanel_lblViewCount"})
                    abc = views.text.split()
                    n = len(abc)
                    view = abc[n-2] + ' ' +abc[n-1]
                    #print(abc[n-2] + ' ' +abc[n-1])
                except:
                    pass
            
            #finding the recipe name
                recipe_name = soup.find("span",{"id": "ctl00_cntrightpanel_lblRecipeName"})
                #print("recipe name is ", recipe_name.text)


        # Get the description of the recipe
                sec = soup.find("div", {"id": "recipe_details_left"})
                desc = sec.find('span', {"itemprop" : "description"})
                #print(desc.text)
                
            #finding the Times 
            #prep time
                try:
                    prep_time = soup.find("time", {"itemprop": "prepTime"})
                    cook1 = prep_time.text.split()
                    if (cook1[1] == 'hours') :
                        pt = int(cook1[0])*60+int(cook1[2])
                        #print("Prep time in minutes is", int(cook1[0])*60+int(cook1[2]))
                    if (cook1[1] == 'hours.'):
                        pt = int(cook1[0])*60
                        #print("Prep time in minutes is", int(cook1[0])*60)
                    else:
                        pt = int(cook1[0])
                        #print("Prep time in minutes is", int(cook1[0]))
                except:
                    pass
                                #cook time
                try:
                    cooking_time = soup.find("time", {"itemprop": "cookTime"})
                    cook = cooking_time.text.split()
                    if (cook[1] == 'hours') :
                        ct = int(cook[0])*60+int(cook[2])
                        #print("Cooking time in minutes is", int(cook[0])*60+int(cook[2]))
                    if (cook[1] == 'hours.'):
                        ct = int(cook[0])*60
                        #print("Cooking time in minutes is", 60*int(cook[0]))
                    else:
                        ct = int(cook[0])
                        #print("Cooking time in minutes is", int(cook[0]))
        
                except:
                    pass
            # total time
                try:
                    total_time =  soup.find("time", {"itemprop": "totalTime"})
                    cook2 = total_time.text.split()
                    if (cook2[1] == 'hours') :
                        tt = int(cook2[0])*60+int(cook2[2])
                        #print("total time in minutes is", int(cook2[0])*60+int(cook2[2]))
                    if (cook2[1] == 'hours.'):
                        tt = int(cook2[0])*60
                        #print("total time in minutes is", int(cook2[0])*60)
                    else:
                        tt = int(cook2[0])
                        #print("total time in minutes is", int(cook2[0]))
                except:
                    pass
                recipe_table.append([int(recipe_id), recipe_name.text, desc.text,ct,pt,tt,url,view,r])
 # storing the recipe datials above ####################################################           
                
                ingridients = soup.find_all("span", {"itemprop": "recipeIngredient"}) # opening the ingridient link
            
                print("recipe_id :  \n", recipe_id )  
                for i in ingridients:    # loop in number of ingridients present for a recipe
         
                    try:
                        ing_name = i.select("span")[1].text.title() # tiltle casing the ingridients  
                        ingridient_table.append([count, ing_name])
                        qty_table.append([recipe_id, count, i.select("span")[0].text])
                        count+=1
                       
      # converting dataframe to csv
                    except:
                        pass
        
# Get recepie instructions list
                try:
                    recInstructions = soup.find("ol", {"itemprop": "recipeInstructions"})
                    method = recInstructions.find_all("li", {"itemprop": "itemListElement"})
                    c= 0
                    for i in method:
                        c+=1
                        method_table.append([recipe_id, c ,i.select("span")[0].text])
                    
                except:
                    pass              
                    
    # Get how to proceed list
                try:
                    recInstructions = soup.find_all("ol", {"itemprop": "recipeInstructions"})
                    howToProceed = recInstructions[1].find_all("li", {"itemprop": "itemListElement"})
                    c= 0
                    for i in howToProceed:
                        c+=1
                        howToProceed_table.append([recipe_id, c ,i.select("span")[0].text])
                    
                except:
                    pass
                    
                    # Get table data
                    
                nutrition_df = []
                nutrition = soup.find("table", {"id": "rcpnutrients"})
                try:
                    nutrition_df = pd.read_html(str(nutrition))
                    nutrition1_df= nutrition_df[0]
                    n = len(nutrition1_df[0])
                    for i in range(0,n):
                        nutrients_table.append([recipe_id,nutrition1_df[0][i],nutrition1_df[1][i].split()[0],nutrition1_df[1][i].split()[1]])
                        
                except:
                    print("failed")
                    pass
                recipe_id+= 1
        
            j+=1     
            
    recipe_table = pd.DataFrame(recipe_table)
    recipe_table.to_csv('recipes2.csv')
    howToProceed_table = pd.DataFrame(howToProceed_table)
    howToProceed_table.to_csv('howToProceed2.csv')
    nutrients_table = pd.DataFrame(nutrients_table)
    nutrients_table.to_csv('nutrition_values2.csv')
    method_table = pd.DataFrame(method_table)
    method_table.to_csv('steps2.csv')
    qty_table = pd.DataFrame(qty_table)
    qty_table.to_csv('ingredient_quantities2.csv')
    ingridient_table = pd.DataFrame(ingridient_table)
    ingridient_table.to_csv('ingredients2.csv')
    
    last_date = datetime.date.today()
    last_date = last_date.strftime('%d/%m/%Y')
    
else:   ################# scraping the latest recipe only
    print("case 2");
    recipe_id = len(recipes)+1 ## updating the recipe_id
    ing_id = len(ingredients)+1 ## updating the ingredient id 
    
    page = requests.get('https://www.tarladalal.com/latest_recipes.aspx?pageindex=1')
    soup=BeautifulSoup(page.text,'lxml')
    tag=soup('a',{'class':"respglink"})
    day = []
    recipe_date = []
    last_date = '04/05/2019'  ## store the last date on which the scraping was done
    last = datetime.datetime.strptime(last_date, "%d/%m/%Y") + datetime.timedelta(days = 1) #### assuming all the recipes added on the last date is scraped
    count = 0
    b = 55555555555
    for t in tag:
        s=str(t)
    s1=re.search('([0-9]+)',s)
    k=int(s1.group(0))
   
    for i in range(k+1):
        page = requests.get('https://www.tarladalal.com/latest_recipes.aspx?pageindex=%d'%(i))
        soup=BeautifulSoup(page.text,'lxml')
    #tag=soup('a',{'class':"respglink"})
        date  = soup.find_all('span',{"style":"font-size:8pt;color:#636770;"})
        for a in date:
            dat = (''.join(a.find('br').next_siblings)) 
            #print(dat)
            if (dat == 'Today') or (dat== 'Yesterday'):
                if dat == 'Today':
                    d = (datetime.datetime.today())                  ### scraping the date of the recipe
                    #print(d.strftime('%d/%m/%Y'))
                    d = d.strftime('%d/%m/%Y')
                else :
                    today = datetime.date.today()
                    d = today - datetime.timedelta(days = 1)
                    #print(d.strftime('%d/%m/%Y'))
                    d = d.strftime('%d/%m/%Y')
            else:
                d = datetime.datetime.strptime(dat, '%d %b %y').strftime('%d/%m/%Y')
                #print(d)  
            d  = datetime.datetime.strptime(d, "%d/%m/%Y")
            if(last <= d):
                count+=1   
            else:    
                b = 0
                break
        if(b == 0):
            break
    cn =  0 
    a = 1
    br = 55555   
    for i in range(k+1):
        page = requests.get('https://www.tarladalal.com/latest_recipes.aspx?pageindex=%d'%(i))
        soup=BeautifulSoup(page.text,'lxml')
        links = soup.find_all('span', {"class": "rcc_recipename"})
            
        for link in links:
            if cn == count :
                br = 0
                break
            else:
                cn+=1
                
            #print(a)
            a = a+1
            print('https://www.tarladalal.com/' + link.find('a').get('href')) 
            r = 'https://www.tarladalal.com/' + link.find('a').get('href')
            try:
                page2 = requests.get(r)
            except requests.exceptions.ConnectionError:
                r.status_code = "Connection refused"
            soup = BeautifulSoup(page2.text,'lxml')
    # Extracting the image url
            try:
                img_link = soup.find('img', {"id":"ctl00_cntrightpanel_imgRecipe"})
                url = 'https://www.tarladalal.com/'+ img_link['src']
                #print ('https://www.tarladalal.com/'+ img_link['src'])
            except:
                pass
        
        # Extracting the number of views 
            try:    
                views = soup.find('span', {"id": "ctl00_cntrightpanel_lblViewCount"})
                abc = views.text.split()
                n = len(abc)
                view = abc[n-2] + ' ' +abc[n-1]
                #print(abc[n-2] + ' ' +abc[n-1])
            except:
                pass
        
        #finding the recipe name
            recipe_name = soup.find("span",{"id": "ctl00_cntrightpanel_lblRecipeName"})
            #print("recipe name is ", recipe_name.text)

        # Get the description of the recipe
            sec = soup.find("div", {"id": "recipe_details_left"})
            desc = sec.find('span', {"itemprop" : "description"})
            #print(desc.text)
            
            #finding the Times 
            #prep time
            try:
                prep_time = soup.find("time", {"itemprop": "prepTime"})
                cook1 = prep_time.text.split()
                if (cook1[1] == 'hours') :
                    pt = int(cook1[0])*60+int(cook1[2])
                    #print("Prep time in minutes is", int(cook1[0])*60+int(cook1[2]))
                if (cook1[1] == 'hours.'):
                    pt = int(cook1[0])*60
                    #print("Prep time in minutes is", int(cook1[0])*60)
                else:
                    pt = int(cook1[0])
                    #print("Prep time in minutes is", int(cook1[0]))
            except:
                pass
                #cook time
            try:
                cooking_time = soup.find("time", {"itemprop": "cookTime"})
                cook = cooking_time.text.split()
                if (cook[1] == 'hours') :
                    ct = int(cook[0])*60+int(cook[2])
                    #print("Cooking time in minutes is", int(cook[0])*60+int(cook[2]))
                if (cook[1] == 'hours.'):
                    ct = int(cook[0])*60
                    #print("Cooking time in minutes is", 60*int(cook[0]))
                else:
                    ct = int(cook[0])
                    #print("Cooking time in minutes is", int(cook[0]))
    
            except:
                pass
            # total time
            try:
                total_time =  soup.find("time", {"itemprop": "totalTime"})
                cook2 = total_time.text.split()
                if (cook2[1] == 'hours') :
                    tt = int(cook2[0])*60+int(cook2[2])
                    #print("total time in minutes is", int(cook2[0])*60+int(cook2[2]))
                if (cook2[1] == 'hours.'):
                    tt = int(cook2[0])*60
                    #print("total time in minutes is", int(cook2[0])*60)
                else:
                    tt = int(cook2[0])
                    #print("total time in minutes is", int(cook2[0]))
            except:
                pass
        
            recipe_table.append([int(recipe_id), recipe_name.text, desc.text,ct,pt,tt,url,view])
 # storing the recipe datials above ####################################################     

            ingridients = soup.find_all("span", {"itemprop": "recipeIngredient"}) # opening the ingridient link
            
            #print("recipe_id :  \n", recipe_id )  
            for i in ingridients:    # loop in number of ingridients present for a recipe
                
                try:
                    ing_name = i.select("span")[1].text.title() # tiltle casing the ingridients  
                    ingridient_table.append([ing_id, ing_name])
                    qty_table.append([recipe_id, ing_id, i.select("span")[0].text])
                    ing_id+=1
                
      # converting dataframe to csv
                except:
                    pass
        
# Get recepie instructions list
            try:
                recInstructions = soup.find("ol", {"itemprop": "recipeInstructions"})
                method = recInstructions.find_all("li", {"itemprop": "itemListElement"})
                c= 0
                for i in method:
                    c+=1
                    method_table.append([recipe_id, c ,i.select("span")[0].text])
                
            except:
                pass              
                    
    # Get how to proceed list
            try:
                recInstructions = soup.find_all("ol", {"itemprop": "recipeInstructions"})
                howToProceed = recInstructions[1].find_all("li", {"itemprop": "itemListElement"})
                c= 0
                for i in howToProceed:
                    c+=1
                    howToProceed_table.append([recipe_id, c ,i.select("span")[0].text])
                    
            except:
                pass
        
            nutrition_df = []
            nutrition = soup.find("table", {"id": "rcpnutrients"})
            try:
                nutrition_df = pd.read_html(str(nutrition))
                nutrition1_df= nutrition_df[0]
                n = len(nutrition1_df[0])
                for i in range(0,n):
                    nutrients_table.append([recipe_id,nutrition1_df[0][i],nutrition1_df[1][i].split()[0],nutrition1_df[1][i].split()[1]])
                        
                      
            except:
                pass
            recipe_id+= 1    
        if br == 0:
            break
        
    recipe_table = pd.DataFrame(recipe_table)
    recipe_table.to_csv('recipes2.csv')
    howToProceed_table = pd.DataFrame(howToProceed_table)
    howToProceed_table.to_csv('howToProceed2.csv')
    nutrients_table = pd.DataFrame(nutrients_table)
    nutrients_table.to_csv('nutrition_values2.csv')
    method_table = pd.DataFrame(method_table)
    method_table.to_csv('steps2.csv')
    qty_table = pd.DataFrame(qty_table)
    qty_table.to_csv('ingredient_quantities2.csv')
    ingridient_table = pd.DataFrame(ingridient_table)
    ingridient_table.to_csv('ingredients2.csv')
    
    # storing the lastdate when scraping took place
    last_date = datetime.date.today()
    last_date = last_date.strftime('%d/%m/%Y')
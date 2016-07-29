# Foreign-Policy-Article-Hits

This repository contains files to create maps in R with ggplot of website visits to 
this article http://foreignpolicy.com/2016/07/26/map-china-skyrocketing-housing-prices-real-estate-bubble/

Once all files are put in the same directory and the working drive is set to that directory 
in the R code it should be straight forward to run the code and create the maps. 

The json file contains data from website visits from about 3:00pm to about 8:00pm on June 27th, and then from about 
6:00am to about 10:00am on June 28th. There are about 385 observations.

The csv file contains data from website visists from 6:00am on June 27 to 6:00am on June 28th. There are 1000 observations. 

The shapefiles for the maps can be downloaded here:
http://www.naturalearthdata.com/downloads/50m-cultural-vectors/

The credit for the function to get the geographic locations goes to Andrew Ziem:
https://heuristically.wordpress.com/2013/05/20/geolocate-ip-addresses-in-r/

The longer post I created for the Foreign Policy article can be found here:
http://dataspiked.com/2016/06/19/chinese-cities-residential-real-estate-prices/

# Foreign-Policy-Article-Hits

This repository contains files to create maps in R with ggplot of website visits to 
this article http://foreignpolicy.com/2016/07/26/map-china-skyrocketing-housing-prices-real-estate-bubble/

Once all files are put in the same directory and the working drive is set to that directory 
in the R code it should be straight forward to run the code and create the maps. 

The json file used contained data from website visits from about 3:00pm to about 8:00pm on June 27th, and then from about 
6:00am to about 10:00am on June 28th. There are about 385 observations. Each json object looked like:
{"localtime":"7\/27\/16 7:52 PM","protocol":"HTTP\/1.1","status":"200","ip":"##.###.##.###","httpdate":"27\/Jul\/2016:19:52:52","size":"36274","timestamp":1469670772,"agent":"Mozilla\/5.0 (iPad; CPU OS 9_3_2 like Mac OS X) AppleWebKit\/601.1.46 (KHTML, like Gecko) Mobile\/13F69","url":"\/chinarealestate\/Indexed_China_Housing.csv","tz":"-0600","method":"GET","referer":"http:\/\/dataspiked.com\/chinarealestate\/","line":999}

The csv file used contained data from website visists from 6:00am on June 27 to 6:00am on June 28th. There are 1000 observations. The data was copied in a table format.  

The shapefiles for the maps can be downloaded here:
http://www.naturalearthdata.com/downloads/50m-cultural-vectors/

The credit for the function to get the geographic locations goes to Andrew Ziem:
https://heuristically.wordpress.com/2013/05/20/geolocate-ip-addresses-in-r/

The longer post I created for the Foreign Policy article can be found here:
http://dataspiked.com/2016/06/19/chinese-cities-residential-real-estate-prices/

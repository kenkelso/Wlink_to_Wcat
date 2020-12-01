# Wlink_to_Wcat
Converts WeatherLink data to WeatherCAT data

It is built using Lazarus and Free Pascal on MacOs

It is a quick and dirty hack but you will only use it once. The .dmg and .app are code signed and notarized by Apple so if you just need to run it there should be no problems.

Make sure you have a backup of your data before using the App. I take no responsibility for loss of data. I suggest you don't select the live WeatherCat data directories but do the conversion elsewhere and when satisfied the files are OK copy them. WeatherCAT year folders will be found in /user/library/WeatherCatData/Location where user and location are specific to your installation. If your WeatherLink data ends mid year you will need to merge the resultant relevant month files together.
If you have months with no data the WeatherCat file must contain at least the following:

VERS:3

t:010000 V:4

This application only converts data from a basic Davis Vantage Pro station, optional sensors such as Solar and Soil moisture are set to 0. Hourly Rain is not calculated.

1/ Make sure WeatherCat is not running.
2/ Make a folder to do the conversion in, create sub-folders for each year of data being converted i.e. 2006, 2007, 2008 etc.
3/ In WeatherLink using the Browse option export the data a year at a time, name the file with the year.
4/ Use the App. to open the WeatherLink year file.
5/ Select a directory for the WeatherCat .cat file. (one of the year folders created earlier)
6/ Check that the DataFile version shown in the App. is the same as that in your WeatherCat files (VERS:3 is current at the time of writing)
7/ If you would like to reduce the number of readings to 4 per hour check the 15 minute samples box.
8/ Select the units that your WeatherLink data uses (WeatherCat data is stored in metric units so the application must do conversion)
9/ Press Convert.
10/ Repeat steps 4 to 9 for all years requiring conversion.
11/ Copy the converted WeatherCat data into your /user/library/WeatherCatData/Location. Be careful not to overwrite existing years/month files created by WeatherCat, you will need to merge month files unless you started using WeatherCat on a year boundary.

Note that the WeatherCat .hrs files will be created automatically when you start WeatherCat.

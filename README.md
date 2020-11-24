# Wlink_to_Wcat
Converts WeatherLink data to WeatherCAT data

It is built using Lazarus Free Pascal on MacOs

This app. has no code signing certificate so you need to change your security settings to use it.
Make sure you have a backup of your data before using the App. I take no responsibility for loss of data. I suggest you don't select the live WeatherCat data directories but do the conversion elsewhere and when satisfied the files are OK copy them. WeatherCAT year folders will be found in /user/library/WeatherCatData/Location where user and location are specific to your installation. If your WeatherLink data ends mid year you will need to merge the resultant relevant month files together.
If you have missing months in your WeatherLink data the app will create an empty WeatherCat month file and you will need to add the following line to each empty file:

t:000030 V:4

To use the app.

1/ Make a folder to do the conversion in.

2/ In WeatherLink using the Browse option export the data a year at a time, name the file with the year.

3/ Use the App. to open the WeatherLink year file.

4/ Select a directory for the WeatherCat .cat file.

5/ Check that the DataFile version shown in the App. is the same as that in your WeatherCat files (VERS:3 is current at the time of writing)

6/ If you would like to reduce the number of readings to 4 per hour check the 15 minute samples box.

7/ Press Convert.

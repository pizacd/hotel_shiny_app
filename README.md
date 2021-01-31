# hotel_shiny_app
Dataset can be found [here](https://www.kaggle.com/jessemostipak/hotel-booking-demand). The data is originally from the article `Hotel Booking Demand Datasets`, written by Nuno Antonio, Ana Almeida, and Luis Nunes for Data in Brief, Volume 22, February 2019.

It contains hotel reservation data for two hotels in Portugal: a city hotel in Lisbon and a resort hotel in Algarve. These check-in dates occurred between July 2015 and August 2017.

![Algarve, Portugal](https://image.freepik.com/free-photo/view-ponta-da-piedade-sunrise-algarve-portugal_268835-310.jpg)

The objective was to create an R Shiny dashboard to:
1. Summarize revenue year-by hotel and season. 
2. Gain insights into the client base, including where they are from, how they book their stays and how far in advance they book these stays.
3. Evaluate the subset of guests that canceled their reservations prior to check-in, and determine if there are any underlying reasons as to why they made said cancelation.

First, I had to clean the dataset, which I did in the script `preprocessing.R`, removing any additional columns that were not useful to achieving the above objectives. I also had to join the hotel dataset with the ISO country code dataset on [Datahub]('https://datahub.io/core/country-codes/r/country-codes.csv').

From there, I created additional columns such as total revenue earned for each stay, which continent/region each guest was from, and other variables I found to be relevant for these analyses.


For more information, or to get in touch with me, please check out my [LinkedIn](https://www.linkedin.com/in/douglas-pizac-ms/).
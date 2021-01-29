#Milestone 3 Reflection

We have successfully managed to port over/recreate a version of Wine Valley running through R dash rather than the Python. This version includes all of the same sliders/dropdowns and equivalent plots/maps to present all of our data. Plots/maps made with altair have been replaced with ggplot/plotly alternatives in this version resulting in a version the dashboard that appears somewhat different but provides functional parity.

Porting our code over to R provided some challenges, with a particular challenge being converting all of our plotting code from working in altair to working in ggplot/plotly. Also, since dash appears to be more widely used in python than R searching the internet for help often yielded fewer results.

A known issue is that when a country is selected that only the top handful of highest rated varieties are represented on our bar plots. We’ve tried to rectify this issue however the number of categories in variety makes the graph appear too crammed within our layout and becoming illegible. As such, we’ve chosen to leave it as is. Next week we plan to implement a variety dropdown to allow the user to filter varieties (as per TA feedback) so this will provide a solution to this issue. 

Additionally, in our proposal sketch we considered including a search bar for a specific type of wine, however, the TA has pointed out that this likely is not necessary since the purpose of our app is not to be used to track down a specific wine but rather to identify new ones based on a number of different factors. 

Another point of feedback mentioned by the TA was that the ranges of our sliders is not entirely clear (i.e. that WineEnthusiast scores are between 80 and 100). We could rectify this issue by mentioning in the title of each slider what the ranges are.

Joel also mentioned that colour could help improve the appearance of our dashboard. For milestone 4 we will try to colour our dashboard based on what is shown in our initial sketch.

The map is also not currently linked with the country dropdown. This is something we hope to implement (as per TA feedback) in our milestone 4.

We have decided that we will be moving forward with the python version of our dashboard for milestone 4 since our team experienced less issues working with python than with R and since there appear to be more online resources available for the python version.

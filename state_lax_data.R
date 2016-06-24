#load libraries
library(XML)
library(ggplot2)
library(maps)
library(plyr)
library(mapproj)

#read in data
unemp= read.csv("states_lax.csv")
#colClasses<- c('factor', 'factor', 'numeric')
unemp$rank<-as.factor(unemp$rank)
unemp$region<-as.factor(unemp$region)
unemp$rate<-as.numeric(unemp$rate)



#rename cols and convert region to lower colClasses
names(unemp)<- c('rank', 'region', 'rate')
unemp$region<-tolower(unemp$region)

#get US state map data and merge with unemp
us_state_map<-map_data('state')
map_data<- merge(unemp, us_state_map, by='region')

#keep data sorted by polygon region
map_data<-arrange(map_data, order)

#plot map using ggplot2

p<- ggplot(map_data, aes(x=long, y=lat, group=group))+
	geom_polygon(aes(fill=cut_number(rate,5)))+
	geom_path(colour=gray, linestyle=2)+
	scale_fill_brewer('NCAA D1 Players \n per state 2013-14 Rosters', palette='Blues')+
	coord_map()

#add state names
nrate<- data.frame(unemp$rate[1:50])
states <- data.frame(state.center, unrate)
p<- p+geom_text(data=states, aes(x=x, y=y, label=state.abb, group=NULL), size=2)

#add title
p<-p+ggtitle("D1 Lacrosse Players from each state \n Continental US")

#add number of players to be displayed center of state
unrate<- data.frame(unemp$rate[1:50])
states <- data.frame(state.center, unrate)
p<- p+geom_text(data=states, aes(x=x, y=y, label=unrate group=NULL), size=2)



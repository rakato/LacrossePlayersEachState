#load libraries
library(XML)
library(ggplot2)
library(maps)
library(plyr)
library(mapproj)

#read in data
lax<- read.csv("states_lax.csv")
#colClasses<- c('factor', 'factor', 'numeric')
lax$rank<-as.factor(lax$rank)
lax$region<-as.factor(lax$region)
lax$rate<-as.numeric(lax$rate)



#rename cols and convert region to lower colClasses
names(lax)<- c('rank', 'region', 'rate')
lax$region<-tolower(lax$region)

#get US state map data and merge with lax
us_state_map<-map_data('state')
map_data<- merge(lax, us_state_map, by='region')

#keep data sorted by polygon region
map_data<-arrange(map_data, order)

#add number of players to be displayed center of state
unrate<- data.frame(lax$rate[1:50])
states <- data.frame(state.center, unrate)
#plot map using ggplot2

p<- ggplot(map_data, aes(x=long, y=lat, group=group))+
	geom_polygon(aes(fill=cut_number(rate,5)))+
	scale_fill_brewer('NCAA D1 Players \n per state 2013-14 Rosters', palette='Blues')+
	coord_map()

#add state names
nrate<- data.frame(lax$rate[1:50])
states <- data.frame(state.center, unrate)
p<- p+geom_text(data=states, aes(x=x, y=y, label=state.abb, group=NULL), size=4)+
ggtitle("D1 Lacrosse Players from each state \n Continental US")

#Add numbers in each state
p<- p+geom_text(data=states, aes(x=x, y=y, label=unrate, group=NULL), size=2)



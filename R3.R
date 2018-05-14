# Ejercicios con el dataset flights

list.of.packages <- c("dplyr","readr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(nycflights13)


##### Ejercicio1 #####
# Filtra todas las columnas de retraso, origen, destino, carrier y distancia
head(flights)
flights %>% 
  select(ends_with("_delay"), carrier, origin, dest, distance)
# Guarda este dataframe
flightsE1 <- flights %>% 
  select(ends_with("_delay"), carrier, origin, dest, distance)

##### Ejercicio2 #####
# Calcula la media de la distancia por cada origen-destino
flights %>% 
  group_by(origin, dest) %>% 
  summarise(medDist = mean(distance, na.rm = T))


##### Ejercicio3 #####
# Calcula la correlación entre la distancia y el total del retraso
flightsTD <- flights %>% 
  mutate(totalDelay = arr_delay + dep_delay)
cor(flightsTD$totalDelay, flightsTD$distance, use = "complete.obs") # "complete.obs", los NA se manejan mediante eliminación por caso (y si no hay 
# casos completos, se produce un error).
cTDD <- flightsTD %>% 
  select(distance, totalDelay) %>% 
  as.matrix
cor(cTDD, use = "complete.obs")
matrizCor <- flightsTD %>% 
  select(distance, totalDelay) %>% 
  as.matrix %>% 
  cor(use = "complete.obs")
matrizCor  


##### Ejercicio4 #####
# Cual es el top 10 de aeropuertos de origen con más media de retraso total
flights %>% 
  group_by(origin) %>% 
  summarise(medDel = mean(arr_delay + dep_delay, na.rm = T)) %>% 
  top_n(10)
flights %>% 
  mutate(totalDel = arr_delay + dep_delay) %>% 
  group_by(origin) %>% 
  summarise(medDel = mean(totalDel, na.rm = T)) %>% 
  top_n(10)


##### Ejercicio5 #####
# Filtra todos aquellos vuelos que superen la media de arr_delay
flights %>% 
  filter(arr_delay > mean(arr_delay, na.rm = T)) 


##### Ejercicio6 #####
# Filtra aquellas rutas que superen la media de las medias del retraso total de las rutas
flights %>% 
  group_by(origin, dest) %>% 
  summarise(medDel = mean(arr_delay + dep_delay,  na.rm = T)) %>% 
  filter(medDel > mean(medDel))

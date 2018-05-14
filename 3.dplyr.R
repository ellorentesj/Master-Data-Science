##### 3. DPLYR#####
# Identify the most important data manipulation tools needed for data analysis and make them easy 
# to use in R. Provide blazing fast performance for in-memory data by writing key pieces of code 
# in C++. Use the same code interface to work with data no matter where it’s stored, whether in a
# data frame, a data table or database.

# The 5 verbs of dplyr
# select – removes columns from a dataset
# filter – removes rows from a dataset
# arrange – reorders rows in a dataset
# mutate – uses the data to build new columns and values
# summarize – calculates summary statistics
# dplyr provides several helpful aggregate functions of its own, in addition to the ones that are 
# already defined in R. These include:
# first(x) - The first element of vector x.
# last(x) - The last element of vector x.
# nth(x, n) - The nth element of vector x.
# n() - The number of rows in the data.frame or group of observations that summarise() describes.
# n_distinct(x) - The number of unique values in vector x. - para variables categóricas

library(dplyr)
library(nycflights13)

# Vemos la cabecera y la cola de flights
head(flights)
tail(flights)

# Vamos a coger aquellas columnas que acaban en "_delay"
flights[,grepl("_delay",colnames(flights))] # grepl busca coincidencias con el patrón del 
# argumento "_delay" dentro de cada elemento de un vector de caracteres "flights"
flights[,grep("_delay", colnames(flights))]

# Se podría desglosar de una manera más sencilla:
mascara <- grep("_delay",colnames(flights))
flights[,mascara]

# Como generar una muestra aleatoria de 10 al azar:
runif(10, 1, 10) # proporcionan información sobre la distribución uniforme en el intervalo de 
# mínimo a máximo
rnorm() # Densidad, función de distribución, función de cuantiles y generación aleatoria para la 
# distribución normal con media igual a media y desviación estándar igual a sd.
sample(1:10,5) # sample toma una muestra del tamaño especificado 5 de los elementos de 1:10, 
# usando ya sea con o sin reemplazo
sample(c("Carlos", "Maria", "Alejandro"), 2)
sample.int(100, 2)
# Tomamos una muestra aleatoria de 10 de la columnas que terminen en "_delay"
flights[sample.int(nrow(flights), 10),
        grep("_delay", colnames(flights))]
# Ahora con los vuelos de UA
flightsUA <- flights[flights$carrier == "UA",]
flightsUA[sample.int(nrow(flightsUA), 10),
          grep("_delay", colnames(flightsUA))]

# Es muy útil para seleccionar datos, usar el operador %in% que sirve para comprobar si algo está 
# dentro de un conjunto
c(1, 3, 18) %in% c(1,2,3,4,5,6,7,8,9)
# devuelve: TRUE, TRUE, FALSE


##### 3.1. SELECT() #####
# DPLYR es la manera primordial de manipular datos a día de hoy. Dplyr funciona con verbos, que no 
# son más que funciones para procesar datos. El verbo para seleccionar columnas se llama "select": 
# Seleccionar del dataset flights las columnas carrier y arr_delay
select(flights, carrier, arr_delay)
# Para elegir todas las columnas que contengan la cadena "_delay", existe la función "contains"
select(flights, contains("_delay"), carrier)
# Funciones de ayuda
# starts_with(“X”): every name that starts with “X”
# ends_with(“X”): every name that ends with “X”
# contains(“X”): every name that contains “X”
# matches(“X”): every name that matches “X”, where “X” can be a regular expression
# num_range(“x”, 1:5): the variables named x01, x02, x03, x04 and x05
# one_of(x): every name that appears in x, which should be a character vector
# Sudmuestreos, con las funciones sample_n y sample_frac: Vamos a repetir la selección aleatoria de
# vuelos pero con dplyr
sample_n(select(flights,contains("_delay")), 10) # A la función sample_n le entra una tabla y de 
# esa tabla escoge 10 elementos al azar, en nuestro caso la tabla va a ser una tabla donde tenemos 
# que seleccionar los columnas que contengan "_delay". Como se puede observar, estamos anidando 
# funciones para poder realizar dos operaciones. Esto es bastante incómodo y es proclive a errores.
# Se puede realizar de manera más sencilla con el operador tubería %>% :
select(flights, contains("_delay")) %>% # Leido de izquierda a derecha, seleccionamos los vuelos 
  # que contienen columnas con la palabra "_delay"
  sample_n(10) #  y %>% de ahí tomamos 10 ejemplos
# Si desglosamos esta operación aún más:
flights %>% # Del dataframe vuelos
  select(contains("_delay")) %>% # Seleccionamos aquellos que sus columnas contengan la palabra 
  # "_delay"
  sample_n(10) # y cogemos 10 elementos aleatorios
# Se puede guardar el resultado en otro dataframe
flightsUA <- flights %>% # Del dataframe flights
  filter(carrier == "UA") %>% # filtramos por aquellas líneas cuya columna carrier tenga el valor 
  # "UA"
  select(contains("_delay")) %>% # de el dataset anterior, nos quedamos con las columnas que 
  # contengan la palabra "_delay"
  sample_n(10) # Seleccionamos 10 filas de estas dos columnas
# %>% lo que hace es coger lo que está a su izquierda y lo incrusta como primer parámetro de la 
# función que está a su derecha


##### 3.2. FILTER() #####
# x < y, TRUE if x is less than y
# x <= y, TRUE if x is less than or equal to y
# x == y, TRUE if x equals y
# x != y, TRUE if x does not equal y
# x >= y, TRUE if x is greater than or equal to y
# x > y, TRUE if x is greater than y
# x %in% c(a, b, c), TRUE if x is in the vector c(a, b, c)
# Más de un filtro simultáneo
flights %>% 
  filter(carrier == "UA", arr_delay > 1)
# o bien aplicamos el filtro a cada uno de los resultados
flights %>% 
  filter(carrier == "UA") %>% 
  filter(arr_delay > 1)
# o usando el operador & (NO recomendable con dplyr)
flights %>% 
  filter(carrier == "UA" & arr_delay > 1)
# Print out all flights in hflights that traveled 3000 or more miles
filter(flights, Distance > 3000)
# All flights flown by one of AA or UA
filter(flights, UniqueCarrier %in% c('AA', 'UA'))
# All flights where taxiing took longer than flying
# Taxi-Out Time: The time elapsed between departure from the origin airport gate and wheels off.
# Taxi-In Time: The time elapsed between wheels-on and gate arrival at the destination airport.
filter(flights, TaxiIn + TaxiOut > AirTime)
# Combining tests using boolean operators
# All flights that departed late but arrived ahead of schedule
filter(flights, DepDelay > 0 & ArrDelay < 0)
# All flights that were cancelled after being delayed
filter(flights, Cancelled == 1, DepDelay > 0)
# Keep rows that have no NA TaxiIn and no NA TaxiOut: temp2
taxi <- flights %>% 
  filter(!is.na(TaxiIn), !is.na(TaxiOut))
# Filter flights to keep all American Airline flights: aa
aa <- flights %>% 
  filter(UniqueCarrier == "AA")

##### 3.2.2. Ejercicio #####
# How many weekend flights to JFK airport flew a distance of more than 1000 miles 
# but had a total taxiing time below 15 minutes?
# 1) Select the flights that had JFK as their destination and assign the result to jfk
jfk <- filter(flights, Dest =='JFK')
# 2) Combine the Year, Month and DayofMonth variables to create a Date column
(jfk <- mutate(jfk, Date = as.Date(paste(Year, Month, DayofMonth, sep = "-"))))
# 3) Result:
nrow(filter(jfk, DayOfWeek %in% c(6,7), Distance > 1000, TaxiIn + TaxiOut <= 15))
# 4) Delete jfk object to free resources 
rm(jfk)


##### 3.3. ARRANGE() #####
# Ordenar con arrange:
flights %>% 
  arrange(year)
flights %>% 
  arrange(desc(year))
flights %>% 
  arrange(-year) # - sólo puede usarse en caso de que se trate de un número
# Cancelled
cancelled <- flights %>% 
  select(UniqueCarrier, Dest, Cancelled, CancellationCode, DepDelay, ArrDelay) 
cancelled <- flights %>% 
  filter(cancelled, Cancelled == 1, !is.na(DepDelay))
# Arrange cancelled by departure delays
cancelled %>% 
  arrange(DepDelay)
# Arrange cancelled so that cancellation reasons are grouped
cancelled %>% 
  arrange(CancellationCode)
# Arrange cancelled according to carrier and departure delays
cancelled %>% 
  arrange(UniqueCarrier, DepDelay)
# Arrange cancelled according to carrier and decreasing departure delays
cancelled %>% 
  arrange(UniqueCarrier, desc(DepDelay))
rm(cancelled)
# Arrange flights by total delay (normal order).
flights %>% 
  arrange(DepDelay + ArrDelay)
# Keep flights leaving to DFW and arrange according to decreasing AirTime 
arrange(filter(flights, Dest == 'JFK'), desc(AirTime))


##### 3.4. MUTATE() #####
# Modificación de datos
# Para crear nuevas variables (columnas) se utilizan las funciones mutate y transmutate
# mutate() añade nuevas variables preservando las existentes
# transmutate() elimina las variables existentes
flights2 <- flights %>% 
  mutate(totalDelay = arr_delay + dep_delay)
# Varias operaciones
foo <- flights %>% 
  mutate(loss = ArrDelay - DepDelay, loss_percent = (loss/DepDelay) * 100 )

##### 3.4.1. Ejercicio #####
# Mutate the data frame so that it includes a new variable that contains the average speed, 
# avg_speed traveled by the plane for each flight (in mph).
# Hint: Average speed can be calculated as distance divided by number of hours of travel, and note 
# that AirTime is given in minutes
foo <- flights %>% 
  mutate(avg_speed = Distance / AirTime * 60)
foo %>% select(Distance, AirTime, avg_speed)


##### 3.5. SUMMARISE() #####
# min(x) – minimum value of vector x.
# max(x) – maximum value of vector x.
# mean(x) – mean value of vector x.
# median(x) – median value of vector x.
# quantile(x, p) – pth quantile of vector x.
# sd(x) – standard deviation of vector x.
# var(x) – variance of vector x.
# IQR(x) – Inter Quartile Range (IQR) of vector x.
# Print out a summary with variables min_dist and max_dist
# Reducimos el tamaño del dataset que contiene la información de las filas que hemos filtrado
flights %>% 
  summarize(min_dist = min(Distance), max_dist = max(Distance))
# Remove rows that have NA ArrDelay: temp1
na_array_delay <- flights %>% 
  filter(!is.na(ArrDelay))
# Generate summary about ArrDelay column of temp1
na_array_delay %>% 
  summarise(earliest = min(ArrDelay), 
            average = mean(ArrDelay), 
            latest = max(ArrDelay), 
            sd = sd(ArrDelay))
#histograma
hist(na_array_delay$ArrDelay)
summary(na_array_delay$ArrDelay)
rm(na_array_delay)

##### 3.5.1. Ejercicio #####
# Print the maximum taxiing difference of taxi with summarise()
summarise(taxi, max_taxi_diff = max(abs(TaxiIn - TaxiOut)))

##### 3.5.2. Ejercicio #####
# Print out a summary of aa with the following variables:
# n_flights: the total number of flights,
# n_canc: the total number of cancelled flights,
# p_canc: the percentage of cancelled flights,
# avg_delay: the average arrival delay of flights whose delay is not NA.
summarise(aa, n_flights = n(),
          n_canc = sum(Cancelled),
          p_canc = 100 * (n_canc / n_flights),
          acg_delay = mean(ArrDelay, na.rm = TRUE)) # calcula la media de la columna de ArrDelay, 
# eliminando aquellas que tengan un NA
# Next to these dplyr-specific functions, you can also turn a logical test into an aggregating 
# function with sum() or mean(). 
# A logical test returns a vector of TRUE’s and FALSE’s. When you apply sum() or mean() to such a 
# vector, R coerces each TRUE to a 1 and each FALSE to a 0. This allows you to find the total 
# number or proportion of observations that passed the test, respectively
set.seed(1973)
(foo <- sample(1:10, 5, replace=T))
foo > 5
sum(foo > 5) # num. elementos > 5
mean(foo) 
mean(foo > 5) #la media del número de elementos que son TRUE

##### 3.5.3. Ejercicio #####
# Exercise: 
# Print out a summary of aa with the following variables:
# n_security: the total number of cancelled flights by security reasons,
# CancellationCode: reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
summarise(aa,
          n_security = sum(CancellationCode == "D", na.rm = TRUE))


##### 3.6. GROUP_BY() #####
# Operaciones agrupadas (estilo GROUP BY)
# Para realizar una operación agrupada, primero hay que realizar un group_by que se realizará sobre
# una operación.
flights %>% 
  group_by(carrier) %>% 
  summarise(medDelay = mean(arr_delay, na.rm = T)) # summarise() se usa generalmente en datos 
# agrupados creados por group_by. La salida tendrá una fila para cada grupo
flights %>% 
  group_by(carrier,origin) %>% 
  summarise(medDelay = mean(arr_delay, na.rm = T))
flights %>% 
  group_by(UniqueCarrier) %>% #agrupado por compañía aérea
  summarise(n_flights = n(), 
            n_canc = sum(Cancelled), 
            p_canc = 100*n_canc/n_flights, 
            avg_delay = mean(ArrDelay, na.rm = TRUE)) %>% 
  arrange(avg_delay) %>% View()
#Tiempos por día de la semana
flights %>% 
  group_by(DayOfWeek) %>% 
  summarize(avg_taxi = mean(TaxiIn + TaxiOut, na.rm = TRUE)) %>% 
  arrange(desc(avg_taxi)) %>% View()
# Combine group_by with mutate
# ranking 
rank(c(21, 22, 24, 23))
flights %>% 
  filter(!is.na(ArrDelay)) %>% 
  group_by(UniqueCarrier) %>% 
  summarise(p_delay = sum(ArrDelay >0)/n()) %>% #ratio de vuelos que han tenido retraso entre el 
  # número total de vuelos que ha operado la compañía
  mutate(rank = rank(p_delay)) %>% 
  arrange(rank) %>% View()


##### 3.7. JOINS #####
# inner_join(x, y)  SELECT * FROM x INNER JOIN y USING (z)
# left_join(x, y) SELECT * FROM x LEFT OUTER JOIN y USING (z)
# right_join(x, y, by = "z") SELECT * FROM x RIGHT OUTER JOIN y USING (z)
# full_join(x, y, by = "z") SELECT * FROM x FULL OUTER JOIN y USING (z)

# semi_join(x, y)
# anti_join(x, y)

airlines <- readr::read_csv('airlines.csv')

airports <- readr::read_csv('airports.csv')

# Before joing dataframes, check for unique keys - Elimino duplicados
airports %>% 
  count(iata) %>% 
  filter(n > 1)

flights2 <- flights %>% 
  select(Origin, Dest, TailNum, UniqueCarrier, DepDelay)

# Top delayed flight by airline
flights2 %>% 
  group_by(UniqueCarrier) %>%
  top_n(1, DepDelay) %>% 
  left_join(airlines, by = c("UniqueCarrier" = "Code"))


##### 3.8. Ejercicios #####

##### 3.8.1. Ejercicio1 #####
# Use summarise() to create a summary of flight with a single variable, n, 
# that counts the number of overnight flights. These flights have an arrival 
# time that is earlier than their departure time. Only include flights that have 
# no NA values for both DepTime and ArrTime in your count.
flights %>% 
  filter(!is.na(DepTime) & !is.na(ArrTime)) %>% #eliminamos los NA
  mutate(overnight = (ArrTime < DepTime)) %>% #buscamos los vuelos nocturnos
  filter(overnight == TRUE) %>% #Filtro todos los vuelos donde el valor de overnight es TRUE
  summarise(n = n())

##### 3.8.2. Ejercicio2 #####
# In a similar fashion, keep flights that are delayed (ArrDelay > 0 and not NA). 
# Next, create a by-carrier summary with a single variable: avg, the average delay of the delayed 
# flights. Again add a new variable rank to the summary according to avg. Finally, arrange by 
# this rank variable.
flights %>% 
  filter(!is.na(ArrDelay), ArrDelay >0) %>% #Vuelos que no estén retrasados
  group_by(UniqueCarrier) %>%  #agrupo por carrier
  summarise(avg = mean(ArrDelay)) %>% #suma de la media de los vuelos retrasados
  mutate(rank = rank(avg)) %>%  #creamos una nueva variable rank que aplique el ranking de medias
  arrange(rank) %>% View() #ordenamos las medias y las mostramos

##### 3.8.3. Ejercicio3 #####
# How many airplanes only flew to one destination from JFK? The result contains only a single 
# column named nplanes and a single row.
# cuantas matriculas distintas han salido desde JFK y han ido a un único destino
flights %>% 
  filter(Origin == 'JFK') %>% 
  group_by(TailNum) %>% 
  summarise(n_dest = n_distinct(Dest)) %>% 
  filter(n_dest == 1) %>% 
  summarise(nplanes =n ())
#a cualquier destino
flights %>% 
  filter(Origin == 'JFK') %>% 
  group_by(TailNum) %>% 
  summarise(n_dest = n_distinct(Dest)) %>% 
  summarise(nplanes = n ())  

##### 3.8.4. Ejercicio4 #####
# Find the most visited destination for each carrier. Your solution should contain four columns:
# UniqueCarrier and Dest, n, how often a carrier visited a particular destination, rank, how each 
# destination ranks per carrier. rank should be 1 for every row, as you want to find the most 
# visited destination for each carrier.
flights %>% 
  group_by(UniqueCarrier, Dest) %>% #agrupamos por compañía y destino
  summarise(n = n()) %>% #sumamos los vuelos
  mutate(rankCarrier = rank(n)) %>% #haces un ranking
  filter(rankCarrier == 1) %>% View()


##### 3.9. MODIFICACIÓN DE VERBOS #####
# Modificación de verbos
# Se realizan ligeros cambios sobre los verbos para poder cambiar su significado. El primer cambio es un guión bajo, sirve para hacer lo mismo
# que realiza el verbo original per en vez de escribir la variable en el código, se puede usar cadena de texto.
variableFavorita <- "arr_delay"
flights %>% 
  select_(variableFavorita)
variableFavorita <- "arr_delay+1"
flights %>% 
  mutate_(arr_delay2 = variableFavorita)
# Hay otros modificadores, los más importantes son: _at, _all, _if
# Suponemos que tenemos que hacer la media de varias variables dividido por el origen
flights %>% 
  group_by(origin) %>% 
  summarise(medArrDelay = mean(arr_delay, na.rm = T),
            medDepDelay = mean(dep_delay, na.rm = T))
# Esto es un poco repetitivo, puesto que hay que realizar un media primero con los arr_delay y después con dep_delay
# Se puede usar _at que no es más que un modificador que repite la misma operación en varias columnas:
flights %>% 
  group_by(origin) %>% 
  summarise_at(vars(arr_delay, dep_delay), mean, na.rm = T) # vars() proporciona una semántica parecida a select(). Se usa para instanciar 
# mutate_at() y summarise_at(). Se puede usar los dos puntos para definir un rango de variables, poniendo solo la primera y la segunda.
# MUY UTIL
flights %>% 
  group_by(origin) %>% 
  summarise_at(vars(arr_delay, dep_delay), mean, na.rm = T)
# _if hace lo mismo, pero en vez de tener que enumerar todas las columnas, puedes ponerle un criterio. Se va a usar is.numeric, voy a calcular la
# media para todas las variables que sean numéricas
flights %>% 
  group_by(origin) %>% 
  summarise_if(is.numeric, mean, na.rm = T)
# _all hace la misma operación con TODAS las columnas
flights %>%
  group_by(origin) %>%
  mutate_all(sum)


##### 3.10. OPERADOR %>% #####
# Piping - Función desarrollada para R que está en la libreria MagicR. Funciona igual que una tuberia dentro
# del sistema operativo (grep | ...)
mean(c(1, 2, 3, NA), na.rm = TRUE)

# Vs
c(1, 2, 3, NA) %>% mean(na.rm = TRUE)
summarize(filter(mutate(flights, diff = TaxiOut - TaxiIn),!is.na(diff)), avg = mean(diff))

# Vs
flights %>%
  mutate(diff=(TaxiOut-TaxiIn)) %>%
  filter(!is.na(diff)) %>% 
  summarise(avg=mean(diff))
#Misma función pero imprimiendo el valor de la variable en otra pestaña
flights %>%
  mutate(diff=(TaxiOut-TaxiIn)) %>%
  filter(!is.na(diff)) %>% tail() %>% 
  summarise(avg=mean(diff)) %>% View()
#Misma función pero imprimiendo el valor en un fichero .csv
flights %>%
  mutate(diff=(TaxiOut-TaxiIn)) %>%
  filter(!is.na(diff)) %>% readr::write_csv("data/foo.csv")#creamos un csv y guardamos
summarise(avg=mean(diff))  
flights %>%
  filter(Month == 5, DayofMonth == 17, UniqueCarrier %in% c('UA', 'WN', 'AA', 'DL')) %>%
  select(UniqueCarrier, DepDelay, AirTime, Distance) %>%
  arrange(UniqueCarrier) %>%
  mutate(air_time_hours = AirTime / 60) #para que el resultado lo guarde en foo al final de esta línea pones -> foo


##### 3.11. OTRAS FUNCIONES DE DPLYR #####

# top_n()
flights %>% 
  group_by(UniqueCarrier) %>% 
  top_n(2, ArrDelay) %>% 
  select(UniqueCarrier,Dest, ArrDelay) %>% 
  arrange(desc(UniqueCarrier))

# mutate_if(is.character, str_to_lower) - si la columna es de tipo caracter, aplicale la función str_to_lower
# mutate_at - es necesario indicar las variables sobre las que vas a operar
foo <- flights %>% 
  head %>% 
  select(contains("Delay")) %>% #selecciona las variables que contiene Delay
  mutate_at(vars(ends_with("Delay")), funs(./2)) #todas las variables que terminen en Delay y le aplico la 
#función de tomar cada una de las variables y dividirlas entre 2
foo
foo %>% 
  mutate_at(vars(ends_with("Delay")), funs(round)) 
rm(foo)


##### 3.12. TRATANDO CON VALORES ATÍPICOS #####
# Dealing with outliers 
# Cómo se quitan y como no se quitan los outliers
# Cuando se tiene outliers es recomendable tener la mediana
# ActualElapsedTime: Elapsed Time of Flight, in Minutes
summary(flights$ActualElapsedTime)

hist(flights$ActualElapsedTime)

library(ggplot2)
ggplot(flights) + 
  geom_histogram(aes(x = ActualElapsedTime))

boxplot(flights$ActualElapsedTime,horizontal = TRUE)

outliers <- boxplot.stats(flights$ActualElapsedTime)$out # out es un objeto
length(outliers) #es lo que considera outliers en función del boxplot
outliers

no_outliers <- flights %>% 
  filter(!ActualElapsedTime %in% outliers) 

boxplot(no_outliers$ActualElapsedTime,horizontal = TRUE)

mean(no_outliers$ActualElapsedTime, na.rm = T)
hist(no_outliers$ActualElapsedTime) #histograma sin los outliers

rm(outliers)
rm(no_outliers)

barplot(table(flights$UniqueCarrier))#tabla de frecuencias, contiene el summarise


##### 3.13. VALORES PERDIDOS (NA) #####
# Missing values 
NA
flights %>% 
  dim # Recupera o establece la dimensión de un objeto. Devuelve la longitud de las filas y 
# columnas de un dataframe

# Removing all NA's from the whole dataset
# distintas maneras de eliminar las líneas que tienen algún na
flights %>% 
  na.omit %>% 
  dim # omite las líneas que tienen algún na
flights %>% 
  filter(complete.cases(.)) %>% 
  dim

library(tidyr) # for drop_na()
flights %>% 
  drop_na() %>% 
  dim

# Removing all NA's from a varible
flights %>% 
  drop_na(ends_with("Delay")) %>% 
  summary() %>% 
  View()

# Better aproaches
flights %>% 
  filter(is.na(DepTime)) %>% 
  mutate(DepTime = coalesce(DepTime, 0L)) %>% 
  View() # convierte una variable (en este caso NA) a 0 y entero (L)

flights %>% 
  filter(is.na(DepTime)) %>% 
  mutate(DepTime = coalesce(DepTime, CRSDepTime)) %>% 
  View() # vuelca lo que pone en la columna CRSDepTime si en DepTime hay un NA

unique(flights$CancellationCode)
foo <- flights %>% 
  mutate(CancellationCode = na_if(CancellationCode, "")) %>% 
  View()
unique(foo$CancellationCode)

# CancellationCode: reason for cancellation (A = carrier, B = weather, C = National Air System, D = security)
foo <- flights %>% 
  mutate(CancellationCode = recode(CancellationCode, "A"="Carrier", "B"="Weather", "C"="National Air System", 
                                   .missing="Not available", 
                                   .default="Others" )) %>% View()
rm(foo)


##### 3.14. TIDYR #####
# Tidy Data 
library(tidyr)

# Wide Vs Long 

# spread
# gather
flights %>% 
  group_by(Origin, Dest) %>% 
  summarise(n = n()) %>% 
  arrange(-n) %>% 
  spread(Origin, n) %>% # pivotamos
  # despivotamos
  gather("Origin", "n", 2:ncol(.)) %>% # a partir del spread, crea una variable Origin, una n y 
  # recoge todo lo que hay el la columna 2 hasta el final de las columnas del anterior objeto
  arrange(-n) %>% 
  View()
# Run the follow statements step by step and trying to understand what they do
flights %>% 
  group_by(UniqueCarrier, Dest) %>%
  summarise(n = n()) %>%
  ungroup() %>% #una vez hecho el cálculo, borramos la agrupación, para poder realizar nuevos 
  # cálculos
  group_by(Dest) %>% 
  mutate(total= sum(n), pct=n/total, pct= round(pct,4)) %>% 
  ungroup() %>% 
  select(UniqueCarrier, Dest, pct) %>% 
  spread(UniqueCarrier, pct) %>% 
  replace(is.na(.), 0) %>% 
  mutate(total = rowSums(select(., -1))) 

# unite()
# separate()
# Run the follow statements step by step and trying to understand what they do
flights %>% 
  head(20) %>% 
  unite("code", UniqueCarrier, TailNum, sep = "-") %>% 
  select(code) %>% 
  separate(code, c("code1", "code2")) %>% 
  separate(code2, c("code3", "code4"), -3)


##### 3.15. FECHAS CON LUBRIDATE #####

# Base R
as.POSIXct("2013-09-06", format="%Y-%m-%d")
as.POSIXct("2013-09-06 12:30", format="%Y-%m-%d %H:%M")

flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3, remove = F) # Divide de derecha a 
# izquierda desde la posición 3 hacia la izquierda asigna hora y de la posición 3 a la derecha, 
# minutos

flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3) %>% 
  mutate(Date = as.Date(paste(Year, Month, DayofMonth, sep = "-")),
         HourMinute = (paste(Hour, Minute, sep = ":")),
         Departure = as.POSIXct(paste(Date, HourMinute), format="%Y-%m-%d %H:%M"))

# Easier with lubridate
library(lubridate) # libreria para trabajar con fechas
today()
now()

(datetime <- ymd_hms(now(), tz = "UTC"))
(datetime <- ymd_hms(now(), tz = 'Europe/Madrid'))

Sys.getlocale("LC_TIME")
Sys.getlocale(category = "LC_ALL")

# Available locales: Run this in your shell: locale -a
(datetime <- ymd_hms(now(), tz = 'Europe/Madrid', locale = Sys.getlocale("LC_TIME")))
month(datetime, label = TRUE, locale = 'fi_FI.ISO8859-15')
wday(datetime, label = TRUE, abbr = FALSE, locale = 'fi_FI.ISO8859-15')

year(datetime)
month(datetime)
mday(datetime)

ymd_hm("2013-09-06 12:3")
ymd_hm("2013-09-06 12:03")

# Esto genera un error
flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3) %>% 
  mutate(dep = make_datetime(Year, Month, DayofMonth, Hour, Minute))

#adecua a la zona horaria
flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3) %>% 
  mutate_if(is.character, as.integer) %>% 
  mutate(dep_date = make_datetime(Year, Month, DayofMonth) ,
         dep_datetime = make_datetime(Year, Month, DayofMonth, Hour, Minute))

# Let’s do the same thing for each of the four time columns in flights. 
# The times are represented in a slightly odd format, so we use modulus arithmetic to pull out the
# hour and minute components

# ?Arithmetic
# %/% := integer division
# %% := modulus

departure_times <- flights %>% 
  head(2) %>% 
  select(DepTime) %>% 
  pull()

# Supongamos la hora: 1232
departure_times %/% 100
departure_times %% 100

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights %>% 
  select(TaxiIn, TaxiOut)

flights_dt <- flights %>%  
  filter(!is.na(DepTime), !is.na(ArrTime), !is.na(CRSDepTime), !is.na(CRSArrTime)) %>% 
  mutate(dep_time = make_datetime_100(Year, Month, DayofMonth, DepTime),
         arr_time = make_datetime_100(Year, Month, DayofMonth, ArrTime),
         sched_dep_time = make_datetime_100(Year, Month, DayofMonth, CRSDepTime),
         sched_arr_time = make_datetime_100(Year, Month, DayofMonth, CRSArrTime)) %>% 
  select(Origin, Dest, ends_with("_time"))

# distribution of departure times across the year
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400)

# wday()
flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()

# Time periods functions
minutes(10)
days(7)
months(1:6)
weeks(3)

datetime
datetime + days(1)

# Datos incoherentes
flights_dt %>% 
  filter(arr_time < dep_time) %>% 
  select(Origin:arr_time)

flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time_ok = arr_time + days(overnight * 1),
    sched_arr_time_ok = sched_arr_time + days(overnight * 1)
  )

# Check
flights_dt %>% 
  filter(overnight == T)

# Time Zones
ymd_hms("2007-01-01 12:32:00")
str(flights_dt$dep_time)

pb.txt <- "2007-01-01 12:32:00"
# Greenwich Mean Time (GMT)
(pb.date <- as.POSIXct(pb.txt, tz="Europe/London"))
# Pacific Time (PT)
format(pb.date, tz="America/Los_Angeles",usetz=TRUE)
# Con lubridate
with_tz(pb.date, tz="America/Los_Angeles")
# Coordinated Universal Time (UTC)
with_tz(pb.date, tz="UTC") 

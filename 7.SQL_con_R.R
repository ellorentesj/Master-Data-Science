##### 7. SQL CON R #####

list.of.packages <- c("R.utils", "tidyverse", "doParallel", "foreach", "sqldf", "broom", "DBI", "data.table")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

flights <- data.table::fread('2007.csv') #data.table - librería de tratamiento de datos, tiene una función para importar archivos

# https://cran.r-project.org/bin/macosx/
# https://github.com/ggrothendieck/sqldf#problem-involvling-tcltk
# capabilities()[["tcltk"]]
# options(gsubfn.engine = "R")

##### 7.1. SQL #####
library(sqldf)

sqldf("select Year from flights group by Year order by Year desc") #función que lanza una consulta
carrier_delays <- sqldf("SELECT UniqueCarrier, COUNT(ArrDelay) AS ArrivalDelays FROM flights WHERE ArrDelay > 0 AND Dest = 'JFK' AND Year = 2007  GROUP BY UniqueCarrier ORDER BY 2 DESC");
carrier_distances <- sqldf("SELECT UniqueCarrier, COUNT(Distance) AS Flights FROM flights WHERE Distance > 0 AND Dest = 'JFK' AND Year = 2007 GROUP BY UniqueCarrier ORDER BY UniqueCarrier ASC");
# The goal is to determine whether the observed differences can be reasonnably explained by chance, or not
carrier_ratios <- sqldf("SELECT UniqueCarrier, Flights, ArrivalDelays AS Yes,  Flights - ArrivalDelays AS No, ROUND(CAST(ArrivalDelays AS float) / Flights,2)  AS Ratio FROM (
                        SELECT carrier_distances.UniqueCarrier, ArrivalDelays, Flights FROM carrier_delays LEFT JOIN carrier_distances ON carrier_delays.UniqueCarrier = carrier_distances.UniqueCarrier
) ORDER BY Ratio DESC ")

##### 7.1.1. Ejemplo #####
# Example: Import airlines.csv into the "airlines" object
# Using SQL add the a new column to carrier_ratios called "Carrier" with the airline name:
# 
#   Carrier                       Flights   Yes    No   Ratio
# 1 ExpressJet Airlines Inc.      195       124    71   0.64
# 2 Northwest Airlines Inc.       1930      1108   822  0.57
# 

library(tidyverse) #instala todas las librerias ggplot2, dplyr, readr, tibble, tidyr...

airlines <- read_csv('airlines.csv')
sqldf("SELECT * FROM airlines LIMIT 10")
carrier_ratios <- sqldf("SELECT Description As Carrier, Flights, Yes, No, Ratio FROM carrier_ratios LEFT JOIN airlines ON carrier_ratios.UniqueCarrier =  airlines.Code")

# Tables and matrices
carrier_ratios.mat <- as.matrix(sqldf("SELECT Yes, No FROM carrier_ratios")) #creamos una matriz numérica
rownames(carrier_ratios.mat) <- sqldf("SELECT Carrier FROM carrier_ratios")[ , "Carrier"] #cada fila es una compañía, asignamos nombre a cada 
# una de las filas. Para ello cogemos el vector "Carrier"
carrier_ratios.mat
class(carrier_ratios.mat)

carrier_ratios.tbl <- as.table(carrier_ratios.mat) #convierte la matriz en una tabla
carrier_ratios.tbl
class(carrier_ratios.tbl)
carrier_ratios.df <- as.data.frame(carrier_ratios.tbl) # convierte la tabla en un dataframe
class(carrier_ratios.df)

( proportions <- round(prop.table(carrier_ratios.tbl, margin = 1),2) ) #c alcula las proporciones de una tabla de frecuencias y redondeo decimales
t(proportions) # transponemos la tabla

barplot(t(proportions), beside=TRUE, legend=TRUE)

# Comparing over the total
round(prop.table(t(carrier_ratios.mat),margin=1), 2)
sum(prop.table(t(carrier_ratios.mat),margin=1)['Yes',])

barplot(prop.table(t(carrier_ratios.mat),margin=1), beside=TRUE, legend=TRUE)

# Basic statistics
# Test to see if we can statistically conclude that not all proportions are equal:
# To know whether UniqueCarrier made a difference in the chances of ArrivalDelays, lets carry out a proportion test. 
# This test tells how probable it is that proportions are the same. A low p-value tells you that  proportions probably differ from each other.
# The null hypothesis H0:  All the proportions are the same
# The alternative H1:  Some are different

#tests estadísticos

prop.test(carrier_ratios.tbl) 
# p-value < 0.05 (random chance probability) => we reject the null hypothesis so H1 is true

prop.test(carrier_ratios.tbl[c('Envoy Air', 'Delta Air Lines Inc.'),])
# p-value = 0.05728 > 0.05 => we cannot reject the null hypothesis so the proportins are the same, 

sqldf("SELECT Carrier, Yes, No, Ratio FROM carrier_ratios WHERE Carrier IN ('Envoy Air', 'Delta Air Lines Inc.')")

barplot(t(proportions[c('Envoy Air', 'Delta Air Lines Inc.'),]), beside=TRUE, legend=TRUE)

# Tesing all the airlnes at time:
test_result <- pairwise.prop.test(carrier_ratios.tbl ,p.adjust.method="none")
test_result

# When the p.values are smaller than the significance level for each pair-wise comparison we can reject the null hypothesis that the proportions are equal based on the available sample of data.

# Airlines 
test_result <- broom::tidy(test_result)
sqldf("SELECT group1, group2, ROUND(`p.value`, 2) AS `p.value` FROM test_result WHERE `p.value` > 0.05")
# The output includes a p-value. Conventionally, a p-value of less than 0.05 indicates that it is likely the groups’ proportions are different whereas a p-value exceeding 0.05 provides no such evidence.


##### 7.2. Trabajando con BBDD #####
# working with data bases 

library(DBI)#libreria que me permite realizar conexiones a bases de datos

con <- dbConnect(RSQLite::SQLite(), path = ":memory:") # establezco conexión y levanta una base de datos en memoria es simplemente para saber 
# que se puede crear bases de datos en memoria
tmp <- tempfile()
con <- dbConnect(RSQLite::SQLite(), tmp) # establecemos una conexion sqlite

dbWriteTable(con, "flights", flights) # escribir una tabla "flights" de la conexión con del objeto flights
dbListTables(con)
dbListFields(con, "flights") #c ampos que tiene la tabla
dbSendQuery(con, "SELECT * FROM flights WHERE Dest = 'JFK' LIMIT 10") # no ha hecho nada con ella porque no se la he asignado a una variable

query <- dbSendQuery(con, "SELECT * FROM flights WHERE Dest = 'JFK' LIMIT 10")
jfk <- dbFetch(query) # traeme los datos y me los guardas en el objeto jfk

dbClearResult(query)
dbDisconnect(con)
unlink(tmp) # borra el archivo temporal que había creado

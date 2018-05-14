##### 5. RESHAPE2 #####
# La libreria reshape2 es la principal librería para cambiar la estructura de una data frame.
# Un mismo dataset puede estar expresado de varias maneras. En general se habla de forma "ancha" (o wide) y larga (long)
# Pero NO es cierto que haya solo dos maneras, hay un espectro de puntos intermedios entre ancho y largo.
library(reshape2)

# Vamos a usar el dataset airquality
#View(airquality)

# Primero vamos a poner todas las variables en minúsculas
colnames(airquality) <- tolower(colnames(airquality))

# Cuando haces algo más largo lo estás "derritiendo", es decir melt. Esta es la versión de "máximo derretimiento". Pero no es especialmente útil
melt(airquality)
# cuales son las variables ID, que no es más que aquellas variables que definen a cada entidad estadística.
# Por así decirlo son los identificadores de cada "objeto".
# Por ejemplo, en una clase podría ser el DNI o el par Nombre+Apellidos o "número de alumno".
# En este caso es mes y día, porque cada entidad es un día de cada mes
melt(airquality, id.vars = c("month", "day"))

# Podéis cambiar los nombres de value y variable a los que  queráis
melt(airquality, id.vars = c("month", "day"),
     variable.name = "miVariable",
     value.name =  "miValor"
) 

# El proceso opuesto a melt es dcast. Así que vamos a coger el dataset "derretido" y vamos a ensancharlo de distintas maneras
derretido <- melt(airquality, id.vars = c("month", "day"))

# a dcast le pasas el dataframe y la "fórmula". La fórmula tiene dos lados, separados por una virgulilla (~)
# En el lado izquierdo vamos a poner la ID variables las que suelen estar a la izquierda, se forman columnas enteras con esas variables
# El lado derecho es lo que se extiende en varias columnas sería la parte "derecha" del dataframe.
dcast(derretido, month  ~ variable)
# month ozone solar.r wind temp
# 1     5    31      31   31   31
# 2     6    30      30   30   30
# 3     7    31      31   31   31
# 4     8    31      31   31   31
# 5     9    30      30   30   30

# Si os fijáis month es una id var (a la izquierda) y todas las demás se han desplegado en la parte superior
# con la palabra en clave "variables", que significa el resto de las variables.

# Este dataset tiene una fila por cada dia del mes. Si os fijáis cada casilla es más de un dato, es decir, month 2, y wind representa a 30 días.
# Estamos agregando aunque no lo parezca, porque las ID variables que hemos usado (solo month) es MENOR que las ID variables del dataset 
# (month+day) así que la única manera que tiene reshape2 de darte ese formato es agrupando los 30 días en una casilla
# Por defecto la función que agrega es length (es decir, numero) de filas. Por eso pone 30.

# Para cambiar esto podemos usar el parámetro fun.aggregate. Podeis añadir mas parametros como na.rm
dcast(derretido, month  ~ variable, fun.aggregate = mean, na.rm=T) 
# month    ozone  solar.r      wind     temp
# 1     5 23.61538 181.2963 11.622581 65.54839
# 2     6 29.44444 190.1667 10.266667 79.10000
# 3     7 59.11538 216.4839  8.941935 83.90323
# 4     8 59.96154 171.8571  8.793548 83.96774
# 5     9 31.44828 167.4333 10.180000 76.90000
# y ahora si nos sale en agregado que queriamos (la media)

# Podemos añadir un ID var más separandolo por el operador
# + (también sirve para el lado derecho)
# Y aunque he puesto un fun aggregate ya no tiene sentido
# Porque cada casilla representa un solo valor
dcast(derretido, month + day ~ variable) 
# month day ozone solar.r wind temp
# 1       5   1    41     190  7.4   67
# 2       5   2    36     118  8.0   72
# 3       5   3    12     149 12.6   74
# 4       5   4    18     313 11.5   62
# 5       5   5    NA      NA 14.3   56
# ...
# 
# Tambien se puede poner el day en la parte de arriba y así 
# "ensanchas" el dataset. Lo unico que haces es crear una 
# columna por cada dia y variable
dcast(derretido, month ~ day + variable)
# month 1_ozone 1_solar.r 1_wind 1_temp 2_ozone 2_solar.r 2_wind
# 1     5      41       190    7.4     67      36       118    8.0
# 2     6      NA       286    8.6     78      NA       287    9.7
# 3     7     135       269    4.1     84      49       248    9.2
# 4     8      39        83    6.9     81       9        24   13.8
# 5     9      96       167    6.9     91      78       197    5.1

# Y la version más larga posible es poner la variable en la izquierda también, R requiere que haya "algo" a la derecha, así que usamos el punto
dcast(derretido, month + day + variable ~ .)
# month day variable     .
# 1     5   1    ozone  41.0
# 2     5   1  solar.r 190.0
# 3     5   1     wind   7.4
# 4     5   1     temp  67.0
# 5     5   2    ozone  36.0
# 6     5   2  solar.r 118.0
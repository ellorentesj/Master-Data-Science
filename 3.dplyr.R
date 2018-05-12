#####3. DPLYR#####
library(dplyr)
library(ggplot2)
library(nycflights13)

# Vemos la cabecera y la cola de flights
head(flights)
tail(flights)

# Vamos a coger aquellas columnas que acaban en "_delay"
flights[,grepl("_delay",colnames(flights))] # grepl busca coincidencias con el patrón del argumento "_delay" dentro de cada elemento de un
# vector de caracteres "flights"
flights[,grep("_delay", colnames(flights))]

# Se podría desglosar de una manera más sencilla:
mascara <- grep("_delay",colnames(flights))
flights[,mascara]

# Como generar una muestra aleatoria de 10 al azar:
runif(10, 1, 10) # proporcionan información sobre la distribución uniforme en el intervalo de mínimo a máximo
rnorm() # Densidad, función de distribución, función de cuantiles y generación aleatoria para la distribución normal 
# con media igual a media y desviación estándar igual a sd.
sample(1:10,5) # sample toma una muestra del tamaño especificado 5 de los elementos de 1:10, usando ya sea con o sin reemplazo
sample(c("Carlos", "Maria", "Alejandro"), 2)
sample.int(100, 2)
# Tomamos una muestra aleatoria de 10 de la columnas que terminen en "_delay"
flights[sample.int(nrow(flights), 10),
        grep("_delay", colnames(flights))]
# Ahora con los vuelos de UA
flightsUA <- flights[flights$carrier == "UA",]
flightsUA[sample.int(nrow(flightsUA), 10),
          grep("_delay", colnames(flightsUA))]

# Es muy útil para seleccionar datos, usar el operador %in% que sirve para comprobar si algo está dentro de un conjunto
c(1, 3, 18) %in% c(1,2,3,4,5,6,7,8,9)
# devuelve: TRUE, TRUE, FALSE

# DPLYR es la manera primordial de manipular datos a día de hoy. Dplyr funciona con verbos, que no son más que funciones para
# procesar datos.
# El verbo para seleccionar columnas se llama "select": Seleccionar del dataset flights las columnas carrier y arr_delay
select(flights, carrier, arr_delay)
# Para elegir todas las columnas que contengan la cadena "_delay", existe la función "contains"
select(flights, contains("_delay"), carrier)

# Otros operadores útiles para las columnas son:
ends_with()
starts_with()
matches() # Compara cada columna con una expresión regular

# Sudmuestreos, con las funciones sample_n y sample_frac: Vamos a repetir la selección aleatoria de vuelos pero con dplyr
sample_n(selec(flights,contains("_delay")), 10) # A la función sample_n le entra una tabla y de esa tabla escoge 10 elementos 
# al azar, en nuestro caso la tabla va a ser una tabla donde tenemos que seleccionar los columnas que contengan "_delay"

# Como se puede observar, estamos anidando funciones para poder realizar dos operaciones. Esto es bastante incómodo y es 
# proclive a errores. Se puede realizar de manera más sencilla con el operador tubería %>% :
select(flights, contains("_delay")) %>% # Leido de izquierda a derecha, seleccionamos los vuelos que contienen columnas con la palabra "_delay"
  sample_n(10) #  y %>% de ahí tomamos 10 ejemplos
# Si desglosamos esta operación aún más:
flights %>% # Del dataframe vuelos
  select(contains("_delay")) %>% # Seleccionamos aquellos que sus columnas contengan la palabra "_delay"
  sample_n(10) # y cogemos 10 elementos aleatorios
# Se puede guardar el resultado en otro dataframe
flightsUA <- flights %>% # Del dataframe flights
  filter(carrier == "UA") %>% # filtramos por aquellas líneas cuya columna carrier tenga el valor "UA"
  select(contains("_delay")) %>% # de el dataset anterior, nos quedamos con las columnas que contengan la palabra "_delay"
  sample_n(10) # Seleccionamos 10 filas de estas dos columnas

# Filtros con el operador filter:
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

# Ordenar con arrange:
flights %>% 
  arrange(year)
flights %>% 
  arrange(desc(year))
flights %>% 
  arrange(-year) # - sólo puede usarse en caso de que se trate de un número

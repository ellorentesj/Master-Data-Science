# EJERCICIO_01
#
# * Crea un nuevo proyecto en RStudio.
#   – Elige entre crear la carpeta al crear el proyecto o utilizar una existente.
#     File>New Proyect>New Directory
# * Una vez en el proyecto añade un script y guárdalo en el directorio de trabajo.
#   File>New File>R Script
# * Dentro del script prueba las funciones setwd() y getwd().
#
?setwd() #ayuda
??setwd() #busca todas las menciones a una palabra en la ayuda
example("setwd") #ejecuta los ejemplos de una ayuda en una función
#
?getwd()
??getwd()
example("getwd")
#
# * Desde el Explorador de Archivos de RStudio prueba las opciones equivalentes a las funciones anteriores.
# * Prueba también las opciones para obtener Ayuda.
# * Prueba también cómo se muestran los ejemplos y la demostración de setwd y graphics respectivamente.
#
require(datasets)
require(grDevices)
require(graphics)
demo(graphics)
#
# * Almacena el script como Ejercicio_01.R


# EJERCICIO_03
#
# Abre un nuevo script dentro de tu proyecto. Guárdalo con el nombre de Ejercicio_o3.R y realiza lo siguiente:
#
# * Escribe un comentario al principio que especifique tu nombre y el enunciado del ejercicio (cópialo de aquí y pégalo en RStudio).
#
# * Utilizando funciones para vectores, crea un vector que tenga el siguiente contenido. No crees el vector de forma manual:
#   > vector
#   [1] 4 4 4 4 4 1 3 5 7 9 3 7 11
#
vector <- c(rep(4,5),seq(1,9,by = 2),seq(3,11,by = 4))
vector # [1]  4  4  4  4  4  1  3  5  7  9  3  7 11
#
# * Piensa qué función podrías utilizar sobre el vector anterior para obtener otro vector como el siguiente. El resultado debe almacenarse
#   en otro vector de nombre vector.dos
#   > vector.dos
#   [1] 8 9 10 12 13
#
vector.dos <- which(vector > 4)
vector.dos # [1]  8  9 10 12 13
#
# * Extrae los elementos que sean mayores que 5 y almacénalos en otro vector de nombre vector.tres
#   > vector.tres
#   [1] 7 9 7 11
#
vector.tres <- vector[vector > 5]
vector.tres # [1]  7  9  7 11
#
# * Ahora realiza lo mismo utilizando obligatoriamente la función which() y almacénalo en un vector de nombre vector.cuatro
#   > vector.cuatro
#   [1] 7 9 7 11
vector.cuatro <- vector[which(vector > 5)]
vector.cuatro # [1]  7  9  7 11
#
# * Suponiendo que desconoce la longitud del vector, crea un vector de nombre vector.cinco que almacene todos los elementos desde el 
#   el primero hasta el penúltimo.
#   > vector.cinco
#   [1] 4 4 4 4 4 1 3 5 7 9 3 7 11
vector.cinco <- vector[seq(1:length(vector)-1)]
vector.cinco  # [1]  4  4  4  4  4  1  3  5  7  9  3  7 11


# EJERCICIO_04
#
# * Utilizando la ayuda de la función matrix(), crea una matriz de nombre mimatriz que tenga 6 filas y 8 columnas.
#
?matrix()
#
# * Rellena la matriz con valores del 1 al 48 por filas
#       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] 
#   [1,]  1    2    3    4    5    6    7    8 
#   [2,]  9   10   11   12   13   14   15   16 
#   [3,] 17   18   19   20   21   22   23   24 
#   [4,] 25   26   27   28   29   30   31   32 
#   [5,] 33   34   35   36   37   38   39   40 
#   [6,] 41   42   43   44   45   46   47   48
#
mimatriz <- matrix(seq(1,48),nrow = 6,ncol = 8,byrow = TRUE)
mimatriz


# EJERCICIO_05
#
# * Partiendo de la matriz del ejercicio 4, redimensiona la misma a 8 filas por 6 columnas y nómbrala como nuevamatriz.
#
mimatriz <- matrix(seq(1,48),nrow = 6,ncol = 8,byrow = TRUE)
mimatriz
#
nuevamatriz <- t(mimatriz)
nuevamatriz
dim(nuevamatriz) <- c(8,6)
#
# * LETTERS y letters son dos vectores primitivos de R que almacenan los 26 caracteres del alfabeto romano. Uno los almacena en
#   mayúsculas y el otro en minúsculas.
#
letters # [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
LETTERS # [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
#
# * Partiendo del vector LETTERS, utilízalo para dar nombre a las columnas de nuevamatriz, de manera que las columnas se llamen como
#   se muestra a continuación:
#        A  B  C  D  E  F 
#   [1,] 1  9 17 25 33 41 
#   [2,] 2 10 18 26 34 42 
#   [3,] 3 11 19 27 35 43 
#   [4,] 4 12 20 28 36 44 
#   [5,] 5 13 21 29 37 45 
#   [6,] 6 14 22 30 38 46 
#   [7,] 7 15 23 31 39 47 
#   [8,] 8 16 24 32 40 48
#
colnames(nuevamatriz) <- LETTERS[seq(1,6)]
nuevamatriz
#
# * Calcula la suma de las columnas y añade el resultado como una nueva fila a la propia matriz.
#
total.columnas <- colSums(nuevamatriz) 
total.columnas
nuevamatriz <- rbind(nuevamatriz,total.columnas)
nuevamatriz


# EJERCICIO_06
#
# * Ante ciertas operaciones podemos obtener valires NA o NaN, por lo que no es necesario controlarlo.
#
# * Escribe un código que evalúe el resultado de una operación y muestre por pantalla el resultado si es válido o un mensaje si NA 
#   o NaN
#
# * Haz por un lado NA y por otro NaN
#
operacion1 <- 0/0
if (is.nan(operacion1)) {
  cat("Operación es ", operacion1)
} else {
  cat("Operación ",operacion1," es correcta")
}
#
vector <- c(1)
operacion2 <- vector[2]
if (is.na(operacion2)){
  cat("Operacion2 muestra", operacion2, "\n")
}else{
  cat("Operación2 es correcta: ",  operacion2, "\n")
}


# EJERCICIO_07
#
# * Crea una matriz como la que se muestra a continuación, incluyendo los datos y los nombres de las filas y de las columnas.
#            Edad Altura Peso
# Europeos     30     80  175
# Americanos  178     35   84
#
matriz <- matrix(
  c(30,178,80,35,175,84),
  ncol = 3,
  nrow = 2,
  dimnames = list(c("Europeos","Americanos"),c("Edad","Altura","Peso"))
)
#
matriz
#
# * Recorre la matriz por filas mostrando por pantalla su contenido. Hazlo con un bucle while y con un bucle for
# * Para calcular el número total de filas y columnas que tiene la matriz, utiliza las funciones correspondientes.
#
filas <- 1
while (filas <= nrow(matriz)){
  columnas <- 1
  while (columnas <= ncol(matriz)){
    cat("Valor de lq posición",filas, "-", columnas, "es:", matriz[filas,columnas],"\n")
    columnas = columnas + 1
  }
  filas = filas + 1
}
#
for (filas in 1:nrow(matriz)){
  for (columnas in 1:ncol(matriz)){
    cat("Valor de lq posición",filas, "-", columnas, "es:", matriz[filas,columnas],"\n")
  }
}


# EJERCICIO_08
#
# * Partiendo de un dataframe de ejemplo incluído en R (mtcars), realiza lo siguiente:
#   - Almacena el dataframe en otro con otro nombre midf.
midf <- data.frame(mtcars)
midf
#   - Muestra por consola las primeras y las últimas filas del dataframe con las funciones head() y tail()
head(midf)
tail(midf)
#   - Añade una columna al dataframe con los modelos de los coches, cuyo valor está en los nombres de cada fila. Hazlo mediante midf$modelo
#     <- ...
midf$modelo <- rownames(midf)
head(midf)
#   - Crea otro dataframe de nombre df que contenga las filas 1 a 6 y las tres últimas columnas. Para el cálculo de columnas, utiliza ncol()
df <- midf[1:6,(ncol(midf)-3):ncol(midf)]
#   - Crea un vector con 6 colores como se muestra en la imagen y añadelo como una nueva columna del dataframe
color <- c("Rojo","Verde","Azul","Amarillo","Rojo","Negro")
df <- cbind(df, color)
#   - Almacena en otro dataframe df2 las filas cuya columna gear sea igual a 4
df2 <- midf[midf$gear == 4,]
#   - Almacena en un vector modelos solo los modelos de coche que tiene color Rojo o Verde.
modelos <- df[df$color == "Rojo"|df$color == "Verde","modelo"]
modelos <- data.frame(modelos)
modelos


# EJERCICIO_09
#
# * Iris es un dataframe que almacena las medidas en centímetros de las variables longitud y ancho del sépalo y longitud y ancho del pétalo, 
#   respectivamente, para 50 flores de cada una de las 3 especies de iris. Las especies son Iris setosa, versicolor y virginica.
# * Partiendo del dataframe iris que incluye R, crea un dataframe para trabajar con él.
# * En df.sub almacena un subconjunto del dataframe original con las siguientes características:
#   - Que el ancho del sépalo esté entre 3,1 y 3,2
#   - La especie tendrá que ser setosa o versicolor.
#   - Solo se quieren las tres últimas columnas.
#   Intenta realizarlo todo en una sola línea. Si es complicado, ve almacenando los resultados en dataframes intermedios y luego intenta 
#   crear esa única línea.
# * Finalmente ordena el dataframe por el campo Species en orden inverso.
#   - Utiliza para ello la función order(), que devuelve un vector de posiciones ordenado y que tendrás que pasar al dataframe
#     df2.
#   - Almacena el resultado en el dataframe df3.

df <- iris

df.sub <- subset(df,
                 (iris$Sepal.Width > 3.0 & iris$Sepal.Width < 3.3) & (iris$Species == "setosa" | iris$Species == "versicolor"),
                 select = Petal.Length:Species)
df.sub

ordenacion <- order(df.sub$Species,decreasing = TRUE)

df2 <- df.sub[ordenacion,]
df3 <- df2
df3


# EJERCICIO_10
# 
# * Accede a una página que tenga CSV disponibles para trabajar:
#   – Busca en Google “CSV samples R” por ejemplo 
#   – O accede a esta página:
#     https://vincentarelbundock.github.io/Rdatasets/datasets.html
# * Prueba a cargar el archivo en un dataframe directamente desde su URL.
# * Descárgate otro archivo a tu ordenador y cárgalo en memoria mediante la función read.csv().
#   – Recuerda que las rutas son importantes, así como el directorio de trabajo en el que te encuentres.
#   – ¿Tu dataframe contiene valores nulos (NA)?. Prueba a utilizar la función na.omit()

library(data.table)
datos <- fread("https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/datasets/USJudgeRatings.csv")
datos

datos2 <- read.csv("LifeCycleSavings.csv")
datos2


# EJERCICIO_11
#
# * Partiendo del dataframe cars realiza un gráfico de barras y otro de los puntos.
#
cars
head(cars)

?plot
plot(x = cars$speed, y = cars$dist, type = "p", main = "DataFrame cars", xlab = "Speed", ylab = "Dist", col = "blue")

plot(x = cars$speed, y = cars$dist, type = "h", main = "DataFrame cars", xlab = "Speed", ylab = "Dist", col = "red", lwd = 4)


# EJERCICIO_12
#
# * Accede a la página del paquete datasets de R: 
#   – R: The R Datasets Package (https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html)
# * Elige un dataset y utilízalo para crear un histograma con la función hist()
head(ability.cov$cov)
names(ability.cov$cov)

cov <- ability.cov$cov
cov
hist(cov, col = "blue", border = "red", main = "Ability and Intelligence Test", xlab = cov, ylab = cov)

hist(airmiles, 
     main = "airmiles data", 
     xlab = "Passenger-miles flown by U.S. commercial airlines", 
     col = 4, 
     ylab = "Year from 1937 to 1960")

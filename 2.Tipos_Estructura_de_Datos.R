#####2. TIPOS DE ESTRUCTURAS DE DATOS EN R#####

####2.1 Vector####
titanic$Survived

#Como saber el tipo
class(titanic$Survived) #"integer"
str(titanic$Survived) # int [1:891] 0 1 1 1 0 0 0 0 1 1 ...
str(titanic)
# 'data.frame':	891 obs. of  12 variables:
# $ PassengerId: int  1 2 3 4 5 6 7 8 9 10 ...
# $ Survived   : int  0 1 1 1 0 0 0 0 1 1 ...
# $ Pclass     : int  3 1 3 1 3 3 1 3 3 2 ...
# $ Name       : Factor w/ 891 levels "Abbing, Mr. Anthony",..: 109 191 358 277 16 559 520 629 417 581 ...
# $ Sex        : Factor w/ 2 levels "female","male": 2 1 1 1 2 2 2 2 1 1 ...
# $ Age        : num  22 38 26 35 35 NA 54 2 27 14 ...
# $ SibSp      : int  1 1 0 1 0 0 0 3 0 1 ...
# $ Parch      : int  0 0 0 0 0 0 0 1 2 0 ...
# $ Ticket     : Factor w/ 681 levels "110152","110413",..: 524 597 670 50 473 276 86 396 345 133 ...
# $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
# $ Cabin      : Factor w/ 148 levels "","A10","A14",..: 1 83 1 57 1 1 131 1 1 1 ...
# $ Embarked   : Factor w/ 4 levels "","C","Q","S": 4 2 4 4 4 3 4 4 4 2 ...

# Crear un vector desde 0
edadDeMisAlumnos <- c(18, 20, 21, 18, 24, 35, 45)
nombreDeMisAlumnos <- c("Carlos", "Maria", "Marisa")

# Crear un vector vacío PREALLOCATER o pre-reservado. Es la manera recomendada cuando se itera un vector en un bucle for o similar
integer(100)
numeric(10)
character(10)

# c() también sirve para concatenar vectores
c(edadDeMisAlumnos, 1, 2, 3, 4) #18 20 21 18 24 35 45  1  2  3  4

####2.2 Listas####

# Son las estructuras de datos más flexibles. Por ejemplo, cuando se trabaja con documentos JSON se suelen usar listas.
misAlumnos <- list(18, "Carlos", 24, "Maria")
misAlumnos
# [[1]]
# [1] 18
# 
# [[2]]
# [1] "Carlos"
# 
# [[3]]
# [1] 24
# 
# [[4]]
# [1] "Maria"

lista2 <- list(1:10, "Carlos", c("Carlos", "Maria"))
lista2
# [[1]]
# [1]  1  2  3  4  5  6  7  8  9 10
# 
# [[2]]
# [1] "Carlos"
# 
# [[3]]
# [1] "Carlos" "Maria" 

lista3 <- list(sabor="Chocolate", tamaño=3)
lista3
# $sabor
# [1] "Chocolate"
# 
# $tamaño
# [1] 3

lista2[3]
# [[1]]
# [1] "Carlos" "Maria" 
str(lista2[3]) # [1] "Carlos" "Maria" 

lista3$tamaño # [1] "Carlos" "Maria" 

# Diferencias entre [] y [[]]:
# El [] devuelve una lista de tamaño 1 con el elemento en cuestión. Pero si quieres acceder al propio elemento sin lista que lo rodee
# hay que usar [[]]
# NOTA: Es muy importante esta diferencia, en ocasiones fallan muchos comandos en R porque no se presta atención a esta distinción

lista3["tamaño"]
# $tamaño
# [1] 3
# > [1] "Carlos" "Maria" 

str(lista3["tamaño"])
# List of 1
# $ tamaño: num 3
# > [1] "Carlos" "Maria"

lista3[["tamaño"]]
# [1] 3
# > [1] "Carlos" "Maria"

####2.3 Relación entre un DF y una lista####
typeof(titanic)
titanic$Age[3] # [1] 26
titanic["Age",3] # [1] NA
titanic[,"Age"][3] # [1] 26

# Los dataframes son listas de vectores (las columnas). Estos vectores forzosamente tienen que tener el mismo tamaño
# (porque tienen el mismo número de filas)

# Devolver un df de una columna, el comando [] tiene una lista de parámetros como cualquier función, el más importante es drop
titanic[,"Age",drop=FALSE] # te devuelve la lista "Age" en formato columna
titanic[,"Age"]

####2.4 Factores####
str(titanic)
# 'data.frame':	891 obs. of  12 variables:
#   $ PassengerId: int  1 2 3 4 5 6 7 8 9 10 ...
# $ Survived   : int  0 1 1 1 0 0 0 0 1 1 ...
# $ Pclass     : int  3 1 3 1 3 3 1 3 3 2 ...
# $ Name       : Factor w/ 891 levels "Abbing, Mr. Anthony",..: 109 191 358 277 16 559 520 629 417 581 ...
# $ Sex        : Factor w/ 2 levels "female","male": 2 1 1 1 2 2 2 2 1 1 ...
# $ Age        : num  22 38 26 35 35 NA 54 2 27 14 ...
# $ SibSp      : int  1 1 0 1 0 0 0 3 0 1 ...
# $ Parch      : int  0 0 0 0 0 0 0 1 2 0 ...
# $ Ticket     : Factor w/ 681 levels "110152","110413",..: 524 597 670 50 473 276 86 396 345 133 ...
# $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
# $ Cabin      : Factor w/ 148 levels "","A10","A14",..: 1 83 1 57 1 1 131 1 1 1 ...
# $ Embarked   : Factor w/ 4 levels "","C","Q","S": 4 2 4 4 4 3 4 4 4 2 ...
embarked <- titanic$Embarked
str(embarked) # Factor w/ 4 levels "","C","Q","S": 4 2 4 4 4 3 4 4 4 2 ...
# embarked es un factor. Realmente es un vector numérico (aunque se vea como una cadena de texto).
# Es un vector numérico (4 2 4 4 4 3 4 4 4 2 ...) que tiene una tabla de traducción entre números y niveles de la variable.
# "" -> 1, "C" -> 2, "Q" -> 3, "S" -> 4
# R, convierte todo a numérico.

# Para obtener los textos
head(as.character(embarked)) # [1] "S" "C" "S" "S" "S" "Q"
is.factor(embarked) # [1] TRUE
levels(embarked) # [1] ""  "C" "Q" "S"

reorder() # reordena los levels
as.factor() # para hacer factores a partir de caracteres

####2.5 Matrices####

# Las matrices son vectores con una etiqueta que dice que dimensionalidad tienen
matrix(1:9, ncol=3)
#      [,1] [,2] [,3]
# [1,]    1    4    7
# [2,]    2    5    8
# [3,]    3    6    9

# El orden normal de almacenamiento es por columnas, pero se puede poner por filas
matrix(1:9, ncol = 3, byrow = T)
#      [,1] [,2] [,3]
# [1,]    1    2    3
# [2,]    4    5    6
# [3,]    7    8    9

####2.6 Info adicional sobre librerias####

# EXTRA. Carga de librerías y conflicto de nombres
# Ejemplo de conflicto de nombres
library("dplyr")
library("ggplot2")
library("MASS")

# Muchas veces os aparecen mensajes en rojo que se ignoran. Uno especialmente frecuente es algo similar a esto:
# 
# The following objects are masked from ‘package:stats’:
#   
#   filter, lag
# 
# Este mensaje ocurre cuando has cargado más de un paquete. Cuando cargas un paquete, se sobreescribe todos sus nombres
# en el espacio de nombres (algo así como tu enviroment). Si hay dos paquetes que tienen una variable o función
# con el mismo nombre (p.e: dplyr, stats tienen los dos "filter")
# 
# R te avisa con un warning, pero sobreescribe el nombre en base al orden en el que cargues la librería. 
# Tened mucho cuidado con eso porque no tienes un 100% de garantía que una librería añada un nuevo nombre en una
# versión futura y te deje de funcionar el código

# Hay una manera que se puede usar para acceder de forma unívoca a una función en concreto:
ggplot2::aes
# Con el doble dos puntos puedes seleccionar el paquete al que quieres hacer referencia.

# En general para evitar que haya conflicto con actualizaciones futuras de paquetes y poder gestionar el versionado de 
# dependencias existe un paquete llamado "ratr" que se escapa del contenido de la clase pero os recomiendo que lo
# tengáis bajo el radar
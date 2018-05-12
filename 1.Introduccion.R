#####1. INTRODUCCIÓN: Dataframe y métodos base de R #####


# Read csv: Función por defecto para leer un csv. Es necesario darle la ruta del fichero, es importante que 
# esté en la carpeta de RStudio.
# Nos descargamos por ejemplo el archivo train de kaggle del dataset titanic
# https://www.kaggle.com/c/titanic/
# getwd() - Ojeamos la ruta en la que estamos
# setwd() - Nos posicionamos en la ruta donde estamos trabajando copiando lo que nos devuelve getwd()
titanic <- read.csv("train.csv")
# head(titanic) - Mostramos las primeras líneas del dataframe
#   PassengerId Survived Pclass                                                Name    Sex Age SibSp Parch           Ticket    Fare Cabin Embarked
# 1           1        0      3                             Braund, Mr. Owen Harris   male  22     1     0        A/5 21171  7.2500              S
# 2           2        1      1 Cumings, Mrs. John Bradley (Florence Briggs Thayer) female  38     1     0         PC 17599 71.2833   C85        C
# 3           3        1      3                              Heikkinen, Miss. Laina female  26     0     0 STON/O2. 3101282  7.9250              S
# 4           4        1      1        Futrelle, Mrs. Jacques Heath (Lily May Peel) female  35     1     0           113803 53.1000  C123        S
# 5           5        0      3                            Allen, Mr. William Henry   male  35     0     0           373450  8.0500              S
# 6           6        0      3                                    Moran, Mr. James   male  NA     0     0           330877  8.4583              Q


# Dataframe: es una estructura tabular para guardar datos de distintos tipos, es decir, una tabla.

# Para leer una columna de un dataframe se puede acceder de dos maneras:
titanic$Age # 1
titanic[,"Age"] # 2

# Ej1: ¿Cuál es la edad del sujeto número 7?
titanic[7,"Age"]

# Para leer una fila de un dataframe:
titanic[7,]

#Ej2: ¿Qué edad tiene la persona más joven?
min(titanic$Age,na.rm = T) # Función min indicando que no se tengan en cuenta los NA

#Ej3: ¿Cuál es la edad media?
mean(titanic$Age, na.rm = T)

# Ej4: ¿Cuál es la edad máxima?
max(titanic$Age, na.rm = T)

# summary: Función que muestra los típicos estadísticos de una o más variables.
summary(titanic$Age)

# Se pueden hacer operaciones sobre vectores enteros simplemente utilizando con ellos un operador matemático o cualquier función como 
# ya hemos hecho (min, max, mean,...). Vamos a realizar una comparación (menor que) para localizar a los menores de edad del desastre
# del titanic
titanic$Age < 18

#Ej5: Selecciona las filas de los menores de edad y guardalo en un nuevo dataframe llamado menores
menores <- titanic[titanic$Age < 18,]
# head(menores)
#    PassengerId Survived Pclass                                 Name    Sex Age SibSp Parch  Ticket    Fare Cabin Embarked
# NA          NA       NA     NA                                 <NA>   <NA>  NA    NA    NA    <NA>      NA  <NA>     <NA>
#  8           8        0      3       Palsson, Master. Gosta Leonard   male   2     3     1  349909 21.0750              S
# 10          10        1      2  Nasser, Mrs. Nicholas (Adele Achem) female  14     1     0  237736 30.0708              C
# 11          11        1      3      Sandstrom, Miss. Marguerite Rut female   4     1     1 PP 9549 16.7000    G6        S
# 15          15        0      3 Vestrom, Miss. Hulda Amanda Adolfina female  14     0     0  350406  7.8542              S
# 17          17        0      3                 Rice, Master. Eugene   male   2     4     1  382652 29.1250              Q

# El vector que hemos generado comparando la edad con el número 18 menores se puede utilizar como selector de filas (o incluso columnas)
# en un dataframe

# View: Funcion de RStudio para visualizar la tabla
View(menores)

# Vamos a limpiar el dataframe menores de NA:
# Máscara: es un concepto bastante amplio que en este contexto significa que un vector booleano (de TRUE o FALSE) "enmascara" a las personas
# que son mayores de edad dejando visibles únicamente a los menores:
mascaraDeMenores <- titanic$Age < 18
head(mascaraDeMenores) # [1] FALSE FALSE FALSE FALSE FALSE    NA

# El problema de esta máscara es que la operación < como la mayoría de operaciones en R, devuelve un NA (valor perdido), cuando en el 
# vector original hay un NA (no sabes si es menor o mayor de edad)
# Primero, utilizamos la función is.na para buscar los NA existentes, y le damos el valor FALSE
mascaraDeMenores[is.na(mascaraDeMenores)] <- F
menores <- titanic[mascaraDeMenores,]
head(menores) # de esta manera el dataframe menores ya no tiene valores NA

# Realizamos selecciones de datos dentro del dataframe:
# Seleccionamos múltiples filas:
titanic[c(3,5),] # Filas 3 y 5
# Seleccionamos múltiples filas:
titanic[c(3,5),c("Age","Sex")] # Filas 3 y 5, columnas Age y Sex
titanic[c(3,5),c(2,5)] # Filas 3 y 5, columnas Survived y Sex
# Se puede convinar sintáxis:
titanic$Name[c(1,2)] # Columna Name, filas 1 y 2
titanic[c(1,2),"Name"]
# Se puede seleccionar y asignar a la vez
titanic[c(1,2),"Age"]
titanic[c(1,2),"Age"] <- 20

# Más funciones útiles de dataframe:
colnames(titanic) # Muestra los nombres de las columnas
rownames(titanic) # Muestra el nombre de las filas
nrow(titanic) # Número de filas
ncol(titanic) # Número de columnas

cbind() # Concatenar columnas
rbind() # Concatenar filas





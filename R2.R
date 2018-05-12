# Ejercicios con el dataset titanic:
# https://www.kaggle.com/c/titanic/

##### 1. Filtra aquellas mujeres de primera clase y extrae las columnas Fare y Survived
titanic <- read.csv("train.csv")
head(titanic)

mujeresPrimera <- titanic[titanic$Sex == "female" & titanic$Pclass == "1",c("Survived","Fare")]

##### 2. Porcentaje de supervivencia en este grupo
totalMujeresPrimera <- nrow(mujeresPrimera) # 94
sumMujeresPrimera <- sum(mujeresPrimera$Survived) # 91
PMujeresPrimera <- sumMujeresPrimera/totalMujeresPrimera # 0.9680851

tapply(titanic$Survived, titanic$Pclass, mean) # Aplica la función mean al vector Survived para cada una de sus factores Pclass
#         1         2         3 
# 0.6296296 0.4728261 0.2423625 
tapply(titanic$Survived, titanic$Sex, mean, na.rm=T) # Aplica la función mean al vector Survived para cada uno de sus factores Sex
#    female      male 
# 0.7420382 0.1889081 

table(titanic$Pclass) # Contruye una tabla contando los elementos totales de cada factor de Pclass
#   1   2   3 
# 216 184 491 
table(titanic$Sex) # Construye una tabla contando los elementos totales de cada factor de Sex
# female   male 
#    314    577 

by(titanic, titanic$Sex, summary) # Dado un dataframe, aplica a un factor o lista de factores (en este caso Sex), la función summary

aggregate(Survived ~ Pclass, titanic, mean) # Calcula la media de Survived para cada uno de los factores de Pclass
#   Pclass  Survived
# 1      1 0.6296296
# 2      2 0.4728261
# 3      3 0.2423625

aggregate(cbind(Survived,Age) ~ Pclass + Sex, titanic, mean) # Calcula la media de Survived y Age para cada uno de los factores de Pclass y dentro
# de Pclass para Sex o viceversa
#   Pclass    Sex  Survived      Age
# 1      1 female 0.9647059 34.61176
# 2      2 female 0.9189189 28.72297
# 3      3 female 0.4607843 21.75000
# 4      1   male 0.3960396 41.28139
# 5      2   male 0.1515152 30.74071
# 6      3   male 0.1501976 26.50759

##### 3. Media de edad de hombres que sobrevivieron
mean(titanic[titanic$Sex=="male" & titanic$Survived,"Age"], na.rm=T) # 27.27602

##### 4. Cuantas personas sobrevivieron
sum(titanic$Survived) # 342
table(titanic$Survived)

##### 5. Cuantas personas fallecieron
nrow(titanic) - sum(titanic$Survived) #549
sum(!titanic$Survived)
table(titanic$Survived)

##### 6. Cuantas personas viajaron en el titanic
nrow(titanic) # 891
sum(titanic$Embarked != "") # 889

##### 7. Ratio entre personas de primer clase y tercera
sum(titanic$Pclass == 1) / sum(titanic$Pclass == 3) #0.4399185

##### 8. Seleccionar columna Age y Sex para personas de primera clase 
titanic[titanic$Pclass == 1, c("Age","Sex")]

##### 9. Calcula la máscara para seleccionar los supervivientes de tercera clase o los hombres de primera que fallecieron
(titanic$Pclass == 3 & titanic$Survived) | 
  (titanic$Pclass == 1 & titanic$Sex == "male" & !titanic$Survived)

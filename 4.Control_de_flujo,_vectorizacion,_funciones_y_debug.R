##### 4. CONTROL DEL FLUJO, VECTORIZACIÓN, FUNCIONES Y DEBUG #####

##### 4.1. Flujo condicional (if) #####
if (5 > 3){
  print("Hola")
}else if (2 < 1){
  print("Adios")
}else{
 print("Cierre") 
}


##### 4.2. Bucles #####

##### 4.2.1. For #####
for (x in 1:10){
  print(x)
}

##### 4.2.2. While #####
contador <- 5
while(contador > 0){
  print(contador)
  contador = contador + 1
}


##### 4.3. Funciones #####
miFuncion <- function(a, b){
  return(a+b)
}
# Con valores por defecto
miFuncion <- function(a, b=5){
  return(a+b)
}
# Función impura: Función que tiene efecto fuera de su cuerpo. NO HACER NUNCA ESTO
miFuncionImpura <- function(df) {
  df$a = 3
  df
}


##### 4.4. Forma vectorizada vs Bucles #####
# Cuando se está aprendiendo a programar se tiende a realizar muchas tareas en bucles. Es la manera que tenemos de pensar y por tanto suele ser
# la manera en la que escribís código.
# Vamos a ver un ejemplo:
# Si compras 1 accion de google cada dia que este supera a apple. ¿En que coste total incurres?
# Nos inventamos los datos
aapl <- rnorm(100)
googl <- rnorm(100)
# Esta sería la forma con bucle
importe <- 0
for (i in 1:100) {
  if (aapl[i] < googl[i])
    importe <- importe + googl[i]
}
# Esta sería la forma vectorizada. Mucho más compacta y rápida. Muchas veces puedes ganar un x100 de velocidad
sum(googl[googl > aapl])


##### 4.5. DEBUG #####
# NOTA: En las siguientes líneas de código hay un error y hay que encontrarlo
# Para ello es necesario debuguear las funciones. La forma más fácil es añadir un breakpoint (punto de ruptura) en la línea en la que te 
# quieras detener.
# Para añadir este breakpoint hay que pulsar a la izquierda del número de fila (en la zona gris izquierda donde tienes) el código fuente.
# Cuando ya salga un punto rojo. Tienes que hacer un source del fichero y ese punto rojo se rellenará
# Ahora ya puedes ejecutar la función con invertir2(...) y ver que pasa línea a línea
invertir <- function (a,b) {
  sum(a[a>b])
}
invertir2 <- function (appl,googl) {
  importe <- 0
  for (i in 1:100)
    if (aapl[i] < googl[i])
      importe <- importe + googl[i]
    importe
}
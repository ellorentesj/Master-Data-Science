##### 6. RECOGIDA Y LECTURA DE DATOS #####

list.of.packages <- c("R.utils", "rvest", "stringr", "foreach", "doParallel", "tidyverse", "sqldf")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


##### 6.1. Recogida de datos #####

tmp_dir <- tempdir() # tempdir() subdirectorio del directorio temporal por sesión encontrado por la siguiente regla cuando se inicia la sesión R
tmp_file <- file.path(tmp_dir, '2007.csv')
download.file('http://stat-computing.org/dataexpo/2009/2007.csv.bz2', tmp_file)

library(R.utils) # for bunzip2
bunzip2(tmp_file, "2007.csv", remove = FALSE, skip = TRUE)

# Checks
file.info(tmp_file) #Downlaoded file
utils:::format.object_size(file.info("downloads/2007.csv")$size, "auto") #Uncompressed file size

##### 6.1.1. Web Scraping #####
library(rvest) # for read_html, html_*, ...
library(stringr) # for str_*

page <- read_html("http://stat-computing.org/dataexpo/2009/the-data.html")

(all_links <- html_nodes(page, "a"))
(linked_resources <- html_attr(all_links, "href"))
(linked_bz2_files <- str_subset(linked_resources, "\\.bz2"))
(bz2_files_links <- paste0("http://stat-computing.org/dataexpo/2009/", linked_bz2_files))
(bz2_files_links <- head(bz2_files_links, 2)) # Nos quedamos con sólo los dos primeros 
(num_files <- length(bz2_files_links))

# Custom download function
download_flights_datasets <- function (link) {
  cat(link, "\n")
  this_file_link <- link
  this_file_name <- str_extract(basename(this_file_link), "^.{0,8}")
  this_tmp_file <- file.path(tmp_dir, this_file_name)
  download.file(this_file_link, this_tmp_file)
  bunzip2(this_tmp_file, file.path('downloads', this_file_name), remove = FALSE, skip = TRUE)
}

# Testing download_flights_datasets 
( link <- bz2_files_links[1] )
download_flights_datasets(link)

# EJ: Coding exercise: Downloading all links
# Sol. 1:
for (link in bz2_files_links){
  download_flights_datasets(link)
}
#Sol. 2:
lapply(bz2_files_links, download_flights_datasets)

# Downloading all files in parallel
library("foreach") # for foreach
library("doParallel") # for makeCluster, registerDoParallel

detectCores()

cl <- makeCluster(detectCores() - 1) # create a cluster with x cores
registerDoParallel(cl) # register the cluster

res <- foreach(i = 1:num_files, 
               .packages = c("R.utils", "stringr")) %dopar% {
                 this_file_link <- bz2_files_links[i]
                 download_flights_datasets(this_file_link)
               }


##### 6.2. Lectura de datos #####

##### 6.2.1. En Base R #####
flights <- read.csv("2007.csv")
airports <- read.csv("airports.csv")

##### 6.2.2. readr #####
library(readr)

ptm <- proc.time()
flights <- read_csv('2007.csv', progress = T)
proc.time() - ptm
print(object.size(get('flights')), units='auto')

##### 6.2.3. data.table #####
# remove.packages("data.table")
# Notes:
# http://www.openmp.org/
# https://github.com/Rdatatable/data.table/wiki/Installation
# 
# Linux & Mac:
# install.packages("data.table", type = "source", repos = "http://Rdatatable.github.io/data.table")
# 
# install.packages("data.table")

library(data.table)

ptm <- proc.time()
flights <- fread("2007.csv")
proc.time() - ptm

##### 6.2.4. Leyendo multiples ficheros #####
( data_path <- file.path('data','flights') )
( files <- list.files(data_path, pattern = '*.csv', full.names = T) )
system.time( flights <- lapply(files, fread) ) 
system.time( flights <- lapply(files, fread, nThread=4) )

# What is flights?
class(flights)
flights <- rbindlist(flights)

##### 6.2.5. Leyendo en paralelo #####
# library(parallel)
# system.time(flights <- mclapply(files, data.table::fread, mc.cores = 8))

library(doParallel)
registerDoParallel(cores = detectCores() - 1)
library(foreach)
system.time( flights <- foreach(i = files, .combine = rbind) %dopar% read_csv(i) )
system.time( flights <- data.table::rbindlist(foreach(i = files) %dopar% data.table::fread(i, nThread=8)))
print(object.size(get('flights')), units='auto')
unique(flights$Year)

##### 6.2.5. Leyendo grandes ficheros #####
# Some times system commands are faster
system('head -5 2007.csv')
readLines("2007.csv", n=5)

# Num rows
length(readLines("2007.csv")) # Not so big files
nrow(data.table::fread("2007.csv", select = 1L, nThread = 1)) # Using fread on the first column

##### 6.2.6. Leyendo solo lo que necesito #####
# Reading only what I neeed
library(sqldf)
jfk <- sqldf::read.csv.sql("2007.csv", 
                           sql = "select * from file where Dest = 'JFK'")
head(jfk)
data.table::fread("data/flights/2008.csv", select = c("UniqueCarrier","Dest","ArrDelay" ))

# Using other tools
# shell: csvcut ./data/airlines.csv -c Code,Description
data.table::fread('/Library/Frameworks/Python.framework/Versions/2.7/bin/csvcut ./data/airports.csv -c iata,airport' )
# shell: head -n 100 ./data/flights/2007.csv | csvcut -c UniqueCarrier,Dest,ArrDelay | csvsort -r -c 3
data.table::fread('head -n 100 ./data/flights/2007.csv | /Library/Frameworks/Python.framework/Versions/2.7/bin/csvcut -c UniqueCarrier,Dest,ArrDelay | /Library/Frameworks/Python.framework/Versions/2.7/bin/csvsort -r -c 3')

# Dealing with larger than memory datasets
# Using a DBMS
# sqldf("attach 'flights_db.sqlite' as flights")
# sqldf("DROP TABLE IF EXISTS flights.delays")
read.csv.sql("./data/flights/2008.csv", 
             sql = c("attach 'flights_db.sqlite' as flights", 
                     "DROP TABLE IF EXISTS flights.delays",
                     "CREATE TABLE flights.delays as SELECT UniqueCarrier, TailNum, ArrDelay FROM file WHERE ArrDelay > 0"), 
             filter = "head -n 100000")
db <- dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')
dbListTables(db)
delays.df <- dbGetQuery(db, "SELECT UniqueCarrier, AVG(ArrDelay) AS AvgDelay FROM delays GROUP BY UniqueCarrier")  
delays.df
unlink("flights_db.sqlite")
dbDisconnect(db)

# Chunks
# read_csv_chunked
library(readr)
f <- function(x, pos) subset(x, Dest == 'JFK')
jfk <- read_csv_chunked("./data/flights/2008.csv",
                        chunk_size = 50000,
                        callback = DataFrameCallback$new(f))

# Importing a file into a DBMS:
db <- DBI::dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')
dbListTables(db)
dbWriteTable(db,"jfkflights",jfk) # Inserta en df en memoria en la base de datos
dbGetQuery(db, "SELECT count(*) FROM jfkflights")  
dbRemoveTable(db, "jfkflights")
rm(jfk)

# Example: Coding exercise: Using read_csv_chunked, read ./data/flights/2008.csv by chunks while sending data into a RSQLite::SQLite() database
db <- DBI::dbConnect(RSQLite::SQLite(), dbname='flights_db.sqlite')
writetable <- function(df,pos) {
  dbWriteTable(db,"flights",df,append=TRUE)
}
readr::read_csv_chunked(file="./data/flights/2008.csv", callback=SideEffectChunkCallback$new(writetable), chunk_size = 50000)

# Check
num_rows <- dbGetQuery(db, "SELECT count(*) FROM flights")
num_rows == nrow(data.table::fread("data/flights/2008.csv", select = 1L, nThread = 2)) 

dbGetQuery(db, "SELECT * FROM flights LIMIT 6") 

dbRemoveTable(db, "flights")
dbDisconnect(db)

# Basic functions for data frames -----------------------------------------
names(flights)
str(flights)
nrow(flights)
ncol(flights)
dim(flights)

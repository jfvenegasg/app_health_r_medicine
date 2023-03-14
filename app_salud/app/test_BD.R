library(DBI)
library(dplyr)
library(dbplyr)

db_password <- Sys.getenv("DATABASE_PASS")
#DBI::dbDisconnect(conn = con)

con <- DBI::dbConnect(RPostgres::Postgres(),
                      host   = "db-postgresql-nyc1-40399-do-user-13749128-0.b.db.ondigitalocean.com",
                      dbname = "defaultdb",
                      user      = "doadmin",
                      password  = db_password,
                      port     = 25060)


DBI::dbCreateTable(con, name = "my_data", fields = head(df, 0))

#Listar bases de datos en la conexion con
DBI::dbListTables(con)

#Leer tabla "datos_suspensiones"
DBI::dbReadTable(con, "datos_suspensiones")

#Leer tabla "datos_suspensiones"
DBI::dbReadTable(con, "sankey_datos_suspensiones")

DBI::dbListFields(conn = con,name = "datos_suspensiones")

# Para crear tablas en la base de datos
DBI::dbCreateTable(con, name = "datos_suspensiones", fields = head(datos_suspensiones, 0))

# Para insertar valores en una tabla
DBI::dbAppendTable(conn = con,name ="datos_suspensiones" ,value =data_insert )

#Filtrar consultas con dplyr
consulta<-tbl(con,sql("SELECT * FROM datos_suspensiones")) %>% filter(Causa.de.suspension=="INFRAESTRUCTURA") %>% collect()


DBI::dbDisconnect(conn = pool)
pool::poolClose(pool)


###############################################################################################################

datos_suspensiones<-xlsx::read.xlsx(file="app_salud/app/logic/data/set_de_datos_1.xlsx",sheetIndex = 5, rowIndex = 16:160, colIndex= 2:5
                                    , as.data.frame = TRUE, header = TRUE)



data_insert<-data.frame(Mes="Diciembre",
                        Causa.de.suspension="INFRAESTRUCTURA",
                        Descripcion="% de total Suspensiones totales junto con Causas De Suspensión Atribuibles A:",
                        Valor=0.01)

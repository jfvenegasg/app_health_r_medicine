# app/global.R

box::use(
  pool,
  DBI,
  RPostgres)

db_password <- Sys.getenv("DATABASE_PASS")
pool <- pool::dbPool(drv=RPostgres::Postgres(),
                     host   = "db-postgresql-nyc1-40399-do-user-13749128-0.b.db.ondigitalocean.com",
                     dbname = "defaultdb",
                     user      = "doadmin",
                     password  = db_password,
                     port     = 25060)

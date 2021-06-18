library(data.table)
library(DBI)
library(RSQLite)

# load data
ships_data <- fread("data/ships.csv")

# assure unique column names
setnames(ships_data, "port", "port_unicode")

# assure unique lonlat data (other data is mostly out of scope)
ships_data <- unique(ships_data, by = c("SHIP_ID", "LON", "LAT"))
ships_data <- ships_data[order(SHIP_ID, DATETIME)]

# there are inconcistencies in data

vessel_by_type = unique(ships_data[, .(ship_type, 
                                       ship_name = SHIPNAME, 
                                       ship_id = SHIP_ID)])



saveRDS(vessel_by_type, "data/vessel_by_type.RDS")

con <- DBI::dbConnect(SQLite(), "data/DB.db")
dbWriteTable(con, "ships", ships_data)
dbDisconnect(con)

library(data.table)
library(DBI)
library(RSQLite)

if (!interactive()) return()

# load data
ships_data <- fread("data/ships.csv")

# assure unique column names
setnames(ships_data, "port", "port_unicode")

# assure unique lonlat data (other data is mostly out of scope)
ships_data <- unique(ships_data, by = c("SHIP_ID", "LON", "LAT"))
ships_data <- ships_data[order(SHIP_ID, DATETIME)]

# there are inconcistencies in data ???

vessel_by_type = unique(ships_data[, .(ship_type, 
                                       ship_name = SHIPNAME, 
                                       ship_id = SHIP_ID)])

saveRDS(vessel_by_type, "data/vessel_by_type.RDS")

con <- DBI::dbConnect(SQLite(), "data/DB.db")
dbWriteTable(con, "ships", ships_data)
dbDisconnect(con)


# prepare translations
en <- data.frame(
    en = c(
        "Marine Vessels and Their Routes in the Baltic Water Area",
        "Ship Type",
        "Ship Name",
        "Total Distance Travelled: ",
        "Longest Segment: ",
        "Based on ",
        "unique points",
        "Dead Weight",
        "Length",
        "Width",
        "End",
        "Start",
        "DateTime",
        "Speed, knots",
        "Change language"
    )
)

ru <- data.frame(
    ru = c(
        "Морские судна и их маршруты в Балтийской акватории",
        "Тип судна",
        "Название судна",
        "Всего дистанции пройдено: ",
        "Самый длинный отрезок: ",
        "Основано на ",
        "уникальных координатах",
        "Грузоподъемность",
        "Длина",
        "Ширина",
        "Конец",
        "Начало",
        "Дата и время",
        "Скорость, узлов",
        "Сменить язык"
    )
)

translation_ru <- cbind(en, ru)
data.table::fwrite(translation_ru, "data/translations/translation_ru.csv")

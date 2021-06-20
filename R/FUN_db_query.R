
get_db_data <- function(db_path, sql, variables, n = -1) {
  con <- dbConnect(RSQLite::SQLite(), db_path)
  res <- dbSendQuery(con, sql, variables)
  df <- dbFetch(res = res, n = n)
  dbClearResult(res)
  dbDisconnect(con)

  if (length(df) == 1) {
    return(df[, 1])
  }
  return(df)
}

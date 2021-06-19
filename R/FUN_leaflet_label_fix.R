myLabelFormat <- function(..., dates = FALSE){ 
    if(dates) { 
        function(type = "numeric", cuts){ 
            as.POSIXct(cuts, origin="1970-01-01")
        } 
    } else {
        leaflet::labelFormat(...)
    }
}
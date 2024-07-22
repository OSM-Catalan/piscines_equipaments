library(jsonlite)
library(httr2)
library(sf)



piscines <- request("https://analisi.transparenciacatalunya.cat/resource/8gmd-gz7i.json?$limit=1000000") |> 
  req_perform() |> 
  resp_body_string() |> 
  fromJSON()



piscines <- piscines[grepl("Piscin*", piscines$categoria),]

str(piscines)




piscines <- st_as_sf(piscines, coords = c("longitud", "latitud"), crs = "EPSG:4326")


piscines <- split(piscines, piscines$comarca)



mapply(\(x,y) st_write(x, paste0("path/",y,".geojson")), piscines, names(piscines))

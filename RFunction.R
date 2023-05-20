library('move')
library('sf')
library('osmdata')
library('devtools')
library('ggplot2')
library('units')
library('mapview')
devtools::install_github('jedalong/wildlifeHI')
library('wildlifeHI')

## The parameter "data" is reserved for the data object passed on from the previous app

## to display messages to the user in the log file of the App in MoveApps one can use the function from the logger.R file: 
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

rFunction = function(data,key,value,geom,crs_code) {
  
  poly2line <- TRUE
  #check input data type
  if (class(data) != 'MoveStack'){
    if (class(data) == 'Move'){
      data <- moveStack(data, forceTz='UTC')
    } else {
      print('Input Data not of class MoveStack. Returning null object.')
      return(NULL)
    }
  }
  
  if (value == 'all'){
    osm_temp <- hi_get_osm(move=data,key=key,geom=geom,poly2line=poly2line)
  } else {
    osm_temp <- hi_get_osm(move=data,key=key,value=value,geom=geom,poly2line=poly2line)
  }
  
  if (crs_code == 0){
    crs_code <- st_crs(data)
  }
  
  move_x <- hi_crossing(data,osmdata=osm_temp)
  x_sf <- hi_crossing_loc(data,osmdata=osm_temp,crs_code=crs_code)
  
  #Crossing Type Table
  x_tab <- table(move_x@trackId, move_x$crossing_value)
  csvName <- 'Table_CrossingType.csv'
  write.csv(x_tab,appArtifactPath(csvName),row.names=TRUE)
  
  #Crossing Fix Table
  x_fix <- data.frame(subset(move_x, crossing_true==TRUE))
  csvName <- 'Table_FixCrossings.csv'
  write.csv(x_fix,appArtifactPath(csvName),row.names=TRUE)
  
  #Crossing Shapefile
  suppressWarnings(x_sf <- st_cast(x_sf,'MULTIPOINT') |> st_cast('POINT'))
  shpName <- 'Shapefile_Crossings.shp'
  suppressWarnings(st_write(x_sf,appArtifactPath(shpName)))
  
  #Crossing Map
  m <- mapview(x_sf['value'])
  htmlName <- 'Map_Crossing.html'
  #mapshot(m,file='D:/DELETE.png',url='D:/DELETE.html')
  mapshot(m,url=appArtifactPath(htmlName))
  
  return(move_x)
}

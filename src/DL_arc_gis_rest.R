# Load the sf package
library(sf)
source("setup.R")
# Base URL for the MapServer
# Note, googled "Virginia Wells" and found this arc gis rest services map at link:
# https://energy.virginia.gov/gis/rest/services/DGMR/VA_Water_Wells/MapServer -- used this
# link as the map_server_url below.
map_server_url <- "https://gis.ohiodnr.gov/arcgis/rest/services/DGS_Services/Ohio_Water_Wells/FeatureServer/1"

# The specific layer ID you want (e.g., Layer 0 for 'Water Wells')
layer_id <- 0

# Construct the URL for the 'query' endpoint, requesting GeoJSON output
# 'where=1=1' means select all features
# 'outFields=*' means include all attributes
# 'returnGeometry=true' means include the spatial geometry
# 'f=geojson' is crucial to tell the service to return data in GeoJSON format
query_url <- paste0(
  map_server_url, "/", layer_id,
  "/query?where=1%3D1&outFields=*&returnGeometry=true&f=geojson"
)

# Download the data into an sf object
# This might take some time depending on the size of the dataset
# and your internet connection.
water_wells_sf <- NULL # Initialize to NULL in case of error

tryCatch({
  water_wells_sf <- st_read(query_url)
  message("\nData downloaded successfully!")
  print(head(water_wells_sf))
  print(paste("Number of features:", nrow(water_wells_sf)))
  print(paste("CRS:", st_crs(water_wells_sf)$input))
}, error = function(e) {
  message("\nError downloading data: ", e$message)
  message("Please ensure the layer ID (e.g., /0, /1, etc.) is correct and the service is configured to return GeoJSON via the /query endpoint.")
  message("You can try pasting the 'query_url' directly into your web browser to see the raw GeoJSON response.")
})

# You can then check if water_wells_sf is not NULL before proceeding
if (!is.null(water_wells_sf) && nrow(water_wells_sf) > 0) {
  message("\nSuccessfully loaded water wells data.")
  # You can now work with water_wells_sf
  # Example: plot the first few wells
  # plot(st_geometry(water_wells_sf[1:10,]))
} else {
  message("\nNo water wells data was loaded.")
}

# Assuming square_polygons_sf_wgs84 is the sf object you want to save
# (as created in your Canvas)

# Define the output file path and name for your shapefile
output_shapefile_path <- "data/Water_Supply_Systems/data_sources/Virginia/Virginia_wells.shp"

# Save the sf object as a shapefile
st_write(water_wells_sf, output_shapefile_path)

# view wells
library(mapview)
mapview(water_wells_sf)

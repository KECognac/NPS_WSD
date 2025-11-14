#load csv data
load_csv <- function(path, x, y, crs) {
  read_csv(path) %>%
    drop_na(c(x, y)) %>%
    st_as_sf(coords = c(x, y), crs = crs, remove = FALSE)
}

add_wgs_coords <- function(df) {
  df %>%
    st_transform(crs = 4326) %>%
    mutate(
      longitude_wgs84 = st_coordinates(.)[, 1],
      latitude_wgs84 = st_coordinates(.)[, 2])
}

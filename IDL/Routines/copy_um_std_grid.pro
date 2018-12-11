pro copy_um_std_grid, basis_grid_name, basis_grid_size,$
                      basis_lon, basis_lat, basis_vert, basis_time, $
                      new_grid_name, new_grid_size, $
                      new_lon, new_lat, new_vert, new_time
  ; A simple routine to copy the grid information for std UM (netCDF
  ; format variables)
  new_grid_name=basis_grid_name
  new_grid_size=basis_grid_size
  new_lon=basis_lon
  new_lat=basis_lat
  new_vert=basis_vert
  new_time=basis_time
end

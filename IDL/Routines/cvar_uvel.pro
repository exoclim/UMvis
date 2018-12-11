pro cvar_uvel, fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               variable_out,$
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               verbose=verbose
  ; Read in U and longitude grid, which differs from pressure
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid,fname, ncdf_name, variable_out, $
                            var_grid_name, var_grid_size
  lon=get_variable_grid(fname, ncdf_name, 0, $
                        verbose=verbose)
  var_lon=lon
  lon=0
end

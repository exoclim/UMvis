pro cvar_vvel, fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               variable_out,$
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               verbose=verbose
  ; Read in V and latitude grid, which differs from pressure
  target_var='Vvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid, fname, ncdf_name, variable_out, $
                             var_grid_name, var_grid_size
  lat=get_variable_grid(fname, ncdf_name, 1, $
                        verbose=verbose)
  var_lat=lat
  lat=0
end

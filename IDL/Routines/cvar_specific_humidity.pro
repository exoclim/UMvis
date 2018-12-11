pro cvar_specific_humidity, fname, netcdf_var_names, $
                            p_array, psurf_array,$
                            p_grid_name, p_grid_size,$
                            p_lon, p_lat, p_vert, p_time,$
                            variable_out,$
                            var_grid_name, var_grid_size,$
                            var_lon, var_lat, var_vert, var_time,$
                            verbose=verbose
  ; find the netcdf short name and read it in
  target_var='specific_humidity'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid,fname, ncdf_name, variable_out, $
                            var_grid_name, var_grid_size
  q_vert=get_variable_grid(fname, ncdf_name, 2, $
                               verbose=verbose)
  var_vert=q_vert
  q_vert=0
end


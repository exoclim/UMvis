pro cvar_pressure_theta_levs, $
               fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               variable_out,$
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               lid_height, $
               verbose=verbose
  ; Pressure on theta levels
  target_var='pressure_theta_levs'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  ; Vertical grid is theta grid
  read_netcdf_variable_grid,fname, ncdf_name, variable_out, $
                            var_grid_name, var_grid_size
  press_theta_levs_vert=get_variable_grid(fname, ncdf_name, 2, $
                               verbose=verbose)
  var_vert=press_theta_levs_vert
  press_theta_levs_vert=0
end

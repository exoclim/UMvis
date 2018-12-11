pro cvar_horizspeed_shear, fname, netcdf_var_names, $
                           p_array, psurf_array,$
                           p_grid_name, p_grid_size,$
                           p_lon, p_lat, p_vert, p_time,$
                           variable_out,$
                           var_grid_name, var_grid_size,$
                           var_lon, var_lat, var_vert, var_time,$
                           verbose=verbose
  ; Vertical shear in horizontal speed, on p-grid
  ; First get horizontal speed
  cvar_horizspeed, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   horizspeed, $
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   verbose=verbose
  variable_out=calc_vert_shear(horiz_speed, var_vert)
  ; Grid unchanged, all on p-grid
  horiz_speed=0
end

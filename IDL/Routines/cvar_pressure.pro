pro cvar_pressure, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   variable_out,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   var_vert_bounds, $
                   p0, $
                   verbose=verbose
  ; Just copy pressure
  variable_out=p_array
  ; Update the boundary values
  ; This should actually be changed to psurf
  ; but is this way to be consistent with
  ; set_grid_bounds_values_vert **WORK**
  var_vert_bounds(0)=p0
  var_vert_bounds(1)=0.0
end

pro cvar_height_rho, fname, netcdf_var_names, $
                     p_array, psurf_array,$
                     p_grid_name, p_grid_size,$
                     p_lon, p_lat, p_vert, p_time,$
                     variable_out, $
                     var_grid_name, var_grid_size, $
                     var_lon, var_lat, var_vert, var_time,$
                     var_vert_bounds, $
                     lid_height, $
                     verbose=verbose
  ; Simply height of pressure surfaces
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  for k=0, var_grid_size(2)-1 do begin
     variable_out(*,*,k,*)=var_vert(k)
  endfor
  ; Update boundaries
  var_vert_bounds(0)=0.0
  var_vert_bounds(1)=lid_height
end

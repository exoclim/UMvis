pro cvar_sigma, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                variable_out,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                var_vert_bounds, $
                verbose=verbose
  variable_out=p_array
  ; Now divide by surface pressure
  for k=0, var_grid_size(2)-1 do begin
     variable_out(*,*,k,*)=p_array(*,*,k,*)/$
                     psurf_array(*,*,*)
  endfor
  ; Update boundary values
  var_vert_bounds(0)=1.0
  var_vert_bounds(1)=0.0
end

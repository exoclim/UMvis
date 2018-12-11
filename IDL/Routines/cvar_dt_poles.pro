pro cvar_dt_poles, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   variable_out,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   p0, kappa,$
                   verbose=verbose
  ; Routine to construct difference in temperature from
  ; each cell, to the average at the N and S pole
  ; Read in the temperature
  cvar_temp, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             temperature,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             p0, kappa, lid_height,$
             verbose=verbose
  ; Allocate and construct output
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; Use average of N and S poles
  for ilat=0, var_grid_size(1)-1 do begin
     variable_out(*,ilat,*,*)=$
        temperature(*,ilat,*,*)-$
        0.5*(temperature(*,0,*,*)+$
             temperature(*,var_grid_size(1)-1,*,*))
  endfor
  temperature=0
end

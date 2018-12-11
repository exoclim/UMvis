pro cvar_t_teq_newtonian, fname, netcdf_var_names, $
                          p_array, psurf_array,$
                          p_grid_name, p_grid_size,$
                          p_lon, p_lat, p_vert, p_time,$
                          variable_out,$
                          var_grid_name, var_grid_size,$
                          var_lon, var_lat, var_vert, var_time,$
                          setup, p0, kappa, lid_height, $
                          verbose=verbose
  ; Routine to construct the difference between the current
  ; temperature and the specified 
  ; Newtonian equilibrium temperature for this setup
  ; Read in temerature
  cvar_temp, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size, $
             p_lon, p_lat, p_vert, p_time,$
             temperature,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             p0, kappa, lid_height,$
             verbose=verbose
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; Calculate the equilibrium temperature
  for t=0, var_grid_size(3)-1 do begin
     for k=0, var_grid_size(2)-1 do begin
        for j=0, var_grid_size(1)-1 do begin
           for i=0, var_grid_size(0)-1 do begin
              teq=get_eq_temp(setup, p_array(i,j,k,t),$
                              p_lon(i),$
                              p_lat(j))
              variable_out(i,j,k,t)=$
                 (temperature(i,j,k,t)-teq)               
           endfor
        endfor
     endfor
  endfor
end

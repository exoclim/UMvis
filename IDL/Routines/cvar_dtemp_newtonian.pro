pro cvar_dtemp_newtonian, fname, netcdf_var_names, $
                          p_array, psurf_array,$
                          p_grid_name, p_grid_size,$
                          p_lon, p_lat, p_vert, p_time,$
                          variable_out,$
                          var_grid_name, var_grid_size,$
                          var_lon, var_lat, var_vert, var_time,$
                          setup, p0, kappa, lid_height, $
                          verbose=verbose
  ; Find the temperature change, per second, 
  ; in each cell, given the equilibrium temperature
  ; Read in the current temperature
  cvar_temp, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             temperature,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             p0, kappa, lid_height, $
             verbose=verbose
  ; Then calculate dT_dt

  ; Define the output array
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  for t=0, var_grid_size(3)-1 do begin
     for k=0, var_grid_size(2)-1 do begin
        for j=0, var_grid_size(1)-1 do begin
           for i=0, var_grid_size(0)-1 do begin
              ; Derive the equlibrium temperature
              t_eq=get_eq_temp(setup, p_array(i,j,k,t),$
                               p_lon(i), p_lat(j))
              ; Derive the reciprocal of the radiative timescale
              recip_tau_rad=get_recip_tau_rad(setup, p_array(i,j,k,t))
              variable_out(i,j,k,t)=-1.0*(temperature(i,j,k,t)-$
                                          t_eq)*recip_tau_rad              
           endfor
        endfor
     endfor
  endfor
  temperature=0
end

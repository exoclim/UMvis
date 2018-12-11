pro cvar_cs, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             variable_out,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             R, p0, kappa, lid_height, $
             verbose=verbose
  ; Calculate sound speed, based solely on ideal gas equation
  if (KEYWORD_SET(verbose)) then begin
     print, 'WARNING: Calculating Cs using simplified equation'
     print, 'Cs=SQRT(1.4*R*T)'
     print, 'This should use density'
  endif
  ; First we need temperature (all on pressure grid)
  cvar_temp, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             variable_out,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             p0, kappa, lid_height,$
             verbose=verbose
  ; Now convert to sound speed
  ; Using P=rho R T
  ; Cs=sqrt(gamma *P/rho)
  ; Dry air gamma =1.4
  variable_out(*,*,*,*)=SQRT((1.4*R)*variable_out(*,*,*,*))
end

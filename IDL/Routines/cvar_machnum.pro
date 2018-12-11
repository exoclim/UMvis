pro cvar_machnum, fname, netcdf_var_names, $
                  p_array, psurf_array,$
                  p_grid_name, p_grid_size,$
                  p_lon, p_lat, p_vert, p_time,$
                  variable_out,$
                  var_grid_name, var_grid_size,$
                  var_lon, var_lat, var_vert, var_time,$
                  p0, kappa, R, lid_height, $
                  verbose=verbose
  ; Routine to calculate the Mach Number of the flow
  ; First read in the sound speed, which is on p-grid
  cvar_cs, fname, netcdf_var_names, $
           p_array, psurf_array,$
           p_grid_name, p_grid_size,$
           p_lon, p_lat, p_vert, p_time,$
           sound_speed,$
           var_grid_name, var_grid_size,$
           var_lon, var_lat, var_vert, var_time,$
           R, p0, kappa, lid_height, $
           verbose=verbose
  ; Now read in the horizontal speed, again on p-grid
  ; so safe to use the cvar routine
  cvar_horizspeed, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   variable_out,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   verbose=verbose
  ; Now calculate the mach number
  variable_out(*,*,*,*)=variable_out(*,*,*,*)/$
                        sound_speed(*,*,*,*)
  sound_speed=0
end
   

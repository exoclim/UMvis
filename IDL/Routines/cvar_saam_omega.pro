pro cvar_saam_omega, fname, netcdf_var_names, $
                     p_array, psurf_array,$
                     p_grid_name, p_grid_size,$
                     p_lon, p_lat, p_vert, p_time,$
                     variable_out,$
                     var_grid_name, var_grid_size,$
                     var_lon, var_lat, var_vert, var_time,$
                     planet_radius, pi, omega, eqn_type=eqn_type,$
                     which_var, $
                     verbose=verbose
  ; Routine to construct the Specific Axial Angular Momentum
  ; Of only the planetary component
  ; Read in density
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; Fake a zonal velocity of 0.0
  u_vel_press=density
  u_vel_press(*,*,*,*)=0.0
  which_type='SAAM_Omega'
  variable_out=calc_zon_ang_mmtm(density, u_vel_press,$
                                 planet_radius, $
                                 var_vert,$
                                 var_lat, $
                                 pi, omega, $
                                 which_type, $
                                 eqn_type=eqn_type)
  density=0
  u_vel_press=0
end

pro cvar_tau_rad_adv, fname, netcdf_var_names, $
                      p_array, psurf_array,$
                     p_grid_name, p_grid_size,$
                     p_lon, p_lat, p_vert, p_time,$
                     variable_out,$
                     var_grid_name, var_grid_size,$
                     var_lon, var_lat, var_vert, var_time,$
                     planet_radius, pi, setup, $
                     verbose=verbose
  ; This constructs the ratio of advective to radiative
  ; timescale
  ; Construct Newtonian radiuative timescale
  cvar_tau_rad_newtonian, fname, netcdf_var_names, $
                          p_array, psurf_array,$
                          p_grid_name, p_grid_size,$
                          p_lon, p_lat, p_vert, p_time,$
                          tau_rad,$
                          var_grid_name, var_grid_size, $
                          var_lon, var_lat, var_vert, var_time,$
                          setup,$
                          verbose=verbose
  ; Constuct the advective timescale (zonal)
  cvar_adv_tau_zon, fname, netcdf_var_names, $
                    p_array, psurf_array,$
                    p_grid_name, p_grid_size,$
                    p_lon, p_lat, p_vert, p_time,$
                    tau_adv_zon,$
                    var_grid_name, var_grid_size,$
                    var_lon, var_lat, var_vert, var_time,$
                    planet_radius, pi,$
                    verbose=verbose
  ; Neither routines alter the grid from the p-grid
  ; Now take ratio
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=tau_rad(*,*,*,*)/$
                  tau_adv_zon(*,*,*,*)
  tau_rad=0
  tau_adv_zon=0
end

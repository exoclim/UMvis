pro cvar_adv_tau_zon, fname, netcdf_var_names, $
                      p_array, psurf_array,$
                      p_grid_name, p_grid_size,$
                      p_lon, p_lat, p_vert, p_time,$
                      variable_out,$
                      var_grid_name, var_grid_size,$
                      var_lon, var_lat, var_vert, var_time,$
                      planet_radius, pi,$
                      verbose=verbose
  ; This is the reciprocal of the  
  ; timescale for the zonal wind
  ; to circulate the planet
  ; Calculate the timescale
  cvar_adv_tau_zon, fname, netcdf_var_names, $
                    p_array, psurf_array,$
                    p_grid_name, p_grid_size,$
                    p_lon, p_lat, p_vert, p_time,$
                    variable_out,$
                    var_grid_name, var_grid_size,$
                    var_lon, var_lat, var_vert, var_time,$
                    planet_radius, pi,$
                    verbose=verbose
  ; Take reciprocal
  variable_out(*,*,*,*)=1.0/variable_out(*,*,*,*)
end

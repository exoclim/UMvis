pro cvar_mass, fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               variable_out,$
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               planet_radius, pi,$
               verbose=verbose
  ; First read in the density
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; To correctly calculate mass we need the theta levels
  target_var='Theta'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  theta_vert=get_variable_grid(fname, ncdf_name, 2, $
                              verbose=verbose)
  variable_out=calc_mass_atm(density, pi, planet_radius,$
                             var_lon,$
                             var_lat,$
                             theta_vert)
  density=0
  theta_vert=0
end

pro cvar_mass_flux_vert, fname, netcdf_var_names, $
                         p_array, psurf_array,$
                         p_grid_name, p_grid_size,$
                         p_lon, p_lat, p_vert, p_time,$
                         variable_out,$
                         var_grid_name, var_grid_size,$
                         var_lon, var_lat, var_vert, var_time,$
                         planet_radius, lid_height, $
                         verbose=verbose
  ; Routine to calculate the vertical mass flux
  ; Done using density, i.e. density*wvel
  ; Need W on pressure grid
  ; Read in vertical velocity
  target_var='Wvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, w_vel
  ; Read in the vertical grid
  w_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
  ; Need vertical velocity on pressure points
  w_vel_press=interp_height_um_std(w_vel, w_vert, var_vert, $
                                   lid_height)
  w_vel=0
  ; Get density, on p-grid again
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=density(*,*,*,*)*$
                        w_vel_press(*,*,*,*)
  density=0
  w_vel_press=0
end

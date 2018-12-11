pro cvar_mass_flux_zon, fname, netcdf_var_names, $
                        p_array, psurf_array,$
                         p_grid_name, p_grid_size,$
                         p_lon, p_lat, p_vert, p_time,$
                         variable_out,$
                         var_grid_name, var_grid_size,$
                         var_lon, var_lat, var_vert, var_time,$
                         planet_radius,$
                         verbose=verbose
  ; Routine to calculate the zonal mass flux
  ; Done using density, i.e. density*uvel
  ; Need u on pressure grid
  ; Read in zonal velocity
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, u_vel
  ; Read in the longitude grid
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  ; Need zonal velocity on pressure points
  u_vel_press=interp_longitude_um_std(u_vel, u_lon, var_lon)
  u_vel=0
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
                        u_vel_press(*,*,*,*)
  density=0
  u_vel_press=0
end

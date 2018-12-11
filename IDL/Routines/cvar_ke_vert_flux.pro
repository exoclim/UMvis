pro cvar_ke_vert_flux, fname, netcdf_var_names, $
                       p_array, psurf_array,$
                       p_grid_name, p_grid_size,$
                       p_lon, p_lat, p_vert, p_time,$
                       variable_out,$
                       var_grid_name, var_grid_size,$
                       var_lon, var_lat, var_vert, var_time,$
                       planet_radius, pi, lid_height,$
                       verbose=verbose
  ; Calculating kinetic energy flux in the vertical direction
  ; Flux is in density, but total KE.
  ; i.e 0.5*rho*v^2 * w
  ; We basically construct the KE, in rho instead of mass
  ; I guess this is called the specific KE, then mulitply 
  ; by vertical velocity

  ; First get horizontal speed.
  ; Interpolated onto p-grid.
  cvar_horizspeed, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   horizspeed,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   verbose=verbose
  ; Read in vertical velocity
  target_var='Wvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, w_vel
  ; Read in the vertical grid
  w_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
  ; Then calculate the total speed
  ; Need vertical velocity on pressure points
  w_vel_press=interp_height_um_std(w_vel, w_vert, var_vert, $
                                   lid_height)
  w_vel=0
  total_speed=safe_alloc_arr(4, var_grid_size, /float_arr)
  total_speed(*,*,*,*)=SQRT((horizspeed(*,*,*,*)^2.0)+$
                            (w_vel_press(*,*,*,*)^2.0))
  w_vel_press=0
  horizspeed=0
  ; Now read in density
  ; p-grid so no change
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius, verbose=verbose
  ; Initialise the output
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=0.5*$
                        density(*,*,*,*)*($
                        total_speed(*,*,*,*)^2.0)*$
                        w_vel_press(*,*,*,*)
  density=0
  total_speed=0
  w_vel_press=0
end

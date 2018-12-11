pro cvar_ke, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             variable_out,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, pi, lid_height, $
             verbose=verbose
  ; Routine to construct Kinetic Energy
  ; We calculate the total velocity
  ; by first getting the horizontal speed
  ; than adding the vertical in quadrature.
  ; This is done to save memory.
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
  ; Need vertical velocity on pressure points
  w_vel_press=interp_height_um_std(w_vel, w_vert, var_vert, $
                                   lid_height)
  w_vel=0
  total_speed=safe_alloc_arr(4, var_grid_size, /float_arr)
  total_speed(*,*,*,*)=SQRT((horizspeed(*,*,*,*)^2.0)+$
                            (w_vel_press(*,*,*,*)^2.0))
  w_vel_press=0
  horizspeed=0
  ; Now to create KE, we need Mass
  ; again on p-grid
  cvar_mass, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             mass,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, pi,$
             verbose=verbose
  ; Initialise the output
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=0.5*$
                        mass(*,*,*,*)*($
                        total_speed(*,*,*,*)^2.0)
  mass=0
  total_speed=0
end

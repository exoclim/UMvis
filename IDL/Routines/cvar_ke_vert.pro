pro cvar_ke_vert, fname, netcdf_var_names, $
                  p_array, psurf_array,$
                  p_grid_name, p_grid_size,$
                  p_lon, p_lat, p_vert, p_time,$
                  variable_out,$
                  var_grid_name, var_grid_size,$
                  var_lon, var_lat, var_vert, var_time,$
                  planet_radius, pi, lid_height, $
                  verbose=verbose
  ; KE of vertical component
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
  ; Now the mass
  cvar_mass, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             mass,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, pi,$
             verbose=verbose
  ; Initialise output
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; Calculate vertical KE
  variable_out(*,*,*,*)=0.5*$
                        mass(*,*,*,*)*($
                        w_vel_press(*,*,*,*)^2.0)
  mass=0
  w_vel_press=0
end

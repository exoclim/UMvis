pro cvar_diff_stream, fname, netcdf_var_names, $
                      p_array, psurf_array,$
                      p_grid_name, p_grid_size,$
                      p_lon, p_lat, p_vert, p_time,$
                      variable_out,$
                      var_grid_name, var_grid_size,$
                      var_lon, var_lat, var_vert, var_time,$
                      planet_radius, pi, min_val, eqn_type=eqn_type,$
                      verbose=verbose
  ; This calculates the difference stream function
  ; of Hardiman et al (2010)
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; Require, vertical and meridional wind and theta
  target_var='Vvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
   read_netcdf_variable_grid, fname, ncdf_name, v_vel
  v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)
  ; Interpolate v onto latitude pressure
  v_press=interp_latitude_um_std(v_vel, v_lat, p_lat)
  v_vel=0
  v_lat=0
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
  w_vert=0
  ; Finally, theta
  target_var='Theta'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
   read_netcdf_variable_only,fname, ncdf_name, theta
  ; Read in the vertical grid
  theta_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
  ; Need vertical velocity on pressure points
  theta_press=interp_height_um_std(theta, theta_vert, var_vert, $
                                   lid_height)
  theta=0
  theta_vert=0
  variable_out=calc_diff_stream(planet_radius,$
                                var_grid_size(0), var_lon,$
                                var_grid_size(1), var_lat,$
                                var_grid_size(2), var_vert,$
                                var_grid_size(3), var_time,$
                                density,$
                                v_vel_press, w_vel_press,$
                                theta_press,$
                                eqn_type=eqn_type, min_val, pi)
  density=0
  v_vel_press=0
  w_vel_press=0
  theta_press=0
end

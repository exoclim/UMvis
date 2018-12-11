pro cvar_eke, fname, netcdf_var_names, $
              p_array, psurf_array,$
              p_grid_name, p_grid_size,$
              p_lon, p_lat, p_vert, p_time,$
              variable_out,$
              var_grid_name, var_grid_size,$
              var_lon, var_lat, var_vert, var_time,$
              min_val,$
              verbose=verbose
  ; Routine to construct the Eddy Kinetic Energy
  ; KE=0.5*(u'^2+v'^2)
  ; Where u'=u-mean(u), where mean() is a zonal and temporal mean
  ; Require U and V vel, on p-grid
  ; and u_lon and v_lat, as they differ from p_grid
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid, fname, ncdf_name, u_vel
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  u_press=interp_longitude_um_std(u_vel, u_lon, p_lon)
  u_vel=0
  u_lon=0
  target_var='Vvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid, fname, ncdf_name, v_vel
  v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)
  v_press=interp_latitude_um_std(v_vel, v_lat, p_lat)
  v_vel=0
  v_lat=0
  ; Now we call routine to calculate EKE
  variable_out=calc_eke(u_press, v_press, min_val)
  u_press=0
  v_press=0
end

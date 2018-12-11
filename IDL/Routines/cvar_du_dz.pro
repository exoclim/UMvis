pro cvar_du_dz, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                variable_out,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                verbose=verbose
  ; Vertical shear in u, on p-grid except longitude
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid,fname, ncdf_name, u_vel, $
                            var_grid_name, var_grid_size
  ; Read in the longitude grid
  lon=get_variable_grid(fname, ncdf_name, 0, $
                        verbose=verbose)
  var_lon=lon
  lon=0
  ; Now caculate shear
  variable_out=calc_vert_shear(u_vel, var_vert)
  u_vel=0
end

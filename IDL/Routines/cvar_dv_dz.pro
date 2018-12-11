pro cvar_dv_dz, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                variable_out,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                verbose=verbose
  ; Vertical shear in v, on p-grid except latitude
  target_var='Vvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid,fname, ncdf_name, v_vel, $
                            var_grid_name, var_grid_size
  lat=get_variable_grid(fname, ncdf_name, 1, $
                             verbose=verbose)
  var_lat=lat
  lat=0
  variable_out=calc_vert_shear(v_vel, var_vert)
  v_vel=0
end

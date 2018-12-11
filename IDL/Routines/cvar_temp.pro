pro cvar_temp, fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               variable_out,$
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               p0, kappa, lid_height, $
               verbose=verbose
  ; Temperature calculated from theta
  ; find the netcdf short name and read it in
  target_var='Theta'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, theta
  ; Theta is on theta levels, need for interpolation
  theta_vert=get_variable_grid(fname, ncdf_name, 2, $
                               verbose=verbose)
  ; Now interpolate theta onto the pressure grid
  theta_on_pressure=interp_height_um_std(theta, theta_vert, $
                                         p_vert, lid_height)
  theta=0
  theta_vert=0
  ; Now calculate temperature, T=Exner*theta
  ; Exner=(P/P0)^kappa
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=((p_array(*,*,*,*)/p0)^kappa)* $
                        theta_on_pressure(*,*,*,*)
  theta_on_pressure=0
  ; Finally replace the vertical axes information 
  ; as we have interpolated onto pressure surfaces
  var_grid_name(2)=p_grid_name(2)
  var_vert=p_vert
end

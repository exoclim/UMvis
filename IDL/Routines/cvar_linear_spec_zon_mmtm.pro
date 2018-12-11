pro cvar_linear_spec_zon_mmtm, fname, netcdf_var_names, $
                               p_array, psurf_array,$
                               p_grid_name, p_grid_size,$
                               p_lon, p_lat, p_vert, p_time,$
                               variable_out,$
                               var_grid_name, var_grid_size,$
                               var_lon, var_lat, var_vert, var_time,$
                               planet_radius, verbose=verbose
  ; Construct the linear specific zonal mmtm
  ; Read in density
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density, $
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; on p-grid so OK
  ; Now require zonal wind on p-grid
  ; Need to read in U and V
  ; and u_lon and v_lat, as they differ from p_grid
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only, fname, ncdf_name, u_vel
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  ; Interpolate u onto longitude pressure
  u_press=interp_longitude_um_std(u_vel, u_lon, p_lon)
  u_vel=0
  u_lon=0
  ; Specific, zonal linear mmtm is then just density*u
  variable_out=alloc_multiply_4d_float(density, u_press, $
                                       var_grid_size)
  density=0
  u_press=0
end

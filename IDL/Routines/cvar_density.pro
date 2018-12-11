pro cvar_density, fname, netcdf_var_names, $
                  p_array, psurf_array,$
                  p_grid_name, p_grid_size,$
                  p_lon, p_lat, p_vert, p_time, $
                  variable_out,$
                  var_grid_name, var_grid_size,$
                  var_lon, var_lat, var_vert, var_time,$
                  planet_radius,$
                  verbose=verbose

  ; Read in UM density, which is rho*r^2 (r=R+z_rho)
  target_var='density_r_sqrd'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, um_dense
  ; Convert to real density, grids are the same
  variable_out=calc_density(um_dense, var_vert, planet_radius)
  um_dense=0
end

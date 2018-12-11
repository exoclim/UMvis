pro cvar_hydrostasy, fname, netcdf_var_names, $
                     p_array, psurf_array,$
                     p_grid_name, p_grid_size,$
                     p_lon, p_lat, p_vert, p_time,$
                     variable_out,$
                     var_grid_name, var_grid_size, $
                     var_lon, var_lat, var_vert, var_time,$
                     lid_height, $
                     grav_surf, $
                     planet_radius, $
                     eqn_type=eqn_type, grav_type=grav_type,$
                     verbose=verbose
  ; This calculates dp/dr+g*rho, which for hydrostatic
  ; balance should equal zero
  ; We have pressure, gravity, height but need density.
  ; Read in UM density, which is rho*r^2 (r=R+z_rho)
  target_var='density_r_sqrd'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, um_dense
  ; Convert to real density, grids are the same
  density=calc_density(um_dense, var_vert, planet_radius)
  um_dense=0
  ; Now calculate departure from hydrostasy
  ; Called with 'Height' vertical type as 
  ; we are calculating it in height (even if we map to pressure later)
  variable_out=calc_hydrostasy('Height', $
                               p_array, p_vert, density, grav_surf, $
                               planet_radius, $
                               eqn_type=eqn_type, grav_type=grav_type,$
                               verbose=verbose)
  density=0
end

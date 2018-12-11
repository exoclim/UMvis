pro cvar_saam, fname, netcdf_var_names, $
               p_array, psurf_array,$
              p_grid_name, p_grid_size,$
              p_lon, p_lat, p_vert, p_time,$
              variable_out,$
              var_grid_name, var_grid_size,$
              var_lon, var_lat, var_vert, var_time,$
              planet_radius, pi, omega, eqn_type=eqn_type,$
              which_var, $
              verbose=verbose
  ; Routine to construct the Specific Axial Angular Momentum
  ; Read in density
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; Read in zonal velocity
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, u_vel
  ; Read in the longitude grid
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  ; Need zonal velocity on pressure points
  u_vel_press=interp_longitude_um_std(u_vel, u_lon, var_lon)
  u_vel=0
  which_type='SAAM'
  variable_out=calc_zon_ang_mmtm(density, u_vel_press,$
                                 planet_radius, $
                                 var_vert,$
                                 var_lat, $
                                 pi, omega, $
                                 which_type, $
                                 eqn_type=eqn_type)
  density=0
  u_vel_press=0
end

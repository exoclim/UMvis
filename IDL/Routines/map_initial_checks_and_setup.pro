pro map_initial_checks_and_setup, nvars, which_var_arr, $
                                  vert_type, $
                                  netcdf_um_in=netcdf_um_in, $
                                  netcdf2_um_in=netcdf2_um_in, $
                                  planet_setup_in=planet_setup_in, $
                                  mapped_fname_in=mapped_fname_in, $
                                  map_grid_use_in=map_grid_use_in, $
                                  map_limits_in=map_limits_in, $
                                  map_grid_use, map_limits, $
                                  cp_ovrd=cp_ovrd, R_ovrd=R_ovrd,$
                                  planet_radius_ovrd=planet_radius_ovrd, $
                                  p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd,$
                                  grav_surf_ovrd=grav_surf_ovrd, $
                                  timestep_ovrd=timestep_ovrd, $
                                  lid_height_ovrd=lid_height_ovrd, $
                                  pi, R, cp, kappa, planet_radius, p0, $
                                  omega, grav_surf, timestep, lid_height, $
                                  min_val, $         
                                  netcdf_um_fname, $
                                  netcdf_um_fname_2, $
                                  mapped_fname, $
                                  planet_setup, $
                                  verbose=verbose
  ; This procedure performs:
  ; (1) Basic checks of the consistency of inputs
  ; (2) Sets the number of variables required to
  ; construct the requested plots
  ; (3) Sets up the planetary constants

  ; Perform a few consistency checks
  ; If we are going from a previously saved
  ; map file then we don not need these checks
  check_map_req, vert_type, $
                 map_grid_use_in=map_grid_use_in, $
                 map_limits_in=map_limits_in, $
                 map_grid_use, map_limits, $
                 planet_setup_in=planet_setup_in, $
                 planet_setup, $
                 netcdf_um_in=netcdf_um_in, $
                 netcdf2_um_in=netcdf2_um_in, $
                 netcdf_um_fname, $
                 netcdf_um_fname_2, $
                 verbose=verbose

  ; Now setup the basic planetary environment parameters/constants
  set_planetary_constants, netcdf_um_fname, $
                           planet_setup, $
                           cp_ovrd=cp_ovrd, R_ovrd=R_ovrd,$
                           planet_radius_ovrd=planet_radius_ovrd, $
                           p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
                           grav_surf_ovrd=grav_surf_ovrd, $
                           timestep_ovrd=timestep_ovrd, $
                           lid_height_ovrd=lid_height_ovrd, $
                           netcdf_name_ovrd=netcdf_name_ovrd, $
                           pi, R, cp, kappa, planet_radius, p0, $
                           omega, grav_surf, timestep, lid_height, $
                           min_val, $         
                           verbose=verbose
  ; Finally construct, if required the name to save the mapped output
  mapped_fname=set_mapped_fname(planet_setup, $
                                nvars, which_var_arr, $
                                vert_type, map_grid_use, map_limits, $
                                mapped_fname_in=mapped_fname_in, $
                                verbose=verbose)
end

pro create_variables_from_mapped, variable_list, $
                                  nvars, which_var_arr, $
                                  vert_type, $
                                  mapped_fname_in=mapped_fname_in, $
                                  map_grid_use_in=map_grid_use_in, $
                                  map_limits_in=map_limits_in, $
                                  planet_setup_in=planet_setup_in, $
                                  cp_ovrd=cp_ovrd, R_ovrd=R_ovrd,$
                                  planet_radius_ovrd=planet_radius_ovrd, $
                                  p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd,$
                                  grav_surf_ovrd=grav_surf_ovrd, $
                                  timestep_ovrd=timestep_ovrd, $
                                  lid_height_ovrd=lid_height_ovrd, $
                                  np_levels_ovrd=np_levels_ovrd, $
                                  grav_type=grav_type, eqn_type=eqn_type, $
                                  meri_mean_pt=meri_mean_pt, $
                                  pi, R, cp, kappa, planet_radius, p0, $
                                  omega, grav_surf, timestep, lid_height, $
                                  min_val, $         
                                  mapped_fname, $
                                  planet_setup, $
                                  var_combined, grid_size_combined,$
                                  lon_combined, lat_combined, $
                                  vert_combined, $
                                  time_combined, $
                                  var_vert_bounds_combined, $
                                  verbose=verbose
  ; This routine deals with constructing variables from a previously
  ; mapped output.
  ; First we set the filename of the mapped data
  if (KEYWORD_SET(mapped_fname_in)) then begin
     ; Set it to the input value
     mapped_fname=mapped_fname_in
  endif else begin
     ; **WORK WHAT ABOUT AUTOMATED NAMES?***
     print, '*****************************************************'
     print, 'When preparing a plot from a mapped input'
     print, 'the filename must be specified using mapped_fname_in'
     print, 'Stopping in create_variables_from_mapped.pro'
     print, '*****************************************************'
     stop
  endelse
  ; Now we compared with the input/ovrd selections to check for 
  ; inconsistencies.
  check_map_restore_input, mapped_fname, $
                           vert_type, $
                           nvars_map, which_var_arr_map, $
                           planet_setup_in=planet_setup_in, $
                           cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, $
                           planet_radius_ovrd=planet_radius_ovrd, $
                           p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
                           grav_surf_ovrd=grav_surf_ovrd, $
                           timestep_ovrd=timestep_ovrd, $
                           lid_height_ovrd=lid_height_ovrd, $
                           np_levels_ovrd=np_levels_ovrd, $
                           pi, R, cp, kappa, planet_radius, p0, $
                           omega, grav_surf, timestep, lid_height, $
                           min_val, $         
                           planet_setup, $
                           var_combined, grid_size_combined, $
                           lon_combined, lat_combined, vert_combined, $
                           time_combined, $
                           var_vert_bounds_combined, $
                           verbose=verbose
  ; Now construct the required variables themselves.
  ; The variables available are placed in nvars_map and which_var_arr_map
  ; We then leave the ones constructed in nvars_which_var_arr
  check_map_to_plot_var_list, variable_list, $
                              nvars_map, which_var_arr_map, $
                              var_combined, $
                              grid_size_combined, $
                              lon_combined, lat_combined, $
                              vert_combined, time_combined, $
                              var_vert_bounds_combined, $
                              nvars, which_var_arr, vert_type, $
                              pi, R, cp, kappa, planet_radius, p0, $
                              omega, grav_surf, timestep, lid_height, $
                              min_val, $
                              grav_type=grav_type, eqn_type=eqn_type, $
                              meri_mean_pt=meri_mean_pt, $
                              verbose=verbose
  ; Now we have the output stored in the variables
  ; var_combined, grid_size_combined, lon_combined, lat_combined,
  ; vert_combined, time_combined, var_vert_bounds_combined.
  ; as well as the constants etc.
end

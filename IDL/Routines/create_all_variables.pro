pro create_all_variables, variable_list, $
                          vert_type, $
                          netcdf_var_names, $
                          netcdf_um_in=netcdf_um_in, $
                          netcdf2_um_in=netcdf2_um_in, $
                          planet_setup_in=planet_setup_in, $
                          mapped_fname_in=mapped_fname_in, $
                          map_grid_use_in=map_grid_use_in, $
                          map_limits_in=map_limits_in, $
                          cp_ovrd=cp_ovrd, R_ovrd=R_ovrd,$
                          planet_radius_ovrd=planet_radius_ovrd, $
                          p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd,$
                          grav_surf_ovrd=grav_surf_ovrd, $
                          timestep_ovrd=timestep_ovrd, $
                          lid_height_ovrd=lid_height_ovrd, $
                          np_levels_ovrd=np_levels_ovrd, $
                          grav_type=grav_type, eqn_type=eqn_type, $
                          meri_mean_pt=meri_mean_pt, $
                          from_map_save=from_map_save,$
                          scratch_map_vars=scratch_map_vars, $
                          remapped_fname=remapped_fname, $
                          pi, R, cp, kappa, planet_radius, p0, $
                          omega, grav_surf, timestep, lid_height, $
                          min_val, $         
                          mapped_fname, $
                          planet_setup, $
                          nvars, which_var_arr, $
                          var_combined, grid_size_combined,$
                          lon_combined, lat_combined, vert_combined, $
                          time_combined, $
                          var_vert_bounds_combined, $
                          verbose=verbose
  ; Things are done slightly differently if we are restoring
  ; a mapped file or performing mapping and construction from scratch
  if (not (KEYWORD_SET(from_map_save))) then begin
     ; Constructing/mapping from a raw UM output
     create_variables_from_um_output, variable_list, $
                                      nvars, which_var_arr, $
                                      vert_type, $
                                      netcdf_var_names, $
                                      netcdf_um_in=netcdf_um_in, $
                                      netcdf2_um_in=netcdf2_um_in, $
                                      planet_setup_in=planet_setup_in, $
                                      mapped_fname_in=mapped_fname_in, $
                                      map_grid_use_in=map_grid_use_in, $
                                      map_limits_in=map_limits_in, $
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
     ; Now save it if requested
     if (KEYWORD_SET(scratch_map_vars)) then begin
        print, 'WARNING: Not saving mapped variables'
     endif else begin
        restore_and_save_mapped, 'save', $   
                                 mapped_fname, $
                                 var_combined, grid_size_combined, $
                                 lon_combined, lat_combined, vert_combined, $
                                 time_combined, $
                                 var_vert_bounds_combined, $
                                 nvars, which_var_arr, vert_type, $
                                 pi, R, cp, kappa, planet_radius, p0, $
                                 omega, grav_surf, timestep, lid_height, $
                                 min_val, $
                                 planet_setup, $
                                 verbose=verbose
     endelse
  endif else begin
     ; Restoring/construction from a mapped input
     create_variables_from_mapped, variable_list, $
                                   nvars, which_var_arr, $
                                   vert_type, $
                                   planet_setup_in=planet_setup_in, $
                                   mapped_fname_in=mapped_fname_in, $
                                   map_grid_use_in=map_grid_use_in, $
                                   map_limits_in=map_limits_in, $
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
     ; In some cases we might want to save the output here
     ; for example, perhaps we constructed a new variable from
     ; the mapped set, and now want to save that.
     if (KEYWORD_SET(remapped_fname)) then begin
        restore_and_save_mapped, 'save', $   
                                 remapped_fname, $
                                 var_combined, grid_size_combined, $
                                 lon_combined, lat_combined, vert_combined, $
                                 time_combined, $
                                 var_vert_bounds_combined, $
                                 nvars, which_var_arr, vert_type, $
                                 pi, R, cp, kappa, planet_radius, p0, $
                                 omega, grav_surf, timestep, lid_height, $
                                 min_val, $
                                 planet_setup, $
                                 verbose=verbose
     endif
  endelse
  ; Now we have constructed or restored an array holding all the
  ; variables we required:
  ; var_combined(which_var_arr,lon_combined, 
  ; lat_combined, vert_combined, time_combined)
  ; Grid size: grid_size_combined
end

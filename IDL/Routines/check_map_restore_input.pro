pro check_map_restore_input, mapped_fname, $
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
  ; This routine restores the mapped file and checks the consistency
  ; of the requested and restored values.
  ; First save the requested vert_type to make sure it matches
  vert_type_req=vert_type
  vert_type=0

  ; Now restore the data in the mapped file
  restore_and_save_mapped, 'restore', $
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
  ; Save the nvars and which_Var_arrs into _map versions
  nvars_map=nvars
  nvars=0
  which_var_arr_map=which_var_arr
  which_var_arr=0
  ; Now we compare the basic overides and setups with the values to
  ; check if things are consistent.
  check_restore_basic, vert_type_req, $
                       vert_type, $
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
                       verbose=verbose
  ; If we get here the values are all consistent so we can drop the 
  ; _in or _ovrd versions and we are left with the restored data
  ; and the requested plot (nvars_req, which_var_arr_req).
end

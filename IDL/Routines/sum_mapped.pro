pro sum_mapped, mapped_fname_one, mapped_fname_two, diff_output, verbose=verbose
  ; This routine restores two mapped files, and adds them
  ; saving the output. This only currently works for variables
  ; on matching grids etc. **WORK** Alter this. 

  if (KEYWORD_SET(verbose)) then begin
     print, 'Restoring Saved File One:', mapped_fname_one
  endif
  restore_and_save_mapped, 'restore', $   
                           mapped_fname_one, $
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
  if (KEYWORD_SET(verbose)) then begin
     print, 'Restoring Saved File Two:', mapped_fname_two
  endif
  restore_and_save_mapped, 'restore', $   
                           mapped_fname_two, $
                           var_combined_two, grid_size_combined_two, $
                           lon_combined_two, lat_combined_two, $
                           vert_combined_two, $
                           time_combined_two, $
                           var_vert_bounds_combined_two, $
                           nvars_two, which_var_arr_two, vert_type_two, $
                           pi_two, R_two, cp_two, kappa_two, $
                           planet_radius_two, p0_two, $
                           omega_two, grav_surf_two, timestep_two, $
                           lid_height_two, $
                           min_val_two, $
                           planet_setup_two, $
                           verbose=verbose
; Quick check as everything should match in terms of grids, constants
; etc.
  if not(array_equal(grid_size_combined_two, grid_size_combined)) then begin
     print, 'Mismatch in grid_size arrays'
     stop
  endif      
  if not(array_equal(lon_combined_two, lon_combined)) then begin
     print, 'Mismatch in longitude arrays'
     stop
  endif      
  if not(array_equal(lat_combined_two, lat_combined)) then begin
     print, 'Mismatch in latitude arrays'
     stop
  endif      
  if not(array_equal(vert_combined_two, vert_combined)) then begin
     print, 'Mismatch in vertical arrays'
     stop
  endif      
  if not(array_equal(time_combined_two, time_combined)) then begin
     print, 'Mismatch in time arrays'
     stop
  endif      
  
  if (nvars_two ne nvars or $
      vert_type_two ne vert_type or $
      pi_two ne pi or $
      R_two ne R or $
      cp_two ne cp or $
      kappa_two ne kappa or $
      planet_radius_two ne planet_radius or $
      p0_two ne p0 or $
      omega_two ne omega or $
      grav_surf_two ne grav_surf or $
      timestep_two ne timestep or $
      lid_height_two ne lid_height or $
      min_val_two ne min_val or $
      planet_setup_two ne planet_setup) then begin
     print, 'Error setup does not match!'
     print, 'Dump for map one:', mapped_fname_one
     print, nvars,  vert_type, $
            pi, R, cp, kappa, planet_radius, p0, $
            omega, grav_surf, timestep, lid_height, $
            min_val, $
            planet_setup
     print, 'Dump for map two:', mapped_fname_two
     print, nvars_two, vert_type_two, $
            pi_two, R_two, cp_two, kappa_two, $
            planet_radius_two, p0_two, $
            omega_two, grav_surf_two, timestep_two, $
            lid_height_two, $
            min_val_two, $
            planet_setup_two   
     stop
  endif else begin
     ; Otherwise we can go ahead and diff
     var_combined=var_combined+var_combined_two
     which_var_arr=which_var_arr+'+'+which_var_arr_two
     print, 'Constructed:', which_var_arr
     print, 'Saving to:', diff_output
     restore_and_save_mapped, 'save', $   
                              diff_output, $
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
end

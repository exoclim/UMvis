pro restore_and_save_mapped, which_action, $
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
  ; Depnedant on "which_action" this routine:
  ; "restore": restores from a file 
  ; "save": saves values to a file
  ; It is done in a combined routine to aid coherence about what
  ; is needed on the restore/save argument lists
  if (which_action eq 'save') then begin
     if (KEYWORD_SET(verbose)) then print, 'Saving file:', mapped_fname
     save, var_combined, grid_size_combined, $
           lon_combined, lat_combined, vert_combined, $
           time_combined, $
           var_vert_bounds_combined, $
           nvars, which_var_arr, vert_type, $
           planet_setup, $
           pi, R, cp, kappa, planet_radius, p0, $
           omega, grav_surf, timestep, lid_height, $
           min_val, $        
           verbose=verbose, $
           filename=mapped_fname
  endif else if (which_action eq 'restore') then begin
     if (KEYWORD_SET(verbose)) then print, 'Restoring file:', mapped_fname
     restore, mapped_fname
  endif else begin
     print, 'Action:', which_action
     print, 'not recognised in restore_and_save_netcdf'
     stop
  endelse
end

pro diff_mapped, mapped_fname_one, mapped_fname_two, diff_output, $
                 interpolate=interpolate, rename=rename, verbose=verbose
  ; This routine restores two mapped files, and diffs them
  ; saving the output.
  ; In the sense: mapped_fname_one-mapped_fname_two
  ; The interpolate key word, allows the code to interpolate
  ; When the grid structure does not match. The results are all
  ; interpolated on to the grid from the mapped_fname_one
  ; The rename variable is set if the new variables should be
  ; named var-var etc
  ; **WORK** Should be absorbed into um_plot.pro at some point
  ; **WORK** not written efficientl!y!
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
; etc. Or be interpolated. 
  if not(array_equal(grid_size_combined_two, grid_size_combined)) then begin
     print, 'Mismatch in grid_size arrays'
     if (KEYWORD_SET(verbose)) then begin
        print, grid_size_combined
        print, grid_size_combined_two 
     endif
     if (KEYWORD_SET(interpolate)) then begin
        print, 'Interpolating mi-matching grids'
     endif else begin
        stop
     endelse
  endif      
  if not(array_equal(lon_combined_two, lon_combined)) then begin
     print, 'Mismatch in longitude arrays'
     if (KEYWORD_SET(verbose)) then begin
        print, lon_combined
        print, lon_combined_two 
     endif
     if (KEYWORD_SET(interpolate)) then begin
        ; Interpolate the second variable array onto the 
        ; onto the longitude axis of the first
        ; Loop over all variables
        for ivar=0, nvars-1 do begin
           ; Create 4d array for interp routine
           var_combined_small=safe_alloc_arr(4, grid_size_combined_two, /float_arr)
           var_combined_small(*,*,*,*)=var_combined_two(ivar,*,*,*,*)
           var_interp_lon=interp_longitude_um_std($
                          var_combined_small, lon_combined_two, lon_combined)
           ; place back in the main array
           var_combined_small=0
           var_combined_two(ivar,*,*,*,*)=var_interp_lon(*,*,*,*)
           var_interp_lon=0
        endfor
        lon_combined_two=lon_combined
        grid_size_combined_two(0)=grid_size_combined(0)
     endif else begin
        stop
     endelse
  endif      
  if not(array_equal(lat_combined_two, lat_combined)) then begin
     print, 'Mismatch in latitude arrays'
     if (KEYWORD_SET(verbose)) then begin
        print, lat_combined
        print, lat_combined_two 
     endif
     if (KEYWORD_SET(interpolate)) then begin
        ; Interpolate the second variable array onto the 
        ; onto the latitude axis of the first
        for ivar=0, nvars-1 do begin
           ; Create 4d array for interp routine
           var_combined_small=safe_alloc_arr(4, grid_size_combined_two, /float_arr)
           var_combined_small(*,*,*,*)=var_combined_two(ivar,*,*,*,*)
           var_interp_lat=interp_latitude_um_std($
                          var_combined_small, lat_combined_two, lat_combined)
           ; place back in the main array
           var_combined_small=0
           var_combined_two(ivar,*,*,*,*)=var_interp_lat(*,*,*,*)
           var_interp_lat=0
        endfor
        lat_combined_two=lat_combined
        grid_size_combined_two(1)=grid_size_combined(1)
     endif else begin
        stop
     endelse
  endif      
  if not(array_equal(vert_combined_two, vert_combined)) then begin
     print, 'Mismatch in vertical arrays'
     if (KEYWORD_SET(verbose)) then begin
        print, vert_combined
        print, vert_combined_two 
     endif
     if (KEYWORD_SET(interpolate)) then begin
        if (vert_type eq vert_type_two) then begin
           ; Interpolate the second variable array onto the 
           ; onto the vertical axis of the first
           for ivar=0, nvars-1 do begin
              ; Create 4d array for interp routine
              var_combined_small=safe_alloc_arr(4, grid_size_combined_two, /float_arr)
              var_combined_small(*,*,*,*)=var_combined_two(ivar,*,*,*,*)
              if (vert_type eq 'Height') then begin
                 var_interp_vert=interp_height_um_std($
                                 var_combined_small, vert_combined_two, $
                                 vert_combined, lid_height, $
                                 var_vert_bounds=var_vert_bounds_combined)
              endif else if (vert_type eq 'Pressure') then begin
                 var_interp_vert=interp_pressure_um_std($
                                 var_combined_small, vert_combined_two, $
                                 vert_combined, p0, $
                                 var_vert_bounds=var_vert_bounds_combined)
              endif else if (vert_type eq 'Sigma') then begin
                 print, 'Interpolation in Sigma coordinates not'
                 print, 'coded yet in diff_mapped.pro'
                 print, 'See pressure section and vertical_mapping.pro'
                 print, 'for guidance.'
                 stop              
              endif
              ; Now change vertical array no matter vert_type
              var_combined_small=0
              var_combined_two(ivar,*,*,*,*)=var_interp_vert(*,*,*,*)
              var_interp_vert=0
           endfor
           vert_combined_two=vert_combined
           grid_size_combined_two(2)=grid_size_combined(2)
        endif else begin
           print, 'Mis match in vertical types, cannot interpolate'
           print, vert_type, vert_type_two
           stop
        endelse
        ; Now must match lid heights
        lid_height_two=lid_height
     endif else begin
        print, 'Interpolation not selected'
        stop
     endelse     
  endif      
  if not(array_equal(time_combined_two, time_combined)) then begin
     print, 'Mismatch in time arrays'
     if (KEYWORD_SET(verbose)) then begin
        print, time_combined
        print, time_combined_two 
     endif
     if (KEYWORD_SET(interpolate)) then begin
        print, 'Time interpolation routine not written yet'
        print, 'diff_mapped.pro, copy interp_height_um_std.pro'
     endif else begin
        stop
     endelse
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
     print, '**************WARNING************************'
     print, 'setup does not match!'
     print, 'does a difference plot make sense?'
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
     print, '**************WARNING************************'
  endif
                                ; Otherwise we can go ahead and diff
     var_combined=var_combined-var_combined_two
     if (KEYWORD_SET(rename)) then begin
        which_var_arr=which_var_arr+'-'+which_var_arr_two
     endif
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
end

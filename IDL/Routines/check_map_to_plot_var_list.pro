pro check_map_to_plot_var_list, variable_list, $
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
  ; This routine works out which variables the user has requested in 
  ; variable list, and decides if they can be directly constructed
  ; or read from the mapped output.
  ; First we need to check if we can support the variables requested
  set_construct_details_map, variable_list, nvars, which_var_arr, $
                             nvars_map, which_var_arr_map, $
                             verbose=verbose

  ; This procedure checks to see if the variables requested
  ; are in the list which have been mapped, and if so
  ; replaces the old list with the new one.
  ; If they are not directly present, in then checks
  ; to see if they can be constructed from those present.
  ; The *-in variables are those requested, the normal names
  ; are those restored from the saved/mapped file.

  ; Then finally creates var_combined as a subset of the mapped 
  ; variables

  ; Save the restored values
  var_combined_full=var_combined
  var_combined=0
  var_vert_bounds_combined_full=var_vert_bounds_combined
  var_vert_bounds_combined=0

  ; Now create an output array for the variables requested
  arr_size=safe_alloc_arr(1, 5, /int_arr)
  arr_size(0)=nvars
  arr_size(1)=grid_size_combined(0)
  arr_size(2)=grid_size_combined(1)
  arr_size(3)=grid_size_combined(2)
  arr_size(4)=grid_size_combined(3)
  var_combined=safe_alloc_arr(5, arr_size, /float_arr)
  arr_size=0
  arr_size=safe_alloc_arr(1, 2, /int_arr)
  arr_size(0)=nvars
  arr_size(1)=2
  var_vert_bounds_combined=safe_alloc_arr(2, arr_size, /float_arr)

  ; Now we need to see if the variables required (which_var_arr)
  ; are available from the mapped set (which_var_arr_map), or if not
  ; whether they can be constructed from those present.
  ; Vectors are already split into components at this stage.
  ; Variables to keep track
  location=safe_alloc_arr(1, nvars, /int_arr)
  location(*)=-1
  count=0
  
  ; Now loop over each requested variable 
  for ivar=0, nvars-1 do begin
     ; Are they present?
     ; we need the search not to fail
     location(ivar)=find_string_in_arr(nvars_map, which_var_arr_map, $
                                       which_var_arr(ivar), /nofail)
     ; If it is found save it
     if (location(ivar) gt -1) then begin
        var_combined(count,*,*,*,*)=$
           var_combined_full(location(ivar),*,*,*,*)
        var_vert_bounds_combined(count,*)=$
           var_vert_bounds_combined_full(location(ivar),*)
        count=count+1
        if (KEYWORD_SET(verbose)) then begin
           print, 'Found requested variable: ', which_var_arr(ivar)
           print, 'In string: ', which_var_arr_map
           print, 'At location: ', location(ivar), ' ', $
                  which_var_arr_map(location(ivar))
        endif
     endif else begin
        ; Otherwise attempt to construct it, place
        ; the results in the next available position (count+1)
        construct_from_mapped, which_var_arr(ivar), $
                               var_combined_full, $
                               grid_size_combined, $
                               lon_combined, lat_combined, $
                               vert_combined, time_combined, $
                               var_vert_bounds_combined_full, $
                               nvars_map, which_var_arr_map, vert_type, $
                               pi, R, cp, kappa, planet_radius, p0, $
                               omega, grav_surf, timestep, lid_height, $
                               min_val, $
                               grav_type=grav_type, eqn_type=eqn_type, $
                               var_single, $
                               var_vert_bounds_single, $
                               verbose=verbose
        var_combined(count,*,*,*,*)=var_single(*,*,*,*)
        var_vert_bounds_combined(count,*)=var_vert_bounds_single(*)
        ; If we survive this routine, we have created
        ; the new variable, so change the tracking
        location(ivar)=count ; not really needed
        count=count+1              
     endelse
  endfor
  ; Now zero the unrequired arrays
  var_combined_full=0
  var_vert_bounds_combined_full=0
  location=0
end

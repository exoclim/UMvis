pro common_grid_vars, ivar, vert_type, $
                      which_var_arr ,$
                      var_array, var_grid_size, $
                      var_lon, var_lat, var_vert, var_time, $
                      var_vert_bounds, $
                      lid_height, min_val, $
                      var_combined, grid_size_combined, $
                      lon_combined, lat_combined, vert_combined, $
                      time_combined,$           
                      var_vert_bounds_combined, $                     
                      verbose=verbose
  ; This routine deals with putting all variables on
  ; a single grid
  ; **WORK** this is currently memory intensive
  ; Get the number of variables
  nvars=n_elements(which_var_arr)
  ; If we are only plotting one variable
  ; then we don't need to do any interpolation
  if (nvars eq 1) then begin
     if (KEYWORD_SET(verbose)) then begin
        print, 'No interpolation or combination of variables'
        print, 'comprising of:', which_var_arr
     endif
     arr_size=INTARR(5)
     arr_size(0)=1
     arr_size(1)=var_grid_size(0)
     arr_size(2)=var_grid_size(1)
     arr_size(3)=var_grid_size(2)
     arr_size(4)=var_grid_size(3)
     var_combined=safe_alloc_arr(5, arr_size, /float_arr)
     var_combined(0,*,*,*,*)=var_array(*,*,*,*)
     grid_size_combined=var_grid_size
     lon_combined=var_lon
     lat_combined=var_lat
     vert_combined=var_vert
     time_combined=var_time    
     var_vert_bounds_combined=var_vert_bounds
  endif else begin
     ; If this is the first variable, then 
     ; we initialise the massive output
     if (ivar eq 0) then begin
        arr_size=INTARR(5)
        arr_size(0)=1
        arr_size(1)=var_grid_size(0)
        arr_size(2)=var_grid_size(1)
        arr_size(3)=var_grid_size(2)
        arr_size(4)=var_grid_size(3)
        var_combined=safe_alloc_arr(5, arr_size, /float_arr)
        var_combined(0,*,*,*,*)=var_array(*,*,*,*)
        grid_size_combined=var_grid_size
        lon_combined=var_lon
        lat_combined=var_lat
        vert_combined=var_vert
        time_combined=var_time        
        ; And the vertical bounds
        bounds_size=INTARR(2)
        bounds_size(0)=1
        bounds_size(1)=2
        var_vert_bounds_combined=safe_alloc_arr(2, bounds_size, /float_arr)
        var_vert_bounds_combined(0,*)=var_vert_bounds(*)
     endif else begin
        ; For subsequent variables, we interpolate
        ; onto the original first grid structure
        if (KEYWORD_SET(verbose)) then begin
           print, 'Interpolating variable (index, name):', $
                  ivar, ' ', which_var_arr(ivar)
           print, 'Onto grid of (index, name):', $
                  0, ' ', which_var_arr(0)
           print, 'Before interpolation:'
           good_pts=where(var_array gt min_val)
           print, 'Size and range of current array (size, min, max):',$
                  size(var_array), min(var_array(good_pts)), $
                  max(var_array(good_pts))
           print, 'Longitude (size, min, max):',$
           n_elements(var_lon), min(var_lon), max(var_lon)
           print, 'Latitude (size, min, max):',$
           n_elements(var_lat), min(var_lat), max(var_lat)
           print, 'Vertical (size, min, max):',$
           n_elements(var_vert), min(var_vert), max(var_vert)
           print, 'Time (size, min, max):',$
           n_elements(var_time), min(var_time), max(var_time)
        endif
        which_interp=INTARR(4)
        which_interp(0)=1
        which_interp(1)=1
        ; Vertical should all be on the same grid due to mapping
        which_interp(2)=0
        which_interp(3)=1
        set_4d_interp_std_arg, vert_type,$
                               var_grid_size, $
                               var_lon, var_lat, var_vert, var_time, $
                               grid_size_combined,$
                               lon_combined, lat_combined, $
                               vert_combined, time_combined, $
                               var_vert_bounds_combined(0,*), $
                               bounding_string, grid_boundaries, $
                               var_boundaries, index_per, grid_period, $
                               axes_index_incr, lid_height,$
                               var_grid, combined_grid 
        ndims=4
        var_interp=linear_interp_multid($
                   ndims, $
                   which_interp, var_array, var_grid_size, $
                   var_grid, grid_size_combined, combined_grid,$
                   bounding_string, $
                   grid_period, grid_boundaries, var_boundaries,$
                   index_per, axes_index_incr, min_val=missing)
        ; Inform user of adjusted array ranges
        if (KEYWORD_SET(verbose)) then begin
           print, 'After interpolation:'
           good_pts=where(var_interp gt min_val)
           print, 'Size and range of current array (size, min, max):',$
                  size(var_interp), min(var_interp(good_pts)), $
                  max(var_interp(good_pts))
        endif
        ; Now we add this to the combined array
        var_temp=var_combined
        var_combined=0
        arr_size=INTARR(5)
        arr_size(0)=ivar+1
        arr_size(1)=grid_size_combined(0)
        arr_size(2)=grid_size_combined(1)
        arr_size(3)=grid_size_combined(2)
        arr_size(4)=grid_size_combined(3)
        var_combined=safe_alloc_arr(5, arr_size, /float_arr)
        ; And the same for the vertical boundary values
        var_vert_bounds_temp=var_vert_bounds_combined
        bound_size=INTARR(2)
        bound_size(0)=ivar+1
        bound_size(1)=2
        var_vert_bounds_combined=$
           safe_alloc_arr(2, bound_size, /float_arr)
        for iivar=0, ivar-1 do begin
           var_combined(iivar,*,*,*,*)=var_temp(iivar,*,*,*,*)
           var_vert_bounds_combined(iivar,*)=$
              var_vert_bounds_temp(iivar,*)
        endfor
        var_combined(ivar,*,*,*,*)=var_interp(*,*,*,*)
        var_vert_bounds_combined(ivar,*)=var_vert_bounds(*)
        ; zero unrequired arrays
        var_interp=0
        var_temp=0
        var_vert_bounds_temp=0
        ; We can get rid of the individual variable
        var_array=0
        var_lon=0
        var_lat=0
        var_vert=0
        var_time=0
        var_grid_size=0
        var_vert_bounds=0
     endelse
  endelse

  ; Check on var_combined sizes
  if (KEYWORD_SET(verbose)) then begin
     print, 'Running array sizes:',$
            size(var_combined)          
     print, 'Size of combined grid:', $
            grid_size_combined
     print, 'Longitude (size, min, max):', $
            n_elements(lon_combined), $
            min(lon_combined), max(lon_combined)
     print, 'Latitude (size, min, max):', $
            n_elements(lat_combined), $
            min(lat_combined), max(lat_combined)
     print, 'Vertical (size, min, max):', $
            n_elements(vert_combined), $
            min(vert_combined), max(vert_combined)
     print, 'Time (size, min, max):', $
            n_elements(time_combined), $
            min(time_combined), max(time_combined)
     endif
end 

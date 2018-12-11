pro mean_sum_slice, grid_use, $
                    p0, lid_height, pi, min_val, $
                    var_array, var_grid_size, $
                    var_lon, var_lat, var_vert, var_time, $
                    var_vert_bounds, $
                    meri_mean_pt=meri_mean_pt, $
                    skip_vert_slice=skip_vert_slice, $
                    vert_type=vert_type, $
                    var_type=var_type, $
                    verbose=verbose
  ; This routine takes an array
  ; (var_array) and performs sums, averages (mean)
  ; (by which we mean the mean) and also
  ; interpolates for individual slices
  ; The input is altered to become the output
  ; The skip_vert_slice is used to not
  ; perform slicing in the vertical
  ; As the mapping process does this automatically
  ; for plotting however, must do it explicitly.
  ; Check the call is consistent with regards to 
  ; treatment of vertical
  err=0
  if (NOT(KEYWORD_SET(skip_vert_slice))) then begin
      if (NOT(KEYWORD_SET(vert_type)) or $
         NOT(KEYWORD_SET(var_type))) then err=1
   endif
  if (err eq 1) then begin
     print, 'If we are slicing in the vertical'
     print, '(appropriate for plotting)'
     print, 'instead of skipping it'
     print, '(appropriate for mapping)'
     print, 'we require a vert_type, and '
     print, 'variable type (which_var_arr(ivar))'
     print, 'mean_sum_slice.pro'
     stop
  endif
  
  ; Loop over each dimension and perform 
  ; required operations whilst updating var_array
  for idim=0, 3 do begin
     ; Let user know  sizes etc before adjustments
     if (KEYWORD_SET(verbose)) then begin
        print, 'Current axis:', idim
        print, 'Size of array before operation:', $
               size(var_array)
        good_pts=where(var_array gt min_val)
        print, 'Data Range: (min, max):', $
               min(var_array(good_pts)),$
               max(var_array(good_pts))
        print, 'Size and range of axis before'
        print, 'operation (size, min, max):'
        if (idim eq 0) then $
           print, 'Longitude', n_elements(var_lon),$
                  min(var_lon), max(var_lon)
        if (idim eq 1) then $
           print, 'Latitude', n_elements(var_lat),$
                  min(var_lat), max(var_lat)
        if (idim eq 2) then $
           print, 'Vertical', n_elements(var_vert),$
                  min(var_vert), max(var_vert)
        if (idim eq 3) then $
           print, 'Time', n_elements(var_time),$
                  min(var_time), max(var_time)
     endif

     ; Averaging, mean
     if (grid_use(idim) eq 'mean') then begin
        ; Let user know what is happening
        if (KEYWORD_SET(verbose)) then begin
           if (idim eq 0) then $
              print, 'Creating zonal mean'
           if (idim eq 1) then $
              print, 'Creating meridional mean'
           if (idim eq 2) then $
              print, 'Creating vertical mean'
           if (idim eq 3) then $
              print, 'Creating temporal mean'
        endif
        ; Set the new size of the array
        var_grid_size(idim)=1
        ; Create a new array for result
        var_temp=safe_alloc_arr(4, var_grid_size, /float_arr)
        ; Now adjust axes and perform averaging
        ; dependant on which axes we are doing
        if (idim eq 0) then begin
           var_temp(*,*,*,*)=zon_mean_um_std(var_array, min_val)
           var_lon=0.0
        endif else if (idim eq 1) then begin
           var_temp(*,*,*,*)=meri_mean_um_std(var_array, var_lat, $
                                             pi, min_val, $
                                             meri_mean_pt=meri_mean_pt)
           var_lat=0.0
        endif else if (idim eq 2) then begin
           var_temp(*,*,*,*)=vert_mean_um_std(var_array, min_val)
           var_vert=0.0
        endif else if (idim eq 3) then begin
           var_temp(*,*,*,*)=time_mean_um_std(var_array, min_val)
           var_time=0.0
        endif
        ; Update var_array
        var_array=0
        var_array=safe_alloc_arr(4, var_grid_size, /float_arr)
        var_array(*,*,*,*)=var_temp(*,*,*,*)
        var_temp=0
     endif else if (grid_use(idim) eq 'sum') then begin
        ; Let user know what is happening
        if (KEYWORD_SET(verbose)) then begin
           if (idim eq 0) then $
              print, 'Creating zonal sum'
           if (idim eq 1) then $
              print, 'Creating meridional sum'
           if (idim eq 2) then $
              print, 'Creating vertical sum'
           if (idim eq 3) then $
              print, 'Creating temporal sum'
        endif
        ; Set the new size of the array
        var_grid_size(idim)=1
        ; Create a new array for result
        var_temp=safe_alloc_arr(4, var_grid_size, /float_arr)
        ; Perform sum
        var_temp(*,*,*,*)=sum_um_std(var_array, idim, min_val)
        ; Update axis
        if (idim eq 0) then $
           var_lon=0.0
        if (idim eq 1) then $
           var_lat=0.0
        if (idim eq 2) then $
           var_vert=0.0
        if (idim eq 3) then $
           var_time=0.0
        ; Update var_array
        var_array=0
        var_array=safe_alloc_arr(4, var_grid_size, /float_arr)
        var_array(*,*,*,*)=var_temp(*,*,*,*)
        var_temp=0
     endif else if (grid_use(idim) eq 'max') then begin
        ; Let user know what is happening
        if (KEYWORD_SET(verbose)) then begin
           if (idim eq 0) then $
              print, 'Finding zonal Max'
           if (idim eq 1) then $
              print, 'Finding meridional Max'
           if (idim eq 2) then $
              print, 'Finding vertical Max'
           if (idim eq 3) then $
              print, 'Finding Temporal Max'
        endif
        ; Set the new size of the array
        var_grid_size(idim)=1
        ; Create a new array for result
        var_temp=safe_alloc_arr(4, var_grid_size, /float_arr)
        ; Find Maximum
        var_temp(*,*,*,*)=max_um_std(var_array, idim, min_val)
        ; Update axis
        if (idim eq 0) then $
           var_lon=0.0
        if (idim eq 1) then $
           var_lat=0.0
        if (idim eq 2) then $
           var_vert=0.0
        if (idim eq 3) then $
           var_time=0.0
        ; Update var_array
        var_array=0
        var_array=safe_alloc_arr(4, var_grid_size, /float_arr)
        var_array(*,*,*,*)=var_temp(*,*,*,*)
        var_temp=0
     endif else if (grid_use(idim) eq 'min') then begin
        ; Let user know what is happening
        if (KEYWORD_SET(verbose)) then begin
           if (idim eq 0) then $
              print, 'Finding zonal Min'
           if (idim eq 1) then $
              print, 'Finding meridional Min'
           if (idim eq 2) then $
              print, 'Finding vertical Min'
           if (idim eq 3) then $
              print, 'Finding Temporal Min'
        endif
        ; Set the new size of the array
        var_grid_size(idim)=1
        ; Create a new array for result
        var_temp=safe_alloc_arr(4, var_grid_size, /float_arr)
        ; Find Minimum
        var_temp(*,*,*,*)=min_um_std(var_array, idim, min_val)
        ; Update axis
        if (idim eq 0) then $
           var_lon=0.0
        if (idim eq 1) then $
           var_lat=0.0
        if (idim eq 2) then $
           var_vert=0.0
        if (idim eq 3) then $
           var_time=0.0
        ; Update var_array
        var_array=0
        var_array=safe_alloc_arr(4, var_grid_size, /float_arr)
        var_array(*,*,*,*)=var_temp(*,*,*,*)
        var_temp=0
        ; Or are we using all of the entries
     endif else if (grid_use(idim) eq 'x' or $
                    grid_use(idim) eq 'y' or $
                    grid_use(idim) eq 'all') then begin
           ; These get left alone, so output
           ; array and grid is unchanged
        if (KEYWORD_SET(verbose)) then begin
           if (idim eq 0) then $
              print, 'Longitude unchanged as an axis'
           if (idim eq 1) then $
              print, 'Latitude unchanged as an axis'
           if (idim eq 2) then $
              print, 'Vertical unchanged as an axis'
           if (idim eq 3) then $
              print, 'Time unchanged as an axis'
        endif
     endif else begin
        ; Finally if we have selected a value
        ; we need to interpolate for it.
        ; Are we skipping the vertical
        skip_slice=0
        if (idim eq 2 and KEYWORD_SET(skip_vert_slice)) then $
           skip_slice=1
        if (skip_slice eq 0) then begin
           ; Let user know what is happening
           if (KEYWORD_SET(verbose)) then begin
              if (idim eq 0) then $
                 print, 'Slicing longitude at:',$
                        float(grid_use(idim))
              if (idim eq 1) then $
                 print, 'Slicing latitude at:',$
                        float(grid_use(idim))
              if (idim eq 2) then $
                 print, 'Slicing vertical at:',$
                        float(grid_use(idim))
              if (idim eq 3) then $
                 print, 'Slicing time at:',$
                        float(grid_use(idim))
           endif
           ; Setup the required input for interpolation
           ; routine
           ; And the output size
           var_grid_size(idim)=1
           input_pt=float(grid_use(idim))
           ; Now call interpolation with boundaries
           ; and extra arguments in each case
           ; then update axes
           if (idim eq 0) then begin
              ; Longitude is periodic
              var_array=linear_interp_point($
                        4, var_array, var_lon, $
                        input_pt, idim, $
                        /periodic, grid_period=360.0)
              var_lon=input_pt
              var_grid=0              
           endif else if (idim eq 1) then begin
              ; Latitude is polar
              var_array=linear_interp_point($
                        4, var_array, var_lat, $
                        input_pt, idim, $
                        /polar, index_per=0)
              var_lat=input_pt
              var_grid=0
           endif else if (idim eq 2) then begin
              ; Vertical has boundaries, depends
              ; on type of vertical coordinate
              ; Set the boundaries of the variable
              ; and the limits of the vertical grid
              var_boundaries=var_vert_bounds
              grid_boundaries=$
                 set_grid_bound_values_vert(vert_type, p0=p0, $
                                            lid_height=lid_height)
              index_increment='positive'
              ; If we are using pressure we need to interpolate 
              ; in ln(pressure)
              ; Perform inteprolation
              if (vert_type eq 'Sigma' or vert_type eq 'Pressure') then begin
                 index_increment='negative'              
                 ln_grid_boundaries=ALOG(grid_boundaries)
                 ln_input_pt=ALOG(input_pt)
                 ln_var_vert=ALOG(var_vert)
                 var_array=linear_interp_point($
                           4, var_array, ln_var_vert, $
                           ln_input_pt, idim, $
                           grid_boundaries=ln_grid_boundaries, $
                           var_boundaries=var_boundaries, $
                           index_increment=index_increment)              
              endif else begin
                 var_array=linear_interp_point($
                           4, var_array, var_vert, $
                           input_pt, idim, $
                           grid_boundaries=grid_boundaries, $
                           var_boundaries=var_boundaries, $
                           index_increment=index_increment)              
              endelse
              var_vert=input_pt
              var_grid=0
           endif else if (idim eq 3) then begin
              ; Time is standard i.e. crash
              ; if request values outside boundaries   
              var_array=linear_interp_point($
                        4, var_array, var_time, $
                        input_pt, idim)
              var_time=input_pt
              var_grid=0
           endif
        endif
     endelse
     ; Let user know  sizes etc after adjustments
     if (KEYWORD_SET(verbose)) then begin
        print, 'Current axis:', idim
        print, 'Size of array after operation:', $
               size(var_array)
        good_pts=where(var_array gt min_val)
        print, 'Data Range: (min, max):', $
               min(var_array(good_pts)), $
               max(var_array(good_pts))
        print, 'Size and range of axis after'
        print, 'operation (size, min, max):'
        if (idim eq 0) then $
           print, 'Longitude', n_elements(var_lon),$
                  min(var_lon), max(var_lon)
        if (idim eq 1) then $
           print, 'Latitude', n_elements(var_lat),$
                  min(var_lat), max(var_lat)
        if (idim eq 2) then $
           print, 'Vertical', n_elements(var_vert),$
                  min(var_vert), max(var_vert)
        if (idim eq 3) then $
           print, 'Time', n_elements(var_time),$
                  min(var_time), max(var_time)
     endif
  endfor
end

function linear_interp_whole_axis, ndims, var_in, var_grid,$
                                   new_axis,$
                                   which_index, $
                                   periodic=periodic, $
                                   grid_period=grid_period, $
                                   value=value,$
                                   grid_boundaries=grid_boundaries, $
                                   var_boundaries=var_boundaries, $
                                   polar=polar,$
                                   missing=missing, $
                                   index_per=index_per, $
                                   index_increment=index_increment
  ; This routine interpolates the values of var_in
  ; on grid var_grid (axis) onto the new axis (new_axis)
  ; which is elements in the array of which_index,
  ; and has boundary or edge behaviour denoted by the
  ; keywords, see linear_interp_point for explanation
  ; It can handle 1d, 2d, 3d and 4d arrays
  ; ndims is to check we have the number of dimensions
  ; we are expecting!
  ; Finally, index_increment can be 'positive' or 'negative'
  ; and it tells the routines whether the axis is
  ; increasing with index i.e. height or decresing i.e. pressure
  ; FIRST: Check if we need interpolation at all
  ; Check if axes match
  if (TOTAL(ABS(var_grid-new_axis)) eq 0.0 and $
      n_elements(var_grid) eq n_elements(new_axis)) then begin
     print, 'Interpolation not required as axes match'
     var_out=var_in
  endif else begin
     ; Find size of new axis
     naxis=n_elements(new_axis)
     ; Find number of dimensions
     arr_dim=size(var_in)
     if (ndims ne arr_dim(0)) then begin
        print, 'Number of array dimensions:', arr_dim(0)
        print, 'Does not match that selected:', ndims
        print, 'stoppping in linear_inerp_whole_axis'
        stop
     endif
     err=0
     if (arr_dim(0) lt 1 or arr_dim(0) gt 4) then err=1
     if (which_index lt 0 or which_index gt arr_dim(0)-1) then err=1
     if (arr_dim(0) eq 1 and KEYWORD_SET(polar)) then err=1
     if (err eq 1) then begin
        print, 'Something inconsistent in call to linear_interp_whole_axis'
        stop
     endif
     ; Allocate new array/output differently
     ; depending on the index we are interpolating
     ; over and the array size
     if (arr_dim(0) eq 1) then begin
        arr_size=naxis
        var_out=safe_alloc_arr(1, arr_size, /float_arr)
     endif else if (arr_dim(0) eq 2) then begin
        arr_size=INTARR(2)
        if (which_index eq 0) then begin
           arr_size(0)=naxis
           arr_size(1)=arr_dim(2)
        endif
        if (which_index eq 1) then begin
           arr_size(0)=arr_dim(1)
           arr_size(1)=naxis
        endif
        var_out=safe_alloc_arr(2, arr_size, /float_arr)
     endif else if (arr_dim(0) eq 3) then begin
        arr_size=INTARR(3)
        if (which_index eq 0) then begin
           arr_size(0)=naxis
           arr_size(1)=arr_dim(2)
           arr_size(2)=arr_dim(3)
        endif
        if (which_index eq 1) then begin
           arr_size(0)=arr_dim(1)
           arr_size(1)=naxis
           arr_size(2)=arr_dim(3)
        endif
        if (which_index eq 2) then begin
           arr_size(0)=arr_dim(1)
           arr_size(1)=arr_dim(2)
           arr_size(2)=naxis
        endif
        var_out=safe_alloc_arr(3, arr_size, /float_arr)
     endif else if (arr_dim(0) eq 4) then begin
        arr_size=INTARR(4)
        if (which_index eq 0) then begin
           arr_size(0)=naxis
           arr_size(1)=arr_dim(2)
           arr_size(2)=arr_dim(3)
           arr_size(3)=arr_dim(4)
        endif
        if (which_index eq 1) then begin
           arr_size(0)=arr_dim(1)
           arr_size(1)=naxis
           arr_size(2)=arr_dim(3)
           arr_size(3)=arr_dim(4)
        endif
        if (which_index eq 2) then begin
           arr_size(0)=arr_dim(1)
           arr_size(1)=arr_dim(2)
           arr_size(2)=naxis
           arr_size(3)=arr_dim(4)
        endif
        if (which_index eq 3) then begin
           arr_size(0)=arr_dim(1)
           arr_size(1)=arr_dim(2)
           arr_size(2)=arr_dim(3)
           arr_size(3)=naxis
        endif
        var_out=safe_alloc_arr(4, arr_size, /float_arr)
     endif

     ; Now loop over new axis points
     ; To perform interpolation
     for iaxis=0, naxis-1 do begin
        ; Call interpolation function
        var_interp=linear_interp_point(ndims, var_in, $
                                       var_grid, $
                                       new_axis(iaxis), which_index,$
                                       periodic=periodic, $
                                       grid_period=grid_period,$
                                       value=value,$
                                       grid_boundaries=grid_boundaries, $
                                       var_boundaries=var_boundaries, $
                                       polar=polar,$
                                       missing=missing, index_per=index_per, $
                                       index_increment=index_increment)
        ; How we store the output then
        ; depends on the dimensions of var_in, and
        ; which_index we are interpolating
        if (arr_dim(0) eq 1) then begin
           var_out(iaxis)=var_interp
        endif else if (arr_dim(0) eq 2) then begin
           if (which_index eq 0) then var_out(iaxis,*)=var_interp(0,*)
           if (which_index eq 1) then var_out(*,iaxis)=var_interp(*,0)
        endif else if (arr_dim(0) eq 3) then begin
           if (which_index eq 0) then $
              var_out(iaxis,*,*)=var_interp(0,*,*)
           if (which_index eq 1) then $
              var_out(*,iaxis,*)=var_interp(*,0,*)
           if (which_index eq 2) then $
              var_out(*,*,iaxis)=var_interp(*,*,0)
        endif else if (arr_dim(0) eq 4) then begin
           if (which_index eq 0) then $
              var_out(iaxis,*,*,*)=var_interp(0,*,*,*)
           if (which_index eq 1) then $
              var_out(*,iaxis,*,*)=var_interp(*,0,*,*)
           if (which_index eq 2) then $
              var_out(*,*,iaxis,*)=var_interp(*,*,0,*)
           if (which_index eq 3) then $
              var_out(*,*,*,iaxis)=var_interp(*,*,*,0)
        endif     
     endfor
  endelse
  return, var_out
end

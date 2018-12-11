function linear_interp_multid, ndims, which_interp, var_in, var_grid_size, $
                               var_grid, new_axis_size, new_axis, $
                               bounding_string, grid_period, $
                               grid_boundaries_in, var_boundaries_in, $
                               index_per_in, axis_index_incr, min_val=min_val
  ; This function allows the user
  ; to interpolate an array, over a whole axis
  ; across several dimensions
  ; It can handle 1d, 2d, 3d, or 4d arrays
  ; ndims is to check the array dimensions are as expected
  ; as IDL can be tricky
  ; All of the relevant outputs are therefore n-D
  ; e.g. 4d
  ; i.e. if var_in(*,*,*,*), then var_grid(4,MAX_GRID_SIZE)
  ; which is of size var_grid_size(4)
  ; and which_interp holds a 1 if a given dimension
  ; is to be interpolated and a 0 if not.
  ; i.e. which_interp(4), which_interp(0)=0
  ; which_interp(1)=1 etc...
  ; bounding_string(?d) contains the boundary information
  ; i.e. periodic, polar, value, missing
  ; grid_boundaries_in(?d) and var_boundaries_in(?d)
  ; contain the relevant boundary values if /value
  ; is present for a given idim, the others have a
  ; default value (0), and grid_period, contains the grid_period
  ; of the periodic axis
  ; Finally, axis_index_incr tells us if the axis increases
  ; with index ('positive' i.e. height)
  ; or decreases ('negative' i.e. pressure)
  ; Find out how many dimensions our input array has
  arr_dim=size(var_in)
  if (ndims ne arr_dim(0)) then begin
     print, 'Size of array (dimensions):', arr_dim(0)
     print, 'Does not match that entered:', ndims
     print, 'stopping in linear_interp_multid'
     stop
  endif  
  ; Check we have an entry for each
  if (n_elements(which_interp) ne arr_dim(0)) then begin
     print, 'Problem with inconsistent input to'
     print, 'linear_interp_multid'
     print, 'stopping in linear_interp_multid'
     stop
  endif

  ; Allocate arrays to hold changing sizes
  n_old=INTARR(arr_dim(0))
  n_new=INTARR(arr_dim(0))
  n_out=INTARR(arr_dim(0))
  ; Setup sizes of new and old arrays
  for idim=0, arr_dim(0)-1 do begin
     ; Save sizes of new and old array
     n_old(idim)=var_grid_size(idim)
     n_new(idim)=new_axis_size(idim)
  endfor
  ; Start with output array the same size as
  ; input
  n_out=n_old
  ; Initialise interpolation input
  ; Need to explicitly retain 4D nature
  var_interp_in=safe_alloc_arr(4, var_grid_size, /float_arr)
  var_interp_in(*,*,*,*)=var_in(*,*,*,*)
  ; Now loop over the dimensions
  for idim=0, arr_dim(0)-1 do begin
     if (which_interp(idim) eq 1) then begin        
        ; Interpolating this index
        which_index=idim
        ; If we are interpolating setup the input
        ; this depends on the dimensions of the
        ; arrays etc.
        ; First isolate the required grids
        if (arr_dim(0) eq 1) then begin
           var_grid_single=var_grid
           new_axis_single=new_axis
        endif else if (arr_dim(0) eq 2) then begin
           if (idim eq 0) then begin
              var_grid_single=var_grid(0,0:var_grid_size(0)-1)
              new_axis_single=new_axis(0,0:new_axis_size(0)-1)
           endif else if (idim eq 1) then begin
              var_grid_single=var_grid(1,0:var_grid_size(1)-1)
              new_axis_single=new_axis(1,0:new_axis_size(1)-1)
           endif
        endif else if (arr_dim(0) eq 3) then begin
           if (idim eq 0) then begin
              var_grid_single=var_grid(0,0:var_grid_size(0)-1)
              new_axis_single=new_axis(0,0:new_axis_size(0)-1)
           endif else if (idim eq 1) then begin
              var_grid_single=var_grid(1,0:var_grid_size(1)-1)
              new_axis_single=new_axis(1,0:new_axis_size(1)-1)
           endif else if (idim eq 2) then begin
              var_grid_single=var_grid(2,0:var_grid_size(2)-1)
              new_axis_single=new_axis(2,0:new_axis_size(2)-1)
           endif
        endif else if (arr_dim(0) eq 4) then begin
           if (idim eq 0) then begin
              var_grid_single=var_grid(0,0:var_grid_size(0)-1)
              new_axis_single=new_axis(0,0:new_axis_size(0)-1)
           endif else if (idim eq 1) then begin
              var_grid_single=var_grid(1,0:var_grid_size(1)-1)
              new_axis_single=new_axis(1,0:new_axis_size(1)-1)
           endif else if (idim eq 2) then begin
              var_grid_single=var_grid(2,0:var_grid_size(2)-1)
              new_axis_single=new_axis(2,0:new_axis_size(2)-1)
           endif else if (idim eq 3) then begin
              var_grid_single=var_grid(3,0:var_grid_size(3)-1)
              new_axis_single=new_axis(3,0:new_axis_size(3)-1)
           endif
        endif     
        ; Now construct the routine call
        ; Start with basic first entry
        routine_call='var_interp_one=linear_interp_whole_axis(ndims, var_interp_in, var_grid_single, new_axis_single, which_index'
        ; Now we add the parts about boundary conditions if required
        ; Check the input strings
        if (bounding_string(idim) eq 'periodic') then begin
           routine_call=STRCOMPRESS(routine_call,/remove_all)+',/periodic, grid_period=grid_period'
        endif else if (bounding_string(idim) eq 'value') then begin
           grid_boundaries=grid_boundaries_in(idim,*)
           var_boundaries=var_boundaries_in(idim,*)
           routine_call=STRCOMPRESS(routine_call,/remove_all)+',/value,grid_boundaries=grid_boundaries, var_boundaries=var_boundaries'
        endif else if (bounding_string(idim) eq 'polar') then begin
           index_per=index_per_in(idim)
           routine_call=STRCOMPRESS(routine_call,/remove_all)+',grid_period=grid_period,/polar,index_per=index_per'
        endif else if (bounding_string(idim) eq 'missing') then begin
           grid_boundaries=grid_boundaries_in(idim,*)
           routine_call=STRCOMPRESS(routine_call,/remove_all)+',missing=min_val'
        endif
        ; Now add string about axis sense
        if (axis_index_incr(idim) eq 'positive' or $
            axis_index_incr(idim) eq 'negative') then begin
           index_increment=axis_index_incr(idim)         
           routine_call=STRCOMPRESS(routine_call,/remove_all)+',index_increment=index_increment)'
        endif else begin
           print, 'Given axis_index_incr, not understood'
           print, 'should be positive/negative i.e. height/pressure'
           print, 'stopping in linear_interp_multid'
           stop
        endelse
        ; Perform the interpolation
        result=execute(routine_call)       
        ; Update the size of the array after interpolation
        n_out(idim)=n_new(idim)
        ; Reset the output array
        var_out=0
        if (arr_dim(0) eq 1) then begin
           arr_size=n_out(0)
           var_out=safe_alloc_arr(1, arr_size, /float_arr)
           var_out(*)=var_interp_one(*)
           ; Prepare next input if required
           if (idim lt arr_dim(0)-1) then begin
              var_interp_in=safe_alloc_arr(1, arr_size, /float_arr)
              var_interp_in(*)=var_out(*)
           endif
        endif else if (arr_dim(0) eq 2) then begin
           arr_size=INTARR(2)
           arr_size(0)=n_out(0)
           arr_size(1)=n_out(1)
           var_out=safe_alloc_arr(2, arr_size, /float_arr)
           var_out(*,*)=var_interp_one(*,*)
           ; Prepare next input if required
           if (idim lt arr_dim(0)-1) then begin
              var_interp_in=safe_alloc_arr(2, arr_size, /float_arr)
              var_interp_in(*,*)=var_out(*,*)
           endif
        endif else if (arr_dim(0) eq 3) then begin
           arr_size=INTARR(3)
           arr_size(0)=n_out(0)
           arr_size(1)=n_out(1)
           arr_size(2)=n_out(2)
           var_out=safe_alloc_arr(3, arr_size, /float_arr)
           var_out(*,*,*)=var_interp_one(*,*,*)
           ; Prepare next input if required
           if (idim lt arr_dim(0)-1) then begin
              var_interp_in=safe_alloc_arr(3, arr_size, /float_arr)
              var_interp_in(*,*,*)=var_out(*,*,*)
           endif
        endif else if (arr_dim(0) eq 4) then begin
           arr_size=INTARR(4)
           arr_size(0)=n_out(0)
           arr_size(1)=n_out(1)
           arr_size(2)=n_out(2)
           arr_size(3)=n_out(3)
           var_out=safe_alloc_arr(4, arr_size, /float_arr)
           var_out(*,*,*,*)=var_interp_one(*,*,*,*)
           ; Prepare next input if required
           if (idim lt arr_dim(0)-1) then begin
              var_interp_in=safe_alloc_arr(4, arr_size, /float_arr)
              var_interp_in(*,*,*,*)=var_out(*,*,*,*)
           endif
        endif
     endif else begin
        ; If there is no interpolation
        ; the output is the input
        ; Need to retain dimensions however
        if (arr_dim(0) eq 1) then begin
           arr_size=INTARR(1)
           arr_size(0)=n_out(0)
           var_out=safe_alloc_arr(1, arr_size, /float_arr)
           var_out(*)=var_interp_in(*)
        endif else if (arr_dim(0) eq 2) then begin
           arr_size=INTARR(2)
           arr_size(0)=n_out(0)
           arr_size(1)=n_out(1)
           var_out=safe_alloc_arr(2, arr_size, /float_arr)
           var_out(*,*)=var_interp_in(*,*)
        endif else if (arr_dim(0) eq 3) then begin
           arr_size=INTARR(3)
           arr_size(0)=n_out(0)
           arr_size(1)=n_out(1)
           arr_size(2)=n_out(2)
           var_out=safe_alloc_arr(3, arr_size, /float_arr)
           var_out(*,*,*)=var_interp_in(*,*,*)
        endif else if (arr_dim(0) eq 4) then begin
           arr_size=INTARR(4)
           arr_size(0)=n_out(0)
           arr_size(1)=n_out(1)
           arr_size(2)=n_out(2)
           arr_size(3)=n_out(3)
           var_out=safe_alloc_arr(4, arr_size, /float_arr)
           var_out(*,*,*,*)=var_interp_in(*,*,*,*)
        endif
     endelse
  endfor
  return, var_out
end

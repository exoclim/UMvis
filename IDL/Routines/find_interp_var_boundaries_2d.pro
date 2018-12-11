function find_interp_var_boundaries_2d, var_in, $
                                        which_index, $
                                        grid_index_bounds, $
                                        PERIODIC=PERIODIC, $
                                        VALUE=VALUE,$
                                        VAR_BOUNDARIES=VAR_BOUNDARIES,$
                                        POLAR=POLAR, $
                                        missing=missing, $
                                        INDEX_PER=INDEX_PER
                                        
  ; a 2d array (var_in(*,*)) 
  ; at the points required for interpolation given
  ; by grid_index_bounds, in the index: which_index
  ; but incorporates treatment
  ; of the boundary conditions
  ; The boundary behaviour can be selected as either
  ; periodic, or as tending towards a value or polar (i.e. latitude)
  ; or missing                                        
  ; using the thus named keywords.
  ; If a value is selected, you must provide
  ; var_boundaries(?)=value of variable at start(0)/end(1) boundary
  ; index_per, for polar, then gives the index of the periodic 
  ; element usually longitude
  var_dim=size(var_in)
  err=0
  if (var_dim(0) ne 2) then err=1
  if (which_index lt 0 or which_index gt 1) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(value)) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(polar)) then err=1
  if (KEYWORD_SET(value) and KEYWORD_SET(polar)) then err=1
  if (KEYWORD_SET(value) and NOT(KEYWORD_SET(var_boundaries))) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(missing)) then err=1
  if (KEYWORD_SET(polar) and KEYWORD_SET(missing)) then err=1
  if (KEYWORD_SET(value) and KEYWORD_SET(missing)) then err=1
  if (KEYWORD_SET(polar)) then begin 
     ; If polar the periodic axis can't
     ; be the one we are interpolating for
     ; doesn't make sense to be periodic and 
     ; polar
     if (index_per eq which_index) then err=1
     ; Also index_per must be set, so we
     ; try to acces it
     err_temp=index_per
     if (index_per lt 0 or index_per gt 1) then err=1
     ; This should fall over if you have
     ; not called the routine correctly
     ; i.e. selected a polar variable
     ; but chosen the axis to be periodic
     ; it can't be both....
  endif
  if (err eq 1) then begin
     print, 'Inconsistency in boundary settings in call'
     print, 'to find_interp_grid_boundaries'
     stop
  endif

  ; Initialise the array and the largest index
  ; Set the maximum size (+1 as var_dim contains
  ; number of columns as entry 0)
  ; Now create the output array
  arr_size=INTARR(2)
  if (which_index eq 0) then begin
     arr_size(0)=2
     arr_size(1)=var_dim(2)
     var_interp_bounds=safe_alloc_arr(2, arr_size, /float_arr)
     nvar_max=var_dim(1)-1
  endif else if (which_index eq 1) then begin
     arr_size(0)=var_dim(1)
     arr_size(1)=2
     var_interp_bounds=safe_alloc_arr(2, arr_size, /float_arr)
     nvar_max=var_dim(2)-1
  endif else begin
     print, 'Error invalid index selected in call to'
     print, 'find_interp_var_boundaries_2d'
     stop
  endelse

  ; Now we need to see if we have hit the edge of
  ; the array, different dependent on the edge condition
  ; First have we hit a non-periodic boundary value
  if (grid_index_bounds(0) eq -1 or grid_index_bounds(1) eq -1) then begin
     ; Must have hit an end point
     if ((NOT(KEYWORD_SET(value)) and $
         NOT(KEYWORD_SET(var_boundaries))) and $
         NOT(KEYWORD_SET(polar)) and NOT(KEYWORD_SET(missing))) then begin
        print, 'Interpolation hit array start/edge, but no'
        print, 'boundary value/choice given'
        print, 'find_interp_var_boundaries_2d'
        stop
     endif
     ; First deal with values at edges
     if KEYWORD_SET(value) then begin
        ; If at end, set value as one given
        if (grid_index_bounds(0) eq -1) then begin
           ; When setting var_interp_bounds
           ; need to check which is free index
           if (which_index eq 0) then begin
              var_interp_bounds(0,*)=var_boundaries(0)
              var_interp_bounds(1,*)=var_in(grid_index_bounds(1),*)
           endif else if  (which_index eq 1) then begin
              var_interp_bounds(*,0)=var_boundaries(0)
              var_interp_bounds(*,1)=var_in(*,grid_index_bounds(1))
           endif
        endif
        if (grid_index_bounds(1) eq -1) then begin
           if (which_index eq 0) then begin
              var_interp_bounds(0,*)=var_in(grid_index_bounds(0),*)
              var_interp_bounds(1,*)=var_boundaries(1)
           endif else if  (which_index eq 1) then begin
              var_interp_bounds(*,0)=var_in(*,grid_index_bounds(0))
              var_interp_bounds(*,1)=var_boundaries(1)
           endif   
        endif
     endif else if KEYWORD_SET(polar) then begin
        ; Now deal with hitting the pole
        ; In this case only the second bound
        ; grid_index_bounds(1) should be -1
        if (grid_index_bounds(0) eq -1) then begin
           print, 'Problem in hitting polar boundary'
           print, 'but not having base index'
           print, 'see find_interp_var_boundaries_2d'
           stop
        endif
        ; If this is the pole, we can loop around in longitude
        ; First point is OK, second point must be on
        ; other side of the globe
        ; The start bound is ok
        if (which_index eq 0) then $
           var_interp_bounds(0,*)=var_in(grid_index_bounds(0),*)
        if  (which_index eq 1) then $ 
           var_interp_bounds(*,0)=var_in(*,grid_index_bounds(0))
        ; Now find the second bound
        ; Require the number of longitude points
        if (index_per eq 0) then nlon=n_elements(var_in(*,0))
        if (index_per eq 1) then nlon=n_elements(var_in(0,*))
        ; Then we must set the value, the other side of the globe
        ; i.e. ilon is partnered with ilon+nlon/2, but both
        ; at the start/finish i.e. grid_index_bounds(0)
        for ilon=0, nlon-1 do begin
           ; If we are less than halfway, then add one
           ; half.
           ; Once over halfway we need to subtract
           ; it, as longitude is periodic
           if (ilon lt nlon/2) then begin
              iilon=ilon+nlon/2
           endif else begin
              iilon=ilon-nlon/2
           endelse
           ; Have to check which index longitude is
           ; then get the bounds differently
           ; dependant on which index we are interpolating
           ; for
           if (index_per eq 0) then begin
              if  (which_index eq 1) then begin
                 var_interp_bounds(ilon,1)=$
                    var_in(iilon,grid_index_bounds(0))
              endif   
           endif else if (index_per eq 1) then begin
              if  (which_index eq 0) then begin
                 var_interp_bounds(1,ilon)=$
                    var_in(grid_index_bounds(0),iilon)
              endif   
           endif
        endfor
     endif else if KEYWORD_SET(missing) then begin
        ; In this case we simply set the values to missing
        var_interp_bounds(*,*)=missing        
     endif
     ; Now have we hit a periodic boundary
  endif else if ((grid_index_bounds(0) eq 0 and grid_index_bounds(1) eq nvar_max)) $
     or ((grid_index_bounds(0) eq nvar_max and grid_index_bounds(1) eq 0)) then begin
     ; We are either interpolating for a point which matches
     ; exactly a grid point, or straddling a boundary
     if (grid_index_bounds(0) ne grid_index_bounds(1) and $
         NOT(KEYWORD_SET(periodic))) then begin
        print, 'Interpolation straddling array start/end'
        print, 'yet interpolation not set as periodic'
        print, 'interp_var_boundaries'
        stop
     endif
     ; If periodic simply set values as start/end points
   if (which_index eq 0) then begin
      var_interp_bounds(0,*)=var_in(grid_index_bounds(0),*)
      var_interp_bounds(1,*)=var_in(grid_index_bounds(1),*)
   endif else if  (which_index eq 1) then begin
      var_interp_bounds(*,0)=var_in(*,grid_index_bounds(0))
      var_interp_bounds(*,1)=var_in(*,grid_index_bounds(1))
   endif
  endif else begin
     ; Otherwise a standard interpolation
     ; If periodic simply set values as start/end points
   if (which_index eq 0) then begin
      var_interp_bounds(0,*)=var_in(grid_index_bounds(0),*)
      var_interp_bounds(1,*)=var_in(grid_index_bounds(1),*)
   endif else if  (which_index eq 1) then begin
      var_interp_bounds(*,0)=var_in(*,grid_index_bounds(0))
      var_interp_bounds(*,1)=var_in(*,grid_index_bounds(1))
   endif
  endelse
  return, var_interp_bounds
end     

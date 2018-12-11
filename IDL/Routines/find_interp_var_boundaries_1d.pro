function find_interp_var_boundaries_1d, var_in, $
                                        grid_index_bounds, $
                                        PERIODIC=PERIODIC, $
                                        VALUE=VALUE,$
                                        VAR_BOUNDARIES=VAR_BOUNDARIES, $
                                        missing=missing
  ; a 1d array (var_in(*)) 
  ; at the points required for interpolation given
  ; by grid_index_bounds, in the index: which_index
  ; but incorporates treatment
  ; of the boundary conditions
  ; The boundary behaviour can be selected as either
  ; periodic, or as tending towards a value
  ; using the thus named keywords.
  ; If a value is selected, you must provide
  ; var_boundaries(?)=value of variable at start(0)/end(1) boundary
  ; Note that compared to the 2d,3d,4d versions of this procedure
  ; which_index is not required (it has the be the only index)
  ; and the interpolatio/boundary can't be polar, as there is not
  ; another index to be periodic.
  arr_dim=size(var_in)
  err=0
  if (arr_dim(0) ne 1) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(value)) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(missing)) then err=1
  if (KEYWORD_SET(value) and KEYWORD_SET(missing)) then err=1
  if (KEYWORD_SET(value) and NOT(KEYWORD_SET(var_boundaries))) then err=1
  if (err eq 1) then begin
     print, 'Inconsistency in boundary settings in call'
     print, 'to find_interp_grid_boundaries'
     stop
  endif

  ; Initialise the array and the largest index
  ; Get the sizes of var_in
  var_dim=size(var_in)
  ; Set the maximum size (+1 as var_dim contains
  ; number of columns as entry 0)
  ; Now create the output array
  var_interp_bounds=safe_alloc_arr(1, 2, /float_arr)
  nvar_max=var_dim(1)-1

  ; Now we need to see if we have hit the edge of
  ; the array, different dependent on the edge condition
  ; First have we hit a non-periodic boundary value
  if (grid_index_bounds(0) eq -1 or grid_index_bounds(1) eq -1) then begin
     ; Must have hit an end point
     if ((NOT(KEYWORD_SET(value)) and $
         NOT(KEYWORD_SET(var_boundaries))) and $
         NOT(KEYWORD_SET(missing))) then begin
        print, 'Interpolation hit array start/edge, but no'
        print, 'boundary value/choice given'
        print, 'find_interp_var_boundaries_1d'
        stop
     endif
     ; First deal with values at edges
     if KEYWORD_SET(value) then begin
        ; If at end, set value as one given
        if (grid_index_bounds(0) eq -1) then begin
           var_interp_bounds(0)=var_boundaries(0)
           var_interp_bounds(1)=var_in(grid_index_bounds(1))
        endif
        if (grid_index_bounds(1) eq -1) then begin
           var_interp_bounds(0)=var_in(grid_index_bounds(0))
           var_interp_bounds(1)=var_boundaries(1)
        endif
     endif else if KEYWORD_SET(missing) then begin
        ; These values are not present
        var_interp_bounds(*)=missing
     endif
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
     var_interp_bounds(0)=var_in(grid_index_bounds(0))
     var_interp_bounds(1)=var_in(grid_index_bounds(1))
  endif else begin
     ; Otherwise a standard interpolation
     ; If periodic simply set values as start/end points
     var_interp_bounds(0)=var_in(grid_index_bounds(0))
     var_interp_bounds(1)=var_in(grid_index_bounds(1))
  endelse
  return, var_interp_bounds
end     

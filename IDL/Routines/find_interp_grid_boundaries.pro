pro find_interp_grid_boundaries, var_grid,$
                                 new_grid_pt_in,$
                                 periodic=periodic, $
                                 grid_period=grid_period, $
                                 value=value,$
                                 grid_boundaries=grid_boundaries, $
                                 polar=polar, $
                                 missing=missing, $
                                 grid_val_bounds, $
                                 grid_index_bounds, $
                                 index_increment=index_increment
 
  ; This routine finds the values and indices of the 
  ; values 'either side' of new_grid_pt_in in var_grid
  ; and outputs them as grid_val_bounds and grid_index_bounds
  ; respectively

  ; The behaviour when the boundaries of var_grid are reached
  ; can be set
  ; periodic, or as tending towards a value, or polar (i.e. latitude)
  ; or missing
  ; using the thus named keywords.
  ; If periodic or polar are set we need to know the
  ; grid_period of the periodic axis i.e. 360 for longitude
  ; If a value is selected, you must provide
  ; grid_boundaries(2)
  ; grid_boundaries(?)=value of grid at start(0)/end(1) boundary
  ; if missing is set, we just ignore these points, and set
  ; them to the value missing

  ; Finally index_increment, tells us if the value
  ; increases with index
  ; (i.e. height, and index_increment eq 'positive')
  ; or decreses with index
  ; (i.e. pressure, and index_increment eq 'negative')
  ; THIS SHOULD BE AUTOMATED

  ; A quick check to see if boundary behaviour selected
  ; is consistent
  err=0
  if (KEYWORD_SET(periodic) and KEYWORD_SET(value)) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(polar)) then err=1
  if (KEYWORD_SET(value) and KEYWORD_SET(polar)) then err=1
  if (KEYWORD_SET(value) and NOT(KEYWORD_SET(grid_boundaries))) then err=1
  if (KEYWORD_SET(periodic) and NOT(KEYWORD_SET(grid_period))) then err=1
  if (KEYWORD_SET(periodic) and KEYWORD_SET(MISSING)) then err=1
  if (KEYWORD_SET(polar) and KEYWORD_SET(MISSING)) then err=1
  if (KEYWORD_SET(value) and KEYWORD_SET(MISSING)) then err=1
  if (err eq 1) then begin
     print, 'Inconsistency in boundary settings in call'
     print, 'to find_interp_grid_boundaries'
     stop
  endif
  ; Now find out what sort of axis it is
  ; if is is positive leave the sense of
  ; the change alone, otherwise we must switch it
  ; default is positive i.e. height
  sense_switch=1.0
  if KEYWORD_SET(index_increment) then begin
     if (index_increment eq 'positive') then begin
        sense_switch=1.0
     endif else if (index_increment eq 'negative') then begin
        sense_switch=-1.0
     endif else begin
        print, 'Type of index_increment unknown:', index_increment
        print, 'in find_interp_grid_boundaries'
     endelse
  endif
  ; First to check if the selected new_grid_pt
  ; makes sense
  new_grid_pt=new_grid_pt_in
  if KEYWORD_SET(value) then begin
     if (new_grid_pt lt min(grid_boundaries) or $
         new_grid_pt gt max(grid_boundaries)) then begin
        print, 'Grid point selected to interpolate to:', new_grid_pt
        print, 'Is beyond stated boundry limits:', $
               min(grid_boundaries), max(grid_boundaries)
        print, 'stopping in find_interp_grid_boundaries'
        stop
     endif
  endif else if KEYWORD_SET(polar) then begin
     if (new_grid_pt gt 90.0 or new_grid_pt lt -90.0) then begin
        print, 'Polar interpolation pt invalid, currently'
        print, 'programmed to work from -90 to +90'
        print, new_grid_pt
        stop
     endif
  endif else if KEYWORD_SET(periodic) then begin
     ; For periodic boundaries which have gone
     ; outside the bounds, we change the phase     
     if (new_grid_pt_in lt 0) then $
        new_grid_pt=new_grid_pt_in+grid_period
     if (new_grid_pt_in gt FLOAT(grid_period)) then $
        new_grid_pt=new_grid_pt_in-grid_period
  endif

  ; Initalise arrays
  grid_val_bounds=safe_alloc_arr(1, 2, /float_arr)
  grid_index_bounds=safe_alloc_arr(1, 2, /int_arr)
  ; Initialise the index array
  grid_index_bounds(*)=-1
  ; Find the maximum index for var grid
  nvar_max=n_elements(var_grid)-1
  ; Now find the closest point
  min_dist=min(abs((var_grid(*)-new_grid_pt)), closest_pt)
  grid_index_bounds(0)=closest_pt
  ; And the sense of the change
  sense=(var_grid(grid_index_bounds(0))-new_grid_pt)
  ; This sense must be switched if required
  sense=sense*sense_switch ; i.e. for pressure
  ; Now we need to find out if this value
  ; needs a bottom or upper boundary
  if ((grid_index_bounds(0) eq 0 and sense gt 0.0) or $
      (grid_index_bounds(0) eq nvar_max $
       and sense lt 0.0)) then begin
     ; At boundary
     ; Check which type of boundary it is
     if KEYWORD_SET(periodic) then begin
        ; Loop over boundaries
        ; The values need thought
        ; Assume grid spacing is even
        if (grid_index_bounds(0) eq 0) then begin
           ; We then set the other index to the end
           grid_index_bounds(1)=nvar_max
           ; e.g. new_grid_pt=0.0, var_grid: 1.25-358.75
           grid_val_bounds(0)=var_grid(0)
           ; The other end then becomes an increment lower
           grid_val_bounds(1)=var_grid(0)-(var_grid(1)-var_grid(0))
        endif else if (grid_index_bounds(0) eq nvar_max) then begin
           ; The other end is 0
           grid_index_bounds(1)=0
           ; e.g. new_grid_pt=358.75 var_grid 0.0-357.5
           grid_val_bounds(0)=var_grid(nvar_max)
           grid_val_bounds(1)=var_grid(nvar_max)+$
                              (var_grid(nvar_max)-$
                               var_grid(nvar_max-1))
        endif
     endif else if KEYWORD_SET(value) then begin 
        ; Here the boundary value is given
        ; But the second index is meaningless
        grid_index_bounds(1)=-1
        if (grid_index_bounds(0) eq 0) then begin
           grid_val_bounds(0)=var_grid(0)
           grid_val_bounds(1)=grid_boundaries(0)
        endif else if (grid_index_bounds(0) eq nvar_max) then begin
           grid_val_bounds(0)=var_grid(nvar_max)
           grid_val_bounds(1)=grid_boundaries(1)
        endif
     endif else if KEYWORD_SET(polar) then begin
        ; In this case the second grid bound is 
        ; set to -1
        if (grid_index_bounds(0) eq 0) then begin
           grid_val_bounds(0)=var_grid(0)
           grid_val_bounds(1)=-1
        endif else if (grid_index_bounds(0) eq nvar_max) then begin
           grid_val_bounds(0)=var_grid(nvar_max)
           grid_val_bounds(1)=-1
        endif
     endif else if KEYWORD_SET(missing) then begin 
        ; Set both to minus 1
        grid_val_bounds(0)=-1
        grid_val_bounds(1)=-1        
     endif else begin
        print, 'Error in find_interp_grid_boundaries'
        print, 'Interpolation requires boundary condition'
        print, 'and this was not set in call'
        stop
     endelse
  endif else begin
     ; Otherwise, within the array
     if (sense eq 0.0) then begin
        grid_index_bounds(1)=grid_index_bounds(0)
     endif else if (sense lt 0.0) then begin
        grid_index_bounds(1)=grid_index_bounds(0)+1
     endif else if (sense gt 0.0) then begin
        grid_index_bounds(1)=grid_index_bounds(0)-1
     endif
     ; Now set values
     grid_val_bounds(0)=var_grid(grid_index_bounds(0))
     grid_val_bounds(1)=var_grid(grid_index_bounds(1))
  endelse
end

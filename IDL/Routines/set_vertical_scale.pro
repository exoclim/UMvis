pro set_vertical_scale, vert_type, vert_use, vert_limits, $
                        p_array, psurf_array, np_vert,$
                        nvar_vert, var_vert, $
                        nvert_map, vert_map, $
                        p0, $
                        np_levels_ovrd=np_levels_ovrd, $
                        verbose=verbose
  ; A procedure to setup the vertical axes
  ; requested, and cut it if required.
  ; First find out if we are requesting
  ; a specific value or an mean or sum
  ; or all, or an axes
  if (vert_use eq 'x' or $
      vert_use eq 'y' OR $
      vert_use eq 'all' OR $
      vert_use eq 'sum' or $
      vert_use eq 'mean') then begin     
     ; In these cases the limits apply
     ; set defaults
     vert_start=0
     vert_end=nvar_vert-1
     nvert_map=nvar_vert
     ; Now find the limits, this is different dependant
     ; on the type of axis required.
     ; Standard bounds apply, i.e. can't extrapolate 
     ; to boundaries etc.
     if (vert_type eq 'Height') then begin
        ; Deal with minimum and maximum
        if (vert_limits(0) ne 'min') then begin
           find_interp_grid_boundaries, var_vert,$
                                        float(vert_limits(0)), $
                                        grid_val_bounds, $
                                        grid_index_bounds
           vert_start=min(grid_index_bounds)
           if (KEYWORD_SET(verbose)) then begin
              print, 'Limiting Vertical axis: ', vert_limits(0)
              print, 'Recovered bounds (index, value): ',$                   
                     min(grid_index_bounds(*)), $
                     grid_val_bounds(min(grid_index_bounds(*)))   
           endif    
        endif
        if (vert_limits(1) ne 'max') then begin
           find_interp_grid_boundaries, var_vert,$
                                        float(vert_limits(1)), $
                                        grid_val_bounds, $
                                        grid_index_bounds
           vert_end=max(grid_index_bounds)
           if (KEYWORD_SET(verbose)) then begin
              print, 'Limiting Vertical axis: ', vert_limits(1)
              print, 'Recovered bounds (index, value): ',$                   
                     max(grid_index_bounds(*)), $
                     grid_val_bounds(max(grid_index_bounds(*)))    
           endif               
        endif
        ; Now construct the output
        nvert_map=vert_end-vert_start+1
        vert_map=safe_alloc_arr(1, nvert_map, /float_arr)
        vert_map=var_vert(vert_start:vert_end)           
     endif else if (vert_type eq 'Pressure' or $
                    vert_type eq 'Sigma') then begin
        ; For Pressure/Sigma things are a little different
        ; The maximum achievable pressure is the minimum
        ; present on the bottom level
        ; and the minimum acheivable is the maximum
        ; at the top level
        if (vert_type eq 'Pressure') then begin
           min_pvert=max(p_array(*,*,np_vert-1,*))
           ; The maximum is the minimum at bottom
           max_pvert=min(p_array(*,*,0,*))
        endif else if (vert_type eq 'Sigma') then begin
           min_pvert=max(p_array(*,*,np_vert-1,*)/psurf_array(*,*,*))
           ; The maximum is 1.0, i.e. at surface
           max_pvert=1.0
        endif   
        ; Now apply limits if required
        if (vert_limits(0) ne 'min') then begin
           if (float(vert_limits(0)) lt min_pvert) then begin
              print, 'Can not achieve requested pressure:', $
                     vert_limits(0)
              print, 'adopting:', min_pvert
           endif else begin
              min_pvert=float(vert_limits(0))
           endelse           
        endif
        if (vert_limits(1) ne 'max') then begin
           if (float(vert_limits(1)) gt max_pvert) then begin
              print, 'Can not achieve requested pressure:', $
                     vert_limits(1)
              print, 'adopting:', max_pvert
           endif else begin
              max_pvert=float(vert_limits(1))
           endelse           
        endif
        ; Are we overiding the number of vertical
        ; levels in the pressure instance?
        if (KEYWORD_SET(np_levels_ovrd)) then $
           nvert_map=np_levels_ovrd
        ; Now we are requesting a set of levels 
        ; between min_pvert and max_pvert for 
        ; the mapping process. Finally we construct them        
        ; Sigma levels are distributed evenly in sigma
        if (vert_type eq 'Sigma') then $           
           vert_map=uni_sigma_vert_levs($
                    nvert_map, min_pvert, max_pvert) 
        ; Pressure levels are distributed evenly in log pressure
        if (vert_type eq 'Pressure') then $
           vert_map=uni_log_press_vert_levs($
                    nvert_map, max_pvert, min_pvert)
     endif 
  endif else begin
     ; For specific requested values we ignore
     ; the limits, and just set the value
     ; we don't care if it is pressure or
     ; sigma or height as we will deal with 
     ; the mapping later.
     nvert_map=1
     vert_map=FLOAT(vert_use)
  endelse
end

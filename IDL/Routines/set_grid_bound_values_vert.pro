function set_grid_bound_values_vert, vert_type, p0=p0,$
                                     lid_height=lid_height
  ; This returns the limits of the vertical grid

  grid_boundaries=safe_alloc_arr(1, 2, /float_arr)
  if (vert_type eq 'Height') then begin
     if (NOT(KEYWORD_SET(lid_height))) then begin
        print, 'Using height require lid height'
        print, 'to set boundary value'
        stop
     endif
     grid_boundaries(0)=0.0
     grid_boundaries(1)=lid_height
  endif else if (vert_type eq 'Pressure') then begin
     if (NOT(KEYWORD_SET(p0))) then begin
        print, 'Using height require p0'
        print, 'to set boundary value'
        stop
     endif
     grid_boundaries(0)=0.0
     grid_boundaries(1)=p0
  endif else if (vert_type eq 'Sigma') then begin
     grid_boundaries(0)=0.0
     grid_boundaries(1)=1.0                    
  endif
  return, grid_boundaries
end

pro check_map_limit, vert_type, $
                     map_grid_use, map_limits, $
                     p_lon, p_lat, p_vert, p_time, $
                     p_array, p_surf_array, $
                     lid_height=lid_height, $
                     verbose=verbose    
  ; This performs a few minor checks on the array
  ; bounds.
  ; **WORK** This should be continually updated
  if (KEYWORD_SET(verbose)) then begin
     print, 'Check_map_limit only checks time and vertical bounds'
     print, 'As min/max longitude and latitude vary on grids'
     print, 'Maximum and Minimum height/pressure/sigma is defined.'
  endif
  ; Err flag
  err=0
  ; Err Message
  err_msg='check_plot_map_limit.pro-Error:'
  ; Currently only check time, as interpolation should 
  ; take care of other checks (!?)
  if (map_limits(3,0) ne 'min') then begin
     if (float(map_limits(3,0)) lt min(p_time)) then begin
        err=1
        err_msg=err_msg+' Lower map limit time outside data bound'
     endif
  endif
  if (map_limits(3,1) ne 'max') then begin
     if (float(map_limits(3,1)) gt max(p_time)) then begin
        err=1
        err_msg=err_msg+' Upper map limit time outside data bound'
     endif
  endif
  ; Now check the vertical
  if (vert_type eq 'Height') then begin
     if (map_limits(2,0) ne 'min') then begin
        if (float(map_limits(2,0)) lt 0.0) then begin
           err=1
           err_msg=err_msg+' Lower map height less than zero'
        endif
     endif
     if (map_limits(2,1) ne 'max') then begin
        if (float(map_limits(2,1)) gt lid_height) then begin
           err=1
           err_msg=err_msg+' Upper map height greater than lid_height'
        endif
     endif
  endif else if (vert_type eq 'Pressure') then begin
     if (map_limits(2,0) ne 'min' AND $
         map_limits(2,0) ne 'max') then begin
        if (float(map_limits(2,0)) gt max(p_array) OR $
            float(map_limits(2,0)) lt min(p_array)) then begin
           err=1
           err_msg=err_msg+' Map pressure outside data bounds'
        endif
     endif
     if (map_limits(2,1) ne 'min' AND $
         map_limits(2,1) ne 'max') then begin
        if (float(map_limits(2,1)) gt max(p_array) OR $
            float(map_limits(2,1)) lt min(p_array)) then begin
           err=1
           err_msg=err_msg+' Map pressure outside data bounds'
        endif
     endif
  endif else if (vert_type eq 'Sigma') then begin
     if (map_limits(2,0) ne 'min') then begin
        if (float(map_limits(2,0)) gt 1.0) then begin
           err=1
           err_msg=err_msg+' Lower map sigma greater than 1.0'
        endif
     endif
     if (map_limits(2,1) ne 'max') then begin
        if (float(map_limits(2,1)) lt 0.0) then begin
           err=1
           err_msg=err_msg+' Upper map sigma less than 0.0'
        endif
     endif
  endif

  if (err eq 1) then begin
     print, 'There is a problem with the consistency'
     print, 'of plot array settings (check_map_limit):'
     print, err_msg
     stop
  endif
end

function find_horiz_time_limits_um_std, vert_type, grid_use, limits, $
                                        var_array, var_grid_size, $
                                        var_lon, var_lat, $
                                        var_vert, var_time, $
                                        verbose=verbose
  ; A function which uses the selection criteria to
  ; find the limits/sizes of the new array
  ; Set defaults, which is to retain whole array
  arr_size=INTARR(2)
  arr_size(0)=4
  arr_size(1)=2
  limit_pts=safe_alloc_arr(2, arr_size, /int_arr)
  limit_pts(*,0)=0
  limit_pts(0,1)=var_grid_size(0)-1
  limit_pts(1,1)=var_grid_size(1)-1
  limit_pts(2,1)=var_grid_size(2)-1
  limit_pts(3,1)=var_grid_size(3)-1
  if (KEYWORD_SET(verbose)) then begin
     print, 'Applying limits:'
     print, 'Longitude (min, max):', limits(0,*)
     print, 'Latitude (min, max):', limits(1,*)
     print, 'Time (min, max):', limits(3,*)
     print, 'Data extents before limiting:'
     print, 'Longitude (min, max):', min(var_lon), $
            max(var_lon)
     print, 'Latitude (min, max):', min(var_lat), $
            max(var_lat)
     print, 'Time (min, max):', min(var_time), $
            max(var_time)
     print, 'Array size:', size(var_array)
     print, 'Var Grid Size:', var_grid_size
  endif
  
  ; Now loop over dimensions and find the
  ; axis use, and the
  ; new start/end points
  for idim=0, 3 do begin   
     ; Don't do vertical 
     if (idim ne 2) then begin
        ; Set the grid to find limits in
        if (idim eq 0) then in_grid=var_lon
        if (idim eq 1) then in_grid=var_lat
        if (idim eq 2) then in_grid=var_vert
        if (idim eq 3) then in_grid=var_time
        ; For all, mean, or sum, apply limits
        ; Or an axes of either sort (plotting)
        if (grid_use(idim) eq 'all' or $
            grid_use(idim) eq 'sum' or $
            grid_use(idim) eq 'max' or $
            grid_use(idim) eq 'min' or $
            grid_use(idim) eq 'y' or $
            grid_use(idim) eq 'x' or $
            grid_use(idim) eq 'mean') then begin
           if (limits(idim, 0) ne 'min') then begin
              ; Find the new bottom        
              find_interp_grid_boundaries, in_grid, float(limits(idim,0)), $
                                           grid_val_bounds, $
                                           grid_index_bounds
              if (KEYWORD_SET(verbose)) then begin
                 print, 'Limiting axes: ', idim, ' with ', limits(idim,0)
                 print, 'Recovered bounds (indices, values): ',$
                        grid_index_bounds(*),  $
                        grid_val_bounds(*)
                 print, 'Using index:', min(grid_index_bounds)
              endif
              ; Choose lowest one to make sure it is in the array
              limit_pts(idim,0)=min(grid_index_bounds(*))
           endif
           if (limits(idim,1) ne 'max') then begin
              ; Find the new top
              find_interp_grid_boundaries, in_grid, float(limits(idim,1)),$
                                           grid_val_bounds, $
                                           grid_index_bounds
              if (KEYWORD_SET(verbose)) then begin
                 print, 'Limiting axes: ', idim, ' with ', limits(idim,1)
                 print, 'Recovered bounds (indices, values): ',$
                        grid_index_bounds(*),  $
                        grid_val_bounds(*)
                 print, 'Using index:', max(grid_index_bounds)
              endif
              ; Choose highest one to make sure it is in the array
              limit_pts(idim,1)=max(grid_index_bounds(*))
           endif
        endif else begin
           ; For values find the bounds
           ; i.e. limitations are ignored
           find_interp_grid_boundaries, in_grid, float(grid_use(idim)), $
                                        grid_val_bounds, $
                                        grid_index_bounds
           if (KEYWORD_SET(verbose)) then begin
              print, 'Selecting point on axes: ', idim, ' at ',$
                     grid_use(idim)
              print, 'Recovered bounds (value, index): ', grid_val_bounds(*), $
                     grid_index_bounds(*)
           endif
           ; Place bounds in the location array
           limit_pts(idim,0)=min(grid_index_bounds(*))
           limit_pts(idim,1)=max(grid_index_bounds(*))
        endelse
     endif
  endfor
  return, limit_pts
end

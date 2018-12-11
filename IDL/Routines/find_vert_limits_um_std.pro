function find_vert_limits_um_std, vert_type, vert_use, vert_limits, $
                                  var_array, vert_size, $
                                  var_vert, $
                                  verbose=verbose
  ; Function which finds the limits in position/size
  ; given the requests of a standard um array
  ; First decide how axis is incremented
  index_increment='positive' ; default is height
  if (vert_type eq 'Sigma' or vert_type eq 'Pressure') then begin
     index_increment='negative'
  endif
  ; Set defaults, to retain whole array
  limit_pts=INTARR(2)  
  limit_pts(0)=0
  limit_pts(1)=vert_size-1
  if (KEYWORD_SET(verbose)) then begin
     print, 'Applying plotting limits to vertical'
     print, 'Before limiting:'
     print, 'Vertical (size, min, max):', $
            vert_size, min(var_vert), max(var_vert)
     print, 'Array size:', size(var_array)
  endif
  ; Are we using the vertical as an axes, retaining all
  ; or averaging or summing? Or even selecting a value?
  if (vert_use eq 'all' or $
      vert_use eq 'min' or $
      vert_use eq 'max' or $
      vert_use eq 'sum' or $
      vert_use eq 'mean' or $
      vert_use eq 'x' or $
      vert_use eq 'y') then begin
     if (vert_limits(0) ne 'min') then begin
        ; We must find the new bottom point
        find_interp_grid_boundaries, var_vert, float(vert_limits(0)), $
                                     grid_val_bounds, $
                                     grid_index_bounds, $
                                     index_increment=index_increment
        ; Need to choose the correct value to encompass the request
        ; this is different if it is a height, or pressures
        ; the "minimum" or (0) entry should be the lowest value of pressure
        ; or sigma (top of model), and the lowest height (bottom of model). 
        ; highest height this is checkwd in check_plot_arr_req.pro
        if (vert_type eq 'Pressure' or vert_type eq 'Sigma') then begin
           ; This is a minimum, and we are working in pressure/sigma
           ; i.e. lowest value at the top of the array.
           ; Therefore, we need to lowest pressure
           if (grid_val_bounds(0) lt grid_val_bounds(1)) then begin
              limit_pts(0)=grid_index_bounds(0)
           endif else if (grid_val_bounds(0) gt grid_val_bounds(1)) then begin
              limit_pts(0)=grid_index_bounds(1)
           endif else if (grid_val_bounds(0) eq grid_val_bounds(1)) then begin
              limit_pts(0)=grid_index_bounds(0)
           endif
        endif else if (vert_type eq 'Height') then begin
           ; for height we need to highest height
           if (grid_val_bounds(0) lt grid_val_bounds(1)) then begin
              limit_pts(0)=grid_index_bounds(1)
           endif else if (grid_val_bounds(0) gt grid_val_bounds(1)) then begin
              limit_pts(0)=grid_index_bounds(0)
           endif else if (grid_val_bounds(0) eq grid_val_bounds(1)) then begin
              limit_pts(0)=grid_index_bounds(0)
           endif
        endif else begin
           print, 'Vert_type:', vert_type
           print, 'not recognised in find_vert_limits_um_std.pro'
           stop
        endelse
        if (KEYWORD_SET(verbose)) then begin
           print, 'Limiting Vertical with (minimum):',  vert_limits(0)
           print, 'Recovered bounds (indices, values): ',$
                  grid_index_bounds(*),  $
                  grid_val_bounds(*)
           print, 'Using index:', limit_pts(0)
        endif
     endif

     print, vert_limits(1)
     
     if (vert_limits(1) ne 'max') then begin
        find_interp_grid_boundaries, var_vert, float(vert_limits(1)),$
                                     grid_val_bounds, $
                                     grid_index_bounds, $
                                     index_increment=index_increment
        ; Need to choose the correct value to encompass the request
        ; this is different if it is a height, or pressure/s
        if (vert_type eq 'Pressure' or vert_type eq 'Sigma') then begin
           ; This is a maximum, and we are working in pressure/sigma
           ; i.e. highest value at the bottom of the array.
           ; Therefore, we need to highest pressure
           if (grid_val_bounds(0) lt grid_val_bounds(1)) then begin
              limit_pts(1)=grid_index_bounds(1)
           endif else if (grid_val_bounds(0) gt grid_val_bounds(1)) then begin
              limit_pts(1)=grid_index_bounds(0)
           endif else if (grid_val_bounds(0) eq grid_val_bounds(1)) then begin
              limit_pts(1)=grid_index_bounds(0)
           endif
        endif else if (vert_type eq 'Height') then begin
           ; for height we need to lowest height
           if (grid_val_bounds(0) lt grid_val_bounds(1)) then begin
              limit_pts(1)=grid_index_bounds(0)
           endif else if (grid_val_bounds(0) gt grid_val_bounds(1)) then begin
              limit_pts(1)=grid_index_bounds(1)
           endif else if (grid_val_bounds(0) eq grid_val_bounds(1)) then begin
              limit_pts(1)=grid_index_bounds(1)
           endif
        endif else begin
           print, 'Vert_type:', vert_type
           print, 'not recognised in find_vert_limits_um_std.pro'
           stop
        endelse
        if (KEYWORD_SET(verbose)) then begin
           print, 'Limiting Vertical with (maximum):',  vert_limits(1)
           print, 'Recovered bounds (indices, values): ',$
                  grid_index_bounds(*),  $
                  grid_val_bounds(*)
           print, 'Using index:', limit_pts(1)
        endif
     endif
  endif else begin
     ; For values find the bounds
     find_interp_grid_boundaries, var_vert, float(vert_use), $
                                  grid_val_bounds, $
                                  grid_index_bounds, $
                                  index_increment=index_increment
     if (KEYWORD_SET(verbose)) then begin
        print, 'Selecting vertical grid points:', vert_use
        print, 'Recovered bounds (value, index): ', grid_val_bounds(*), $
               grid_index_bounds(*)
     endif
     ; Place bounds in the location array
     limit_pts(0)=min(grid_index_bounds)
     limit_pts(1)=max(grid_index_bounds)
  endelse
  ; Finally, we have to account for the indices switching in pressure coordinates
  if (limit_pts(0) gt limit_pts(1)) then begin
     temp=limit_pts(0)
     limit_pts(0)=limit_pts(1)
     limit_pts(1)=temp
     temp=0
     if (KEYWORD_SET(verbose)) then begin
        print, 'WARNING*********'
        print, 'Switching limit points, this is usually due to pressure coordinates'
        print, 'vert_type:', vert_type
     endif
  endif
  return, limit_pts
end

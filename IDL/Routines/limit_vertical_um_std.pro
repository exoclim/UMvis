pro limit_vertical_um_std, vert_type, vert_use, vert_limits, $
                           var_array, grid_size, $
                           var_vert, $
                           verbose=verbose
  ; Procedure which limits the input array,
  ; in the vertical dimension given the vert_use 
  ; and vert_type, by the vert_limits variable
  ; First find the limits in size and array position
  limit_pts=find_vert_limits_um_std(vert_type, vert_use, vert_limits, $
                                    var_array, grid_size(2), $
                                    var_vert, $
                                    verbose=verbose)
  ; Now we must get the new axis sizes
  ; Now get the new axis size
  grid_size(2)=(limit_pts(1)-limit_pts(0)+1)
  ; Now create the output
  ; Now create output axes and arrays
  var_vert_temp=var_vert
  var_vert=0
  var_vert=safe_alloc_arr(1, grid_size(2), /float_arr)
  var_vert(*)=var_vert_temp(limit_pts(0):limit_pts(1))
  var_temp=var_array
  var_array=0
  var_array=safe_alloc_arr(4, grid_size, /float_arr)
  var_array(*,*,*,*)=var_temp(*,*,limit_pts(0):limit_pts(1),*)

  if (KEYWORD_SET(verbose)) then begin
     print, 'Data vertical extents after limiting:'
     print, 'Vertical (min, max):', min(var_vert), $
            max(var_vert)
     print, 'Array size:', size(var_array)
     print, 'Grid Size:', grid_size
  endif
end

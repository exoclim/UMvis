pro limit_horiz_time_um_std, vert_type, grid_use, limits, $
                             var_array, var_grid_size, $
                             var_lon, var_lat, $
                             var_vert, var_time, $
                             verbose=verbose
  ; Procedure which limits the input array,
  ; and associated grids, given the input limits.
  ; And the requested use of the axes in grid_use

  ; Find the limits in size of new array
  limit_pts=find_horiz_time_limits_um_std(vert_type, grid_use, limits, $
                                     var_array, var_grid_size, $
                                     var_lon, var_lat, $
                                     var_vert, var_time, $
                                     verbose=verbose)
  ; Now we must get the new axis sizes
  ; Now get the new axes size
  for idim=0, 3 do begin
     var_grid_size(idim)=(limit_pts(idim,1)-limit_pts(idim,0)+1)
  endfor
  ; First we must find out how we are using the array
  ; For averages, sums or axes we retain the whole array
  ; between the limits, for values we only retain 
  ; the bounding values.
  ; Now create output axes and arrays
  var_lon_temp=var_lon
  var_lat_temp=var_lat
  var_vert_temp=var_vert
  var_time_temp=var_time
  var_lon=0
  var_lat=0
  var_vert=0
  var_time=0
  var_lon=safe_alloc_arr(1, var_grid_size(0), /float_arr)
  var_lat=safe_alloc_arr(1, var_grid_size(1), /float_arr)
  var_vert=safe_alloc_arr(1, var_grid_size(2), /float_arr)
  var_time=safe_alloc_arr(1, var_grid_size(3), /float_arr)
  var_lon(*)=var_lon_temp(limit_pts(0,0):limit_pts(0,1))
  var_lat(*)=var_lat_temp(limit_pts(1,0):limit_pts(1,1))
  var_vert(*)=var_vert_temp(limit_pts(2,0):limit_pts(2,1))
  var_time(*)=var_time_temp(limit_pts(3,0):limit_pts(3,1))
  var_temp=var_array
  var_array=0
  var_array=safe_alloc_arr(4, var_grid_size, /float_arr)
  var_array(*,*,*,*)=var_temp(limit_pts(0,0):limit_pts(0,1), $
                            limit_pts(1,0):limit_pts(1,1), $
                            limit_pts(2,0):limit_pts(2,1), $
                            limit_pts(3,0):limit_pts(3,1))
  if (KEYWORD_SET(verbose)) then begin
     print, 'Data extents after limiting:'
     print, 'Longitude (min, max):', min(var_lon), $
            max(var_lon)
     print, 'Latitude (min, max):', min(var_lat), $
            max(var_lat)
     print, 'Time (min, max):', min(var_time), $
            max(var_time)
     print, 'Array size:', size(var_array)
     print, 'Var Grid Size:', var_grid_size
  endif
end




pro set_4d_interp_std_arg, vert_type, $
                           old_grid_size,$
                           old_lon, old_lat, old_vert, old_time, $
                           new_grid_size,$
                           new_lon, new_lat, new_vert, new_time, $
                           var_vert_bounds, $
                           bounding_string, grid_boundaries, $
                           var_boundaries, index_per, grid_period, $
                           axes_index_incr, lid_height,$
                           old_grid, new_grid
  ; This routine setups the arguments to 
  ; linear_interp_multid, for a standard 4D UM array
  ; i.e. var(longitude, latitude, height, time)
  ; The only arg not set is which_interp, which
  ; selects which axes are to be interpolated

  ; Fill up a single array for the grid
  arr_size=INTARR(2)
  arr_size(0)=4
  arr_size(1)=max(old_grid_size)
  old_grid=safe_alloc_arr(2, arr_size, /float_arr)
  old_grid(0,0:old_grid_size(0)-1)=old_lon
  old_grid(1,0:old_grid_size(1)-1)=old_lat
  old_grid(2,0:old_grid_size(2)-1)=old_vert
  old_grid(3,0:old_grid_size(3)-1)=old_time
  new_grid=safe_alloc_arr(2, arr_size, /float_arr)
  new_grid(0,0:new_grid_size(0)-1)=new_lon
  new_grid(1,0:new_grid_size(1)-1)=new_lat
  new_grid(2,0:new_grid_size(2)-1)=new_vert
  new_grid(3,0:new_grid_size(3)-1)=new_time
  ; Now the boundary treatment
  bounding_string=safe_alloc_arr(1, 4, /string_arr)
  bounding_string(*)=''
  ; Longitude is periodic
  bounding_string(0)='periodic'
  ; Latitude is polar
  bounding_string(1)='polar'
  ; Vertical has surfaces
  bounding_string(2)='value'
  ; Time is normal
  bounding_string(3)=''
  arr_size(1)=2
  grid_boundaries=safe_alloc_arr(2, arr_size, /float_arr)
  grid_boundaries(0,*)=0.0
  grid_boundaries(1,*)=0.0
  grid_boundaries(2,0)=0.0
  grid_boundaries(2,1)=lid_height  
  grid_boundaries(3,*)=0.0
  var_boundaries=safe_alloc_arr(2, arr_size, /float_arr)
  ; Currently assume values tend to
  ; zero outside grid, needs sorting**
  var_boundaries(0,*)=0.0
  var_boundaries(1,*)=0.0
  var_boundaries(2,0)=var_vert_bounds(0)
  var_boundaries(2,1)=var_vert_bounds(1)
  var_boundaries(3,*)=0.0  
  ; For the polar index, it needs
  ; to know which index is periodic
  index_per=safe_alloc_arr(1, 4, /string_arr)
  index_per(0)=-1
  index_per(1)=0 ; for latitude interp, longitude is the periodic axis
  index_per(2)=-1
  index_per(3)=-1
  ; What is the period of the periodic axis (longitude)
  grid_period=360.0   
  ; Now set what tpye of axis increment this is
  ; i.e. positive is height/lon/lat negative would be pressure
  ; as pressure decreases with index, but other increase
  axes_index_incr=safe_alloc_arr(1, 4, /string_arr)
  axes_index_incr(0)='positive'
  axes_index_incr(1)='positive'
  axes_index_incr(2)='positive'
  axes_index_incr(3)='positive'
end

pro limit_map, vert_type, map_grid_use, map_limits, $
               p_array, psurf_array, p_grid_size, $
               p_lon, p_lat, p_vert, p_time, $
               p0, lid_height, min_val, $
               var_array, var_grid_size, $
               var_lon, var_lat, var_vert, var_time, $
               var_vert_bounds, $
               ivar, $
               nvert_map, vert_map, $
               np_levels_ovrd=np_levels_ovrd, $
               verbose=verbose
  ; This procedure limits the variable array, as requested
  ; in map_limits, and then maps it onto the required 
  ; vertical coordinate as described in vert_type

  ; First we perform the cuts/limitations prescribed
  ; in the map_limit array to the horizontal
  ; axes and time (vertical might be mapped)
  limit_horiz_time_um_std, vert_type, map_grid_use, map_limits, $
                           var_array, var_grid_size, $
                           var_lon, var_lat, var_vert, var_time, $
                           verbose=verbose
  ; var_array should now be limited (as should var_lon etc)
  ; given the horizontal and time cuts in map_limits
  ; Now we setup the vertical scale-IF this is the first
  ; variable to be constructed.
  if (ivar eq 0) then begin
     set_vertical_scale, vert_type, map_grid_use(2), $
                         map_limits(2,*), $
                         p_array, psurf_array, p_grid_size(2),$
                         var_grid_size(2), var_vert, $
                         nvert_map, vert_map, $
                         p0, $
                         np_levels_ovrd=np_levels_ovrd, $
                         verbose=verbose
  endif
  ; Now we map the variable onto the required vertical grid
  vertical_mapping, vert_type, $
                    var_array, var_grid_size, $
                    var_lon, var_lat, var_vert, var_time, $
                    var_vert_bounds, $
                    p_array, p_grid_size, $
                    p_lon, p_lat, p_vert, p_time, $
                    psurf_array, $
                    nvert_map, vert_map,$
                    missing=missing, $
                    lid_height, p0
  ; Now we should have our mapped, and cut variable
  ; in var_array(var_lon, var_lat, var_vert, var_time)
  ; =FLTARR(var_grid_size(0,1,2,3)
end

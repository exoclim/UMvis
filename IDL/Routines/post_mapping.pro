pro post_mapping, vert_type, map_grid_use, $
                  p0, lid_height, pi, min_val, $
                  var_array, var_grid_size, $
                  var_lon, var_lat, var_vert, var_time, $
                  var_vert_bounds, $
                  ivar, $
                  meri_mean_pt=meri_mean_pt, $
                  which_var_arr, $
                  var_combined, grid_size_combined, $
                  lon_combined, lat_combined, vert_combined, $
                  time_combined,$
                  var_vert_bounds_combined, $
                  verbose=verbose
  ; This routine performs averaging, slicing
  ; and summing after mapping

  ; Deal with averaging, summing and slicing
  ; for this specific variable
  mean_sum_slice, map_grid_use, $
                  p0, lid_height, pi, min_val, $
                  var_array, var_grid_size, $
                  var_lon, var_lat, var_vert, var_time, $
                  var_vert_bounds, $
                  meri_mean_pt=meri_mean_pt, $
                  /skip_vert_slice, $
                  verbose=verbose
  ; Now we deal with interpolating all variables
  ; onto the same grid structure
  ; WARNING: this routine will zero the var_array
  ; var_lon/lat/vert/time and var_grid_size variables
  common_grid_vars, ivar, vert_type, $
                    which_var_arr, $
                    var_array, var_grid_size, $
                    var_lon, var_lat, var_vert, var_time, $
                    var_vert_bounds, $
                    lid_height, min_val, $
                    var_combined, grid_size_combined, $
                    lon_combined, lat_combined, vert_combined, $
                    time_combined,$   
                    var_vert_bounds_combined, $                             
                    verbose=verbose
  ; Now var_combined=(ivar, combined_lon, combined_lat, combined_vert,
  ; combined_time), is each variable interpolated onto the same
  ; common grid=FLTARR(grid_size_combined(0,1,2,3)
end

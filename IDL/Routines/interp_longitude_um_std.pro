function interp_longitude_um_std, array_in,$
                                  current_lon, output_lon
  ; This routine takes a standard UM
  ; netcdf output array and interpolates the
  ; longitude column from the current_lon
  ; to output_lon
  ; It is basically a wrapper for 
  ; linear_interp_whole_axis
  ; Setup the standard stuff
  ndims=4
  ; Set which index is to be interpolated
  which_index=0
  ; Period of longitude is 360.0
  grid_period=360.0
  interpolated_array=linear_interp_whole_axis($
                     ndims, array_in, current_lon,$
                     output_lon,$
                     which_index, $
                     /periodic, $
                     grid_period=grid_period)
  return, interpolated_array
end

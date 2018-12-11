function interp_latitude_um_std, array_in,$
                                 current_lat, output_lat
  ; This routine takes a standard UM
  ; netcdf output array and interpolates the
  ; latitude column from the current_lat
  ; to output_lat
  ; It is basically a wrapper for 
  ; linear_interp_whole_axis
  ; Setup the standard stuff
  ndims=4
  ; Set which index is to be interpolated
  which_index=1
  ; Latitude is polar and longitude is periodic
  ; with a period of 360.0
  index_per=0
  grid_period=360.0
  interpolated_array=linear_interp_whole_axis($
                     ndims, array_in, current_lat,$
                     output_lat,$
                     which_index, $
                     /polar, $
                     index_per=index_per, $
                     grid_period=grid_period)
  return, interpolated_array
end

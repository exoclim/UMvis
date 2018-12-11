function interp_height_um_std, array_in,$                            
                               current_height, $
                               output_height, $
                               lid_height, $
                               var_vert_bounds=var_vert_bounds
  ; This routine takes a standard UM
  ; netcdf output array and interpolates the
  ; height column from the current_height
  ; to output_height
  ; NOTE THIS WORKS FOR HEIGHT GRID
  ; NOT PRESSURE
  ; It is basically a wrapper for 
  ; linear_interp_whole_axis
  ; Setup the standard stuff
  ndims=4
  ; Set which index is to be interpolated
  which_index=2
  ; Height has limits
  vert_type='Height'
  grid_boundaries=set_grid_bound_values_vert($
                  vert_type, lid_height=lid_height)
  if (KEYWORD_SET(var_vert_bounds)) then begin
     var_boundaries=var_vert_bounds
  endif else begin
     var_boundaries=safe_alloc_arr(1, 2, /float_arr)
     var_boundaries(0)=0.0
     var_boundaries(1)=0.0 
  endelse
  interpolated_array=linear_interp_whole_axis($
                     ndims, array_in, current_height,$
                     output_height,$
                     which_index, $
                     /value, $
                     grid_boundaries=grid_boundaries, $
                     var_boundaries=var_boundaries)
  return, interpolated_array
end

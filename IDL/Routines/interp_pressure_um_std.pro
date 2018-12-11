function interp_pressure_um_std, array_in,$                            
                                 current_pressure, $
                                 output_pressure, $
                                 p0, $
                                 var_vert_bounds=var_vert_bounds
  ; This routine takes a standard UM
  ; netcdf output array and interpolates the
  ; pressure column from the current_pressure
  ; to output_pressure
  ; It is basically a wrapper for 
  ; linear_interp_whole_axis
  ; Setup the standard stuff
  ndims=4
  ; Set which index is to be interpolated
  which_index=2
  vert_type='Pressure'  
  grid_boundaries=set_grid_bound_values_vert($
                  vert_type, p0=p0)
  if (KEYWORD_SET(var_vert_bounds)) then begin
     var_boundaries=var_vert_bounds
  endif else begin
     var_boundaries=safe_alloc_arr(1, 2, /float_arr)
     var_boundaries(0)=0.0
     var_boundaries(1)=0.0 
  endelse
  ; Shift to ln(pressure) for more accurate interpolation
  ln_current_pressure=ALOG(current_pressure)
  ln_output_pressure=ALOG(output_pressure)
  ln_grid_boundaries=ALOG(grid_boundaries)
  interpolated_array=linear_interp_whole_axis($
                     ndims, array_in, ln_current_pressure,$
                     ln_output_pressure,$
                     which_index, $
                     /value, $
                     grid_boundaries=ln_grid_boundaries, $
                     var_boundaries=var_boundaries)
  ; Zero the ln arrays
  ln_current_pressure=0
  ln_output_pressure=0
  return, interpolated_array
end

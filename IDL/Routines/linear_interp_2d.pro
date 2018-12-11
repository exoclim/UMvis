function linear_interp_2d, which_index, var_bounds, eta
  ; A simple routine to perform linear interpolation
  ; of a 2D array var_out(*,*)
  ; given the weighting (eta) and boundary values
  ; depending on which index is used
  ; Get the sizes
  var_dim=size(var_bounds)
  if (var_dim(0) ne 2) then begin
     print, 'Error expecting array with two'
     print, 'dimension in linear_interp_2d'
     print, 'Actual number of dimensions:', var_dim(0)
     stop
  endif

  arr_size=INTARR(2)
  if (which_index eq 0) then begin
     arr_size(0)=1
     arr_size(1)=var_dim(2)
     var_out=safe_alloc_arr(2, arr_size, /float_arr)
     var_out(0,*)=(1.0-eta)*var_bounds(0,*)+$
                      eta*var_bounds(1,*)
  endif else if (which_index eq 1) then begin
     arr_size(0)=var_dim(1)
     arr_size(1)=1
     var_out=safe_alloc_arr(2, arr_size, /float_arr)
     var_out(*,0)=(1.0-eta)*var_bounds(*,0)+$
                      eta*var_bounds(*,1) 
  endif
  return, var_out
end

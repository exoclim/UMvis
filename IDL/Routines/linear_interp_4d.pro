function linear_interp_4d, which_index, var_bounds, eta
  ; A simple routine to perform linear interpolation
  ; of a 4D array var_out(*,*,*,*)
  ; given the weighting (eta) and boundary values
  ; depending on which index is used
  ; Get the sizes
  var_dim=size(var_bounds)
  if (var_dim(0) ne 4) then begin
     print, 'Error expecting array with four'
     print, 'dimension in linear_interp_4d'
     print, 'Actual number of dimensions:', var_dim(0)
     stop
  endif
  arr_size=INTARR(4)
  if (which_index eq 0) then begin
     arr_size(0)=1
     arr_size(1)=var_dim(2)
     arr_size(2)=var_dim(3)
     arr_size(3)=var_dim(4)
     var_out=safe_alloc_arr(4, arr_size, /float_arr)
     var_out(0,*,*,*)=(1.0-eta)*var_bounds(0,*,*,*)+$
                      eta*var_bounds(1,*,*,*)
  endif else if (which_index eq 1) then begin
     arr_size(0)=var_dim(1)
     arr_size(1)=1
     arr_size(2)=var_dim(3)
     arr_size(3)=var_dim(4)
     var_out=safe_alloc_arr(4, arr_size, /float_arr)
     var_out(*,0,*,*)=(1.0-eta)*var_bounds(*,0,*,*)+$
                      eta*var_bounds(*,1,*,*)     
  endif else if (which_index eq 2) then begin
     arr_size(0)=var_dim(1)
     arr_size(1)=var_dim(2)
     arr_size(2)=1
     arr_size(3)=var_dim(4)
     var_out=safe_alloc_arr(4, arr_size, /float_arr)
     var_out(*,*,0,*)=(1.0-eta)*var_bounds(*,*,0,*)+$
                      eta*var_bounds(*,*,1,*)     
  endif else if (which_index eq 3) then begin
     arr_size(0)=var_dim(1)
     arr_size(1)=var_dim(2)
     arr_size(2)=var_dim(3)
     arr_size(3)=1
     var_out=safe_alloc_arr(4, arr_size, /float_arr)
     var_out(*,*,*,0)=(1.0-eta)*var_bounds(*,*,*,0)+$
                      eta*var_bounds(*,*,*,1)          
  endif
  return, var_out
end

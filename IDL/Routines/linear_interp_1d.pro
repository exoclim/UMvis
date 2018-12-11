function linear_interp_1d, var_bounds, eta
  ; A simple routine to perform linear interpolation
  ; of a 1D array var_out
  ; given the weighting (eta) and boundary values
  ; Get the sizes
  var_dim=size(var_bounds)
  if (var_dim(0) ne 1) then begin
     print, 'Error expecting array with one'
     print, 'dimension in linear_interp_1d'
     print, 'Actual number of dimensions:', var_dim(0)
     stop
  endif
  var_out=(1.0-eta)*var_bounds(0)+$
               eta*var_bounds(1)
  return, var_out
end

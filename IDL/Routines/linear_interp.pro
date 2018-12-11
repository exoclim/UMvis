function linear_interp, var_bounds, eta
  ; A simple routine to perform linear interpolation
  ; given the weighting (eta) and boundary values
  var_out=(1.0-eta)*var_bounds(0)+$
          eta*var_bounds(1)
  return, var_out
end

function linear_interp_eta, bounds, value
  ; This routine simply derives the eta
  ; value for linear interpolation
  eta=0.0
  if (bounds(1)-bounds(0) eq 0.0) then begin
     eta=0.5
  endif else begin
     eta=(value-bounds(0)) /        $
         (bounds(1)-bounds(0))
  endelse
  return, eta
end

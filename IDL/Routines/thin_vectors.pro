function thin_vectors, array_in, nx, ny, $
                       thin_factor, missing
  ; This function thins out vectors in array_in
  ; setting the unwanted ones to missing
  ; i.e thin=2.0 we miss out half the points
  ; thin_factor=1 is all the points

  ; Create the output
  thinned=fltarr(nx,ny)
  ; Fill the array
  thinned=array_in
  for iy=0, ny-1 do begin
     if ((iy mod thin_factor) ne 0) then begin
        thinned(*,iy)=missing
     endif else begin
        for ix=0, nx-1 do begin
           ; Check if this is a multiple of
           ; thin_factor
           if ((ix mod thin_factor) ne 0) then thinned(ix,*)=missing
        endfor
     endelse
  endfor
  return, thinned
end

FUNCTION minloc, f
	;
	;  Corresponds to the Fortran-90/95 function minLOC,
	;  which returns an array of indices to the min.
	;  The IDL function min(F,M) returns a one-dimensional
	;  index to the minimum, which may be converted to 3D
	;  by division with the size of planes and rows.
	;-

  sz=size(f)
  fm=min(f,m)
  if sz[0] eq 1 then begin
     ix=m
     return,ix
  end else if sz[0] eq 2 then begin
     iy=m/sz[1]
     ix=m-iy*sz[1]
     return,[ix,iy]
  end else if sz[0] eq 3 then begin
     iz=m/(sz[1]*sz[2])
     m=m-iz*sz[1]*sz[2]
     iy=m/sz[1]
     ix=m-iy*sz[1]
     return,[ix,iy,iz]
  end
END

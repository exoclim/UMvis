function calc_density, um_dense, z, planet_radius
  ; Function which calculates density from the UM
  ; density variable which is rho*r^2
  
  ; Height elements should be same
  nz=n_elements(z)
  density=um_dense
  density(*,*,*,*)=0.0
  ; Convert
  for k=0, nz-1 do begin
     density(*,*,k,*)=um_dense(*,*,k,*)/$
                      ((z(k)+planet_radius)^2.0)
  endfor
  return, density
end

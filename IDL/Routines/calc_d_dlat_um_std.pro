function calc_d_dlat_um_std, var_in, lat, pi
  ; A function which calculates the d/dphi of
  ; something (i.e. latitude)

  ; Set up output
  d_dphi=safe_alloc_um_std_template(var_in)
  d_dphi(*,*,*,*)=0.0
  arr_dim=size(var_in)
  n_lon=arr_dim(1)
  n_lat=arr_dim(2)
  n_vert=arr_dim(3)
  n_time=arr_dim(4)
  ; Use third order accurate intrinsic derivative
  ; First create latitude in radians
  lat_rad=deg_to_rad(lat, pi)
  for ilon=0, n_lon-1 do begin
     for ivert=0, n_vert-1 do begin
        for itime=0, n_time-1 do begin
           d_dphi(ilon,0:n_lat-1,ivert,itime)=$
              deriv(lat_rad, var_in(ilon,0:n_lat-1,ivert,itime))
        endfor
     endfor
  endfor  
  return, d_dphi
end

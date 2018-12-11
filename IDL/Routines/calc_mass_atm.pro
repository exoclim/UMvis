function calc_mass_atm, density, pi, Radius, lon, lat, z_theta
  ; This function calculates the total mass in each
  ; grid box.
  ; The total mass of the box is, obviously, the size of
  ; of the box times by the density.
  dimensions=size(density)
  n_lon=dimensions(1)
  n_lat=dimensions(2)
  n_heights=dimensions(3)
  nt=dimensions(4)
  arr_size=INTARR(4)
  arr_size(0)=n_lon
  arr_size(1)=n_lat
  arr_size(2)=n_heights
  arr_size(3)=nt
  ; Define the output array
  mass=safe_alloc_arr(4, arr_size, /float_arr)
  ; The integral for volume then expressed over finite
  ; difference element is:
  ; Because latitude is measured from the equator
  ; to pole, whereas is Standard spherical polar
  ; it is from the pole to equator!
  ; Therefore (lat=90-angle), and cos(90-angle)=sin(angle)
  ; dV=((r^3)/3  * (sin(lat2)-sin(lat(1))) * (lon2-lon1)
  ; Mass=Rho*((r2^3-r1^3)/3  * (sin(lat2)-sin(lat(1))) * (lon2-lon1)
  ; Breaking it into elements:
  ; dr=(r2^3-r1^3)/3
  ; dlon=(lon2-lon1)
  ; dlat=(sin(lat2)-sin(lat(1)))
  ; Therefore Mass=Rho*dr*dlon*dlat
  ; First setup the dlongitude
  ; As this is constant
  dlon=(2.0*pi)/n_elements(lon)
  ; The dlatitude is also a constant
  ; Used for grid sizes but only over pi not two*pi
  dlat_res=(pi)/n_elements(lat)
  ; Create a latitude in radians
  rad_lat=deg_to_rad(lat, pi)
  ; Loop over heights to interpolate
  for k=0, n_heights-1 do begin
     ; Setup up dr for this height
     if (k eq 0) then begin
        ; this is just the surface to top of first cell
        dr=((Radius+z_theta(k))^3.0-(Radius+0.0)^3.0)/3.0
     endif else begin
        dr=((Radius+z_theta(k))^3.0-(Radius+z_theta(k-1))^3.0)/3.0
     endelse
     for j=0, n_lat-1 do begin
        ; Finally setup dlat
        ; Use the cell centre then plus and minus half a
        ; grid size either way 
        dlat_inc=(SIN(rad_lat(j)+0.5*dlat_res)-$
                  SIN(rad_lat(j)-0.5*dlat_res))
        for i=0, n_lon-1 do begin
           mass(i,j,k,*)=(density(i,j,k,*)*dr*dlon*dlat_inc)
        endfor
     endfor
  endfor

  ; Calculate alternative Mass from Spherical Symmetry
  ; Just Mass=4*pi*r^2*dr*mass(i)
  mass_alt=safe_alloc_arr(1, nt, /float_arr)
  frac_diff_mass=safe_alloc_arr(1, nt, /float_arr)
  for it=0, nt-1 do begin
     mass_alt(it)=0.0
     for k=0, n_heights-1 do begin     
        if (k eq 0) then begin
           z_rho=0.5*z_theta(k)
           dr=z_theta(k)
        endif else begin
           z_rho=z_theta(k)-0.5*(z_theta(k)-z_theta(k-1))
           dr=(z_theta(k)-z_theta(k-1))
        endelse
        mass_alt(it)=mass_alt(it)+$
                     4.0*pi*((Radius+z_rho)^2.0)*dr*$
                     density(0,n_lat/2,k,it)
     endfor
     print, 'Total Mass at timestep:', it
     print, 'Full calc:', TOTAL(mass(*,*,*,it))
     print, 'Spherical Symmetry (density from equator, longitude=0.0:',$
            mass_alt(it)     
     frac_diff_mass(it)=(TOTAL(mass(*,*,*,it))-mass_alt(it))/TOTAL(mass(*,*,*,it))
  endfor
  print, 'Largest fractional difference between spherically symmetric estimate and full calculation:',$
         MAX(frac_diff_mass(*)), ' i.e. ', 100*MAX(frac_diff_mass(*)), '%'
  print, 'Fractional change from start to finish:', $
            (TOTAL(mass(*,*,*,nt-1))-TOTAL(mass(*,*,*,0)))/TOTAL(mass(*,*,*,0)), $
         ' i.e. ', (TOTAL(mass(*,*,*,nt-1))-TOTAL(mass(*,*,*,0)))/TOTAL(mass(*,*,*,0))*100, '%'
  return, mass
end

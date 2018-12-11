function calc_zon_ang_mmtm, mass, uvel_press, $
                            planet_radius, z_rho, lat, pi, omega, $
                            which_plot, $
                            eqn_type=eqn_type
  ; This function calculates the
  ; Zonal angular momentum given the 
  ; zonal wind and mass fields and the planetary rotation rate 

  ; First check that eqn type is set correctly
  eqn_type_check, eqn_type=eqn_type
  
  ; Angular momentum: L= r X Mv
  ; We create it on mass points, and interpolate wind
  ; For both codes we only need to interpolate
  ; for longitude points
  dim=size(mass)
  nlon=dim(1)
  nlat=dim(2)
  nvert=dim(3)
  ntime=dim(4)
  arr_size=INTARR(4)
  arr_size(0)=nlon
  arr_size(1)=nlat
  arr_size(2)=nvert
  arr_size(3)=ntime
  ang_mmtm=safe_alloc_arr(4, arr_size, /float_arr)

  for ivert=0, nvert-1 do begin
     for ilat=0, nlat-1 do begin
        ; L = r_axis X Mv, where r_axis is distance from the rotation axis
        ; therefore, r_axis = r cos(latitude) 
        ; Here velocity is zonal wind plus the rotational velocity
        ; at r, v_rot=Omega*r_axis
        factor=cos_deg_to_rad(lat(ilat),pi)
        if (eqn_type eq 'shallow') then begin
           r_axis=((planet_radius)*factor)
        endif else if (eqn_type eq 'deep') then begin
           r_axis=((planet_radius+z_rho(ivert))*factor)
        endif
        ang_mmtm(*,ilat,ivert,*)=(mass(*,ilat,ivert,*)*$
                                  r_axis*$
                                  (uvel_press(*,ilat,ivert,*)+$
                                   omega*r_axis))
     endfor
  endfor
  for it=0, ntime-1 do begin
     print, 'Sum ', which_plot, ' at timestep:', it, ' = ', $
            TOTAL(ang_mmtm(*,*,*,it))
  endfor
  print, 'Fractional change in total ', which_plot, ' from start to finish:',$
         (TOTAL(ang_mmtm(*,*,*,ntime-1))-TOTAL(ang_mmtm(*,*,*,0)))/$
         TOTAL(ang_mmtm(*,*,*,0)), $
         ' i.e. ', $
         (TOTAL(ang_mmtm(*,*,*,ntime-1))-TOTAL(ang_mmtm(*,*,*,0)))/$
         TOTAL(ang_mmtm(*,*,*,0))*100, $
         '%'
  return,ang_mmtm
end

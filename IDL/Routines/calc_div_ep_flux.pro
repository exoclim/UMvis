function calc_div_ep_flux, ep_lat, ep_vert, planet_radius, z, lat, $
                          eqn_type=eqn_type, min_val, pi
  ; This function calculates the divergence of
  ; The Eliassen-Palm flux using the equation in
  ; Hardiman et al (2010)
  ; Define the output array
  arr_size=INTARR(4)
  arr_size(0)=n_lon
  arr_size(1)=n_lat
  arr_size(2)=n_heights
  arr_size(3)=nt
  div_ep=safe_alloc_arr(4, arr_size, /float_arr)

  ; Loop over latitude and vertical for
  ; derivatives
  ; Go to one off top for interpolation
  for ivert=0,  n_heights-2 do begin
     radial_pos=$
        get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
     radial_pos_two=$
        get_radius(planet_radius, z(ivert+1), eqn_type=eqn_type)
     for ilat=0, n_lat-1 do begin
        inc_lat=ilat+1
        ; Stop if we hit the pole
        if (ilat eq n_lat-1) then begin
           print, 'Hit the pole in calc_total_speed.pro'
           print, 'Look at solution in mapvert_um and v_vel_onto_pressure.pro'
           stop
        endif
        cos_lat=cos_deg_to_rad(lat(ilat), pi)
        cos_lat_inc=cos_deg_to_rad(lat(inc_lat), pi)
        factor=1.0/(radial_pos*cos_lat)
        term_one=factor*$
                 (cos_lat_inc*ep_lat(*,inc_lat,ivert,*)-$
                  cos_lat*ep_lat(*,ilat,ivert,*))/$
                 (lat_rad_inc-lat_rad)
        factor_two=1.0/(radial_pos^2.0)
        term_two=factor*$
                 (radial_pos_two^2.0*ep_vert(*,ilat,ivert+1,*)-$
                  radial_pos^2.0*ep_vert(*,ilat,ivert,*))/$
                 (radial_pos_two-radial_pos)
        div_ep(*,ilat,ivert,*)=term_one+term_two
     endfor
  endfor
     ; Set the last one to zero
  div_ep(*,*,n_heights-1,*)=0.0
  return, div_ep
end

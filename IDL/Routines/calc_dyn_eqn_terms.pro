function calc_dyn_eqn_terms, fname, which_plot,$
                             u_in, v_in, w_in, rho_in, lat,$
                             n_lon, n_lat, n_heights, nt,$
                             z, planet_radius, omega, pi, $
                             eqn_type=eqn_type, lid_height
  
  ; This function calculates a term from the dynamical
  ; equations. (all inputs must be on pressure grid)
  ; Initial check if eqn_type is valid
  eqn_type_check, eqn_type=eqn_type

print, '********************************'
print, 'WARNING: these need to be checked'
print, '********************************'

  ; Define the output array
  arr_size=INTARR(4)
  arr_size(0)=n_lon
  arr_size(1)=n_lat
  arr_size(2)=n_heights
  arr_size(3)=nt
  term=safe_alloc_arr(4, arr_size, /float_arr)
  ; Switch between terms to calculate the value
  if (which_plot eq 'ueqn_metric_uvtan') then begin
     ;(u*v*tan(phi)/r)
     for ivert=0, n_heights-1 do begin
        radial_pos=$
           get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
        for ilat=0, n_lat-1 do begin
           tan_lat=tan_deg_to_rad(lat(ilat), pi)
           term(*,ilat,ivert,*)=$
              (u_in(*,ilat,ivert,*)*v_in(*,ilat,ivert,*)*$
               tan_lat)/radial_pos
        endfor
     endfor
  endif else if (which_plot eq 'ueqn_metric_uw') then begin
     ; -u*w/r
     ; This is ommited in the shallow version
     if (eqn_type eq 'shallow') then begin
        term(*,*,*,*)=0.0
     endif else begin
        for ivert=0, n_heights-1 do begin
           radial_pos=$
              get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
           term(*,*,ivert,*)=$
              -1.0* u_in(*,*,ivert,*)*w_in(*,*,ivert,*)/$
              radial_pos
        endfor
     endelse
  endif else if (which_plot eq 'ueqn_coriolis_vsin') then begin
     ; 2*Omega*v*sin(phi)
     for ilat=0, n_lat-1 do begin    
        sin_lat=sin_deg_to_rad(lat(ilat), pi)
        term(*,ilat,*,*)=$
           2.0*omega*v_in(*,ilat,*,*)*sin_lat
     endfor
  endif else if (which_plot eq 'ueqn_coriolis_wcos') then begin
     ; -2*Omega*w*cos(phi)
     if (eqn_type eq 'shallow') then begin
        term(*,*,*,*)=0.0
     endif else begin
        for ilat=0, n_lat-1 do begin    
           cos_lat=cos_deg_to_rad(lat(ilat), pi)
           term(*,ilat,*,*)=$
              -2.0*omega*w_in(*,ilat,*,*)*cos_lat
        endfor
     endelse
  endif else if (which_plot eq 'veqn_metric_utan') then begin
     ; -u^2 * tan(phi) / r
     for ivert=0, n_heights-1 do begin
        radial_pos=$
           get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
        for ilat=0, n_lat-1 do begin
           tan_lat=tan_deg_to_rad(lat(ilat), pi)
           term(*,ilat,ivert,*)=$
              (-1.0*(u_in(*,ilat,ivert,*)^2.0)*$
               tan_lat)/radial_pos
        endfor
     endfor
  endif else if (which_plot eq 'veqn_metric_vw') then begin
     ; -v*w/r
     if (eqn_type eq 'shallow') then begin
        term(*,*,*,*)=0.0
     endif else begin
        for ivert=0, n_heights-1 do begin
           radial_pos=$
              get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
           term(*,*,ivert,*)=$
              -1.0*v_in(*,*,ivert,*)*w_in(*,*,ivert,*)/$
              radial_pos
        endfor
     endelse
  endif else if (which_plot eq 'veqn_coriolis_usin') then begin
     ; -2*Omega*u*sin(phi)
     for ilat=0, n_lat-1 do begin    
        sin_lat=sin_deg_to_rad(lat(ilat), pi)
        term(*,ilat,*,*)=$
           -2.0*omega*u_in(*,ilat,*,*)*sin_lat
     endfor
  endif else if (which_plot eq 'weqn_metric_uv') then begin
     ;(u^.02 + v^2.0)/r
     if (eqn_type eq 'shallow') then begin
        term(*,*,*,*)=0.0
     endif else begin
        for ivert=0, n_heights-1 do begin
           radial_pos=$
              get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
           term(*,*,ivert,*)=$
              ((u_in(*,*,ivert,*)^2.0)+(v_in(*,*,ivert,*)^2.0))/$
              radial_pos
        endfor
     endelse
  endif else if (which_plot eq 'weqn_coriolis_ucos') then begin
     ; 2*Omega*u*cos(phi)
     if (eqn_type eq 'shallow') then begin
        term(*,*,*,*)=0.0
     endif else begin
        for ilat=0, n_lat-1 do begin    
           cos_lat=cos_deg_to_rad(lat(ilat), pi)
           term(*,ilat,*,*)=$
              2.0*omega*u_in(*,ilat,*,*)*cos_lat
        endfor
     endelse
  endif else if (which_plot eq 'rhoeqn_dw_dvert') then begin
     ; Either -rho/r^2 * d(r^2 w)/dr (deep) or -rho*dw/dz (shallow)
     ; First construct w term
     w_loc=safe_alloc_um_std_template(w_in)
     if (eqn_type eq 'deep') then begin
         ; r^2 w
        for ivert=0, n_heights-2 do begin   
           radial_pos=get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
           w_loc(*,*,ivert,*)=w_loc(*,*,ivert,*)*radial_pos^2.0
        endfor
     endif else begin
        w_loc(*,*,*,*)=w_in(*,*,*,*)
     endelse
     ; Now perform derivation, doesn't matter if it is z, or r
     ; difference is the same
     dw=calc_d_dvert_um_std(w_loc, z)
     ; No multiply by density, and divide by r^2 if required.
     if (eqn_type eq 'deep') then begin
         ; -rho/r^2 *d(r^2 w)/dr
        for ivert=0, n_heights-2 do begin       
           radial_pos=get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
           term(*,*,ivert,*)=-1.0*(rho(*,*,ivert,*)/radial_pos^2.0)*dw(*,*,ivert,*)
        endfor
     endif else begin
        ; -rho*dw/dz
        term(*,*,*,*)=-1.0*rho(*,*,ivert*,*)*dw(*,*,*,*)
     endelse
     term(*,*,n_heights-1,*)=0.0
  endif else begin
     print, 'Term not yet sorted in calc_momentum_terms.pro'
     print, which_plot
     stop     
  endelse
  return, term
end

function calc_hydrostasy, vert_type, $
                          p_array, p_vert, density, grav_surf, $
                          planet_radius, $
                          eqn_type=eqn_type, grav_type=grav_type,$
                          verbose=verbose
  ; Function calculates dp/dr+g*rho
  ; This can be called using different vertical types

  if (vert_type eq 'Height') then begin
     ; Create the output
     p_size=size(p_array)
     arr_dim=INTARR(4)
     arr_dim(0)=p_size(1)
     arr_dim(1)=p_size(2)
     arr_dim(2)=p_size(3)
     arr_dim(3)=p_size(4)
     hydrostasy=safe_alloc_arr(4, arr_dim, /float_arr)  
     hydrostasy(*,*,*,*)=0.0
     dense_size=size(density)
     for idim=0, 4 do begin
        if (not(p_size(idim) eq dense_size(idim))) then begin
           print, 'Trying to calculate hydrostasy'
           print, 'But pressure: ', p_size
           print, 'and density: ', dense_size
           print, 'array sizes different.'
           print, 'Stopping in calc_hydrostasy.pro'
           stop
        endif
     endfor
     ; Get gravity
     gravity=calc_grav(grav_surf, planet_radius, p_vert, p_size(3), $
                       grav_type=grav_type, verbose=verbose)
     for ilon=0, p_size(1)-1 do begin
        for ilat=0, p_size(2)-1 do begin
           for itime=0, p_size(4)-1 do begin
              ; First calculate dp/dr (dp/dr is equal to dp/dz)
              dp_dr=deriv(p_vert(0:p_size(3)-1), $
                          p_array(ilon,ilat,0:p_size(3)-1,itime))
              ; Now add g*rho
              hydrostasy(ilon,ilat,*,itime)=$
                 dp_dr(*)+(gravity(*)*density(ilon,ilat,*,itime))
           endfor
        endfor
     endfor
  endif else if (vert_type eq 'Pressure') then begin
     ; Need the dp/dr + g*rho
     ; In this case the p_array is just the vertical pressure
     ; coordinate, and the p_vert is the height on pressure levels
     r_size=size(p_vert)
     arr_dim=INTARR(4)
     arr_dim(0)=r_size(1)
     arr_dim(1)=r_size(2)
     arr_dim(2)=r_size(3)
     arr_dim(3)=r_size(4)
     hydrostasy=safe_alloc_arr(4, arr_dim, /float_arr)  
     hydrostasy(*,*,*,*)=0.0
     r_size=size(p_vert)
     dense_size=size(density)
     for idim=0, 4 do begin
        if (not(r_size(idim) eq dense_size(idim))) then begin
           print, 'Trying to calculate hydrostasy'
           print, 'But height on pressure: ', r_size
           print, 'and density: ', dense_size
           print, 'array sizes different.'
           print, 'Stopping in calc_hydrostasy.pro'
           stop
        endif
     endfor
     for ilon=0, r_size(1)-1 do begin
        for ilat=0, r_size(2)-1 do begin
           for itime=0, r_size(4)-1 do begin
             ; Get gravity at the height for each pressure level
              gravity=calc_grav(grav_surf, planet_radius, $
                                p_vert(ilon,ilat,0:r_size(3)-1,itime), $
                                r_size(3), $
                                grav_type=grav_type)
              ; Now calculate dp/dr (dp/dr is equal to dp/dz)
              ; Recall that here the height is on pressure surfaces
              ; and 4D, but the pressure at each height is now 1D
              dp_dr=deriv(p_vert(ilon,ilat,0:r_size(3)-1,itime), $
                          p_array(0:r_size(3)-1))
              ; Now add g*rho
              hydrostasy(ilon,ilat,*,itime)=$
                 dp_dr(*)+(gravity(*)*density(ilon,ilat,*,itime))
           endfor
        endfor
     endfor
  endif else if (vert_type eq 'Sigma') then begin
     print, 'Not included hydrostatic calculation using'
     print, 'sigma coordinates yet, stopping in calc_hydrostasy.pro'
     stop
  endif else begin
     print, 'Vert type: ', vert_type
     print, 'not recognised in calc_hydrostasy.pro, stopping'
     stop
  endelse
  return, hydrostasy
end

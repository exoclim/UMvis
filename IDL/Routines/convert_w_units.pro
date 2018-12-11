function convert_w_units, vert_type, w_in, vert, $
                          radius_map=radius_map
  ; A function to convert the vertical velocity
  ; to the required units.
  w_out=safe_alloc_um_std_template(w_in)
  if (vert_type eq 'Height') then begin
     ; No change
     w_out(*,*,*,*)=w_in(*,*,*,*)
  endif else if (vert_type eq 'Pressure') then begin
     if (KEYWORD_SET(radius_map)) then begin
        ; To convert from dr/dt to dp/dt we require dp/dr
        dp_dr=safe_alloc_um_std_template(w_in)
        arr_size=size(w_in)
        for ilon=0, arr_size(1)-1 do begin
           for ilat=0, arr_size(2)-1 do begin
              for itime=0, arr_size(4)-1 do begin           
                 dp_dr(ilon,ilat,0:arr_size(3)-1,itime)=$
                    deriv(radius_map(ilon,ilat,0:arr_size(3)-1,itime), $
                          vert(0:arr_size(3)-1))
              endfor
           endfor
        endfor
        ; Now mutiplty w_in*dp_dr -> dp/dt
        w_out(*,*,*,*)=w_in(*,*,*,*)*dp_dr(*,*,*,*)
     endif else begin
        print, 'Radius on pressure surfaces required'
        print, 'to convert w from m/s to Pa/s'
        print, 'Stopping in convert_w_units.pro'
        stop
     endelse
  endif else if (vert_type eq 'Sigma') then begin
     print, 'Sigma coordinates not yet coded for converting'
     print, 'w stoppping in convert_w_units.pro'
     stop
  endif else begin
     print, 'Vert_type not recognised: ', vert_type
     print, 'Stopping in convert_w_units.pro'
     stop
  endelse
  return, w_out
end

function calc_d_dvert_um_std, var_in, vert, vert_4=vert_4d
  ; A function which calculates the d/dvert of 
  ; something.
  ; The standard is a single vertical column, but
  ; the vert_4d keyword incorporates a 4D field for the
  ; vertical coordinate.

  ; Set up output
  d_dvert=safe_alloc_um_std_template(var_in)
  d_dvert(*,*,*,*)=0.0
  arr_dim=size(var_in)
  n_lon=arr_dim(1)
  n_lat=arr_dim(2)
  n_vert=arr_dim(3)
  n_time=arr_dim(4)
  for ilon=0, n_lon-1 do begin
     for ilat=0, n_lat-1 do begin
        for itime=0, n_time-1 do begin     
           ; Are we using a single column or 4D array for
           ; vertical coordinate?
           if (KEYWORD_SET(vert_4d)) then begin
              d_dvert(ilon,ilat,0:n_vert-1,itime)=$
                 deriv(vert(ilon,ilat,0:n_vert-1,itime), $
                       var_in(ilon,ilat,0:n_vert-1,itime))           
           endif else begin
              d_dvert(ilon,ilat,0:n_vert-1,itime)=$
                 deriv(vert(0:n_vert-1), $
                       var_in(ilon,ilat,0:n_vert-1,itime))           
           endelse
        endfor
     endfor
  endfor
  return, d_dvert
end

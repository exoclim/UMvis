function calc_jet_char, which_plot, $
                        uvel, lat_array, $
                        vert_array, vert_type, $
                        min_val, $
                        verbose=verbose
  ; WARNING THIS ROUTINE IS WRITTEN VERY INEFFCIENTLY!!!
  ; Routine to characterise a prograde, 
  ; equatorial jet.
                                ; jet_max_u: the maximum zonal mean zonal wind
                                ; jet_max_vert: the vertical
                                ; coordinate of the location of the
                                ; maximum
                                ; eq_jet_depth: the depth from the
                                ; jet_max_vert, at the equator of the
                                ; jet (using factor_breadth)
                                ;eq_jet_breadth: the breadth of the
                                ;jet at the equator
                                ; at the location of max speed at
                                ; equator (using factor_depth)
  factor_breadth=0.5
  factor_depth=0.5
 ; First create an output array.
  dimensions=size(uvel)
  n_lon=dimensions(1)
  n_lat=dimensions(2)
  n_vert=dimensions(3)
  n_t=dimensions(4)
  arr_size=INTARR(4)
  arr_size(0)=n_lon
  arr_size(1)=n_lat
  arr_size(2)=n_vert
  arr_size(3)=n_t
  jet_char=safe_alloc_arr(4, arr_size, /float_arr)
  jet_char(*,*,*,*)=0.0
  
  ; Perform a zonal mean
  jet_mean=zon_mean_um_std(uvel, min_val)

  ; Create arrays to save jet peak wind speed
  ; and vertical location of peak speed
  
  arr_size=0
  arr_size=INTARR(4)
  arr_size(0)=1
  arr_size(1)=n_lat
  arr_size(2)=1
  arr_size(3)=n_t
  jet_max_u=safe_alloc_arr(4, arr_size, /float_arr)
  arr_size=0
  arr_size=INTARR(2) 
  arr_size(0)=n_lat
  arr_size(1)=n_t
  vert_loc=safe_alloc_arr(2, arr_size, /int_arr)
  vert_value=safe_alloc_arr(2, arr_size, /float_arr)

  if (which_plot eq 'jet_max_u_100pa' or $
      which_plot eq 'jet_max_vert_100pa' or $
      which_plot eq 'eq_jet_breadth_100pa' or $
      which_plot eq 'eq_jet_depth_100pa') then begin
     print, '***********WARNING**************'
     print, 'placing 100Pa limit on calc_jet_char.pro routine'
                                ; We need to ignore all velocities for regions above
                                ; 100 Pa
     for ivert=0, n_vert-1 do begin
        if (vert_array(ivert) lt 100.0) then begin
           jet_mean(*,*,ivert,*)=min_val
        endif
     endfor
  endif

  
  ; Find the peak u and its vertical position
  for tindex=0, n_t-1 do begin
     for ilat=0, n_lat-1 do begin
        ; Find the maximum and location
        jet_max_u(0,ilat,0,tindex)=$
           max(jet_mean(0,ilat,*,tindex), temp)        
        ; Store location and its value
        vert_loc(ilat,tindex)=temp
        vert_value(ilat, tindex)=$
           vert_array(vert_loc(ilat, tindex))
     endfor
  endfor
  ; Now we have the peak u at all 
  ; latitudes and times, and the vertical

  ; Now we want the width in latitude of the 
  ; jet, and the depth in vertical range
  ; But these are values close to the equator.
  ; find location in latitude array closest to 
  ; equator. 
  test=min(abs(lat_array(*)-0.0), eq_loc)
  print, 'Using winds at latitude: ', lat_array(eq_loc)
  print, 'To characterise jet.'

  ; If calculating the breadth of depth then crack on!
  if (which_plot eq 'eq_jet_breadth_100pa' or $
      which_plot eq 'eq_jet_depth_100pa') then begin
                                ; Now we take the peak at this position
                                ; and move out in latitude, or "down"
                                ; in vertical coordinates to get the
                                ; width and breadth
                                ; Allocate arrays
     arr_size=0
     arr_size=INTARR(4)
     arr_size(0)=1
     arr_size(1)=1
     arr_size(2)=1
     arr_size(3)=n_t
     jet_breadth=safe_alloc_arr(4, arr_size, /float_arr)
     jet_depth=safe_alloc_arr(4, arr_size, /float_arr)
     print, 'Using width/depth factors of:', factor_breadth, $
            factor_depth, ' respectively'
     print, 'Hardcoded in calc_jet_char.pro'
                                ; Begin with the width
     for tindex=0, n_t-1 do begin
        if (which_plot eq 'eq_jet_breadth_100pa') then begin
           if (lat_array(eq_loc) gt 0.0) then begin
                                ; Northern Hemisphere move to n_lat-1
              for ilat=eq_loc, n_lat-1 do begin
                                ; Move until the zonal mean is factor*
                                ; value of the value at the equator
                                ; (at the height of the maximum over
                                ; the equator)
                 if (jet_mean(0,ilat,vert_loc(eq_loc,tindex),tindex) gt $
                     factor_breadth*jet_max_u(0,eq_loc,0,tindex)) then begin
                                ; going from equator so -0.0 not lat_array(ilat)
                    jet_breadth(0,0,0,tindex)=abs(lat_array(ilat)-0.0)
                 endif
              endfor
           endif else if (lat_array(eq_loc) lt 0.0) then begin              
                                ; Southern move to zero
              for ilat=eq_loc, 0, -1 do begin
                                ; Move until the zonal mean is factor*
                                ; value of the value at the equator
                                ; (at the height of the maximum over
                                ; the equator)
                 if (jet_mean(0,ilat,vert_loc(eq_loc,tindex),tindex) gt $
                     factor_breadth*jet_max_u(0,eq_loc,0,tindex)) $
                 then begin
                                ; going from equator so -0.0 not lat_array(ilat)
                    jet_breadth(0,0,0,tindex)=abs(lat_array(ilat)-0.0)
                 endif                 
              endfor
           endif
        endif        
        if (which_plot eq 'eq_jet_depth_100pa') then begin
                                ; Now for the depth
                                ; Move down till we hit factor*peak
           for ivert=vert_loc(eq_loc,tindex), 0, -1 do begin              
              if (jet_mean(0,eq_loc,ivert,tindex) gt $
                  factor_depth*jet_max_u(0,eq_loc,0,tindex)) $
              then begin
                 if (vert_type eq 'Height') then begin
                    jet_depth(0,0,0,tindex)=abs(vert_array(vert_loc(eq_loc,tindex))$
                                            -vert_array(ivert))
                 endif else if (vert_type eq 'Pressure') then begin
                    jet_depth(0,0,0,tindex)=abs(vert_array(ivert)$
                                            -vert_array(vert_loc(eq_loc,tindex)))
                 endif else if (vert_type eq 'Sigma') then begin
                    jet_depth(0,0,0,tindex)=abs(vert_array(ivert)$
                                            -vert_array(vert_loc(eq_loc,tindex)))
                 endif                 
              endif              
           endfor
        endif        
     endfor
  endif
  
  ; Now we have the equatorial jet depth and width 
  ; Finally, fill the output array as required by the type of plot
  for tindex=0, n_t-1 do begin
     for ivert=0, n_vert-1 do begin
        for ilat=0, n_lat-1 do begin
           for ilon=0, n_lon-1 do begin
              if (which_plot eq 'jet_max_u_100pa') then begin
                 jet_char(ilon,ilat,ivert,tindex)=jet_max_u(0,ilat,0,tindex)
              endif else if (which_plot eq 'jet_max_vert_100pa') then begin
                 jet_char(ilon,ilat,ivert,tindex)=vert_array(vert_loc(ilat, tindex))
              endif else if (which_plot eq 'eq_jet_breadth_100pa') then begin
                 jet_char(ilon,ilat,ivert,tindex)=jet_breadth(0,0,0,tindex)
              endif else if (which_plot eq 'eq_jet_depth_100pa') then begin
                 jet_char(ilon,ilat,ivert,tindex)=jet_depth(0,0,0,tindex)
              endif
           endfor
        endfor
     endfor
  endfor
  ; Get rid of copious other arrays!!!
  jet_max_u=0
  vert_loc=0
  jet_mean=0
  jet_breadth=0
  jet_depth=0  
  return, jet_char
end


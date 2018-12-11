pro calc_gradient, nlon, lon, nlat, lat, nheights, heights, nt, times,$
                   var_in, $
                   grad_lon, grad_lat, grad_vert, grad_time
  ; This function calculates the gradient of an array
  ; Define the outputs
  arr_size=INTARR(4)
  arr_size(0)=nlon
  arr_size(1)=nlat
  arr_size(2)=nheights
  arr_size(3)=nt
  grad_lon=safe_alloc_arr(4, arr_size, /float_arr)
  grad_lat=safe_alloc_arr(4, arr_size, /float_arr)
  grad_vert=safe_alloc_arr(4, arr_size, /float_arr)
  grad_time=safe_alloc_arr(4, arr_size, /float_arr)
  
  for it=0, nt-2 do begin
     inc_time=+1
     for ivert=0, nheights-2 do begin
        inc_vert=+1
        for ilat=0, nlat-1 do begin
           inc_lat=+1
           ; Stop at the pole
           if (ilat eq nlat-1) then begin
              print, 'Hit the pole in calc_total_speed.pro'
              print, 'Look at solution in mapvert_um and'
              print, ' v_vel_onto_pressure.pro'
              stop
           endif
           for ilon=0, nlon-1 do begin
              inc_lon=+1
              ; Handle going around globe
              if (ilon eq nlon-1) then inc_lon=-(nlon-1)
              d_var_lon=var_in(ilon+inc_lon,ilat,ivert,it)-$
                        var_in(ilon,ilat,ivert,it)
              d_var_lat=var_in(ilon,ilat+inc_lat,ivert,it)-$
                        var_in(ilon,ilat,ivert,it)
              d_var_vert=var_in(ilon,ilat,ivert+inc_vert,it)-$
                         var_in(ilon,ilat,ivert,it)
              d_var_time=var_in(ilon,ilat,ivert,it+inc_time)-$
                         var_in(ilon,ilat,ivert,it)
              d_lon=lon(ilon+inc_lon)-lon(ilon)
              d_lat=lat(ilat+inc_lat)-lat(ilat)
              d_vert=heights(ivert+inc_vert)-heights(ivert)
              d_time=times(it+inc_time)-times(it)
              grad_lon(ilon,ilat,ivert,it)=$
                 d_var_lon/d_lon
              grad_lat(ilon,ilat,ivert,it)=$
                 d_var_lat/d_lat
              grad_vert(ilon,ilat,ivert,it)=$
                 d_var_vert/d_vert
              grad_time(ilon,ilat,ivert,it)=$
                 d_var_time/d_time
           endfor
        endfor
     endfor
  endfor

  ; Deal with end values
  grad_lon(*,*,*,nt-1)=0.0
  grad_lon(*,*,nheights-1,*)=0.0
  grad_lat(*,*,*,nt-1)=0.0
  grad_lat(*,*,nheights-1,*)=0.0
  grad_vert(*,*,*,nt-1)=0.0
  grad_vert(*,*,nheights-1,*)=0.0
  grad_time(*,*,*,nt-1)=0.0
  grad_time(*,*,nheights-1,*)=0.0
end

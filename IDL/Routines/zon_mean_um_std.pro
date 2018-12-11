function zon_mean_um_std, array_in, min_val, retain_size=retain_size, $
                          include_bad_levels=include_bad_levels
  ; This function returns a zonally averaged
  ; array from a standard UM input array
  ; array_in(lon,lat,vert,tim)
  ; At some heights/pressures, the array may have
  ; missing values (at min_val)
  ; these heights/pressures are skipped
  ; , i.e. set to min_val
  ; Initialise output
  arr_dim=size(array_in)
  arr_size=INTARR(4)
  arr_size(0)=1
  ; If the user wants a full sized array
  ; reset the longitude points
  if (KEYWORD_SET(retain_size)) then begin
     arr_size(0)=arr_dim(1)
  endif 
  arr_size(1)=arr_dim(2)
  arr_size(2)=arr_dim(3)
  arr_size(3)=arr_dim(4)
  zonal_mean=safe_alloc_arr(4, arr_size, /float_arr)
  zonal_mean(*,*,*,*)=0.0

  ; If we are going to perform averages even where missing data
  ; are present we need a different approach
  if (KEYWORD_SET(include_bad_levels)) then begin
     for ilat=0, arr_dim(2)-1 do begin
        for ivert=0, arr_dim(3)-1 do begin
           for itime=0, arr_dim(4)-1 do begin
              decrement=0
              for ilon=0, arr_dim(1)-1 do begin
                 ; Is this point good?
                 if (array_in(ilon,ilat,ivert,itime) gt min_val) then begin
                    zonal_mean(0,ilat,ivert,itime)=$
                       zonal_mean(0,ilat,ivert,itime)+$
                       array_in(ilon,ilat,ivert,itime)
                 endif else begin
                    decrement=decrement+1
                 endelse
              endfor
              ; Once finished a zonal pass find average
              zonal_mean(0,ilat,ivert,itime)=$
                 zonal_mean(0,ilat,ivert,itime)/$
                 (arr_dim(1)-decrement)
              
           endfor
        endfor
     endfor
  endif else begin
     ; Otherwise just skip the level entirely
     for ivert=0, arr_dim(3)-1 do begin
        ; If there are no bad points at this level
        ; begin sum
        if (min(array_in(*,*,ivert,*)) gt min_val) then begin
           for ilon=0, arr_dim(1)-1 do begin           
              zonal_mean(0,*,ivert,*)=zonal_mean(0,*,ivert,*)+$
                                      array_in(ilon,*,ivert,*)
           endfor
           ; And divide by number of longitudes
           zonal_mean(0,*,ivert,*)=zonal_mean(0,*,ivert,*)/$
                                   arr_dim(1)
        endif else begin
           ; Otherwise set this height to unavailable
           zonal_mean(0,*,ivert,*)=min_val
        endelse
     endfor
  endelse

  ; If we are retaining the full size
  ; array copy the values form index 0 to all
  if (KEYWORD_SET(retain_size)) then begin
     for ilon=1, arr_dim(1)-1 do begin
        zonal_mean(ilon,*,*,*)=zonal_mean(0,*,*,*)
     endfor
  endif
  return, zonal_mean
end



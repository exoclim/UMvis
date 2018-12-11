function meri_mean_um_std, array_in, lat,$
                           pi, min_val, $
                           meri_mean_pt=meri_mean_pt, $
                           retain_size=retain_size, $
                           include_bad_levels=include_bad_levels
  ; This function returns the meridionally
  ; average of array_in. 
  ; It skips vertical levels where a 
  ; missing value (i.e. min_val) is present
  ; and also can perform the average
  ; just by summing and dividing by the
  ; number of points (meri_mean_pt) or
  ; by adjusting for the change in size of a cell
  ; with latitude (default)
  ; It assumes a standrad UM array
  ; i.e. array_in(lon, lat, vert, time)
  ; Initialise output
  arr_dim=size(array_in)
  arr_size=INTARR(4)
  arr_size(0)=arr_dim(1)
  arr_size(1)=1
  ; If the user wants a full sized array
  ; reset the latitude points
  if (KEYWORD_SET(retain_size)) then begin
     arr_size(1)=arr_dim(2)
  endif 
  arr_size(2)=arr_dim(3)
  arr_size(3)=arr_dim(4)
  meri_mean=safe_alloc_arr(4, arr_size, /float_arr)
  meri_mean(*,*,*,*)=0.0
  if (KEYWORD_SET(meri_mean_pt)) then begin
     print, 'WARNING: using point-wise meridional mean'
  endif
  ; If we are going to perform averages even where missing data
  ; are present we need a different approach
  if (KEYWORD_SET(include_bad_levels)) then begin
     for ilon=0, arr_dim(1)-1 do begin
        for ivert=0, arr_dim(3)-1 do begin
           for itime=0, arr_dim(4)-1 do begin
              decrement=0
              for ilat=0, arr_dim(2)-1 do begin
                 ; Is this point good?
                 if (array_in(ilon,ilat,ivert,itime) gt min_val) then begin
                    ; Are we performing point-wise?
                    if (KEYWORD_SET(meri_mean_pt)) then begin
                       ; For point-wise just sum up values
                       meri_mean(ilon,0,ivert,itime)=$
                          meri_mean(ilon,0,ivert,itime)+$
                          array_in(ilon,ilat,ivert,itime)
                    endif else begin
                       ; For area weighted sum values, adjusted
                       ; by an area factor
                       factor=cos_deg_to_rad(lat(ilat), pi) 
                       meri_mean(ilon,0,ivert,itime)=$
                          meri_mean(ilon,0,ivert,itime)+$
                          factor*array_in(ilon,ilat,ivert,itime)
                    endelse
                    decrement=decrement+1
                 endif
              endfor
              ; Once finished a zonal pass find average
              meri_mean(ilon,0,ivert,itime)=$
                 meri_mean(ilon,0,ivert,itime)/$
                 (arr_dim(2)-decrement)              
           endfor
        endfor
     endfor
  endif else begin
     for ivert=0, arr_dim(3)-1 do begin
        ; If this level is ok, begin sum
        if (min(array_in(*,*,ivert,*)) gt min_val) then begin
           ; Sum differently depending on whether
           ; we are using a point wise or area weighted
           for ilat=0, arr_dim(2)-1 do begin
              if (KEYWORD_SET(meri_mean_pt)) then begin
                 ; For point-wise just sum up values
                 meri_mean(*,0,ivert,*)=meri_mean(*,0,ivert,*)+$
                                        array_in(*,ilat,ivert,*)
              endif else begin
                 ; For area weighted sum values, adjusted
                 ; by an area factor
                 factor=cos_deg_to_rad(lat(ilat), pi) 
                 meri_mean(*,0,ivert,*)=meri_mean(*,0,ivert,*)+$
                                        factor*array_in(*,ilat,ivert,*)
              endelse
           endfor
           ; Now divide by number of latitude points
           meri_mean(*,0,ivert,*)=meri_mean(*,0,ivert,*)/$
                                  arr_dim(2)
        endif else begin
           ; Otherwise set this height to unavailable
           meri_mean(*,0,ivert,*)=min_val
        endelse
     endfor
  endelse
  ; If we are retaining the full size
  ; array copy the values from index 0 to all
  if (KEYWORD_SET(retain_size)) then begin
     for ilat=1, arr_dim(2)-1 do begin
        meri_mean(*,ilat,*,*)=meri_mean(*,0,*,*)
     endfor
  endif
  return, meri_mean
end

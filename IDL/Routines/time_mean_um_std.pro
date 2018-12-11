function time_mean_um_std, array_in, min_val, retain_size=retain_size
  ; This function returns the temporal average
  ; of array_in, assumed to be a standard UM
  ; array, i.e. (lon,lat,vert,time)
  ; It also skips vertical layers where data
  ; are missing, i.e. min_val
  ; Initialise output
  arr_dim=size(array_in)
  arr_size=INTARR(4)
  arr_size(0)=arr_dim(1)
  arr_size(1)=arr_dim(2)
  arr_size(2)=arr_dim(3)
  arr_size(3)=1
  ; If the user wants a full sized array
  ; reset the time points
  if (KEYWORD_SET(retain_size)) then begin
     arr_size(3)=arr_dim(4)
  endif 
  time_mean=safe_alloc_arr(4, arr_size, /float_arr)
  time_mean(*,*,*,*)=0.0
  for ivert=0, arr_dim(3)-1 do begin
     ; Is this layer missing or not
     if (min(array_in(*,*,ivert,*)) gt min_val) then begin
        ; If OK perform sum as normal
        for itime=0, arr_dim(4)-1 do begin
           time_mean(*,*,ivert,0)=time_mean(*,*,ivert,0)+$
                                 array_in(*,*,ivert,itime)   
        endfor
        ; Normalise
        time_mean(*,*,ivert,*)=time_mean(*,*,ivert,*)/arr_dim(4)
     endif else begin
        ; Otherwise layer is missing
        time_mean(*,*,ivert,0)=min_val
     endelse
  endfor
  ; If we are retaining the full size
  ; array copy the values from index 0 to all
  if (KEYWORD_SET(retain_size)) then begin
     for itime=1, arr_dim(4)-1 do begin
        time_mean(*,*,*,itime)=time_mean(*,*,*,0)
     endfor
  endif
  return, time_mean
end

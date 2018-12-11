function vert_mean_um_std, array_in, min_val, retain_size=retain_size
  ; This function returns a verticall averaged
  ; array, but skips heights which have missing
  ; values (i.e. min_val)
  ; The array is assumed as a UM standard
  ; array_in(lon,lat,vert,time)
  ; Initialise output

  print, '---------------------------------------------'
  print, 'WARNING: Vertical mean is currently performed'
  print, 'in pointwise fashion!'
  print, '---------------------------------------------'

  arr_dim=size(array_in)
  arr_size=INTARR(4)
  arr_size(0)=arr_dim(1)
  arr_size(1)=arr_dim(2)
  arr_size(2)=1
  ; If the user wants a full sized array
  ; reset the vertical points
  if (KEYWORD_SET(retain_size)) then begin
     arr_size(2)=arr_dim(3)
  endif 
  arr_size(3)=arr_dim(4)
  vert_mean=safe_alloc_arr(4, arr_size, /float_arr)
  vert_mean(*,*,*,*)=0.0
  ; Count number of levels included
  ncount=0
  for ivert=0, arr_dim(3)-1 do begin
     ; If no missing data, sum as normal
     if (min(array_in(*,*,ivert,*)) gt min_val) then begin
        vert_mean(*,*,0,*)=vert_mean(*,*,0,*)+$
                          array_in(*,*,ivert,*)
        ncount=ncount+1
     endif
  endfor
  ; Now normalise
  vert_mean(*,*,*,*)=vert_mean(*,*,*,*)/ncount
  ; If we are retaining the full size
  ; array copy the values form index 0 to all
  if (KEYWORD_SET(retain_size)) then begin
     for ivert=1, arr_dim(3)-1 do begin
        vert_mean(*,*,ivert,*)=vert_mean(*,*,0,*)
     endfor
  endif
  return, vert_mean
end

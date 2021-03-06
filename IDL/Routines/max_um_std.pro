function max_um_std, array_in, which_dim, min_val
  ; This function accepts a standard UM array
  ; array_in(lon,lat,vert,time) and finds the max 
  ; value in the dimensions selected (which_dim)
  ; whilst skipping any value which is missing
  ; i.e. min_val
  ; Initialise output
  arr_dim=size(array_in)
  arr_size=INTARR(4)
  ; We also have to loop over the non-selected
  ; axis so set loop limits
  if (which_dim eq 0) then begin
     arr_size(0)=1
     arr_size(1)=arr_dim(2)
     arr_size(2)=arr_dim(3)
     arr_size(3)=arr_dim(4)
     nloop_1=arr_dim(2)
     nloop_2=arr_dim(3)
     nloop_3=arr_dim(4)
  endif else if (which_dim eq 1) then begin
     arr_size(0)=arr_dim(1)
     arr_size(1)=1
     arr_size(2)=arr_dim(3)
     arr_size(3)=arr_dim(4)
     nloop_1=arr_dim(1)
     nloop_2=arr_dim(3)
     nloop_3=arr_dim(4)
  endif else if (which_dim eq 2) then begin
     arr_size(0)=arr_dim(1)
     arr_size(1)=arr_dim(2)
     arr_size(2)=1
     arr_size(3)=arr_dim(4)
     nloop_1=arr_dim(1)
     nloop_2=arr_dim(2)
     nloop_3=arr_dim(4)
  endif else if (which_dim eq 3) then begin
     arr_size(0)=arr_dim(1)
     arr_size(1)=arr_dim(2)
     arr_size(2)=arr_dim(3)
     arr_size(3)=1
     nloop_1=arr_dim(1)
     nloop_2=arr_dim(2)
     nloop_3=arr_dim(3)
  endif else begin
     print, 'Dimension selected not possible:',$
            which_dim
     print, 'Array dimensions:', arr_dim(0)
     print, 'stop in max_um_std.pro'
     stop
  endelse
  max_out=safe_alloc_arr(4, arr_size, /float_arr)
  max_out(*,*,*,*)=0.0
  ; To find the max in a given axis we have to loop over
  ; the remaining axes.
  for iloop_1=0, nloop_1-1 do begin
     for iloop_2=0, nloop_2-1 do begin
        for iloop_3=0, nloop_3-1 do begin
           ; Find the required maximum
           if (which_dim eq 0) then begin
              max_out(0, iloop_1, iloop_2, iloop_3)=$
                 max(array_in(*, iloop_1, iloop_2, iloop_3))
           endif else if (which_dim eq 1) then begin
              max_out(iloop_1, 0, iloop_2, iloop_3)=$
                 max(array_in(iloop_1, *, iloop_2, iloop_3))              
           endif else if (which_dim eq 2) then begin
              max_out(iloop_1, iloop_2, 0, iloop_3)=$
                 max(array_in(iloop_1, iloop_2, *, iloop_3))  
           endif else if (which_dim eq 3) then begin
              max_out(iloop_1, iloop_2, iloop_3, 0)=$
                 max(array_in(iloop_1, iloop_2, iloop_3, *))              
           endif
        endfor
     endfor
  endfor
  return, max_out
end

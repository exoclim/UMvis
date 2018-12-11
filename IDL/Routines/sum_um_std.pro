function sum_um_std, array_in, which_dim, min_val
  ; This function accepts a standard UM array
  ; array_in(lon,lat,vert,time) and sums
  ; it in the dimensions selected (which_dim)
  ; whilst skipping any value which is missing
  ; i.e. min_val
  ; Initialise output
  arr_dim=size(array_in)
  arr_size=INTARR(4)
  if (which_dim eq 0) then begin
     arr_size(0)=1
     arr_size(1)=arr_dim(2)
     arr_size(2)=arr_dim(3)
     arr_size(3)=arr_dim(4)
     nloop=arr_dim(1)
  endif else if (which_dim eq 1) then begin
     print, '------------------------'
     print, 'WARNING MERDIONAL SUMS ARE CURRENTLY DONE POINTWISE'
     print, '------------------------'
     arr_size(0)=arr_dim(1)
     arr_size(1)=1
     arr_size(2)=arr_dim(3)
     arr_size(3)=arr_dim(4)
     nloop=arr_dim(2)
  endif else if (which_dim eq 2) then begin
     print, '------------------------'
     print, 'WARNING VERTICAL SUMS ARE CURRENTLY DONE POINTWISE'
     print, '------------------------'
     arr_size(0)=arr_dim(1)
     arr_size(1)=arr_dim(2)
     arr_size(2)=1
     arr_size(3)=arr_dim(4)
     nloop=arr_dim(3)
  endif else if (which_dim eq 3) then begin
     arr_size(0)=arr_dim(1)
     arr_size(1)=arr_dim(2)
     arr_size(2)=arr_dim(3)
     arr_size(3)=1
     nloop=arr_dim(4)
  endif else begin
     print, 'Dimension selected not possible:',$
            which_dim
     print, 'Array dimensions:', arr_dim(0)
     print, 'stop in sum_um_std.pro'
     stop
  endelse
  sum_out=safe_alloc_arr(4, arr_size, /float_arr)
  ; In order to skip values missing, we set them to
  ; zero, so they don't contribute to the sum
  array_sum=array_in
  bad_points=where(array_sum le min_val)
  array_sum(bad_points)=0.0
  sum_out(*,*,*,*)=0.0
  ; Now perform the sum
  for iloop=0, nloop-1 do begin
     if (which_dim eq 0) then $
        sum_out(0,*,*,*)=sum_out(0,*,*,*)+$
                           array_sum(iloop,*,*,*)
     if (which_dim eq 1) then $
        sum_out(*,0,*,*)=sum_out(*,0,*,*)+$
                           array_sum(*,iloop,*,*)
     if (which_dim eq 2) then $
        sum_out(*,*,0,*)=sum_out(*,*,0,*)+$
                           array_sum(*,*,iloop,*)
     if (which_dim eq 3) then $
        sum_out(*,*,*,0)=sum_out(*,*,*,0)+$
                           array_sum(*,*,*,iloop)
  endfor
  array_sum=0
  return, sum_out
end

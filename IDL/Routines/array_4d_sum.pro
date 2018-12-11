function array_4d_sum, array_in, ni, nj, nk, nl, sum_axis, $
                       missing=missing
; This routine sums one of the axes of a 4D array
; It also skips the values of missing or lower
; get sizes
  ni_loop=ni
  nj_loop=nj
  nk_loop=nk
  nl_loop=nl
  ; Set the array size for output
  ; And for the summed axis
  if (sum_axis eq 1) then begin 
     ni_loop=1
     nsum=ni
  endif else if (sum_axis eq 2) then begin
     nj_loop=1
     nsum=nj
  endif else if (sum_axis eq 3) then begin
     nk_loop=1
     nsum=nk
  endif else if (sum_axis eq 4) then begin
     nl_loop=1
     nsum=nl
  endif
  array_sizes=INTARR(4)
  array_sizes(0)=ni_loop
  array_sizes(1)=nj_loop
  array_size(2)=nk_loop
  array_size(3)=nl_loop
  array_out=safe_alloc_arr(ndim, array_sizes, /float_arr)
  if (nl_loop eq 1) then $
  array_out(*,*,*,*)=0.0
  ; Now perform the sum
  for il=0, nl_loop-1 do begin
     for ik=0, nk_loop-1 do begin
        for ij=0, nj_loop-1 do begin
           for ii=0, ni_loop-1 do begin
              ; Now sum the required axis,
              for isum=0, nsum-1 do begin
                 ; Set the increment
                 if (sum_axis eq 1) then $
                    increment=array_in(isum,ij,ik,il)
                 if (sum_axis eq 2) then $
                    increment=array_in(ii,isum,ik,il)
                 if (sum_axis eq 3) then $
                    increment=array_in(ii,ij,isum,il)
                 if (sum_axis eq 4) then $
                    increment=array_in(ii,ij,ik,isum)
                 ; Skip missing values
                 if (increment gt missing+1.0) then $
                    array_out(ii,ij,ik,il)=$
                    array_out(ii,ij,ik,il)+$
                    increment
              endfor
           endfor
        endfor
     endfor
  endfor
  return,array_out
end

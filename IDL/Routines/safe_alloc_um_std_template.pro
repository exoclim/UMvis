function safe_alloc_um_std_template, template
  ; This simple function safely creates an
  ; array of the same size as the input array, and
  ; zeros the values
  ; Find size
  arr_size=size(template)
  arr_dim=INTARR(4)
  arr_dim(0)=arr_size(1)
  arr_dim(1)=arr_size(2)
  arr_dim(2)=arr_size(3)
  arr_dim(3)=arr_size(4)
  array_out=safe_alloc_arr(4, arr_dim, /float_arr)
  array_out(*,*,*,*)=0.0     
  return, array_out
end

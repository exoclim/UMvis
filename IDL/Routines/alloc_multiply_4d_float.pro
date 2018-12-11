function alloc_multiply_4d_float, array_one, array_two, array_size
  ; A simple routine to multiply two matching sized arrays
  ; which are array_size (as well as safely allocate a float array)
  variable_out=safe_alloc_arr(4, array_size, /float_arr)
  variable_out(*,*,*,*)=array_one(*,*,*,*)*array_two(*,*,*,*)
  return, variable_out
end




function calc_vert_shear, variable, z
  ; This function calculates the shear of 
  ; the variable
  ; This is d(variable)/dz
  dimensions=size(variable)
  n_lon=dimensions(1)
  n_lat=dimensions(2)
  n_heights=dimensions(3)
  nt=dimensions(4)
  arr_size=INTARR(4)
  arr_size(0)=n_lon
  arr_size(1)=n_lat
  arr_size(2)=n_heights
  arr_size(3)=nt
  ; Define the output array
  shear=safe_alloc_arr(4, arr_size, /float_arr)
  
  for ivert=0, n_heights-2 do begin
     shear(*,*,ivert,*)=$
        (variable(*,*,ivert+1,*)-$
         variable(*,*,ivert,*))/$
        (z(ivert+1)-z(ivert))
  endfor
  shear(*,*,n_heights-1,*)=0.0
  return,shear
end

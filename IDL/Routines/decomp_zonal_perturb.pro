pro decomp_zonal_perturb, field_in, field_perturb,$
                          field_mean, min_val, $
                          retain_size=retain_size
  ; This routines decomposes a given field into a zonal
  ; mean and a perturbation from the zonal mean
  dim=size(field_in)
  nlon=dim(1)
  nlat=dim(2)
  nvert=dim(3)
  ntime=dim(4)
  ; First create the zonal average
  field_mean=zon_mean_um_std(field_in, min_val,$
                             retain_size=retain_size)
  ; Now find the perturbation
  arr_size=INTARR(4)
  arr_size(0)=nlon
  arr_size(1)=nlat
  arr_size(2)=nvert
  arr_size(3)=ntime
  field_perturb=safe_alloc_arr(4, arr_size, /float_arr)
  ; If the size of the arrays is retained just find difference
  if (KEYWORD_SET(retain_size)) then begin
        field_perturb(*,*,*,*)=$
           field_in(*,*,*,*)-field_mean(*,*,*,*)
  endif else begin
     ; Otherwise we have to loop (mean field
     ; is array of length 1 in longitude)
     for ilon=0, nlon-1 do begin
        field_perturb(ilon,*,*,*)=$
           field_in(ilon,*,*,*)-field_mean(0,*,*,*)
     endfor
  endelse
end

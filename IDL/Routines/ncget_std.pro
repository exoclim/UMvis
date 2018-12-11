function ncget_std, ncid, name, values, $
                    verbose=verbose

@nc_info

ivar=-1

for i=0, num_var-1 do begin
  if (strcompress(var_name(i),/remove_all) eq name) then ivar=i
endfor

if (ivar eq -1) then begin
  print
  print, 'ncget_std:'
  print, 'Variable ', name, ' not found.'
  return, 1
endif

if (KEYWORD_SET(verbose)) then $
   print, name, ': ivar = ', ivar

var_size=long(1)
for idim=0,var_dims(ivar)-1 do begin
  size_tmp=dim_size(var_dimid(idim,ivar))
  var_size=var_size*size_tmp
  if (idim eq 0) then begin
    var_shape=size_tmp
    zero=0
  endif else begin
    var_shape=[var_shape,size_tmp]
    zero=[zero,0]
  endelse
endfor

;values=fltarr(var_size)
;values=reform(values,var_shape)

ncdf_varget, ncid,ivar,values

stat=0

return, stat

end

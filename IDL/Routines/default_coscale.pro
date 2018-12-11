function default_coscale, ncoconts
  ; A short function to create default colour scale
  ; Default colour numbers
  begin_col=1
  ncols=254
  coscale=safe_alloc_arr(1, ncoconts, /float_arr)
  step=(float(ncols)-float(begin_col))/(float(ncoconts-1.0))
  for i=0 ,ncoconts-1 do begin
     coscale(i)=begin_col+step*float(i)
  endfor
  return, coscale
end

function default_contours, plot_array, min_val, nconts,$
                           fix_min=fix_min, fix_max=fix_max
  ; Short function to create a standard set of contours
  if (KEYWORD_SET(fix_min)) then begin
     min_data=fix_min
  endif else begin
     min_data=min(plot_array(where(plot_array gt min_val)))
  endelse
  if (KEYWORD_SET(fix_max)) then begin
     max_data=fix_max
  endif else begin
     max_data=max(plot_array(where(plot_array gt min_val)))
  endelse
  step=(max_data-min_data)/float(nconts-1.0)
  conts=safe_alloc_arr(1, nconts, /float_arr)
  for icont=0, nconts-1 do begin
     conts(icont)=min_data+icont*step
  endfor  
  return, conts
end 

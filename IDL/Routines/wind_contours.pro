function wind_contours, plot_array, min_val, $
                        nconts, $
                        fix_min=fix_min, $
                        fix_max=fix_max
  ; This function returns a set of contours
  ; symmetric in number about zero
  ; The option exists to fix the maximum and minimum
  conts=safe_alloc_arr(1, nconts, /float_arr)
  if (KEYWORD_SET(fix_min)) then begin
     min_data=fix_min
  endif else begin
     min_data=min(plot_array(where(plot_array gt min_val)))
  endelse
  IF (KEYWORD_SET(fix_max)) then begin
     max_data=fix_max
  endif else begin
     max_data=max(plot_array(where(plot_array gt min_val)))
  endelse
  if (min_data lt 0.0 and max_data gt 0.0) then begin
     ; If we straddle zero we want this as a contour
     ; For odd numbers of contours, we simply take one
     ; For even we have to steal one from either side
     ; of zero, and therefore take it from the side
     ; with the smallest range.
     if (abs((nconts/2.0)-fix(nconts/2.0)) gt 0.0) then begin
        ; Odd number, include zero in the negative side
        ; for construction purposes
        nneg=fix(nconts/2.0)+1
        npos=nneg-1
        step_neg=(0.0-min_data)/float(nneg-1.0)
        ; Now construct 
        for icont=0, nneg-1 do begin
           conts(icont)=min_data+float(icont*step_neg)        
        endfor
        step_pos=(max_data-conts(nneg-1))/float(npos)
        for icont=nneg, nconts-1 do begin
           conts(icont)=conts(nneg-1)+$
                        float((icont-nneg+1))*step_pos
        endfor
     endif else begin
        ; Even, take contour from smallest side
        ; to use as the zero contour
        npos=(nconts/2)
        nneg=(nconts/2)
        if (abs(min_data) lt abs(max_data)) then begin
           step_neg=(0.0-min_data)/float(nneg-1.0)
           ; Now construct 
           for icont=0, nneg-1 do begin
              conts(icont)=min_data+float(icont*step_neg)        
           endfor
           step_pos=(max_data-conts(nneg-1))/float(npos)
           for icont=nneg, nconts-1 do begin
              conts(icont)=conts(nneg-1)+$
                           float((icont-nneg+1))*step_pos
           endfor           
        endif else if (abs(min_data) gt $
                       abs(max_data)) then begin
           step_pos=(max_data-0.0)/float(npos-1.0)
           for icont=nneg, nconts-1 do begin
              conts(icont)=0.0+$
                           float((icont-nneg))*step_pos
           endfor           
           step_neg=(conts(nneg)-min_data)/float(nneg)
           for icont=0, nneg-1 do begin
              conts(icont)=min_data+float(icont*step_neg)        
           endfor
        endif
     endelse            
  endif else begin
     conts=default_contours(plot_array, min_val, nconts)
  endelse
  return, conts
end

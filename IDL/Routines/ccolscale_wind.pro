pro ccolscale_wind, coconts, coscale
  ; Create a colour scale symmetric about zero
  ncols=254.0
  white_col=127.0
  start_col=0.0
  ncoconts=n_elements(coconts)
  coscale=safe_alloc_arr(1, ncoconts, /float_arr)
  ; We have split the contours about zero, so do the 
  ; same for the colour scale
  ; Where is the zero_pt
  zero_pt=minloc(abs(coconts))
  ; Do we have a zero contour?
  if (coconts(zero_pt) eq 0.0) then begin
     ; Fix zero at col=white_col, and build either side
     coscale(zero_pt)=white_col
     ; Could be at the end or beginning
     if (zero_pt eq 0) then begin
        step=(ncols-white_col)/(float(ncoconts)-1.0)
        for iscale=1, ncoconts-1 do begin
           coscale(iscale)=white_col+float(iscale)*step
        endfor
     endif else if (zero_pt eq ncoconts-1) then begin
        step=(white_col-start_col)/(float(ncoconts)-1.0)
        for iscale=0, ncoconts-2 do begin
           coscale(iscale)=start_col+float(iscale)*step
        endfor
     endif else begin
        ; Standard case
        ; Build contours either side
        step=(white_col-start_col)/(float(zero_pt))
        for iscale=0, zero_pt-1 do begin
           coscale(iscale)=start_col+float(iscale)*step
        endfor
        step=(ncols-white_col)/(float(ncoconts-zero_pt-1.0))
        for iscale=zero_pt+1, ncoconts-1 do begin
           coscale(iscale)=white_col+$
                           (float(iscale-zero_pt))*step
        endfor
     endelse
  endif else begin
     ; If zero is not included we still need to split
     ; it about zero.
     ; First deal with all negative or all positive
     ; cases using default approach
     if (min(coconts) gt 0.0 and max(coconts) gt 0.0) then begin
        step=(ncols-white_col)/(float(ncoconts)-1.0)
        for iscale=0, ncoconts-1 do begin
           coscale(iscale)=white_col+float(iscale)*step
        endfor
     endif else if (min(coconts) lt 0.0 and $
                    max(coconts) lt 0.0) then begin
        step=(white_col-start_col)/(float(ncoconts)-1.0)
        for iscale=0, ncoconts-1 do begin
           coscale(iscale)=start_col+float(iscale)*step
        endfor
        endif else begin
           ; Finally, a scale that doesn't include
           ; zero and is not all negative or positive
           ; We still have to split positive and negative
           if (coconts(zero_pt) lt 0.0) then begin
              step=(white_col-start_col)/(float(zero_pt)+1.0)
              for iscale=0, zero_pt do begin
                 coscale(iscale)=start_col+float(iscale)*step
              endfor              
              step=(ncols-white_col)/(float(ncoconts-zero_pt)+1.0)
              for iscale=zero_pt+1, ncoconts-1 do begin
                 coscale(iscale)=white_col+$
                                 float(iscale-zero_pt)*step
              endfor              
           endif else begin
              step=(ncols-white_col)/(float(ncoconts-zero_pt))
              for iscale=zero_pt, ncoconts-1 do begin
                 coscale(iscale)=white_col+$
                                 float(iscale-zero_pt+1)*step
              endfor              
              step=(white_col-start_col)/(float(zero_pt))
              for iscale=0, zero_pt-1 do begin
                 coscale(iscale)=start_col+float(iscale)*step
              endfor              
           endelse           
     endelse
  endelse


;white is 127

  ; If we straddle zero then split the contours there
;  if (min(coconts) lt 0.0 and max(coconts) gt 0.0) then begin
     ; Where is the closest point to zero?;
;     zero_pt=minloc(abs(coconts))
     ; Set location of last negative point
     ; Zero is including in the negative
;     if (coconts(zero_pt) eq 0.0 or $
;         coconts(zero_pt) lt 0.0) then begin
;        loc_neg=zero_pt
;     endif else if (coconts(zero_pt) gt 0.0) then begin
;        loc_neg=zero_pt-1
;     endif
     ; Now create a negative
;     step_neg=(float((float(ncols)-float(begin_col))/2.0)$
;               -float(begin_col))/float(loc_neg)
     ; Create the negative portion of cosale
;     for ineg=0, loc_neg do begin
;        coscale(ineg)=begin_col+step_neg*float(ineg)
;     endfor
     ; Now create the positive step and scale
;     step_pos=(float(ncols)-float(coscale(loc_neg)))/float(ncoconts-loc_neg-1.0)
;     for ipos=loc_neg+1, ncoconts-1 do begin
;        coscale(ipos)=coscale(loc_neg)+step_pos*float(ipos-loc_neg)
;     endfor
;  endif else begin
     ; Otherwise just create colour scale
;     coscale=default_coscale(ncoconts)
;  endelse
end

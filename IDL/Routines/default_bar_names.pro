function default_bar_names, nbar_names,$
                            ncoconts, coconts, coscale
  ; Simple function to setup some default
  ; names for a colour bar
  ; Fix bottom and top values
  bar_names=safe_alloc_arr(1, nbar_names, /string_arr)
  bar_values=safe_alloc_arr(1, nbar_names, /float_arr)
  bar_names(0)=min(coconts)
  bar_names(nbar_names-1)=max(coconts)
  ; The colours may not evenly sample
  ; the contour space.
  ; We must work out how it is sampled
  ; and derive bar_names over correct
  ; spacings
  ; What fraction of the total colour
  ; range is covered by each coscale element
  range=coscale(ncoconts-1)-coscale(0)
  col_step=(coscale-coscale(0))/range
  ; Now interpolate for the actual value
  ; of cocont, if the xaxis was the colour step
  ; and our sampling was in steps of 1/nbar_names
  step=1.0/float(nbar_names-1.0)
  for i=0, nbar_names-1 do begin
     bar_values(i)=linear_interp_point($
                  1, coconts, col_step,$
                  float(step*i), 0)
  endfor
  ; Now put into the string in a format
  ; which is appropriate
  for i=0, nbar_names-1 do begin
     if (abs(bar_values(i)) gt 1.0) then begin
        bar_names(i)=string(bar_values(i))
     endif else begin
        bar_names(i)=string(bar_values(i), format='(g9.3)')
     endelse
  endfor
  ; Finally remove whitespace
  for ibar=0, nbar_names-1 do begin
     bar_names(ibar)=STRCOMPRESS(bar_names(ibar),/remove_all)
  endfor
  return, bar_names
end

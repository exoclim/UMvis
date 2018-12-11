pro ccoltbl_wind, coconts
  ; A routine to load the colour table required
  ; for wind plots
  ; Set up a blue=negative, red=positive color scale. The
  ; middle of the scale is white:
  H = [replicate(240.0, 128), replicate(360.0, 128)]
  S = 2*[reverse(findgen(128)), findgen(128)]/255
  V = fltarr(256)+1
  tvlct, H, S, V, /hsv
  tvlct, R, G, B, /get
  red = R
  green = G
  blue = B
  color_table = 0
  tvlct, red, green, blue  
  ; The colours need adjusting for all 
  ; negative or all postive winds
  if (max(coconts) le 0.0) then begin
     ; All negative
     red=indgen(n_elements(red))
     green=indgen(n_elements(green))
     blue(*)=255
     tvlct, red, green, blue
  endif else if (min(coconts) ge 0.0) then begin
     ; All positive
     ; Reform a scale only using red 
     blue=indgen(n_elements(blue))
     blue=reverse(blue)
     green=indgen(n_elements(green))
     green=reverse(green)
     red(*)=255
     tvlct,red, green, blue
  endif   
end 

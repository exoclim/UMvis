pro ccoltbl_exp_wind, coconts
  ; A routine to load the colour table required
  ; for wind plots in exponential space
  ; Set up a blue=negative, red=positive color scale. The
  ; middle of the scale is white:
  H = [replicate(240.0, 128), replicate(360.0, 128)]
  ; Create an saturation array evenly spaced in log
  ; First the standard array
  S = 2*[reverse(findgen(128)), findgen(128)]/255
  ; Then fix the end points in exponential space
  S_max=10.0^(254.0/255)
  S_min=10.0^(0.001)
  Sexp=S
  Sexp(*)=0.0
  for i=0, 127 do begin
     Sexp(i)=S_max-float(i)*(S_max-S_min)/127.0
     S(i)=ALOG10(Sexp(i))
     S(255-i)=S(i)
  endfor
  Sexp=0
  ; Reset the middle points to zero
  S(127)=0.0
  S(128)=0.0
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


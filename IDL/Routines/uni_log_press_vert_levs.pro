function uni_log_press_vert_levs, nlevels, p_min, p_max
  ; This function returns a set of 
  ; levels (nlevels) uniformly spaced
  ; in log(pressure) from p_max, 
  ; to p_min
  vert_levs=safe_alloc_arr(1, nlevels, /float_arr)
  for k=0, nlevels-1 do begin
     vert_levs(k)=ALOG10(p_max)-$
                  k*(ALOG10(p_max)-ALOG10(p_min))/$
                  (float(nlevels)-1)
  endfor
  ; Fix the last level to account for
  ; rounding errors                                        
  vert_levs(nlevels-1)=ALOG10(p_min)
  vert_levs=10.0^vert_levs
  ; Finally reverse the levels as these go from
  ; low pressure to high
  vert_temp=vert_levs
  vert_levs(*)=0.0
  for k=0, nlevels-1 do begin
     vert_levs(k)=vert_temp((nlevels-1)-k)
  endfor
  return, vert_levs
end

function uni_log_sigma_vert_levs, nlevels, sig_min, sig_max
  ; This function returns a set of evenly spaced
  ; levels in log(sigma)

  log_sigma=safe_alloc_arr(1, nlevels, /float_arr)
  for k=0, nlevels-1 do begin
     log_sigma(k)=ALOG10(sig_max)-$
                  k*(ALOG10(sig_max)-ALOG10(sig_min))/$
                  (float(nlevels)-ALOG10(sig_max))
  endfor
  ; Fix the last level to account for rounding errors
  log_sigma(nlevels-1)=ALOG10(sig_min)
  return, log_sigma
end

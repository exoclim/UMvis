function uni_sigma_vert_levs, nlevels, sig_min, sig_max
   ; This function simply creates a set
   ; of levels going from sig_min to 1.0
   sigma=safe_alloc_arr(1, nlevels, /float_arr)
   for k=0, nlevels-1 do begin
      sigma(k)=sig_max-float(k)*$
               ((sig_max-sig_min)/$
                (float(nlevels)-sig_max))
   endfor
   ; Set the final level as that requested,
   ; as it can differ due to rounding errors
   sigma(nlevels-1)=sig_min
   return,sigma
end

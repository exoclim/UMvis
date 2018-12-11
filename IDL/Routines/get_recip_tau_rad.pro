function get_recip_tau_rad, setup, pressure, lon, lat
  ; This function returns the reciprocated Radiative
  ; Radiative at a given pressure for various profiles
  
  if (setup eq 'HS') then begin
     print, 'Radiative Radiative routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'EL') then begin
     print, 'Radiative Radiative routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'TLE') then begin
     print, 'Radiative Radiative routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'SHJ' or setup eq 'SHJ_Deep') then begin
     print, 'Radiative Radiative routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'HD209458b' or $
                 setup eq 'HD209458b_3kb') then begin
     recip_tau_rad=recip_tau_rad_hd209_iro(pressure)
  endif else begin
     print, 'Setup:', setup
     print, 'Not found'
     stop
  endelse

  return, recip_tau_rad

end

function get_eq_temp, setup, pressure, lon, lat
  ; This function returns the equlibrium
  ; Temperature at a given pressure for various profiles
  

  if (setup eq 'HS') then begin
     print, 'Equilibirum Temperature routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'EL') then begin
     print, 'Equilibirum Temperature routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'TLE') then begin
     print, 'Equilibirum Temperature routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'SHJ' or setup eq 'SHJ_Deep') then begin
     print, 'Equilibirum Temperature routine'
     print, 'Not written yet for :', setup
     print, 'Get on it!'
     stop
  endif else if (setup eq 'HD209458b' or $
                 setup eq 'HD209458b_3kb') then begin
     t_eq=temperature_hd209_heng_smooth(pressure, lon, lat)
  endif else begin
     print, 'Setup:', setup
     print, 'Not found'
     stop
  endelse

  return, t_eq

end

pro set_vectors, vect_arr_lgth, vect_arr_thin, $
                 missing_vect, $
                 vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
                 vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
                 missing_vect_ovrd=missing_vect_ovrd, $
                 verbose=verbose
  ; Setup the types of vector for the plots
  if (KEYWORD_SET(vect_arr_lgth_ovrd)) then begin
     vect_arr_lgth=vect_arr_lgth_ovrd
  endif else begin
     vect_arr_lgth=1.0
  endelse
  if (KEYWORD_SET(vect_arr_thin_ovrd)) then begin
     vect_arr_thin=vect_arr_thin_ovrd
  endif else begin
     vect_arr_thin=1.0
  endelse
  if (KEYWORD_SET(missing_vect_ovrd)) then begin
     missing_vect=missing_vect_ovrd
  endif else begin
     missing_vect=1.0e9
  endelse
  if (KEYWORD_SET(verbose)) then begin
     print, 'Using vector arrow length:', vect_arr_lgth
     print, 'Thinning vector arrows by factor:', vect_arr_thin
     print, 'Using missing vector value:', missing_vect
  endif
end

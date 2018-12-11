function calc_pumping_terms_wrap, which_term, nterms, term_names, $
                                  term_calc, ncalls, $
                                  n_lon, n_lat, n_vert, n_time, $
                                  lat, vert, time, $
                                  vert_type_decomp, $
                                  rho_in, u_in, v_in, w_in, $
                                  planet_radius, pi, omega, timestep, $
                                  lid_height, min_val, $
                                  eqn_type=eqn_type, $
                                  radius_map=radius_map, $
                                  verbose=verbose
  ; This is a simple wrapper to call the 
  ; calculation routine for eddy-mean flow pumping
  ; terms, so it can be used by cvar and cvar_mapped
  ; i.e. made from netcdf or from a mapped file
  ; The radius_map keyword is an array
  ; required when working from a mapped set of data.
    
  ; If we are only calculating a single term
  ; call the calculation, otherwise loop
  if (KEYWORD_SET(verbose)) then begin
     print, 'Calculating: ', which_term
  endif
  if (ncalls eq 1) then begin
     pumping_term=calc_pump_terms(which_term, $
                                  n_lon, n_lat, n_vert, n_time, $
                                  lat, vert, time, $
                                  vert_type_decomp, $
                                  rho_in, u_in, v_in, w_in, $
                                  planet_radius, pi, omega, timestep, $
                                  lid_height, min_val, $
                                  eqn_type=eqn_type, $
                                  radius_map=radius_map)
  endif else begin
     ; Otherwise we must loop
     count=0
     for iterm=0, nterms-1 do begin
        if (KEYWORD_SET(verbose) and $
            term_calc(iterm) eq 1) then begin
           print, 'Calculating: ', term_names(iterm), ' Term: ', count+1
        endif
        if (term_calc(iterm) eq 1) then begin
           ; Replace name with the name of the component term
           pumping_it=calc_pump_terms(term_names(iterm), $
                                      n_lon, n_lat, n_vert, n_time, $
                                      lat, vert, time, $
                                      vert_type_decomp, $
                                      rho_in, u_in, v_in, w_in, $
                                      planet_radius, pi, omega, timestep, $
                                      lid_height, min_val, $
                                      eqn_type=eqn_type, $
                                      radius_map=radius_map)
           ; If the first call save value
           if (count eq 0) then begin
              pumping_term=pumping_it
              pumping_it=0
              ; subsequent calls sum
           endif else begin
              pumping_term(*,*,*,*)=pumping_term(*,*,*,*)+pumping_it(*,*,*,*)
              pumping_it=0
           endelse
           count=count+1
        endif
     endfor
  endelse
  return, pumping_term
end

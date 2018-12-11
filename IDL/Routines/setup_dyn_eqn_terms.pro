pro setup_dyn_eqn_terms, which_term, nterms, term_names, $
                         term_calc, ncalls, $
                         read_rho, read_u, read_v, read_w
  ; This routine sets up the requirements
  ; for each momentum term, like which values are required for winds
  ; and names etc.

  ; Setup an array of names
  nterms=10
  term_names=safe_alloc_arr(1, nterms, /string_arr)  

  ;+(u*v*tan(phi)/r)
  term_names(0)='ueqn_metric_uvtan'

  ; -u*w/r 
  term_names(1)='ueqn_metric_uw'

  ; +2*Omega*v*sin(phi)
  term_names(2)='ueqn_coriolis_vsin'

  ; -2*Omega*w*cos(phi)
  term_names(3)='ueqn_coriolis_wcos'

  ; -u^2 * tan(phi) / r
  term_names(4)='veqn_metric_utan'

  ; -v*w/r
  term_names(5)='veqn_metric_vw'

  ; -2*Omega*u*sin(phi)
  term_names(6)='veqn_coriolis_usin'

  ; +(u^.02 + v^2.0)/r
  term_names(7)='weqn_metric_uv'

  ; +2*Omega*u*cos(phi)
  term_names(8)='weqn_coriolis_ucos'

  ; Either -rho/r^2 * d(r^2 w)/dr (deep) or -rho*dw/dz (shallow)
  term_names(9)='rhoeqn_dw_dvert'

  ; Setup an array to show which are being calculated
  ; 0 is no 1 is yes
  ; This with ncalls can be used to create sums
  ; of several terms (not yet completed)
  term_calc=safe_alloc_arr(1, nterms, /int_arr)
  term_calc(*)=0
  ; Finally initialise read choices
  ; if this i 0 the variable will be set to 1.0
  ; otherwise it will be read in.
  read_rho=0
  read_u=0
  read_v=0
  read_w=0

  ; Find which term we want, it shouldn't fail
  ; as the request might be for a sum term
  term_index=find_string_in_arr(nterms, term_names, which_term, $
                               /nofail)
  ; If it is found set to calculate this term
  ; and set which components are required
  if (term_index gt -1) then begin
     ncalls=1
     term_calc(term_index)=1
     ; Do we need to read density
     if (term_index eq 9) then read_rho=1
     ; Now we decide which wind components are required
     ; First all requiring Uvel
     if (term_index eq 0 or term_index eq 1 or $
         term_index eq 4 or term_index eq 6 or $
         term_index eq 7 or term_index eq 8) then read_u=1
     ; Now those requiring v
     if (term_index eq 0 or term_index eq 2 or $
         term_index eq 5 or term_index eq 7) then read_v=1
     ; Now those requiring w
     if (term_index eq 1 or term_index eq 3 or $
         term_index eq 5 or term_index eq 9) then read_w=1
  endif else begin
     print, 'Term: ', which_term
     print, 'Not available in momentum terms'
     print, 'Stopping in setup_momentum_terms'
     stop
  endelse
end

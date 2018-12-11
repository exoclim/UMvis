pro setup_pumping_terms, which_term_in, which_term_calc, $
                         nterms, term_names, $
                         term_calc, ncalls, $
                         read_rho, read_u, read_v, read_w
  ; This routine sets up the requirements
  ; for each pumping term, like which values are required for winds
  ; and names etc.

  ; However, these terms are calcuated from a rearranged
  ; version of Equation (5) from Hardiman et al. (2010)
  ; where the acceleration of the mean zonal flow is the
  ; LHS (i.e. d(rho_bar*u_bar)/dt.
  ; All other terms are moved to the RHS.
  
  which_term_calc=which_term_in

  ; Setup an array of names
  nterms=8
  term_names=safe_alloc_arr(1, nterms, /string_arr)  

  ; d(rho_bar*u_bar)/dt
  term_names(0)='zon_mean_pump' 

  ; (d((rho*v)_bar*u_bar*cos^2(phi))/dphi)/rcos^2(phi)
  term_names(1)='meri_mean_pump'

  ; (d((rho*w)_bar*u_bar*r^3)/dr)/r^3
  term_names(2)='vert_mean_pump'

  ; 2*Omega*(rho*v)_bar*sin(phi)
  term_names(3)='meri_mean_sin_pump'

  ; 2*Omega*(rho*w)_bar*cos(phi)
  term_names(4)='vert_mean_cos_pump'

  ; d(rho_prime*u_prime)_bar)/dt
  term_names(5)='zon_eddy_pump'

  ; (d(((rho*v)_prime*u_prime)_bar*cos^2(phi))/dphi)/(rcos^2(phi))
  term_names(6)='meri_eddy_pump'

  ; (d((rho*w)_prime*u_prime)_bar*r^3)/dr)/r^3
  term_names(7)='vert_eddy_pump'

  ; Now setup the sum names
  nsums=3
  sum_names=safe_alloc_arr(1, nsums, /string_arr)  
  sum_names(0)='sum_pump'  
  sum_names(1)='sum_mean_pump'
  sum_names(2)='sum_eddy_pump'

  ; Setup an array to show which are being calculated
  ; 0 is no 1 is yes
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
  term_index=find_string_in_arr(nterms, term_names, which_term_calc, $
                               /nofail)
  ; If it is found set to calculate this term
  ; and set which components are required
  if (term_index gt -1) then begin
     ncalls=1
     term_calc(term_index)=1
     ; Default is density is always required
     read_rho=1
     ; Now we decide which wind components are required
     ; First all requiring Uvel
     if (term_index eq 0 or term_index eq 1 or $
         term_index eq 2 or term_index eq 5 or $
         term_index eq 6 or term_index eq 7) then read_u=1
     ; Now those requiring v
     if (term_index eq 1 or term_index eq 3 or $
         term_index eq 6) then read_v=1
     ; Now those requiring w
     if (term_index eq 2 or term_index eq 4 or $
         term_index eq 7) then read_w=1
  endif else begin
     ; Otherwise it might be a summed variables
     ; Which will need all the variables
     read_rho=1
     read_u=1
     read_v=1
     read_w=1
     if (which_term_calc eq sum_names(0)) then begin
        ncalls=7
        term_calc(*)=1
        term_calc(0)=0
     endif else if (which_term_calc eq sum_names(1)) then begin
        ncalls=5
        term_calc(0)=1
        term_calc(1)=1
        term_calc(2)=1
        term_calc(3)=1
        term_calc(4)=1
     endif else if (which_term_calc eq sum_names(2)) then begin
        ncalls=3
        term_calc(5)=1
        term_calc(6)=1
        term_calc(7)=1    
     endif else begin
        print, 'Pumping term: ', which_term_calc
        print, 'Not available'
        print, 'Stopping in setup_pumping_terms.pro'
        stop
     endelse
  endelse
end

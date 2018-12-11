function calc_pump_terms, which_term, $
                          n_lon, n_lat, n_vert, n_time, $
                          lat, vert, time, $
                          vert_type_decomp, $
                          rho_in, u_in, v_in, w_in, $
                          planet_radius, pi, omega, timestep, $
                          lid_height, min_val, $
                          eqn_type=eqn_type, $
                          radius_map=radius_map
  ; Finally! This routine actually calculates the pumping
  ; terms following Hardiman et al (2010) and Showman &
  ; Polvani (2011)
  ; THIS IS CURRENTLY WRITTEN VERY VERBOSELY AND INEFFICIENTLY
  ; this is done to aid the reader, and for testing, 
  ; eventually the routine can be made significantly
  ; more efficient.
  ; RADIUS_MAP: is an array (if present) which 
  ; includes the mapping from height to the vertical
  ; coordinate system used, and is the height+planet radius
  ; It is only required when
  ; running from a mapped set of variables.
  ; These terms are calcuated from a rearranged
  ; version of Equation (5) from Hardiman et al. (2010)
  ; where the accelration of the mean zonal flow is the
  ; LHS (i.e. d(rho_bar*u_bar)/dt.
  ; All other terms are moved to the RHS.
  ; The pressure versions for vertical coordinates
  ; are constructed by performing interpolation of fields
  ; onto pressure before zonally averaging along isobars

  ; NOTES ****:
  ; 1, To get pressure versions we convert w from m/s to pa/s
  ; For pressure-based formulae one des not need to include density
  ; to remove the zonal pressure gradient term (it is proportional to
  ; 1/rho). Therefore, the derivation is much simpler.
  ; However, in height-based, we have the extra term 1\rho dP/dlambda
  ; which does not zonally average to zero...
  ; Althougth the next two points still stand they are tied in to this
  ; Additionally, this is why the
  ; density can not just be removed from these euqations.
  ; 2, I do not understand why the meri_mean term of Hardiman et al.
  ; (2010) includes a cos^2 term but the corresponding term in Showman
  ; and Polvani (2011) does not.
  ; 3, Similarly, I am not sure why the "w" term appears within the 
  ; derivative in Hardiman et al (2010), but without in Showman 
  ; & Polvani (2011)

  if (vert_type_decomp eq 'Pressure') then begin
     if not(KEYWORD_SET(radius_map)) then begin
        print, 'Require a mapping from height to pressure'
        print, 'to calculate pumping terms from pressure'
        print, 'mapped set.'
        print, 'Stopping in calc_pump_terms.pro'
        stop
     endif
  endif else if (vert_type_decomp eq 'Sigma') then begin
     print, 'Not yet coded ability to handle sigma coords'
     print, 'For eddy-mean flow terms'
     print, 'stopping in calc_pump_terms.pro'
     stop
  endif

  ; First we must ensure the equation type used is set
  eqn_type_check, eqn_type=eqn_type

  ; Now calculate value:
  if (which_term eq 'zon_mean_pump') then begin
     ; d(rho_bar*u_bar)/dt
     ; Need zonal mean rho and u, differentiate by time
     ; Calc u_bar
     u_bar=zon_mean_um_std(u_in, min_val, /retain_size)
     rho_bar=zon_mean_um_std(rho_in, min_val, /retain_size)
     rho_u_bar=safe_alloc_um_std_template(u_bar)
     rho_u_bar(*,*,*,*)=u_bar(*,*,*,*)*rho_bar(*,*,*,*)
     rho_bar=0
     u_bar=0
     ; Now differentiate wrt time
     pump_out=calc_d_dt_um_std(rho_u_bar, time)
     rho_u_bar=0
     ; LHS +ve so no need to adjust
  endif else if (which_term eq 'meri_mean_pump') then begin
     ; (d((rho*v)_bar*u_bar*cos^2(phi))/dphi)/rcos^2(phi)
     ; Need (rho*v)_bar
     rho_v=safe_alloc_um_std_template(v_in)
     rho_v(*,*,*,*)=rho_in(*,*,*,*)*v_in(*,*,*,*)
     rho_v_bar=zon_mean_um_std(rho_v, min_val, /retain_size)
     rho_v=0
     ; Now u_bar
     u_bar=zon_mean_um_std(u_in, min_val, /retain_size)
     ; Mutiply them together
     rho_v_bar_u_bar=safe_alloc_um_std_template(rho_v_bar)
     rho_v_bar_u_bar(*,*,*,*)=rho_v_bar(*,*,*,*)*u_bar(*,*,*,*)
     rho_v_bar=0
     u_bar=0
     ; Now need cos^2(phi) factor
     ; Setup output
     d_rho_wind=safe_alloc_um_std_template(rho_v_bar_u_bar)
     d_rho_wind(*,*,*,*)=0.0
     for ilat=0, n_lat-1 do begin
        cos_lat=cos_deg_to_rad(lat(ilat), pi)
        ; Now perform multiplication
        d_rho_wind(*,ilat,*,*)=rho_v_bar_u_bar(*,ilat,*,*)$
                               *cos_lat^2.0
     endfor
     rho_v_bar_u_bar=0
     ; Now differentiate by latitude
     d_rho_wind_dphi=calc_d_dlat_um_std(d_rho_wind, lat, pi)
     d_rho_wind=0
     ; Finally divide by r*cos^2(phi)
     ; Making sure to protect against /0.0
     ; This is done differently if we are using pressure
     ; mapped variables and the deep equations
     ; Setup the output
     pump_out=safe_alloc_um_std_template(d_rho_wind_dphi)
     if (vert_type_decomp eq 'Pressure' and $
         eqn_type eq 'deep') then begin
        for ilat=0, n_lat-1 do begin
           cos_lat=cos_deg_to_rad(lat(ilat), pi)
           if (cos_lat^2.0 gt 0.0) then begin
              pump_out(*,ilat,*,*)=d_rho_wind_dphi(*,ilat,*,*)/$
                                   (radius_map(*,ilat,*,*)*cos_lat^2.0)
           endif else begin
              pump_out(*,ilat,*,*)=0.0         
           endelse
        endfor
     endif else begin
        for ivert=0, n_vert-1 do begin
           radial_pos=get_radius(planet_radius, $
                                 vert(ivert), eqn_type=eqn_type)
           for ilat=0, n_lat-1 do begin
              cos_lat=cos_deg_to_rad(lat(ilat), pi)
              if (cos_lat^2.0 gt 0.0) then begin
                 pump_out(*,ilat,ivert,*)=d_rho_wind_dphi(*,ilat,ivert,*)/$
                                          (radial_pos*cos_lat^2.0)           
              endif else begin
                 pump_out(*,ilat,ivert,*)=0.0         
              endelse
           endfor
        endfor
     endelse
     d_rho_wind_dhpi=0
     ; RHS -ve
     pump_out(*,*,*,*)=-1.0*pump_out(*,*,*,*)
  endif else if (which_term eq 'vert_mean_pump') then begin
     ; (d((rho*w)_bar*u_bar*r^3)/dr)/r^3
     ; First we need to deal with w units.
     ; in height coords this is m/s, 
     ; in Pressure this is Pa/s
     w_loc=convert_w_units(vert_type_decomp, w_in, $
                           vert, radius_map=radius_map)
     ; Now need (rho*w)_bar
     rho_w=safe_alloc_um_std_template(w_loc)
     rho_w(*,*,*,*)=rho_in(*,*,*,*)*w_loc(*,*,*,*)
     rho_w_bar=zon_mean_um_std(rho_w, min_val, /retain_size)
     rho_w=0
     ; Now mutiply by u_bar
     u_bar=zon_mean_um_std(u_in, min_val, /retain_size)
     rho_w_bar_u_bar=safe_alloc_um_std_template(u_bar)
     rho_w_bar_u_bar(*,*,*,*)=rho_w_bar(*,*,*,*)*u_bar(*,*,*,*)
     u_bar=0
     rho_w_bar=0
     ; Now we times by r^3 
     ; Setup output
     rho_w_bar_u_bar_r=safe_alloc_um_std_template(rho_w_bar_u_bar)
     ; Done differently if we are using
     ; a pressure mapped set of variables and deep equations
     ; (for shallow it is always just planet_radius
     if (vert_type_decomp eq 'Pressure' and $
         eqn_type eq 'deep') then begin
        rho_w_bar_u_bar_r(*,*,*,*)=$
           rho_w_bar_u_bar(*,*,*,*)*radius_map(*,*,*,*)^3.0
     endif else begin
        for ivert=0, n_vert-1 do begin
           radial_pos=get_radius(planet_radius, $
                                 vert(ivert), eqn_type=eqn_type)
           rho_w_bar_u_bar_r(*,*,ivert,*)=$
              rho_w_bar_u_bar(*,*,ivert,*)*radial_pos^3.0
        endfor
     endelse
     rho_w_bar_u_bar=0
     ; Now differentiate in the vertical
     rho_w_bar_u_bar_r_dr=calc_d_dvert_um_std($
                          rho_w_bar_u_bar_r, vert)
     rho_w_bar_u_bar_r=0
     ; Finally, divide by r^3
     ; Setup output
     pump_out=safe_alloc_um_std_template(rho_w_bar_u_bar_r_dr)
     ; Again done differently if using pressure mapped input
     ; in conjunction with deep equations (shallow=planet_radius)
     if (vert_type_decomp eq 'Pressure' and $
         eqn_type eq 'deep') then begin
        pump_out(*,*,*,*)=$
           rho_w_bar_u_bar_r_dr(*,*,*,*)/radius_map(*,*,*,*)^3.0
     endif else begin
        for ivert=0, n_vert-1 do begin
           radial_pos=get_radius(planet_radius, $
                                 vert(ivert), eqn_type=eqn_type)
           pump_out(*,*,ivert,*)=$
              rho_w_bar_u_bar_r_dr(*,*,ivert,*)/radial_pos^3.0
        endfor
     endelse
     rho_w_bar_u_bar_r_dr=0
     ; RHS -ve
     pump_out(*,*,*,*)=-1.0*pump_out(*,*,*,*)
  endif else if (which_term eq 'meri_mean_sin_pump') then begin
     ; 2*Omega*(rho*v)_bar*sin(phi)     
     ; First (rho*v)_bar
     rho_v=safe_alloc_um_std_template(v_in)
     rho_v(*,*,*,*)=rho_in(*,*,*,*)*v_in(*,*,*,*)
     rho_v_bar=zon_mean_um_std(rho_v, min_val, /retain_size)
     rho_v=0
     ; Now times by 2*Omega
     rho_v_bar(*,*,*,*)=rho_v_bar(*,*,*,*)*2.0*omega
     ; Finally add the *sin(phi) part
     ; Setup output
     pump_out=safe_alloc_um_std_template(rho_v_bar)
     for ilat=0, n_lat-1 do begin
        sin_lat=sin_deg_to_rad(lat(ilat), pi)
        pump_out(*,ilat,*,*)=rho_v_bar(*,ilat,*,*)*$
                             sin_lat        
     endfor
     rho_v_bar=0
     ; RHS +ve
  endif else if (which_term eq 'vert_mean_cos_pump') then begin
     ; 2*Omega*(rho*w)_bar*cos(phi)     
     ; First (rho_w)_bar
     ; Conversion of vertical velocity from m/s to Pa/s
     ; not required as there is no derivative
     rho_w=safe_alloc_um_std_template(w_in)
     rho_w(*,*,*,*)=rho_in(*,*,*,*)*w_in(*,*,*,*)
     rho_w_bar=zon_mean_um_std(rho_w, min_val, /retain_size)
     rho_w=0
     ; Now times by 2*Omega
     rho_w_bar(*,*,*,*)=rho_w_bar(*,*,*,*)*2.0*omega
     ; Finally times by cos(phi)
     ; Setup output
     pump_out=safe_alloc_um_std_template(rho_w_bar)
     for ilat=0, n_lat-1 do begin
        cos_lat=cos_deg_to_rad(lat(ilat), pi)
        pump_out(*,ilat,*,*)=rho_w_bar(*,ilat,*,*)*$
                             cos_lat        
     endfor
     rho_w_bar=0
     ; RHS -ve
     pump_out(*,*,*,*)=-1.0*pump_out(*,*,*,*)
  endif else if (which_term eq 'zon_eddy_pump') then begin
     ; d(rho_prime*u_prime)_bar)/dt     
     ; Calculate rho_prime*u_prime
     ; As perturbations can vary in longitude we must retain
     ; the full size of the arrays
     decomp_zonal_perturb, rho_in, rho_prime, rho_bar, min_val, $
                           /retain_size
     rho_bar=0
     decomp_zonal_perturb, u_in, u_prime, u_bar, min_val, $
                           /retain_size
     u_bar=0
     rho_prime_u_prime=safe_alloc_um_std_template(u_prime)
     rho_prime_u_prime(*,*,*,*)=rho_prime(*,*,*,*)*u_prime(*,*,*,*)
     rho_prime=0
     u_prime=0
     ; Now mean of this
     rho_prime_u_prime_bar=zon_mean_um_std(rho_prime_u_prime, $
                                           min_val, /retain_size)
     rho_prime_u_prime=0
     ; Finally the time differential
     pump_out=calc_d_dt_um_std(rho_prime_u_prime_bar, time)
     rho_prime_u_prime_bar=0
     ; RHS -ve
     pump_out(*,*,*,*)=-1.0*pump_out(*,*,*,*)
  endif else if (which_term eq 'meri_eddy_pump') then begin
     ; (d(((rho*v_prime)*u_prime)_bar*cos^2(phi))/dphi)/(rcos^2(phi))     
     ; First calculate (rho*v)_prime
     ; Again perturbations vary in longitude so retain size
     rho_v=safe_alloc_um_std_template(v_in)
     rho_v(*,*,*,*)=rho_in(*,*,*,*)*v_in(*,*,*,*)
     decomp_zonal_perturb, rho_v, rho_v_prime, rho_v_bar, min_val, $
                           /retain_size
     rho_v_bar=0
     rho_v=0
     ; Now u_prime and multiply
     decomp_zonal_perturb, u_in, u_prime, u_bar, min_val, $
                           /retain_size
     u_bar=0
     rho_v_prime_u_prime=safe_alloc_um_std_template(u_prime)
     rho_v_prime_u_prime(*,*,*,*)=rho_v_prime(*,*,*,*)*u_prime(*,*,*,*)
     rho_v_prime=0
     u_prime=0
     ; Now we average this
     rho_v_prime_u_prime_bar=zon_mean_um_std($
                             rho_v_prime_u_prime, $
                             min_val, /retain_size)
     rho_v_prime_u_prime=0
     ; Now we times by the cos^2(phi) term
     ; setup output
     d_rho_v_prime_u_prime_bar=$
        safe_alloc_um_std_template(rho_v_prime_u_prime_bar)
     for ilat=0, n_lat-1 do begin
        cos_lat=cos_deg_to_rad(lat(ilat), pi)
        ; Now perform multiplication
        d_rho_v_prime_u_prime_bar(*,ilat,*,*)=$
           rho_v_prime_u_prime_bar(*,ilat,*,*)$
                               *cos_lat^2.0
     endfor
     rho_v_prime_u_prime_bar=0
     ; Then differentiate in latitude
     d_rho_v_prime_u_prime_bar_dphi=calc_d_dlat_um_std($
                                    d_rho_v_prime_u_prime_bar, lat, pi)
     d_rho_v_prime_u_prime_bar=0
     ; Finally divide by r*cos^2(phi)
     ; setup output
     pump_out=safe_alloc_um_std_template(d_rho_v_prime_u_prime_bar_dphi)
     ; Making sure to protect against /0.0
     ; Done differently if we are using
     ; a pressure mapped set of variables and
     ; deep equations (shallow radius=planet radius)
     if (vert_type_decomp eq 'Pressure' $
         and eqn_type eq 'deep') then begin
        for ilat=0, n_lat-1 do begin
           cos_lat=cos_deg_to_rad(lat(ilat), pi)
           if (cos_lat^2.0 gt 0.0) then begin
              pump_out(*,ilat,*,*)=$
                 d_rho_v_prime_u_prime_bar_dphi(*,ilat,*,*)/$
                 (radius_map(*,ilat,*,*)*cos_lat^2.0)           
           endif else begin
              pump_out(*,ilat,*,*)=0.0         
           endelse
        endfor
     endif else begin
        for ivert=0, n_vert-1 do begin
           radial_pos=get_radius(planet_radius, $
                                 vert(ivert), eqn_type=eqn_type)
           for ilat=0, n_lat-1 do begin
              cos_lat=cos_deg_to_rad(lat(ilat), pi)
              if (cos_lat^2.0 gt 0.0) then begin
                 pump_out(*,ilat,ivert,*)=$
                    d_rho_v_prime_u_prime_bar_dphi(*,ilat,ivert,*)/$
                    (radial_pos*cos_lat^2.0)           
              endif else begin
                 pump_out(*,ilat,ivert,*)=0.0         
              endelse
           endfor
        endfor
     endelse
     d_rho_v_prime_u_prime_bar_dphi=0
     ; RHS -ve
     pump_out(*,*,*,*)=-1.0*pump_out(*,*,*,*)
  endif else if (which_term eq 'vert_eddy_pump') then begin
     ; (d((rho*w)_prime*u_prime)_bar*r^3)/dr)/r^3     
     ; First derive (rho*w)_prime
     ; Again retain full longitude size of array
     ; First we need to deal with w units.
     ; in height coords this is m/s, 
     ; in Pressure this is Pa/s
     w_loc=convert_w_units(vert_type_decomp, w_in, $
                           vert, radius_map=radius_map)
     rho_w=safe_alloc_um_std_template(w_loc)
     rho_w(*,*,*,*)=rho_in(*,*,*,*)*w_loc(*,*,*,*)
     decomp_zonal_perturb, rho_w, rho_w_prime, rho_w_bar, min_val, $
                           /retain_size
     rho_w_bar=0
     rho_w=0
     ; Mulitply by u_prime
     decomp_zonal_perturb, u_in, u_prime, u_bar, min_val, $
                           /retain_size
     u_bar=0
     rho_w_prime_u_prime=safe_alloc_um_std_template(u_prime)
     rho_w_prime_u_prime(*,*,*,*)=rho_w_prime(*,*,*,*)*u_prime(*,*,*,*)
     rho_w_prime=0
     u_prime=0
     ; Now we average this
     rho_w_prime_u_prime_bar=zon_mean_um_std($
                             rho_w_prime_u_prime, $
                             min_val, /retain_size)
     rho_w_prime_u_prime=0
     ; Now multiply br r^3
     ; Setup output
     d_rho_w_prime_u_prime_bar=$
        safe_alloc_um_std_template(rho_w_prime_u_prime_bar)
     ; The *r^3 is done differently if coming
     ; from a mapped input and deep equations
     if (vert_type_decomp eq 'Pressure' and $
         eqn_type eq 'deep') then begin
        d_rho_w_prime_u_prime_bar(*,*,*,*)=$
           rho_w_prime_u_prime_bar(*,*,*,*)*$
           radius_map(*,*,*,*)^3.0
     endif else begin
        for ivert=0, n_vert-1 do begin
           radial_pos=get_radius(planet_radius, $
                                 vert(ivert), eqn_type=eqn_type)
           d_rho_w_prime_u_prime_bar(*,*,ivert,*)=$
              rho_w_prime_u_prime_bar(*,*,ivert,*)*radial_pos^3.0
        endfor
     endelse
     rho_w_prime_u_prime_bar=0
     ; Next differentiate vertically 
     d_rho_w_prime_u_prime_bar_dr=calc_d_dvert_um_std($
                                  d_rho_w_prime_u_prime_bar, $
                                  vert)
     d_rho_w_prime_u_prime_bar=0
     ; Finally, divide by r^3
     ; Again done differently from mapped
     ; when using deep equations, for shallow
     ; only use planet radius anyway.
     ; Setup output
     pump_out=safe_alloc_um_std_template(d_rho_w_prime_u_prime_bar_dr)
     if (vert_type_decomp eq 'Pressure' and $
         eqn_type eq 'deep') then begin
        pump_out(*,*,*,*)=$
           d_rho_w_prime_u_prime_bar_dr(*,*,*,*)/$
           radius_map(*,*,*,*)^3.0
     endif else begin
        for ivert=0, n_vert-1 do begin
           radial_pos=get_radius(planet_radius, $
                                 vert(ivert), eqn_type=eqn_type)
           pump_out(*,*,ivert,*)=$
              d_rho_w_prime_u_prime_bar_dr(*,*,ivert,*)/radial_pos^3.0
        endfor
     endelse
     d_rho_w_prime_u_prime_bar_dr=0
     ; RHS -ve
     pump_out(*,*,*,*)=-1.0*pump_out(*,*,*,*)
  endif else begin
     print, 'Pumping terms: ', which_term
     print, 'not available in calc_pump_terms.pro'
     stop
  endelse
  return, pump_out
end

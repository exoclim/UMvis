pro check_restore_basic, vert_type_req, $
                         vert_type, $
                         planet_setup_in=planet_setup_in, $
                         cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, $
                         planet_radius_ovrd=planet_radius_ovrd, $
                         p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
                         grav_surf_ovrd=grav_surf_ovrd, $
                         timestep_ovrd=timestep_ovrd, $
                         lid_height_ovrd=lid_height_ovrd, $
                         np_levels_ovrd=np_levels_ovrd, $
                         pi, R, cp, kappa, planet_radius, p0, $
                         omega, grav_surf, timestep, lid_height, $
                         min_val, $         
                         planet_setup, $ 
                         verbose=verbose
  ; A small routine to check the consistency of restored and 
  ; requested variables.
  err=0
  err_msg='Error:'
  if (KEYWORD_SET(planet_setup_in)) then begin
     if (planet_setup_in ne planet_setup) then begin
        err=1
        err_msg=err_msg+' planet_setup_in does not match restored planet_setup'
     endif
  endif
  if (vert_type_req ne vert_type) then begin
     err=1
     err_msg=err_msg+' vert_type requested does not matched restored vert_type'
  endif
  if (KEYWORD_SET(cp_ovrd)) then begin
     if (cp_ovrd ne cp) then begin
        err_msg=err_msg+' cp requested does not match cp restored'
     endif
  endif
  if (KEYWORD_SET(planet_radius_ovrd)) then begin
     if (planet_radius_ovrd ne planet_radius) then begin
        err_msg=err_msg+' planet_radius requested does not match planet_radius restored'
     endif
  endif
  if (KEYWORD_SET(p0_ovrd)) then begin
     if (p0_ovrd ne p0) then begin
        err_msg=err_msg+' p0 requested does not match p0 restored'
     endif
  endif
  if (KEYWORD_SET(grav_surf_ovrd)) then begin
     if (grav_surf_ovrd ne grav_surf) then begin
        err_msg=err_msg+' grav_surf requested does not match grav_surf restored'
     endif
  endif
  if (KEYWORD_SET(timestep_ovrd)) then begin
     if (timestep_ovrd ne timestep) then begin
        err_msg=err_msg+' timestep requested does not match timestep restored'
     endif
  endif
  if (KEYWORD_SET(lid_height_ovrd)) then begin
     if (lid_height_ovrd ne lid_height) then begin
        err_msg=err_msg+' lid_height requested does not match lid_height restored'
     endif
  endif
  if (KEYWORD_SET(R_ovrd)) then begin
     if (R_ovrd ne R) then begin
        err_msg=err_msg+' R requested does not match R restored'
     endif
  endif
  if (kappa ne R/cp) then begin
    err_msg=err_msg+' Inconsistent R/cp and Kappa selected restored'
  endif

  if (err eq 1) then begin
     print, '***************************************'
     print, err_msg
     print, 'stopping in check_restore_basic.pro'
     print, '***************************************'
     stop
  endif
end

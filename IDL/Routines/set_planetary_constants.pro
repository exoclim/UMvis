pro set_planetary_constants, netcdf_um_fname, $
                             planet_setup, $
                             cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, $
                             planet_radius_ovrd=planet_radius_ovrd, $
                             p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
                             grav_surf_ovrd=grav_surf_ovrd, $
                             timestep_ovrd=timestep_ovrd, $
                             lid_height_ovrd=lid_height_ovrd, $
                             netcdf_name_ovrd=netcdf_name_ovrd, $
                             pi, R, cp, kappa, planet_radius, p0, $
                             omega, grav_surf, timestep, lid_height, $
                             min_val, $         
                             verbose=verbose
  ; Set up planetary constants, and sort overrides
  ; First we set up universal constants
  pi=4.0*atan(1.0D)
  min_val=-1.0e90
  ; Now populate the list 
  planet_setup_list, nsetups, setup_names, R_list, cp_list, $
                     planet_radius_list, p0_list, omega_list, $
                     grav_surf_list, timestep_list

  ; Is our setup in the list
  found=0
  for iset=0, nsetups-1 do begin
     if (planet_setup eq setup_names(iset)) then begin
        found=1
        R=R_list(iset)
        cp=cp_list(iset)
        planet_radius=planet_radius_list(iset)
        p0=p0_list(iset)
        omega=omega_list(iset)
        grav_surf=grav_surf_list(iset)
        timestep=timestep_list(iset)
     endif
  endfor
  if (found eq 0) then begin
     print, 'Planet_Setup:', planet_setup
     print, 'not found in planet_setup_list.pro'
     stop
  endif

  ; Now we set the lid height as a special case
  if KEYWORD_SET(lid_height_ovrd) then begin
     lid_height=lid_height_ovrd
  endif else begin
     ; Default is top of theta
     z_theta=get_variable_grid(netcdf_um_fname, 'theta', 2,$
                               verbose=verbose)
     lid_height=max(z_theta)
     z_theta=0
  endelse
  
  ; Now deal with overrides
  if (KEYWORD_SET(cp_ovrd)) then cp=cp_ovrd
  if (KEYWORD_SET(R_ovrd)) then R=R_ovrd
  if (KEYWORD_SET(planet_radius_ovrd)) then $
     planet_radius=planet_radius_ovrd
  if (KEYWORD_SET(p0_ovrd)) then p0=p0_ovrd
  if (KEYWORD_SET(omega_ovrd)) then omega=omega_ovrd
  if (KEYWORD_SET(grav_surf_ovrd)) then grav_surf=grav_surf_ovrd
  if (KEYWORD_SET(timestep_ovrd)) then timestep=timestep_ovrd

  ; Finally set out only dependant constant
  kappa=R/cp
  
  if (KEYWORD_SET(verbose)) then begin
     print, 'Using planet_setup:', planet_setup
     print, 'R:', R
     print, 'cp:', cp
     print, 'kappa:', kappa
     print, 'planet_radius:', planet_radius
     print, 'p0:', p0
     print, 'omega:', omega
     print, 'grav_surf:', grav_surf
     print, 'timestep:', timestep
     print, 'lid_height:', lid_height
     print, 'pi:', pi
     print, 'min_val:', min_val
  endif
end

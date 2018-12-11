function calc_ep_flux, which_plot, $
                       planet_radius,$
                       n_lon, n_lat, n_heights, nt,$
                       density, uvel_press, wind_press,$
                       z, lat, $
                       eqn_type=eqn_type, min_val, pi


print, 'This is not finished yet'


; NEED THE DIFF_STREAMFUNCTION
; AND ZONAL-MEAN AXIAL ABSOLUTE ANGULAR MOMENTUM PER UNIT MASS

stop



  ; This function calculates either the components of the
  ; Eliasen-Palm flux or the divergence of this.
  ; Equations for deep nonhydrostatic atmosphere
  ; from Hardiman et al (2010)
  ; The pertubations from the wind and density are the same
  ; as for the eddy momentum terms
  ; The input winds should be on a p-grid

  ; Define the output array
  arr_size=INTARR(4)
  arr_size(0)=n_lon
  arr_size(1)=n_lat
  arr_size(2)=n_heights
  arr_size(3)=nt
  ep_out=safe_alloc_arr(4, arr_size, /float_arr)
  ; First we need to create the perturbation variable
  ; Need u' for both but either (rho*v)' or (rho*w)'
  decomp_zonal_perturb,uvel_press, $
                       uvel_perturb, uvel_mean, min_val
  ; Do not need the zonal wind zonal mean
  uvel_mean=0
  ; To get the rho*wind variable we must interpolate the wind
  rho_wind=safe_alloc_arr(4, arr_size, /float_arr)
  ; Create the rho_wind variable
  rho_wind(*,*,*,*)=density(*,*,*,*)*wind_press(*,*,*,*)
  ; Now get the final perturbation variable
  decomp_zonal_perturb, rho_wind, $
                        rho_wind_perturb, rho_wind_mean, min_val
  ; Do not need the zonal mean
  rho_wind_mean=0
  ; The final perturbation variable
  perturb=safe_alloc_arr(4, arr_size, /float_arr)
  perturb(*,*,*,*)=rho_wind_perturb(*,*,*,*)*uvel_perturb(*,*,*,*)
  rho_wind_perturb=0
  uvel_perturb=0
  rho_wind=0
  ; Now we have the perturbation variable or eddy-eddy variable
  ; either (rho*v)'u' or (rho*w)'u'
  ; Now we zonally average it
  zon_mean_perturb=safe_alloc_arr(4, arr_size, /float_arr)
  perturb_mean=zon_mean_um_std(perturb, min_val)
  perturb=0
  for ilon=0, n_lon-1 do begin
     zon_mean_perturb(ilon,*,*,*)=perturb_mean(0,*,*,*)
  endfor
  perturb_mean=0
  ; Now we can create the actual term
  if (which_plot eq 'EP_flux_lat') then begin
     ; Go to one off top for interpolation
     for ivert=0,  n_heights-2 do begin
        radial_pos=$
           get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
        radial_pos_two=$
           get_radius(planet_radius, z(ivert+1), eqn_type=eqn_type)
        for ilat=0, n_lat-1 do begin
           inc_lat=ilat+1
           ; Stop if we hit the pole
           if (ilat eq n_lat-1) then begin
              print, 'Hit the pole in calc_total_speed.pro'
              print, 'Look at solution in mapvert_um and v_vel_onto_pressure.pro'
              stop
           endif
           cos_lat=cos_deg_to_rad(lat(ilat), pi)
           cos_lat_inc=cos_deg_to_rad(lat(inc_lat), pi)
           factor=-1.0/(radial_pos*cos_lat^2.0)
           ; Protect against infinte values
           if (cos_lat eq 0.0 or $
               cos_lat_inc-cos_lat eq 0.0) then begin
              eddy_conv(*,ilat,ivert,*)=0.0
           endif else begin
              eddy_conv(*,ilat,ivert,*)=$
                 factor*$
                 ((zon_mean_perturb(*,inc,ivert,*)*cos_lat_inc^2.0-$
                   zon_mean_perturb(*,ilat,ivert,*)*cos_lat^2.0)$
                  /(lat_rad_inc-lat_rad))
           endelse
        endfor
     endfor
  endif else if (which_plot eq 'vert_eddy_mmtm_conv') then begin
     ; Vertical gradient so can't do top
     for ivert=0,  n_heights-2 do begin
        radial_pos=$
           get_radius(planet_radius, z(ivert), eqn_type=eqn_type)
        radial_pos_two=$
           get_radius(planet_radius, z(ivert+1), eqn_type=eqn_type)
        factor=-1.0/radial_pos^3.0
        eddy_conv(*,*,ivert,*)=$
            factor*$
           ((zon_mean_perturb(*,*,ivert+1,*)*radial_pos_two^3.0-$
             zon_mean_perturb(*,*,ivert,*)*radial_pos^3.0)$
            /(z(ivert+1)-z(ivert)))
     endfor
     ; Set the last one to zero
     eddy_conv(*,*,n_heights-1,*)=0.0
  endif
  zon_mean_perturb=0
  return, eddy_conv
end

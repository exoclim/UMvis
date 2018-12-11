function calc_diff_stream, planet_radius,$
                           n_lon, lon, n_lat, lat, $
                           n_heights, z, nt, t,$
                           density, vvel_press, wvel_press, $
                           theta_press,$
                           eqn_type=eqn_type, min_val, pi


;THIS IS VERY, VERY UNTESTED!!!!


  ; This function calculates the stream difference
  ; stream function defined in Hardiman et al (2010)
  ; Define the output array
  diff_stream=fltarr(n_lon,n_lat,n_heights,nt)
  ; First we find the perturbation zonal-mean variables
  ; Need the pertubation of theta, rho*v and rho*w
  ; Theta first (theta')
  decomp_zonal_perturb,theta_press, theta_perturb,$
                       theta_mean_temp, min_val
  ; Need a full theta_mean variable
  theta_mean=fltarr(n_lon,n_lat,n_heights,nt)
  for ilon=0, n_lon-1 do begin
     theta_mean(ilon,*,*,*)=theta_mean_temp(0,*,*,*)
  endfor

  theta_press=0
  ; Now construct rho*v pertubration (i.e. (rho*v)')
  decomp_zonal_perturb, vvel_press, $
                        vvel_perturb, vvel_mean, min_val
  ; Do not need the zonal wind zonal mean  
  vvel_mean=0
  rho_vvel=fltarr(n_lon,n_lat,n_heights,nt)
  rho_vvel(*,*,*,*)=density(*,*,*,*)*vvel_press(*,*,*,*)
  decomp_zonal_perturb,rho_vvel,rho_vvel_perturb, rho_vvel_mean, min_val
  rho_vvel_mean=0
  ; Now the same for W (i.e. (rho*w)')
  decomp_zonal_perturb, wvel_press, $
                        wvel_perturb, wvel_mean, min_val
  ; Do not need the zonal wind zonal mean  
  wvel_mean=0
  rho_wvel=fltarr(n_lon,n_lat,n_heights,nt)
  rho_wvel(*,*,*,*)=density(*,*,*,*)*w_press(*,*,*,*)
  decomp_zonal_perturb,rho_wvel,rho_wvel_perturb, rho_wvel_mean, min_val
  rho_wvel_mean=0
  ; So have: theta', (rho*v)' and (rho*w)'
  ; Now need zonal average of [theta'(rho*v)'], 
  ; [theta] and [theta'(rho*w)']
  ; Zonal-mean of theta we already have from 
  ; perturbation calculation
  ; zonal-mean of (rho*v)'*theta'
  zon_mean, rho_vvel_perturb*theta_perturb, $
            min_val, n_lon, n_lat, n_heights, nt,$
            meri_mean_perturb_temp
  ; Need a full sized variable
  meri_mean_perturb=fltarr(n_lon,n_lat,n_heights,nt)
  for ilon=0, n_lon-1 do begin
     meri_mean_perturb(ilon,*,*,*)=meri_mean_perturb_temp(*,*,*)
  endfor
  meri_mean_perturb_temp=0
  rho_vvel_perturb=0
  ; zonal-mean of (rho*w)'*theta'
  zon_mean, rho_wvel_perturb*theta_perturb, $
           min_val, n_lon, n_lat, n_heights, nt,$
           vert_mean_perturb_temp
  vert_mean_perturb=fltarr(n_lon,n_lat,n_heights,nt)
  for ilon=0, n_lon-1 do begin
     vert_mean_perturb(ilon,*,*,*)=vert_mean_perturb_temp(*,*,*)
  endfor
  vert_mean_perturb_temp=0
  rho_wvel_perturb=0
  ; Finally we need the modulus^2.0
  ; of the gradient of theta_mean
  calc_gradient,n_lon, lon, n_lat, lat, $
                n_heights, z, nt, t,$
                theta_mean, grad_lon,$
                grad_lat, grad_vert,$
                grad_time
  ; Modulus (space, components only)
  mod_grad_theta_mean=fltarr(n_lon,n_lat,n_heights,nt)
  mod_grad_theta_mean(*,*,*,*)=grad_lon(*,*,*,*)^2.0+$
                               grad_lat(*,*,*,*)^2.0+$
                               grad_vert(*,*,*,*)^2.0
  grad_lon=0
  grad_lat=0
  grad_vert=0
  grad_time=0
  ; Allocate arrays to hold factors
  ; and construction variables
  factor=FLTARR(n_lon,1,1,nt)
  term_one=FLTARR(n_lon,1,1,nt)
  term_two=FLTARR(n_lon,1,1,nt)

  ; Now construct the actual streamfunction
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
        ; Need to protect against zero values
        for it=0, nt-1 do begin
           for ilon=0, n_lon-1 do begin
              if (mod_grad_theta_mean(ilon,ilat,ivert,it) eq 0.0) then begin
                 factor(ilon,0,0,it)=0.0
              endif else begin
                 factor(ilon,0,0,it)=(radial_pos*cos_lat)/$
                                     (mod_grad_theta_mean(ilon,ilat,ivert,it))
              endelse
           endfor
        endfor
        term_one(*,0,0,*)=factor(*,0,0,*)*$
                          meri_mean_perturb(*,ilat,ivert,*)*$
                          ((theta_mean(*,ilat,ivert+1,*)-$
                            theta_mean(*,ilat,ivert,*))/$
                           (z(ivert+1)-z(ivert)))
        if (lat_rad_inc-lat_rad eq 0.0) then begin
           term_two(*,0,0,*)=0.0
        endif else begin
           term_two(*,0,0,*)=(1.0/radial_pos)*factor(*,0,0,*)*$
                             vert_mean_perturb(*,ilat,ivert,*)*$
                             ((theta_mean(*,inc_lat,ivert,*)-$
                               theta_mean(*,ilat,ivert,*))/$
                              (lat_rad_inc-lat_rad))
        endelse
        diff_stream(*,ilat,ivert,*)=term_one(*,0,0,*)+$
                                    term_two(*,0,0,*)
     endfor
  endfor
  ; set the top value
  diff_stream(*,*,n_heights-1,*)=0.0
  factor=0
  term_one=0
  term_two=0
  theta_mean=0
  meri_mean_perturb=0
  vert_mean_perturb=0
  return, diff_stream
end

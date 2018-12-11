pro cvar_rossby_number, fname, netcdf_var_names, $
                        p_array, psurf_array,$
                        p_grid_name, p_grid_size,$
                        p_lon, p_lat, p_vert, p_time,$
                        variable_out,$
                        var_grid_name, var_grid_size,$
                        var_lon, var_lat, var_vert, var_time,$
                        planet_radius, pi, omega, eqn_type=eqn_type,$
                        which_var, $
                        verbose=verbose
  ; Routine to construct simple Rossby number
  ; Read in zonal velocity
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, u_vel
  ; Read in the longitude grid
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  ; Need zonal velocity on pressure points
  u_vel_press=interp_longitude_um_std(u_vel, u_lon, var_lon)
  u_vel=0
  ; Now calculate the Rossby Number
  arr_size=INTARR(4)
  arr_size(0)=p_grid_size(0)
  arr_size(1)=p_grid_size(1)
  arr_size(2)=p_grid_size(2)
  arr_size(3)=p_grid_size(3)
  variable_out=safe_alloc_arr(4, arr_size, /float_arr)
  arr_size=0
  factor=4.0*pi*omega
  if (KEYWORD_SET(verbose)) then begin
     print, 'Starting calculation of Rossby number'
  endif
  
  ; Now loop to create Rossby Number
  for ilat=0, p_grid_size(1)-1 do begin
     sin_lat=sin_deg_to_rad(p_lat(ilat), pi)     
     if (sin_lat eq 0.0) then begin
        variable_out(*,ilat,*,*)=min_val
     endif else begin
        for itime=0, p_grid_size(3)-1 do begin
           for ivert=0, p_grid_size(2)-1 do begin              
              for ilon=0, p_grid_size(0)-1 do begin
                 if (KEYWORD_SET(eqn_type)) then begin
                    if (eqn_type eq 'deep') then begin
                       ; R=U/(4*pi*Omega*(Rp+Zu)*sin(phi)
                       variable_out(ilon,ilat,ivert,itime)=$
                          u_vel_press(ilon,ilat,ivert,itime)/$
                          (factor*(planet_radius+var_vert(ivert))*sin_lat) 
                    endif else if (eqn_type eq 'shallow') then begin
                                ; R=U/(4*pi*Omega*(Rp+Zu)*sin(phi)
                       variable_out(ilon,ilat,ivert,itime)=$
                          u_vel_press(ilon,ilat,ivert,itime)/$
                          (factor*planet_radius*sin_lat)
                    endif else begin
                       print, 'Equation Type not recognised', eqn_type
                       stop
                    endelse        
                 endif else begin
                    print, 'Equation type must be set to calculate Rossby Number'
                    stop
                 endelse
              endfor
           endfor
        endfor
     endelse
  endfor
  u_vel_press=0
end


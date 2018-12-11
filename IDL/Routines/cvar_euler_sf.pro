pro cvar_euler_sf, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   variable_out,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   planet_radius, pi, p0, min_val, grav_surf,$
                   grav_type=grav_type, eqn_type=eqn_type,$
                   verbose=verbose
  ; Construction of the Euler mean streamfunction
  ; based on the meridional velocity.
  ; Therefore, read this in and alter the
  ; grid
  target_var='Vvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid, fname, ncdf_name, $
                             vvel, var_grid_name,$
                             var_grid_size
  ; Only latitude grid should be different so read it in
  v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)
  var_lat=v_lat
  v_lat=0
  ; now calculate the stream function
  ; This is from Held & Shneider (1998) 
  ; and Paulius, Czja and Korty (2008) but 
  ; using height instead of pressure
  ; Currently this function needs checking
  if (KEYWORD_SET(verbose)) then begin
     print, 'WARNING: Euler SF needs checking'
     print, 'TIME MUST BE SET TO MEAN'
  endif
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; First we required the mean meridional velocity
  zon_mean_vvel=zon_mean_um_std(vvel, min_val)
  ; No we integrate in height fromm position to
  ; the bottom
  grav=calc_grav(grav_surf, $
                 planet_radius, $
                 var_vert, var_grid_size(2), $
                 grav_type=grav_type, verbose=verbose)
  for ilat=0, var_grid_size(1)-1 do begin
     for ivert=0, var_grid_size(2)-1 do begin
        ; Get radius
        radial_pos=$
           get_radius(planet_radius, var_vert(ivert),$
                      eqn_type=eqn_type)
        ; Calculate cos_lat
        cos_lat=cos_deg_to_rad(var_lat(ilat), pi)
        ; Now calculate multiplying factor
        ; Not dimensionally consistent with others
        ; so add different term, pressure not radius
        ; factor=(2.0*pi*radial_pos*cos_lat)/grav(ivert)
        ; factor=(2.0*pi*p0*cos_lat)/grav(ivert)
        ; Version used in paper (Mayne et al, 2013-Earth)
        factor=-1.0*(2.0*pi*radial_pos*cos_lat)
        for ilon=0, var_grid_size(0)-1 do begin
           if (ivert eq 0) then begin
              ; Now calculate int_sum
              ; On bottom so just the height 
              ; of cell
              variable_out(ilon,ilat,ivert,*)=$
                 factor*zon_mean_vvel(0,ilat,ivert,*)*$
                 (var_vert(ivert))
           endif else begin
              ; Above bottom cumulative sum
              variable_out(ilon,ilat,ivert,*)=$
                 variable_out(ilon,ilat,ivert-1,*)+$
                 factor*zon_mean_vvel(0,ilat,ivert,*)*$
                 (var_vert(ivert)-var_vert(ivert-1))
           endelse
        endfor
     endfor
  endfor
end

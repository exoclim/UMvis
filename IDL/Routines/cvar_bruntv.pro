pro cvar_bruntv, fname, netcdf_var_names, $
                 p_array, psurf_array,$
                 p_grid_name, p_grid_size,$
                 p_lon, p_lat, p_vert, p_time,$
                 variable_out,$
                 var_grid_name, var_grid_size,$
                 var_lon, var_lat, var_vert, var_time,$
                 planet_radius, grav_surf, grav_type=grav_type,$
                 verbose=verbose
  ; Routine to calculate the Brunt-Vaisaila Frequency
  ; or bouyancy frequency.
  ; First we need th density, on p-grid.
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; Now calculate Brunt V
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  gravity=calc_grav(grav_surf,  planet_radius,$
                    var_vert, var_grid_size(2), $
                    grav_type=grav_type, verbose=verbose)

  ; Now calculate the Brunt-Vaisala Frequency
  ; N=SQRT(-g/rho   drho(z)/dz)

  for ivert=0, var_grid_size(2)-1 do begin
     if (ivert lt var_grid_size(2)-1) then begin
        dz=var_vert(ivert+1)-z_rho(ivert)
        drho=density(*,*,ivert+1,*)-$
             density(*,*,ivert,*)
        ; for top level just copy box below
     endif else begin
        dz=var_vert(ivert)-z_rho(ivert-1)
        drho=density(*,*,ivert,*)-$
             density(*,*,ivert-1,*)
     endelse
     drho_dz=drho/dz
     variable_out(*,*,ivert,*)=$
        SQRT((-1.0*gravity(ivert)/density(*,*,ivert,*))*$
             drho_dz)    
  endfor
  density=0
  gravity=0
end

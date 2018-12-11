pro cvar_h_p, fname, netcdf_var_names, $
              p_array, psurf_array,$
              p_grid_name, p_grid_size,$
              p_lon, p_lat, p_vert, p_time,$
              variable_out,$
              var_grid_name, var_grid_size,$
              var_lon, var_lat, var_vert, var_time,$
              p0, kappa, R, planet_radius, grav_surf,$
              grav_type=grav_type,$
              verbose=verbose
  ; Routine to construct the pressure scaleheight
  ; H_p=RT/g
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  gravity=calc_grav(grav_surf, planet_radius,$
                    var_vert, var_grid_size(2), $
                    grav_type=grav_type, verbose=verbose)
  ; Read in temperature
  cvar_temp, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             temperature, $
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             p0, kappa, lid_height,$
             verbose=verbose

  if (KEYWORD_SET(verbose)) then begin
     print, 'WARNING: using a simplification involving'
     print, 'assumption of ideal gas'
  endif
  ; Now calc the pressure scaleheight
  ; As P_i=P_0exp(-g/RT * dz)  For hydrostatic equlibirum
  ;H_p=RT/g

  for ivert=0, var_grid_size(2)-1 do begin
     variable_out(*,*,ivert,*)=(R*temperature(*,*,ivert,*))/$
                               gravity(ivert)
  endfor
  temperature=0
  gravity=0
end

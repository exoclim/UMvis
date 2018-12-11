pro cvar_pe, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             variable_out,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, pi, grav_surf, grav_type=grav_type,$
             verbose=verbose
  ; Calculation of the simple PE, i.e. PE=mgh
  ; Read mass, on p-grid so OK to use cvar routine
  cvar_mass, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             mass,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, pi,$
             verbose=verbose
  ; Output on p-grid, should match var_grid
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; Calculate the gravity at each height
  gravity=calc_grav(grav_surf, planet_radius, var_vert, $
                    var_grid_size(2), grav_type=grav_type, $
                    verbose=verbose)
  ; Calculate PE
  for ivert=0, var_grid_size(2)-1 do begin
     variable_out(*,*,ivert,*)=$
        mass(*,*,ivert,*)*gravity(ivert)*var_vert(ivert)
  endfor
  mass=0
  gravity=0
end

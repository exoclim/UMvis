pro cvar_dyn_eqn_terms, fname, netcdf_var_names, $
                        p_array, psurf_array,$
                        p_grid_name, p_grid_size,$
                        p_lon, p_lat, p_vert, p_time,$
                        variable_out,$
                        var_grid_name, var_grid_size,$
                        var_lon, var_lat, var_vert, var_time,$
                        planet_radius, omega, pi, eqn_type=eqn_type,$
                        lid_height, which_term,$
                        verbose=verbose
  ; Routine to construct the terms from
  ; the equations of motion (mmtm and mass)
  ; First setup the read info
  setup_dyn_eqn_terms, which_term, nterms, term_names, $
                       term_calc, ncalls, $
                       read_rho, read_u, read_v, read_w
  ; Now read in the required variables (and interpolated to p grid)
  if (read_rho eq 1) then begin
     cvar_density, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   rho_in,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   planet_radius,$
                   verbose=verbose

  endif else begin
     rho_in=0
  endelse
  ; Now winds, u:
  if (read_u eq 1) then begin
     target_var='Uvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     read_netcdf_variable_only,fname, ncdf_name, u_vel
     ; Need U on p-grid
     u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
     u_in=interp_longitude_um_std(u_vel, u_lon, p_lon)
     u_vel=0
     u_lon=0
  endif else begin
     u_in=0
  endelse
  ; Now all terms with v
  if (read_v eq 1) then begin
     target_var='Vvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     read_netcdf_variable_only,fname, ncdf_name, v_vel
     ; Need V on p-grid
     v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)    
     v_in=interp_latitude_um_std(v_vel, v_lat, p_lat)
     v_vel=0
     v_lat=0
  endif else begin
     v_in=0
  endelse
  ; Now all the terms with w
  if (read_w eq 1) then begin
     target_var='Wvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     read_netcdf_variable_only,fname, ncdf_name, w_vel
     ; W on p-grid
     w_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
     ; Need vertical velocity on pressure points
     w_in=interp_height_um_std(w_vel, w_vert, p_vert, $
                               lid_height)
     w_vel=0
     w_vert=0
  endif else begin
     w_in=0
  endelse
  ; Now calculate the term
  variable_out=calc_dyn_eqn_terms(fname, which_term,$
                                  u_in, v_in, w_in, rho_in,$
                                  var_lat,$
                                  var_grid_size(0), var_grid_size(1), $
                                  var_grid_size(2), var_grid_size(3), $
                                  var_vert, $
                                  planet_radius, omega, pi,$
                                  eqn_type=eqn_type, lid_height)
  u_in=0
  v_in=0
  w_in=0
  rho_in=0  
end

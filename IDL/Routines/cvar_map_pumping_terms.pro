pro cvar_map_pumping_terms, which_var, var_combined_full, $
                            nprog_req, prog_name_req, call_var_index, $
                            grid_size_combined, $
                            lon_combined, lat_combined, $
                            vert_combined, time_combined, $
                            var_vert_bounds_combined_full, vert_type, $
                            pi, planet_radius, omega, timestep, lid_height, $
                            min_val, $
                            eqn_type=eqn_type, $                            
                            var_constructed, $
                            var_vert_bounds_constructed, $
                            verbose=verbose
  ; This routine constructs the pumping terms from mapped output  
  ; First call the routine to setup the information
  ; for the basic terms
  setup_pumping_terms, which_var, which_var_calc, nterms, term_names, $
                       term_calc, ncalls, $
                       read_rho, read_u, read_v, read_w
  ; First we assign the density
  if (read_rho eq 1) then begin
     ; This should not fail as it is prescribed!
     rho_loc=find_string_in_arr(nprog_req, prog_name_req, 'Density')
     ; Setup output
     rho_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
     rho_in(*,*,*,*)=var_combined_full(call_var_index(rho_loc),*,*,*,*)
  endif else begin     
     rho_in=0
  endelse
  ; Read in wind components as required
  if (read_u eq 1) then begin
     ; This should not fail as it is prescribed!
     u_loc=find_string_in_arr(nprog_req, prog_name_req, 'Uvel')
     u_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
     u_in(*,*,*,*)=var_combined_full(call_var_index(u_loc),*,*,*,*)
  endif else begin
     u_in=0
  endelse
  if (read_v eq 1) then begin
     ; This should not fail as it is prescribed!
     v_loc=find_string_in_arr(nprog_req, prog_name_req, 'Vvel')
     v_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
     v_in(*,*,*,*)=var_combined_full(call_var_index(v_loc),*,*,*,*)
  endif else begin
     v_in=0
  endelse
  if (read_w eq 1) then begin
     ; This should not fail as it is prescribed!
     w_loc=find_string_in_arr(nprog_req, prog_name_req, 'Wvel')
     w_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
     w_in(*,*,*,*)=var_combined_full(call_var_index(w_loc),*,*,*,*)
  endif else begin
     w_in=0
  endelse

  ; Now we deal with the mapping from height to the
  ; chosen coordinate (used to create the mapping file).
  ; Also add in the planet radius to make it radial position.
  if (vert_type eq 'Pressure' or vert_type eq 'Sigma') then begin
     radius_map_loc=find_string_in_arr(nprog_req, prog_name_req, 'Height_rho')
     radius_map=safe_alloc_arr(4, grid_size_combined, /float_arr)
     radius_map(*,*,*,*)=$
        var_combined_full(call_var_index(radius_map_loc),*,*,*,*)$
                         +planet_radius
  endif else if (vert_type eq 'Height') then begin
     radius_map=0
  endif
  ; Now call the wrapper which actually calls the pumping calculation
  var_constructed=calc_pumping_terms_wrap(which_var_calc, nterms, term_names, $
                                          term_calc, ncalls, $
                                          grid_size_combined(0), $
                                          grid_size_combined(1), $
                                          grid_size_combined(2), $
                                          grid_size_combined(3), $ 
                                          lat_combined, vert_combined, $
                                          time_combined, $       
                                          vert_type, $
                                          rho_in, u_in, v_in, w_in, $
                                          planet_radius, pi, omega, timestep, $
                                          lid_height, min_val, $
                                          eqn_type=eqn_type,$
                                          radius_map=radius_map)
  ; Sort vertical bounds
  var_vert_bounds_constructed=$
     var_vert_bounds_combined_full(call_var_index(rho_loc),*,*,*,*)
  ; Zero construction arrays
  rho_in=0
  u_in=0
  v_in=0
  w_in=0
  radius_map=0
end

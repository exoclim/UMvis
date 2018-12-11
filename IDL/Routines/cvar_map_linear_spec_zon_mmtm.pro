pro cvar_map_linear_spec_zon_mmtm,  var_combined_full, $
                                    nprog_req, prog_name_req, $
                                    call_var_index, $
                                    grid_size_combined, $
                                    lon_combined, lat_combined, $
                                    vert_combined, time_combined, $
                                    var_vert_bounds_combined_full, $
                                    vert_type, $
                                    var_constructed, $
                                    var_vert_bounds_constructed, $
                                    verbose=verbose
  ; Construct the linear specific zonal mmtm from mapped arrays
  ; Read in wind and density components as required
  u_loc=find_string_in_arr(nprog_req, prog_name_req, 'Uvel')
  rho_loc=find_string_in_arr(nprog_req, prog_name_req, 'Density')
  ; Create outputs for them  
  u_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  rho_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  u_in(*,*,*,*)=var_combined_full(call_var_index(u_loc),*,*,*,*)
  rho_in(*,*,*,*)=var_combined_full(call_var_index(rho_loc),*,*,*,*)
  ; Specific, zonal linear mmtm is then just density*u
  var_constructed=alloc_multiply_4d_float(rho_in, u_in, $
                                          grid_size_combined)
  var_vert_bounds_constructed(*)=$
     var_vert_bounds_combined_full(u_loc,*)
  ; Zero construction arrays
  u_in=0
  rho_in=0
end

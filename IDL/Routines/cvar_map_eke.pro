pro cvar_map_eke, which_var, var_combined_full, $
                  var_vert_bounds_combined_full, $
                  grid_size_combined, $
                  nprog_req, prog_name_req, call_var_index, $
                  min_val, $
                  var_constructed, $
                  var_vert_bounds_constructed, $
                  verbose=verbose
  ; This routine constructs the EKE from mapped variables
  ; Read in wind components as required
  ; This should not fail as it is prescribed!
  u_loc=find_string_in_arr(nprog_req, prog_name_req, 'Uvel')
  v_loc=find_string_in_arr(nprog_req, prog_name_req, 'Vvel')
  ; Create outputs for them  
  u_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  v_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  u_in(*,*,*,*)=var_combined_full(call_var_index(u_loc),*,*,*,*)
  v_in(*,*,*,*)=var_combined_full(call_var_index(v_loc),*,*,*,*)
  ; Now call the routine to actually calculate the EKE
  var_constructed=calc_eke(u_in, v_in, min_val)
  var_vert_bounds_constructed(*)=$
     var_vert_bounds_combined_full(u_loc,*)
  ; Zero construction arrays
  u_in=0
  v_in=0
end

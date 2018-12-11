pro cvar_map_jet_char,  which_var, var_combined_full, $
                        lat_combined, vert_combined, $
                        var_vert_bounds_combined_full, $
                        grid_size_combined, nprog_req, $
                        prog_name_req, call_var_index, $
                        min_val, var_constructed, $
                        var_vert_bounds_constructed, $
                        vert_type, $
                        verbose=verbose
  ; This calculates the jet characteristics
  ; Find and read in the U 
  u_loc=find_string_in_arr(nprog_req, prog_name_req, 'Uvel')
  ; Create outputs 
  u_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  u_in(*,*,*,*)=var_combined_full(call_var_index(u_loc),*,*,*,*)

  ; Now call the routine to calculate the required
  ; jet characteristic
  var_constructed=calc_jet_char(which_var, $
                                u_in, lat_combined, $
                                vert_combined, vert_type, $
                                min_val, $
                                verbose=verbose)
                                
  var_vert_bounds_constructed(*)=$
     var_vert_bounds_combined_full(u_loc,*)
  ; Zero construction array
  u_in=0
end

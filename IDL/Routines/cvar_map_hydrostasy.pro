pro cvar_map_hydrostasy, var_combined_full, nprog_req, prog_name_req, $
                         call_var_index, grid_size_combined, $
                         lon_combined, lat_combined, vert_combined, $
                         time_combined, var_vert_bounds_combined_full, $
                         vert_type, planet_radius, grav_surf, $
                         eqn_type=eqn_type, grav_type=grav_type, $
                         var_constructed, var_vert_bounds_constructed, $
                         verbose=verbose
  ; This routine calculates the departure from hydrostatic
  ; equilibrium
  ; Find the density and height
  rho_loc=find_string_in_arr(nprog_req, prog_name_req, 'Density')
  rho_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  rho_in(*,*,*,*)=var_combined_full(call_var_index(rho_loc),*,*,*,*)
  height_loc=find_string_in_arr(nprog_req, prog_name_req, 'Height_rho')
  height_in=safe_alloc_arr(4, grid_size_combined, /float_arr)
  height_in(*,*,*,*)=var_combined_full(call_var_index(height_loc),*,*,*,*)
  ; Sort the pressure axis
  pressure_z=vert_combined
  ; Basic boundaries
  var_vert_bounds_constructed=var_vert_bounds_combined_full(rho_loc)
  ; Now construct a pressure array
  var_constructed=calc_hydrostasy(vert_type, $
                                  pressure_z, height_in, rho_in, grav_surf, $
                                  planet_radius, $
                                  eqn_type=eqn_type, grav_type=grav_type,$
                                  verbose=verbose)
  pressure_z=0
  height_in=0
  rho_in=0
end

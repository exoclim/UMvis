pro construct_from_mapped,  which_var, $
                            var_combined_full, $
                            grid_size_combined, $
                            lon_combined, lat_combined, $
                            vert_combined, time_combined, $
                            var_vert_bounds_combined_full, $
                            nvars_map, which_var_arr_map, vert_type, $
                            pi, R, cp, kappa, planet_radius, p0, $
                            omega, grav_surf, timestep, lid_height, $
                            min_val, $
                            grav_type=grav_type, eqn_type=eqn_type, $
                            var_constructed, $
                            var_vert_bounds_constructed, $
                            verbose=verbose
  ; This routines attempts to construct the requested variable
  ; (which_var) using the variables from the map 
  ; (var_combined_full), as well as the other info (e.g., PI etc).
  ; The resulting variable is saved in var_combined (the same is
  ; true for the var_vert_bounds).
  ; This routine works similarly to construct_var.pro
  ; in that the routine calls are written in cvar_list_mapped.pro
  ; in a standardised format-so any changes to argument list names
  ; MUST be transferred to the cvar_list_mapped.pro calls 
  ; (hence the somewhat awkward names).

  ; Use default vertical boundaries (these will be adjusted by 
  ; the routines as required
  var_vert_bounds_constructed=safe_alloc_arr(1, 2, /float_arr)
  var_vert_bounds_constructed(*)=0.0

  ; First we work out, as in construct var, if it is a supported
  ; post-mapping variable, then check the required prognostics
  ; are available from the restored file (i.e. are in 
  ; which_var_arr_map), and finally execute the construction command.

  ; If the variable is supported and can be constructed from
  ; what is available is performed in one go.
  ; This routine will fail if it can't be done.
  cvar_find_mapped, which_var, nvars_map, which_var_arr_map, $
                    nprog_req, prog_name_req, $
                    routine_call, $
                    call_var_index, $
                    var_tested, $
                    verbose=verbose

  ; Construct the variable
  if (KEYWORD_SET(verbose)) then $ 
     print, 'Variable construction call: ', routine_call
  result=execute(routine_call)

  ; Tell the user what they have
  if (KEYWORD_SET(verbose)) then begin
     output_string=which_var
     print, 'Constructed: ', output_string
     print, 'Final Variable Extremes'
     print, 'Maximum = ', max(var_constructed)
     print, 'Minimum = ', min(var_constructed)
     print, 'Longitude, range, size:', $
            min(lon_combined), max(lon_combined), $
            grid_size_combined(0)
     print, 'Latitude, range, size:', $
            min(lat_combined), max(lat_combined), $
            grid_size_combined(1)
     print, 'Vertical, range, size:', $
            min(vert_combined), max(vert_combined), $
            grid_size_combined(2)
     print, 'Time, range, size:', $
            min(time_combined), max(time_combined), $
            grid_size_combined(3)
  endif
end


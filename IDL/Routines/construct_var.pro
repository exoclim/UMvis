pro construct_var, fname_1, fname_2, planet_setup,$
                   which_var, $
                   netcdf_var_names, $
                   p_array, psurf_array, $
                   p_grid_name, p_grid_size, $
                   p_lon, p_lat, p_vert, p_time, $
                   p0, kappa, R, cp, planet_radius, pi, omega, $
                   grav_surf, min_val, lid_height, $
                   grav_type=grav_type, eqn_type=eqn_type, $
                   variable_out, var_grid_name, var_grid_size, $
                   var_lon, var_lat, var_vert, var_time,$
                   var_vert_bounds, $
                   verbose=verbose
  ; WARNING: the name "which_var" and other variables
  ; may also be used in cvar_list.pro to construct
  ; the routine call, therefore if you change them
  ; this must be done in both procedures
  ; We assume the grid for the variable is pressure
  ; and changes in the cvar_routines, replace/alter this.
  ; Boundary conditions. Currently the boundary values
  ; are held in var_vert_bounds(2), for inner (0) and
  ; outer (1) boundary, which is quite unsophisticated.
  ; The default values are that the variable tends to 
  ; zero. Should you have specific values for your
  ; additional variable then set this in the cvar_?
  ; routine
  ; Setup the default values the variable tends to at the 
  ; inner and outer boundary 
  ; (this should eventually be upgraded to a 2D surface **WORK**)
   var_vert_bounds=safe_alloc_arr(1, 2, /float_arr)
   var_vert_bounds(*)=0.0
  ; Copy pressure to variable grid.
  copy_um_std_grid, p_grid_name, p_grid_size,$
                    p_lon, p_lat, p_vert, p_time, $
                    var_grid_name, var_grid_size, $
                    var_lon, var_lat, var_vert, var_time
  ; Attempt to find the variable in the list
  cvar_find, which_var, found, routine_call, var_tested, $
             verbose=verbose
  if (found eq 0) then begin
     print, 'Variable:', which_var, ' not found'
     print, 'in cvar_list.pro (using cvar_find.pro)'
     print, 'Error in construct_var.pro'
     stop
  endif
  
  ; Construct the variable
  if (KEYWORD_SET(verbose)) then $ 
     print, 'Variable construction call: ', routine_call
  fname = fname_1
  result=execute(routine_call)
  ; If making a difference plot
  ; read in the second file then take the difference
  if (fname_2 NE '') then begin
    if (KEYWORD_SET(verbose)) then $
      print, 'Taking difference between files ', fname_1, $
      'and ', fname_2
    ; copy variable out
    variable_out_copy = variable_out
    ; construct variable from second input file
    fname = fname_2
    result =execute(routine_call)
    ; take difference of variables 
    variable_out = variable_out_copy - variable_out
    fname = fname_1
  endif

  ; Tell the user what they have
  if (KEYWORD_SET(verbose)) then begin
     output_string=which_var
     print, 'Plotting: ', output_string
     print, 'Final Variable Extremes'
     print, 'Maximum = ', max(variable_out)
     print, 'Minimum = ', min(variable_out)
     print, 'Longitude, range, size:', $
            min(var_lon), max(var_lon), var_grid_size(0)
     print, 'Latitude, range, size:', $
            min(var_lat), max(var_lat), var_grid_size(1)
     print, 'Vertical, range, size:', $
            min(var_vert), max(var_vert), var_grid_size(2)
     print, 'Time, range, size:', $
            min(var_time), max(var_time), var_grid_size(3)
  endif

  ; Quick check grids have been updated properly
  for igrid=0, 3 do begin
     diff=0.0
     if (KEYWORD_SET(verbose)) then begin
        if (igrid eq 0) then string='Longitude'
        if (igrid eq 1) then string='Latitude'
        if (igrid eq 2) then string='Vertical'
        if (igrid eq 3) then string='Time'
        print, 'Checking grid consistency for: ', which_var, ' ', $
               string
     endif
     if (igrid eq 0) then diff=MAX(ABS(var_lon-p_lon))
     if (igrid eq 1) then diff=MAX(ABS(var_lat-p_lat))
     if (igrid eq 2) then diff=MAX(ABS(var_vert-p_vert))
     if (igrid eq 3) then diff=MAX(ABS(var_time-p_time))
     if (p_grid_name(igrid) ne var_grid_name(igrid)) then begin
        if (not (diff gt 0.0)) then begin
           print, 'WARNING:'
           print, 'Pressure and Variable grid names different: ', $
                  p_grid_name(igrid), ' ',$
                  var_grid_name(igrid)
           print, 'But grid values match'
           print, 'stopping in construct_var.pro'
           ;stop
        endif
     endif else begin
        if (diff gt 0.0) then begin
           print, 'Pressure and Variable grid names match: ', $
                  p_grid_name(igrid), ' ',$
                  var_grid_name(igrid)
           print, 'But values different'
           print, 'stopping in construct_var.pro'
           stop
        endif
     endelse
  endfor
end

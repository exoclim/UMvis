pro cvar_jet_char, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   variable_out,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   which_var, min_val,$
                   verbose=verbose
  ; Wrapper routine to calculate Jet characteristics
  ; i.e. depth, strength, width etc.
  ; All based on zonal velocity so on u-lon grid.
  ; Read in the Uvel and alter the grid (done in cvar_uvel)
  cvar_uvel, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             uvel,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             verbose=verbose
  ; Now call the routine to calculate the required values
  variable_out=calc_jet_char(which_var, uvel, var_lat, var_vert, $
                             vert_type, min_val,$
                            verbose=verbose)
  uvel=0
end

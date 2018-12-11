pro cvar_mole_fraction, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                variable_out,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                verbose=verbose
  ; find the netcdf short name and read it in
  target_var='tracer'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid,fname, ncdf_name, variable_out, $
                            var_grid_name, var_grid_size
  tracer = variable_out
  ; read in tracer
  tracer_vert=get_variable_grid(fname, ncdf_name, 2, $
                               verbose=verbose)
  
  
  ; Read in all species to calculate total n
  ;n = 0.
  ;ntr = 105
  ;FOR I = 1, ntr DO BEGIN
  ;  num = STRING(I)
  ;  target_var = 'tracer'+STRTRIM(num,1)
  ;  print, target_var
  ;  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  ;  read_netcdf_variable_grid,fname, ncdf_name, variable_out, $
  ;                         var_grid_name, var_grid_size
  ;  n = n + variable_out
  ;ENDFOR

  ; calculate mole fraction
  ;variable_out = tracer/n

  var_vert=tracer_vert
  tracer_vert=0
end


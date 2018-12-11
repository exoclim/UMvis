pro cvar_recip_tau_rad_newtonian, fname, netcdf_var_names, $
                                  p_array, psurf_array,$
                                  p_grid_name, p_grid_size,$
                                  p_lon, p_lat, p_vert, p_time,$
                                  variable_out,$
                                  var_grid_name, var_grid_size,$
                                  var_lon, var_lat, var_vert, var_time,$
                                  setup,$
                                  verbose=verbose
  ; Calculate the reciprocal of the radiative timescale
  ; used for the Newtonian relaxation of temperature.
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  for t=0, var_grid_size(3)-1 do begin
     for k=0, var_grid_size(2)-1 do begin
        for j=0, var_grid_size(1)-1 do begin
           for i=0, var_grid_size(0)-1 do begin
              variable_out(i,j,k,t)=$
                 get_recip_tau_rad(setup, p_array(i,j,k,t))
           endfor
        endfor
     endfor
  endfor
end

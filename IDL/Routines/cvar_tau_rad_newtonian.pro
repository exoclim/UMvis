pro cvar_tau_rad_newtonian, fname, netcdf_var_names, $
                            p_array, psurf_array,$
                            p_grid_name, p_grid_size,$
                            p_lon, p_lat, p_vert, p_time,$
                            variable_out,$
                            var_grid_name, var_grid_size,$
                            var_lon, var_lat, var_vert, var_time,$
                            setup,$
                            verbose=verbose
  ; Routine to construct the relaxation timescale
  ; for the Newtonian cooling to an equilibirum temperature
  ; First get the reciprocal, as we have a routine for that.
  cvar_recip_tau_rad_newtonian, fname, netcdf_var_names, $
                                p_array, psurf_array,$
                                p_grid_name, p_grid_size,$
                                p_lon, p_lat, p_vert, p_time,$
                                variable_out,$
                                var_grid_name, var_grid_size,$
                                var_lon, var_lat, var_vert, var_time,$
                                setup,$
                                verbose=verbose
  variable_out(*,*,*,*)=1.0/variable_out(*,*,*,*)
end

pro cvar_mass_flux_meri, fname, netcdf_var_names, $
                         p_array, psurf_array,$
                         p_grid_name, p_grid_size,$
                         p_lon, p_lat, p_vert, p_time,$
                         variable_out,$
                         var_grid_name, var_grid_size,$
                         var_lon, var_lat, var_vert, var_time,$
                         planet_radius,$
                         verbose=verbose
  ; Routine to calculate the meridional mass flux
  ; Done using density, i.e. density*vvel
  ; Need v on pressure grid
  ; Read in meridional velocity
  target_var='Vvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only,fname, ncdf_name, v_vel
  ; Read in the latitude grid
  v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)
  ; Need meridional on pressure points
  v_vel_press=interp_latitude_um_std(v_vel, v_lat, var_lat)
  v_vel=0
  ; Get density, on p-grid again
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size,$
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=density(*,*,*,*)*$
                        v_vel_press(*,*,*,*)
  density=0
  v_vel_press=0
end

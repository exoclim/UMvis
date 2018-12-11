pro cvar_adv_tau_zon, fname, netcdf_var_names, $
                      p_array, psurf_array,$
                      p_grid_name, p_grid_size,$
                      p_lon, p_lat, p_vert, p_time,$
                      variable_out,$
                      var_grid_name, var_grid_size,$
                      var_lon, var_lat, var_vert, var_time,$
                      planet_radius, pi,$
                      verbose=verbose
  ; This is the timescale for the zonal wind
  ; to circulate the planet
  ; Require zonal wind, put it on p-grid
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_only, fname, ncdf_name, u_vel
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  u_vel_press=interp_longitude_um_std(u_vel, u_lon, var_lon)
  u_vel=0
  u_lon=0
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; Time to circulate around globe is 2*pi*r/|u|
  for ivert=0, var_grid_size(2)-1 do begin
     variable_out(*,*,ivert,*)=2.0*pi*$
                               (planet_radius+var_vert(ivert))/$
                               abs(u_vel_press(*,*,ivert,*))
  endfor
  u_vel_press=0
end

pro cvar_ep, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             variable_out,$
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, pi, min_val,$
             eqn_type=eqn_type, which_type,$
             verbose=verbose
  ; Routine to construct the various
  ; types of Eliasen-Palm Flux
  ; The Eliasen-Palm Flux and divergence of EP flux
  ; shows poleward advection of potential vorticity
  ; diagnostic of jet pumping via Rossby wave
  ; generation and subsequent movement and dissipation
  ; (eastward mmtm deposited where generated and 
  ; westward where dissipated)
  ; This, as with mmtm calculations rests on density points.
  cvar_density, fname, netcdf_var_names, $
                p_array, psurf_array,$
                p_grid_name, p_grid_size,$
                p_lon, p_lat, p_vert, p_time,$
                density,$
                var_grid_name, var_grid_size, $
                var_lon, var_lat, var_vert, var_time,$
                planet_radius,$
                verbose=verbose
  ; Require Zonal wind also on p-grid
  target_var='Uvel'
  ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
   read_netcdf_variable_grid, fname, ncdf_name, u_vel
  u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
  ; Interpolate u onto longitude pressure
  u_press=interp_longitude_um_std(u_vel, u_lon, p_lon)
  u_vel=0
  u_lon=0
  which_type_one=which_type
  ; Now require either vertical wind or meridional
  ; For the divergence need both so meri first
  ; Interpolate both onto pressure grid
  if (which_type eq 'EP_flux_lat' or $
      which_type eq 'div_EP_flux') then begin
     which_type_one='EP_flux_lat'
     target_var='Vvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var) 
     read_netcdf_variable_grid, fname, ncdf_name, v_vel
     v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)
     ; Interpolate v onto latitude pressure
     wind=interp_latitude_um_std(v_vel, v_lat, p_lat)
     v_vel=0
     v_lat=0
  endif else if (which_type eq 'EP_flux_vert') then begin
     ; Read in vertical velocity
     target_var='Wvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     read_netcdf_variable_only,fname, ncdf_name, w_vel
     ; Read in the vertical grid
     w_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
     ; Need vertical velocity on pressure points
     wind=interp_height_um_std(w_vel, w_vert, var_vert, $
                               lid_height)
     w_vel=0
  endif
  ; Now have the density, zonal and either 
  ; meridional or vertical wind can create eddy-mmtm convergence
  ; values
  ; Using which_plot_one to allow ratio calculation
  ep_one=calc_ep_flux(which_type_one, $
                      planet_radius,$
                      var_grid_size(0), $
                      var_grid_size(1),$
                      var_grid_size(2), $
                      var_grid_size(3), $
                      density, u_press, wind,$
                      var_vert, $
                      var_lat, $
                      eqn_type=eqn_type, min_val, pi)
  wind=0
  ; If we are plotting the divergence read the second one
  if (which_type eq 'div_EP_flux') then begin
   ; Read in vertical velocity
     target_var='Wvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     read_netcdf_variable_only,fname, ncdf_name, w_vel
     ; Read in the vertical grid
     w_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
     ; Need vertical velocity on pressure points
     wind_two=interp_height_um_std(w_vel, w_vert, var_vert, $
                                   lid_height)
     w_vel=0
     ep_two=calc_ep_flux('EP_flux_vert', which_ver, $
                         planet_radius, var_grid_size(0), $
                         var_grid_size(1), var_grid_size(2), $
                         var_grid_size(3), $
                         density, u_press, wind_two,$
                         var_vert, $
                         var_lat, $
                         eqn_type=eqn_type, min_val, pi)
     density=0
     uvel=0
     wind_two=0
     variable_out=calc_div_ep_flux(ep_one, ep_two, planet_radius,$
                                   var_vert, $
                                   var_lat, $
                                   eqn_type=eqn_type, min_val, pi)
     ep_one=0
     ep_two=0
  endif else begin
     density=0
     u_press=0
     variable_out=ep_one
     ep_one=0
  endelse
end

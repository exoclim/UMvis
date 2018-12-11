pro cvar_list, ncvar, cvar_name, cvar_call, tested=tested
  ; This routine lists the available individual variables
  ; WARNING: this is called within construct_var.pro
  ; and ALL variable names must be consistent with this 
  ; procedure
  ; Procedures work relative to pressure grid,
  ; hence it is input to each routine.
  ; KEY: the var_grid is already the p_grid
  ; just replace things which change!
  ; BEWARE if you are using cvar_routines within others
  ; as they may alter the grids.
  ; A standard call will look a little like cvar_height_rho 
  ; cvar_NAME, $
  ; FNAME, NETCDF_VAR_NAMES, PRESSURE INFO, VARIABLE INFO, OTHER ARGUMENTS, VERBOSITY
  
  ; To add plotable scalar increment this number
  ; then add details at the bottom of the page.
  ncvar=86
  cvar_name=safe_alloc_arr(1, ncvar, /string_arr)
  cvar_call=safe_alloc_arr(1, ncvar, /string_arr)
  ; This is 0 if untested, and one if tested.
  tested=safe_alloc_arr(1, ncvar, /int_arr)
  ; Initialise counter
  count=0

  cvar_name(count)='Height_rho'
  cvar_call(count)='cvar_height_rho, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, var_vert_bounds, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Theta'
  cvar_call(count)='cvar_theta, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Temp'
  cvar_call(count)='cvar_temp, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, p0, kappa, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='surface_temperature'
  cvar_call(count)='cvar_surface_temperature, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='surface_pressure'
  cvar_call(count)='cvar_surface_pressure, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Uvel'
  cvar_call(count)='cvar_uvel, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Vvel'
  cvar_call(count)='cvar_vvel, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Wvel'
  cvar_call(count)='cvar_wvel, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Pressure'
  cvar_call(count)='cvar_pressure, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, var_vert_bounds, p0, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Sigma'
  cvar_call(count)='cvar_sigma, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, var_vert_bounds, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Density'
  cvar_call(count)='cvar_density, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='specific_humidity'
  cvar_call(count)='cvar_specific_humidity, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='Mass'
  cvar_call(count)='cvar_mass, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Cs'
  cvar_call(count)='cvar_cs, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, R, p0, kappa, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1
 
  cvar_name(count)='Horizspeed'
  cvar_call(count)='cvar_horizspeed, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='du_dz'
  cvar_call(count)='cvar_du_dz, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='dv_dz'
  cvar_call(count)='cvar_dv_dz, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='horizspeed_shear'
  cvar_call(count)='cvar_horizspeed_shear, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='Machnum'
  cvar_call(count)='cvar_machnum, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, p0, kappa, R, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='PE'
  cvar_call(count)='cvar_pe, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, grav_surf, grav_type=grav_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='KE'
  cvar_call(count)='cvar_ke, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='KE_vert'
  cvar_call(count)='cvar_ke_vert, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='KE_vert_flux'
  cvar_call(count)='cvar_ke_vert_flux, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='mass_flux_vert'
  cvar_call(count)='cvar_mass_flux_vert, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='mass_flux_meri'
  cvar_call(count)='cvar_mass_flux_meri, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='mass_flux_zon'
  cvar_call(count)='cvar_mass_flux_zon, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='dtemp_newtonian'
  cvar_call(count)='cvar_dtemp_newtonian, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_setup, p0, kappa, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='recip_tau_rad_newtonian'
  cvar_call(count)='cvar_recip_tau_rad_newtonian, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_setup, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='tau_rad_newtonian'
  cvar_call(count)='cvar_tau_rad_newtonian, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_setup, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='Teq_newtonian'
  cvar_call(count)='cvar_teq_newtonian, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_setup, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='T-Teq_newtonian'
  cvar_call(count)='cvar_t_teq_newtonian, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_setup, p0, kappa, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='DT_poles'
  cvar_call(count)='cvar_dt_poles, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, p0, kappa, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='AAM'
  cvar_call(count)='cvar_aam, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, omega, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='AAM_Atm'
  cvar_call(count)='cvar_aam_atm, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='AAM_Omega'
  cvar_call(count)='cvar_aam_omega, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, omega, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='SAAM'
  cvar_call(count)='cvar_saam, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, omega, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='SAAM_Atm'
  cvar_call(count)='cvar_saam_atm, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='SAAM_Omega'
  cvar_call(count)='cvar_saam_omega, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, omega, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='BruntV'
  cvar_call(count)='cvar_bruntv, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, grav_surf, grav_type=grav_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='H_p'
  cvar_call(count)='cvar_h_p, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, p0, kappa, R, planet_radius, grav_surf, grav_type=grav_type, verbose=verbose' 
  tested(count)=0
  count=count+1

  cvar_name(count)='L_D'
  cvar_call(count)='cvar_rossby_def_rad, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, p0, kappa, omega, pi, grav_surf, grav_type=grav_type, verbose=verbose' 
  tested(count)=0
  count=count+1
 
  cvar_name(count)='Ri'
  cvar_call(count)='cvar_ri, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, grav_surf, grav_type=grav_type, verbose=verbose' 
  tested(count)=0
  count=count+1
  
  cvar_name(count)='tau_adv_zon'
  cvar_call(count)='cvar_adv_tau_zon, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='recip_tau_adv_zon'
  cvar_call(count)='cvar_recip_tau_adv_zon, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, verbose=verbose'
  tested(count)=0
  count=count+1
 
  cvar_name(count)='tau_rad_adv'
  cvar_call(count)='cvar_tau_rad_adv, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, planet_setup, verbose=verbose'
  tested(count)=0
  count=count+1
 
  cvar_name(count)='ueqn_metric_uvtan'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='ueqn_metric_uw'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='ueqn_coriolis_vsin'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='ueqn_coriolis_wcos'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'  
  tested(count)=0
  count=count+1
  
  cvar_name(count)='veqn_metric_utan'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'  
  tested(count)=0
  count=count+1
  
  cvar_name(count)='veqn_metric_vw'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'    
  tested(count)=0
  count=count+1
  
  cvar_name(count)='veqn_coriolis_usin'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'    
  tested(count)=0
  count=count+1
  
  cvar_name(count)='weqn_metric_uv'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'    
  tested(count)=0
  count=count+1
  
  cvar_name(count)='weqn_coriolis_ucos'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'    
  tested(count)=0
  count=count+1
  
  cvar_name(count)='rhoeqn_dw_dvert'
  cvar_call(count)='cvar_dyn_eqn_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, omega, pi, lid_height, which_var, eqn_type=eqn_type, verbose=verbose'    
  tested(count)=0
  count=count+1
  
  cvar_name(count)='linear_spec_zon_mmtm'
  cvar_call(count)='cvar_linear_spec_zon_mmtm, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='zon_eddy_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='zon_mean_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='meri_eddy_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='meri_mean_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='meri_mean_sin_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='vert_eddy_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='vert_mean_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='vert_mean_cos_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='sum_eddy_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='sum_mean_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='sum_pump'
  cvar_call(count)='cvar_pumping_terms, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, omega, eqn_type=eqn_type, lid_height, timestep, which_var, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='euler_sf'
  cvar_call(count)='cvar_euler_sf, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, p0, min_val, grav_surf, grav_type=grav_type, eqn_type=eqn_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='EKE'
  cvar_call(count)='cvar_eke, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, min_val, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='jet_max_u_100pa'
  cvar_call(count)='cvar_jet_char, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, which_var, min_val, verbose=verbose'
  tested(count)=0
  count=count+1

    cvar_name(count)='jet_max_vert_100pa'
  cvar_call(count)='cvar_jet_char, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, which_var, min_val, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='eq_jet_breadth_100pa'
  cvar_call(count)='cvar_jet_char, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, which_var, min_val, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='eq_jet_depth_100pa'
  cvar_call(count)='cvar_jet_char, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, which_var, min_val, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='hydrostasy'
  cvar_call(count)='cvar_hydrostasy, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, lid_height, grav_surf, planet_radius, eqn_type=eqn_type, grav_type=grav_type, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='ageair'
  cvar_call(count)='cvar_ageair, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='log_ageair'
  cvar_call(count)='cvar_log_ageair, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, verbose=verbose'
  tested(count)=0
  count=count+1

  ; NEW UNTESTED ROUTINES BELOW.
 
  cvar_name(count)='temperature_theta_levs'
  cvar_call(count)='cvar_temperature_theta_levs, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1

    cvar_name(count)='pressure_theta_levs'
  cvar_call(count)='cvar_pressure_theta_levs, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, p0, kappa, lid_height, verbose=verbose'
  tested(count)=0
  count=count+1

  cvar_name(count)='rossby_number'
  cvar_call(count)='cvar_rossby_number, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, omega, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
; Below here these routines are very dodgy and VERY untested**
  
  cvar_name(count)='diff_stream'
  cvar_call(count)='cvar_diff_stream, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, eqn_type=eqn_type, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='EP_flux_lat'
  cvar_call(count)='cvar_ep, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='EP_flux_height'
  cvar_call(count)='cvar_ep, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1
  
  cvar_name(count)='div_EP_flux'
  cvar_call(count)='cvar_ep, fname, netcdf_var_names, p_array, psurf_array, p_grid_name, p_grid_size, p_lon, p_lat, p_vert, p_time, variable_out, var_grid_name, var_grid_size, var_lon, var_lat, var_vert, var_time, planet_radius, pi, min_val, eqn_type=eqn_type, which_var, verbose=verbose'
  tested(count)=0
  count=count+1

  ; Use this template to add another
  ; increment ncvar
  ;cvar_name(count)=''
  ;cvar_call(count)=''
  ;tested(count)=0
  ;count=count+1

end


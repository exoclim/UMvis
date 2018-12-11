pro create_variables_from_um_output, variable_list, $
                                     nvars, which_var_arr, $
                                     vert_type, $
                                     netcdf_var_names, $
                                     netcdf_um_in=netcdf_um_in, $
                                     netcdf2_um_in=netcdf2_um_in, $
                                     planet_setup_in=planet_setup_in, $
                                     mapped_fname_in=mapped_fname_in, $
                                     map_grid_use_in=map_grid_use_in, $
                                     map_limits_in=map_limits_in, $
                                     cp_ovrd=cp_ovrd, R_ovrd=R_ovrd,$
                                     planet_radius_ovrd=planet_radius_ovrd, $
                                     p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd,$
                                     grav_surf_ovrd=grav_surf_ovrd, $
                                     timestep_ovrd=timestep_ovrd, $
                                     lid_height_ovrd=lid_height_ovrd, $
                                     np_levels_ovrd=np_levels_ovrd, $
                                     grav_type=grav_type, eqn_type=eqn_type, $
                                     meri_mean_pt=meri_mean_pt, $
                                     pi, R, cp, kappa, planet_radius, p0, $
                                     omega, grav_surf, timestep, lid_height, $
                                     min_val, $         
                                     mapped_fname, $
                                     planet_setup, $
                                     var_combined, grid_size_combined,$
                                     lon_combined, lat_combined, $
                                     vert_combined, $
                                     time_combined, $
                                     var_vert_bounds_combined, $
                                     verbose=verbose
  ; This routine deals with creating
  ; variables from the UM netcdf files
  ; First se check the requested variables etc.
  set_construct_details, variable_list, $
                         nvars, which_var_arr, construction_calls, $
                         verbose=verbose
  ; Now we do some basic checks for consistency
  if (KEYWORD_SET(verbose)) then $
     print, 'Setting constants/parameters'
  map_initial_checks_and_setup, $
     nvars, which_var_arr, $
     vert_type, $
     netcdf_um_in=netcdf_um_in, $
     netcdf2_um_in=netcdf2_um_in, $
     planet_setup_in=planet_setup_in, $
     mapped_fname_in=mapped_fname_in, $
     map_grid_use_in=map_grid_use_in, $
     map_limits_in=map_limits_in, $
     map_grid_use, map_limits, $
     cp_ovrd=cp_ovrd, R_ovrd=R_ovrd,$
     planet_radius_ovrd=planet_radius_ovrd, $
     p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd,$
     grav_surf_ovrd=grav_surf_ovrd, $
     timestep_ovrd=timestep_ovrd, $
     lid_height_ovrd=lid_height_ovrd, $
     pi, R, cp, kappa, planet_radius, p0, $
     omega, grav_surf, timestep, lid_height, $
     min_val, $         
     netcdf_um_fname, $
     netcdf_um_fname_2, $
     mapped_fname, $
     planet_setup, $
     verbose=verbose
  
     ; Setup the pressure, and associated grid
     print, 'Reading in pressure structure'
     set_press_grid, netcdf_um_fname, $
                     netcdf_var_names, $
                     kappa, p0, pi,$
                     p_array, psurf_array, $
                     p_grid_name, p_grid_size, $
                     p_lon, p_lat, p_vert, p_time, $
                     verbose=verbose

    ; Now loop over the number of required individual
    ; variables for this plot, and construct them
     for ivar=0, nvars-1 do begin
        print, 'Constructing variable:', ivar+1,' of ', nvars, ' ' ,$
               which_var_arr(ivar)
        construct_var, netcdf_um_fname, netcdf_um_fname_2, $ 
                       planet_setup, $
                       which_var_arr(ivar), $
                       netcdf_var_names, $
                       p_array, psurf_array, $
                       p_grid_name, p_grid_size, $
                       p_lon, p_lat, p_vert, p_time, $
                       p0, kappa, R, cp, planet_radius, pi, omega, $
                       grav_surf, min_val, lid_height, $
                       grav_type=grav_type, eqn_type=eqn_type, $
                       var_array, var_grid_name, var_grid_size, $
                       var_lon, var_lat, var_vert, var_time,$
                       var_vert_bounds, $
                       verbose=verbose
        ; Now we have the variable
        ; Values: var_array(lon,lat,vert,time)
        ; Dimensions sizes: var_grid_size
        ; Names of grid: var_grid_name
        ; Grids: var_lon, var_lat, var_vert, var_time
        ; And the pressure
        ; Values: p_array(lon,lat,vert,time)
        ; Dimensions sizes: p_grid_size
        ; Names of grid: p_grid_name
        ; Grids: p_lon, p_lat, p_vert, p_time
        ; And the surface pressure
        ; Values: psurf_array(lon,lat,time)
        ; Dimensions of sizes: p_grid_size(0,1,3) i.e. no vert
        ; Grids: p_lon, p_lat, p_time ; i.e. no vert
        ; Now for each individual variable
        ; we perform any limiting requested and mapping of 
        ; vertical axes.

        ; Check if the requested map_limits etc are
        ; sensible
        check_map_limit, vert_type, $
                         map_grid_use, map_limits, $
                         p_lon, p_lat, p_vert, p_time, $
                         p_array, p_surf_array, $
                         lid_height=lid_height, $
                         verbose=verbose         

        ; Perform limiting and mapping
        limit_map, vert_type, map_grid_use, map_limits, $
                   p_array, psurf_array, p_grid_size, $
                   p_lon, p_lat, p_vert, p_time, $
                   p0, lid_height, min_val, $
                   var_array, var_grid_size, $
                   var_lon, var_lat, var_vert, var_time, $
                   var_vert_bounds, $
                   ivar, $
                   nvert_map, vert_map, $
                   np_levels_ovrd=np_levels_ovrd, $
                   verbose=verbose
       ; The output should now be an array (var_array),
       ; which has been cut according to map_limits
       ; and mapped onto the required vertical axes
       ; given in vert_type. The corresponding 
       ; var_lon, var_lat, var_vert, var_time and
       ; var_grid_size will also be changed.
       ; i.e. useable output still
       ; var_array(var_lon, var_lat, var_vert, var_time)
       ;=FLTARR(var_grid_size(0,1,2,3,))
       ; Now we perform averaging, slicing
       ; And combine variables, if required
       ; WARNING: this array will zero var_array
       ; var_lon, var_lat, var_vert, var_time
       ; and var_grid_size
        post_mapping, vert_type, map_grid_use, $
                      p0, lid_height, pi, min_val, $
                      var_array, var_grid_size, $
                      var_lon, var_lat, var_vert, var_time, $
                      var_vert_bounds, $
                      ivar, $
                      meri_mean_pt=meri_mean_pt, $
                      which_var_arr, $
                      var_combined, grid_size_combined, $
                      lon_combined, lat_combined, vert_combined, $
                      time_combined, $
                      var_vert_bounds_combined, $
                      verbose=verbose
     endfor  
end

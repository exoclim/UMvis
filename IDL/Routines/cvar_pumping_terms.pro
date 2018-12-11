pro cvar_pumping_terms, fname, netcdf_var_names, $
                        p_array, psurf_array,$
                        p_grid_name, p_grid_size,$
                        p_lon, p_lat, p_vert, p_time,$
                        variable_out,$
                        var_grid_name, var_grid_size,$
                        var_lon, var_lat, var_vert, var_time,$
                        planet_radius, pi, min_val, omega,$
                        eqn_type=eqn_type, lid_height,$
                        timestep, which_term,$
                        verbose=verbose
  ; Routine to construct the terms of the 
  ; eddy-mean flow equation (Hardiman et al., 2010) from 
  ; netcdf files
  ; First call the routine to setup the information
  setup_pumping_terms, which_term, which_term_calc, nterms, term_names, $
                       term_calc, ncalls, $
                       read_rho, read_u, read_v, read_w
  ; Now the read_* routines tells us which fields need
  ; to be read (and interpolated onto pressure grid)
  ; and the nterms, and term_calc let us know
  ; how many terms are being calculated (i.e. for summing)

  ; Now we read in, and interpolate the required fields
  if (read_rho eq 1) then begin
     cvar_density, fname, netcdf_var_names, $
                   p_array, psurf_array,$
                   p_grid_name, p_grid_size,$
                   p_lon, p_lat, p_vert, p_time,$
                   rho_in,$
                   var_grid_name, var_grid_size,$
                   var_lon, var_lat, var_vert, var_time,$
                   planet_radius,$
                   verbose=verbose
  endif else begin
     rho_in=0
  endelse
  if (read_u eq 1) then begin
     ; All require u on pressure grid
     target_var='Uvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     u_lon=get_variable_grid(fname, ncdf_name, 0, verbose=verbose)
     ; Need zonal velocity on pressure points
     read_netcdf_variable_only,fname, ncdf_name, uvel
     u_in=interp_longitude_um_std(uvel, u_lon, p_lon)
     uvel=0
     u_lon=0
  endif else begin
     u_in=0
  endelse
  if (read_v eq 1) then begin
     ; All require v on pressure grid
     target_var='Vvel'
     ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
     v_lat=get_variable_grid(fname, ncdf_name, 1, verbose=verbose)
     ; Need meridional velocity on pressure points
     read_netcdf_variable_only,fname, ncdf_name, vvel
     v_in=interp_latitude_um_std(vvel, v_lat, p_lat)
     vvel=0
     v_lat=0
  endif else begin
     v_in=0
  endelse
 if (read_w eq 1) then begin
     ; All require w on pressure grid
    target_var='Wvel'
    ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
    w_vert=get_variable_grid(fname, ncdf_name, 2, verbose=verbose)
    ; Need vertical velocity on pressure points
    read_netcdf_variable_only,fname, ncdf_name, wvel
    w_in=interp_height_um_std(wvel, w_vert, p_vert, $
                              lid_height)
    wvel=0
    w_vert=0
  endif else begin
     w_in=0
  endelse

  ; The Native grid is height
  vert_type_decomp='Height'

  ; Now call the wrapper which actually calls the pumping calculation
  variable_out=calc_pumping_terms_wrap(which_term_calc, nterms, term_names, $
                                       term_calc, ncalls, $
                                       var_grid_size(0), var_grid_size(1), $
                                       var_grid_size(2), var_grid_size(3), $ 
                                       var_lat, var_vert, var_time, $       
                                       vert_type_decomp, $
                                       rho_in, u_in, v_in, w_in, $
                                       planet_radius, pi, omega, timestep, $
                                       lid_height, min_val, $
                                       eqn_type=eqn_type, $
                                       verbose=verbose)
  ; Zero construction arrays
  rho_in=0
  u_in=0
  v_in=0
  w_in=0
end

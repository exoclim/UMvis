pro set_press_grid, fname, $
                    netcdf_var_names, $
                    kappa, p0, pi,$
                    press, psurf, $
                    p_grid_name, p_grid_size,$
                    p_lon, p_lat, p_vert, p_time, $
                    verbose=verbose
  ; Simply read in the pressure, surface pressure
  ; and associated grids.

  ; Set a constant
  recip_kappa=1.0/kappa

  ; Find the correct surface pressure short name used
  ; in the netcdf file, and read it in
  target_var='surface_pressure'
  surface_pressure_ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  if (KEYWORD_SET(verbose)) then $
     print, 'Reading surface pressure as: ', surface_pressure_ncdf_name
  read_netcdf_variable_grid_all, fname, $
                                 surface_pressure_ncdf_name, $
                                 psurf_in, psurf_grid_name, psurf_size, $
                                 psurf_lon, psurf_lat, psurf_vert, psurf_time, $
                                 verbose=verbose
  ; Now find the name of the pressure variable and read it in
  ; Currently using Exner, but could change to pressure on theta levels
  target_var='Exner'
  exner_ncdf_name=get_netcdf_short_name(netcdf_var_names, target_var)
  read_netcdf_variable_grid_all, fname,  $
                                 exner_ncdf_name, $
                                 exner, p_grid_name, p_grid_size, $
                                 p_lon, p_lat, p_vert, p_time, $
                                 verbose=verbose
  ; Now ensure the horizontal grids match between the surface
  ; and Exner pressure
  if (max(abs(p_lon-psurf_lon)) gt 0.0 or $
      max(abs(p_lat-psurf_lat)) gt 0.0) then begin
     print, 'Surface pressure and atmospheric pressure on different'
     print, 'horizontal grids, need to code up interpolation in'
     print, 'set_press_grid.pro'
     stop
  endif
  ; Now create the pressure structures
  press=safe_alloc_arr(4, p_grid_size, /float_arr)
  arr_size=INTARR(3)
  arr_size(0)=p_grid_size(0)
  arr_size(1)=p_grid_size(1)
  arr_size(2)=p_grid_size(3)
  ; Get rid of unwanted variables and create output surface pressure
  psurf_grid_name=0
  psurf_size=0
  psurf=safe_alloc_arr(3, arr_size, /float_arr)
  psurf(*,*,*)=reform(psurf_in(*,*,0,*),p_grid_size(0),$
                      p_grid_size(1),1,p_grid_size(3))
  press(*,*,*,*)=p0*(exner(*,*,*,*)^(1.0/kappa))
  ; Get rid of exner
  exner=0

  if (KEYWORD_SET(verbose)) then begin
     print, 'Read pressure, range:', min(press), max(press)
     print, 'Read surface pressure, range:', min(psurf), max(psurf)
     print, 'Pressure Longitude, range, size:',$
            min(p_lon), max(p_lon), p_grid_size(0)
     print, 'Pressure Latitude, range, size:',$
            min(p_lat), max(p_lat), p_grid_size(1)
     print, 'Pressure Vertical, range, size:',$
            min(p_vert), max(p_vert), p_grid_size(2)
     print, 'Pressure Time, range, size:',$
            min(p_time), max(p_time), p_grid_size(3)
  endif

end



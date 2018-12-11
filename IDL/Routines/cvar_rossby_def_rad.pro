pro cvar_rossby_def_rad, fname, netcdf_var_names, $
                         p_array, psurf_array,$
                         p_grid_name, p_grid_size,$
                         p_lon, p_lat, p_vert, p_time,$
                         variable_out,$
                         var_grid_name, var_grid_size,$
                         var_lon, var_lat, var_vert, var_time,$
                         planet_radius, p0, kappa, omega, pi,$
                         grav_surf, grav_type=grav_type,$
                         verbose=verbose
  ; Routine to construct Rossby Deformation Radius
  ; First need the Brunt V
  cvar_bruntv, fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               bruntv, $
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               planet_radius, grav_surf,$
               grav_type=grav_type,$
               verbose=verbose
  ; Now read calculate the pressure scaleheight
  cvar_h_p, fname, netcdf_var_names, $
            p_array, psurf_array,$
            p_grid_name, p_grid_size,$
            p_lon, p_lat, p_vert, p_time,$
            h_p,$
            var_grid_name, var_grid_size,$
            var_lon, var_lat, var_vert, var_time,$
            p0, kappa, R, planet_radius,$
            grav_surf, grav_type=grav_type,$
            verbose=verbose
  ; Allocate output
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  ; L_D=NH/f_0
  variable_out(*,*,*,*)=$
     (bruntV(*,*,*,*)*$
      h_p(*,*,*,*))/$
     (2.0*omega*SIN((var_lat(ilat)*2.0*pi/360.0)))
  bruntv=0
  h_p=0
end

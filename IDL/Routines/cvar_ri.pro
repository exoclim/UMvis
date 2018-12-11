pro cvar_ri, fname, netcdf_var_names, $
             p_array, psurf_array,$
             p_grid_name, p_grid_size,$
             p_lon, p_lat, p_vert, p_time,$
             variable_out, $
             var_grid_name, var_grid_size,$
             var_lon, var_lat, var_vert, var_time,$
             planet_radius, grav_surf, grav_type=grav_type,$
             verbose=verbose
  ; Routine to calculate the Richardson number
  ; Ri=N^2/(dv/dz)^2, where N is brunt V and
  ; dv/dz is shear of horizontal speed
  ; Calculate Brunt V
  cvar_bruntv, fname, netcdf_var_names, $
               p_array, psurf_array,$
               p_grid_name, p_grid_size,$
               p_lon, p_lat, p_vert, p_time,$
               bruntv,$
               var_grid_name, var_grid_size,$
               var_lon, var_lat, var_vert, var_time,$
               planet_radius, grav_surf, grav_type=grav_type,$
               verbose=verbose
  ; Calculate shear in horizontal speed
  cvar_horizspeed_shear, fname, netcdf_var_names, $
                         p_array, psurf_array,$
                         p_grid_name, p_grid_size,$
                         p_lon, p_lat, p_vert, p_time,$
                         dv_dz,$
                         var_grid_name, var_grid_size,$
                         var_lon, var_lat, var_vert, var_time,$
                         verbose=verbose
  ; Finally Richardson Number
  ; Ri=N^2/(dv/dz)^2
  variable_out=safe_alloc_arr(4, var_grid_size, /float_arr)
  variable_out(*,*,*,*)=(bruntv(*,*,*,*)^2.0)/$
                        (dv_dz(*,*,*,*)^2.0)  
  bruntv=0
  dv_dz=0
end

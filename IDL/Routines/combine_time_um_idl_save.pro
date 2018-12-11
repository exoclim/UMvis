pro combine_time_um_idl_save, fname_one, fname_two, fname_out, $
                              vert_type_missing=vert_type_missing
  ; Small routine to combine previously saved
  ; UM plot variables
  ; This must match the file contents of restore_and_save_netcdf.pro
  ; Restore the first file
  restore, fname_one
  ; Copy entries to another name and zero
  var_combined_one=var_combined
  var_combined=0
  grid_size_combined_one=grid_size_combined
  grid_size_combined=0
  lon_combined_one=lon_combined
  lon_combined=0
  lat_combined_one=lat_combined
  lat_combined=0
  vert_combined_one=vert_combined
  vert_combined=0
  time_combined_one=time_combined
  time_combined=0
  var_vert_bounds_combined_one=var_vert_bounds_combined
  var_vert_bounds_combined=0
  nvars_one=nvars
  nvars=0
  which_var_arr_one=which_var_arr
  which_var_arr=0
  if (KEYWORD_SET(vert_type_missing)) then begin
     vert_type=vert_type_missing
  endif
  vert_type_one=vert_type
  vert_type=0
  pi_one=pi
  pi=0
  R_one=R
  R=0
  cp_one=cp
  cp=0
  kappa_one=kappa
  kappa=0
  planet_radius_one=planet_radius
  planet_radius=0
  p0_one=p0
  p0=0
  omega_one=omega
  omega=0
  grav_surf_one=grav_surf
  grav_surf=0
  timestep_one=timestep
  timestep=0
  lid_height_one=lid_height
  lid_height=0
  min_val_one=min_val
  min_val=0
  ; Restore the second file
  restore, fname_two
  if (KEYWORD_SET(vert_type_missing)) then begin
     vert_type=vert_type_missing
  endif
  ; Now the parameters like pi, etc., and the grid should
  ; match otherwise we can not seemlessly combine them
  ; Only missmatch is the data and time variables
  if (grid_size_combined_one(0) eq grid_size_combined(0) AND $
      grid_size_combined_one(1) eq grid_size_combined(1) AND $
      grid_size_combined_one(2) eq grid_size_combined(2) AND $
      lon_combined_one eq lon_combined AND $
      lat_combined_one eq lat_combined AND $
      vert_combined_one eq vert_combined AND $
      var_vert_bounds_combined_one eq var_vert_bounds_combined AND $
      nvars_one eq nvars AND $
      which_var_arr_one eq which_var_arr AND $
      vert_type_one eq vert_type AND $
      pi_one eq pi AND $
      R_one eq R AND $
      cp_one eq cp AND $
      kappa_one eq kappa AND $
      planet_radius_one eq planet_radius AND $
      p0_one eq p0 AND $
      omega_one eq omega AND $
      grav_surf_one eq grav_surf AND $
      timestep_one eq timestep AND $
      lid_height_one eq lid_height AND $
      min_val_one eq min_val) then begin
                                ; First we can get rid of all of the _one quantities
                                ; apart from the data and time
     lon_combined_one=0
     lat_combined_one=0
     vert_combined_one=0
     var_vert_bounds_combined_one=0
     nvars_one=0
     which_var_arr_one=0
     vert_type_one=0
     pi_one=0
     R_one=0
     cp_one=0
     kappa_one=0
     planet_radius_one=0
     p0_one=0
     omega_one=0
     grav_surf_one=0
     timestep_one=0
     lid_height_one=0
     min_val_one=0
     ; Now we can combine the arrays.
     ; data and time, and sizes
     ; First array size, extend for time
     grid_size_combined_two=grid_size_combined
     grid_size_combined(3)=grid_size_combined_one(3)+grid_size_combined_two(3)
     ; Now we have to count the total entries required
     ; Now stick them together in the order the time dictates
     ; Pt next version in new array
     var_combined_two=var_combined
     time_combined_two=time_combined
     time_combined=0
     var_combined=0        
     ; Do they overlap?
     overlap=-1
     if (time_combined_one(0) gt time_combined_two(0)) then begin
        print, 'Please call the routine with your files'
        print, 'in the reverse order'
        print, 'Currently file: ', fname_one
        print, 'Has large times than: ', fname_two
        print, 'Sorry no time to make this routine better!'
        print, 'stoppping in combine_time_um_idl'
        stop
     endif
     ; Adopt the _one versions as the baseline
     for itime=0, grid_size_combined_two(3)-1 do begin
        if (time_combined_two(itime) eq $
            time_combined_one(grid_size_combined_one(3)-1)) then begin
           overlap=itime
        endif
     endfor
     ; If it overlaps, we stitch together
     grid_size_combined(3)=grid_size_combined_one(3)+$
                           grid_size_combined_two(3)-$
                           overlap-1
     time_combined=safe_alloc_arr(1, grid_size_combined(3), /float_arr)
     var_size=INTARR(5)
     var_size(0)=nvars
     var_size(1)=grid_size_combined(0)
     var_size(2)=grid_size_combined(1)
     var_size(3)=grid_size_combined(2)
     var_size(4)=grid_size_combined(3)
     var_combined=safe_alloc_arr(5, var_size, /float_arr)
     time_combined(0:grid_size_combined_one(3)-1)=$
        time_combined_one
     start=overlap+1
     time_combined(grid_size_combined_one(3):grid_size_combined(3)-1)=$
        time_combined_two(start:grid_size_combined_two(3)-1)
     var_combined(*,*,*,*,0:grid_size_combined_one(3)-1)=$
        var_combined_one(*,*,*,*,*)
     var_combined(*,*,*,*,grid_size_combined_one(3):grid_size_combined(3)-1)=$
        var_combined_two(*,*,*,*,start:grid_size_combined_two(3)-1)
     var_combined_one=0
     var_combined_two=0
     time_combined_one=0
     time_combined_two=0
     grid_size_combined_one=0
     grid_size_combined_two=0
  endif else begin
     print, 'Restored files: ', fname_one, fname_two
     print, 'differ in simulation output contents'
     print, 'stopping in combine_um_idl_save'
    stop
 endelse
  ; Save it
  save, var_combined, grid_size_combined, $
        lon_combined, lat_combined, vert_combined, $
        time_combined, $
        var_vert_bounds_combined, $
        nvars, which_var_arr, vert_type, $
        pi, R, cp, kappa, planet_radius, p0, $
        omega, grav_surf, timestep, lid_height, $
        min_val, $
        verbose=verbose, $
        filename=fname_out
end

pro vertical_mapping, vert_type,$
                      var_array, var_grid_size, $
                      var_lon, var_lat, var_vert, var_time, $
                      var_vert_bounds, $
                      p_array, p_grid_size, $
                      p_lon, p_lat, p_vert, p_time, $
                      psurf_array, $
                      nvert_map, vert_map, $
                      missing=missing, $
                      lid_height, p0
  ; This routine maps the var_array onto the vertical
  ; scale given by vert_map, it REPLACES var_array
  ; with the new version it also replaces the 
  ; var_vert, and corrects the var_grid_size(2)
  ; The mapping is in either height, sigma or pressure
  ; Set the missing entry value
  if not(keyword_set(missing)) then missing=-1.0e90
  ; Which type of vertical coordinate is required?
  ; Height is treated differently to pressure based 
  ; i.e. pressure and sigma
  if (vert_type eq 'Height') then begin
     ; UM uses height so no mapping required
     ; Just selecting the axes sections/interpolating
     ; Set the vertical boundaries
     grid_boundaries=set_grid_bound_values_vert($
                     vert_type, lid_height=lid_height)
     var_mapped=linear_interp_whole_axis($
                4, var_array, var_vert, $
                vert_map, 2, /value, $
                grid_boundaries=grid_boundaries, $
                var_boundaries=var_vert_bounds)
  endif else begin
     ; Mapping to pressure or sigma requires more
     ; work
     ; Create a local variable dependent on 
     ; which type we are mapping to, which is in 
     ; ln(pressure), as P/P_0=e^(-g/rt * dz) to 
     ; linearly interpolate it is more accurate
     ; to use ln(P)
     if (vert_type eq 'Pressure') then begin
        p_for_map=ALOG(p_array)
     endif else if (vert_type eq 'Sigma') then begin
        p_for_map=p_array      
        for ilat=0, p_grid_size(1)-1 do begin
           for ilon=0, p_grid_size(0)-1 do begin
              p_for_map(ilon,ilat,*,*)=ALOG(p_array(ilon,ilat,*,*)/$
                                            psurf_array(ilon,ilat))
           endfor
        endfor
     endif
     ; WARNING p_for_map is ln(P) in pressure case!!!
     ; Now perform mapping
     ; First we create the vertical coord at
     ; the field/variable points, by interpolating
     ; p_for_map, onto the var_array grids (other
     ; than the vertical grid of course)
     ; First setup the required arguments
     ; Which dimensions need interpolation
     which_interp=INTARR(4)
     which_interp(0)=1
     which_interp(1)=1
     which_interp(2)=1
     which_interp(3)=1
     ; Now setup the boundaries and grids etc.
     ; This vertical limits in the pressure are
     ; effectively p0 and 0.0, although the
     ; upper boundary is more difficult.
     p_vert_bounds=FLTARR(2)
     if (vert_type eq 'Pressure') then begin
        p_vert_bounds(0)=ALOG(p0)
        p_vert_bounds(1)=ALOG(0.0)
     endif else if (vert_type eq 'Sigma') then begin
        ; Sigma bounds are 1.0 and 0.0
        p_vert_bounds(0)=ALOG(1.0)
        p_vert_bounds(1)=ALOG(0.0)        
     endif
     set_4d_interp_std_arg, vert_type,$
                            p_grid_size, $
                            p_lon, p_lat, p_vert, p_time, $
                            var_grid_size,$
                            var_lon, var_lat, var_vert, var_time, $
                            p_vert_bounds, $
                            bounding_string, grid_boundaries, $
                            var_boundaries, index_per, grid_period, $
                            axes_index_incr, lid_height,$
                            p_grid, var_grid
     ; Finally interpolate
     ndims=4
     ; WARNING p_mapped is in ln(P)
     p_mapped=linear_interp_multid($
              ndims, $
              which_interp, p_for_map, p_grid_size, $
              p_grid, var_grid_size, var_grid, bounding_string, $
              grid_period, grid_boundaries, var_boundaries,$
              index_per, axes_index_incr, min_val=missing)
     p_for_map=0
     ; Due to problems with the upper boundary we can now reset 
     ; the value in cases where it is required just by assuming 
     ; hydrostatic balance
     ; Recall that pressure is in ln(P) at the moment
     ; First, is the grid HEIGHT of the variable extending
     ; above the HEIGHT of the pressure grid?
     if (max(var_vert) gt max(p_vert)) then begin
        ; If so extrapolate for the top pressure
        if (vert_type eq 'Pressure') then begin
           p_mapped(*,*,var_grid_size(2)-1,*)=$
           ALOG((EXP(p_mapped(*,*,var_grid_size(2)-2,*))^2.0)/$
                (EXP(p_mapped(*,*,var_grid_size(2)-3,*))))
        endif else if (vert_type eq 'Sigma') then begin
           p_mapped(*,*,var_grid_size(2)-1,*)=$
              ALOG(((EXP(p_mapped(*,*,var_grid_size(2)-2,*))^2.0)/$
                    (EXP(p_mapped(*,*,var_grid_size(2)-3,*))))/$
                   psurf_array(*,*,*))
        endif
     endif
     ; Now we have the ln(pressure/sigma) at the field/variable positions
     ; (p_mapped) we have to map the variable from a height
     ; to pressure/sigma structure as given by vert_map
     ; Here for a given longitude, latitude and time,
     ; the pressure at a given height is in p_mapped.
     ; From this we find the values of the variable
     ; at pressures in vert_map
     ; "std_array" part just means this function
     ; assumes that the array is (lon, lat, vert, time)
     ; However we need ln(vert_map), so create temporary
     ; variable
     ln_vert_map=ALOG(vert_map)
     var_mapped=map_std_array_to_pressure($
                var_array, var_grid_size, $
                p_mapped, nvert_map, ln_vert_map, $
;                missing=missing, $
                /value, $
; Call with the vertical bounds prescribed for this
; variable, and with the grid boundaries.
                grid_boundaries=p_vert_bounds, $
                var_boundaries=var_vert_bounds)

     ; Zero unrequired arrays
     ln_vert_map=0
     p_mapped=0
     p_vert_bounds=0
  endelse
  ; Replace the input array with the new one
  var_vert=vert_map
  var_grid_size(2)=nvert_map
  var_array=0
  var_array=safe_alloc_arr(4, var_grid_size, /float_arr)
  var_array(*,*,*,*)=var_mapped(*,*,*,*)
end


pro check_map_req, vert_type, $
                   map_grid_use_in=map_grid_use_in, $
                   map_limits_in=map_limits_in, $
                   map_grid_use, map_limits, $
                   planet_setup_in=planet_setup_in, $
                   planet_setup, $
                   netcdf_um_in=netcdf_um_in, $
                   netcdf2_um_in=netcdf2_um_in, $
                   netcdf_um_fname, $
                   netcdf2_um_fname, $
                   verbose=verbose
  ; Performs a few consistency checks for the mapping
  ; **WORK** This should be continually updated
  ; SHOULD ADD CHECKS WITHIN GRID ETC**
  ; Err flag
  err=0
  err_msg='check_map_req.pro-Error:'
  ; Setup grid use and limits
  if (KEYWORD_SET(map_grid_use_in)) then begin
     map_grid_use=map_grid_use_in
  endif else begin
     ; Default is all
     map_grid_use=STRARR(4)
     map_grid_use(*)='all'
  endelse
  if (KEYWORD_SET(map_limits_in)) then begin
     map_limits=map_limits_in
  endif else begin
     ; Default is all
     map_limits=STRARR(4,2)
     map_limits(*,0)='min'
     map_limits(*,1)='max'
  endelse
  for idim=0, 3 do begin
     ; We need to check if a value is selected
     ; it is a valid number
     if (map_grid_use(idim) ne 'all' and $
         map_grid_use(idim) ne 'mean' and $
         map_grid_use(idim) ne 'sum') then begin
        number_test=valid_num(map_grid_use(idim))
        if (number_test eq 0) then begin
           err=1
           err_msg=err_msg+' invalid number for map_grid_use'
        endif
     endif
     for i=0, 1 do begin
        if (map_limits(idim,i) ne 'min' and $
            map_limits(idim,i) ne 'max') then begin
           number_test=valid_num(map_limits(idim,i))
           if (number_test eq 0) then begin
              err=1
              err_msg=err_msg+' invalid number for map_limits'
           endif
        endif
     endfor
  endfor
  ; Now we need to check if min and max are requested they
  ; are consistent
  if (vert_type eq 'Pressure' or vert_type eq 'Sigma') then begin
     if (map_limits(2,0) ne 'min' and map_limits(2,1) ne 'max') then begin
        if (map_limits(2,0) gt map_limits(2,1)) then begin
           print, 'Adopting vertical coordinate:', vert_type
           print, 'But min:', map_limits(2,0), ' and max:', map_limits(2,1)
           print, 'inconsistent-stop in check_map_req.pro'
           stop
        endif
     endif
  endif else if (vert_type eq 'Height') then begin
     if (map_limits(2,0) ne 'min' and map_limits(2,1) ne 'max') then begin
        if (map_limits(2,0) lt map_limits(2,1)) then begin
           print, 'Adopting vertical coordinate:', vert_type
           print, 'But min:', map_limits(2,0), ' and max:', map_limits(2,1)
           print, 'inconsistent-stop in check_map_req.pro'
           stop
        endif
     endif
  endif else begin
     print, 'Vert_type:', vert_type, ' not recognised'
     print, 'stop in check_map_req.pro'
     stop
  endelse
  ; Check the planet setup input and um filename
  if (KEYWORD_SET(planet_setup_in)) then begin
     planet_setup=planet_setup_in
  endif else begin
     print, 'Planet setup must be selected! (i.e. planet_setup_in)'
     print, 'Stopping in check_map_req.pro'
     stop
  endelse
  if (KEYWORD_SET(netcdf_um_in)) then begin
     netcdf_um_fname=netcdf_um_in
  endif else begin
     print, 'UM input file must be given (i.e. netcdf_um_in)'
     print, 'Stopping in check_map_req.pro'
     stop
  endelse
  if (KEYWORD_SET(netcdf2_um_in)) then begin
    netcdf2_um_fname=netcdf2_um_in
    print, 'Second UM input file is defined (netcdf2_um_in)'
    print, 'This means we will take a difference between'
    print, 'the two files and plot the difference' 
    print, 'WARNING: So far this assumes that the two '
    print, 'simulations have the same physical constants '
    print, '(e.g. gravity, radius etc.).                 '
  endif else begin
    netcdf2_um_fname = ''
    print, 'Second UM input file is not defined. Making standard plot'
  endelse
end

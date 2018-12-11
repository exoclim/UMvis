function set_mapped_fname, planet_setup, $
                           nvars, which_var_arr, $
                           vert_type, map_grid_use, map_limits, $
                           mapped_fname_in=mapped_fname_in, $
                           verbose=verbose
  ; This routine creates the name for the mapped variables
  if (KEYWORD_SET(mapped_fname_in)) then begin
     map_name=mapped_fname_in
  endif else begin
     map_name=planet_setup
     ; Add variable details
     for ivar=0, nvars-1 do begin
        var_type=which_var_arr(ivar)
        map_name=map_name+'_'+var_type
     endfor
     ; Add in mapping requirements
     map_name=map_name+'_vert_'+vert_type
     ; Now use of grid dimensions
     for idim=0, 3 do begin        
        if (idim eq 0) then grid='_Lon'
        if (idim eq 1) then grid='_Lat'
        if (idim eq 2) then grid='_Vert'
        if (idim eq 3) then grid='_Time'
        grid=grid+'_'+map_grid_use(idim)
        if (map_limits(idim, 0) ne 'min') then $
           grid=grid+'min_'+map_limits(idim,0)
        if (map_limits(idim, 1) ne 'max') then $
           grid=grid+'max_'+map_limits(idim,1)
        map_name=map_name+grid
     endfor
     map_name=STRCOMPRESS(map_name,/remove_all)
  endelse

  if (KEYWORD_SET(verbose)) then begin
     print, 'Using netCDF/mapping name:', map_name
  endif
  return, map_name
end

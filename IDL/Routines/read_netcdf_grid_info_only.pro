pro read_netcdf_grid_info_only,fname,varname_in,$
                              grid_name_out, grid_size, $
                               verbose=verbose
   ; This routine opens and reads from a netcdf
   ; file (called fname) the variable (called varname_in)
   ; and saves it in array_out
@nc_info ; Common block to save info
   ncopen_std, ncid, fname
   ; Find which variable we are reading
   for ivar=1, num_var-1 do begin
      if (strcompress(var_name(ivar),/remove_all) eq varname_in) $
      then var_id=ivar
   endfor
   ; find corresponding dimensions
   ; Allocate the grid_variable
   grid_name_out=STRARR(var_dims(var_id))
   grid_size=INTARR(var_dims(var_id))
   for iivar=0, var_dims(var_id)-1 do begin
      grid_size(iivar)=dim_size(var_dimid(iivar,var_id))         
      grid_name_out(iivar)= $
         (strcompress(dim_name(var_dimid(iivar,var_id)),/remove_all))
   endfor
   ncdf_close, ncid
   if (KEYWORD_SET(verbose)) then begin
      print, 'Read in:', varname_in
      print, 'On grid:', grid_name_out
      print, 'Dimensions:', grid_size
   endif
end

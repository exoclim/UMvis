pro read_netcdf_variable_only, fname, varname, array_out, $
                              verbose=verbose
   ; This routine opens and reads from a netcdf
   ; file (called fname) the variable (called varname)
   ; and saves it in array_out
   ncopen_std, ncid, fname
   stat=ncget_std(ncid, varname, array_out, verbose=verbose) 
   ncdf_close, ncid
   if (KEYWORD_SET(verbose)) then begin
      print, 'Read in:', varname
      print, 'Dimensions:', size(array_out)
   endif
end

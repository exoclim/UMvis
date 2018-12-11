function set_netcdf_var_names, netcdf_name_key, verbose=verbose
  ; A function to read the file linking the short field names
  ; in the input netcdf file to those in the UMvis framework
  ; This file should have a prescribed format:
  ; Header (staring with #) then two columns, space delimited:
  ; 1= UMvis variable name, 
  ; 2= Netcdf file name (short name)

  ; Read in the file
  openr, lun, netcdf_name_key, /get_lun
  ; Define variables to read in the header and count the 
  ; arrays
  ; Read in the header
  line=''
  ncount=0
  while not EOF(lun) do begin
     readf, lun, line
     ; Check if it is header , i.e. starts with #
     first_char=STRMID(line, 0, 1)
     if (not (first_char eq '#')) then $
        ncount=ncount+1
  endwhile
  if (KEYWORD_SET(verbose)) then begin
     print, 'Counted: ', ncount, ' variable names in file: ', netcdf_name_key    
  endif

  ; Now allocate the array:   
  if (ncount eq 1 or ncount eq 0) then begin
     print, 'Problem with netcdf name key:', netcdf_name_key
     print, 'File does not contain enough information'
     print, 'stopping in set_netcdf_var_names.pro'
     stop
  endif
  netcdf_var_names=STRARR(2, ncount)
  ; Rewind the file and read in
  free_lun, lun
  openr, lun, netcdf_name_key, /get_lun
  ncount=0
  while not EOF(lun) do begin
     readf, lun, line
     ; Check if it is header , i.e. starts with #
     first_char=STRMID(line, 0, 1)
     if (not (first_char eq '#')) then begin
        ; Split the line, and save the components
        line_array=STRSPLIT(line, $
                            /REGEX, /EXTRACT, COUNT=ncols, $
                            ' ')
        if (not (ncols eq 2)) then begin
           print, 'Expecting two columns in file: ', netcdf_name_key
           print, 'But found: ', ncols
           print, 'stopping in set_netcdf_var_names.pro'
           stop
        endif

        netcdf_var_names(0, ncount)=line_array[0]
        netcdf_var_names(1, ncount)=line_array[1]
        if (KEYWORD_SET(verbose)) then begin
           print, 'Reading element: ', ncount
           print, 'Got UMVis, and netcdf names: ', $
                  netcdf_var_names(0, ncount), $
                  ' -> ', netcdf_var_names(1, ncount)
        endif
        ncount=ncount+1
     endif
  endwhile
  return, netcdf_var_names
end

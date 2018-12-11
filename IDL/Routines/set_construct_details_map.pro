pro set_construct_details_map, variable_list, nvars, which_var_arr, $
                               nvars_map, which_var_arr_map, $
                               verbose=verbose
  ; This routine checks if the requested variable_list
  ; is available in either the direct values present in the map
  ; nvars_map, which_var_arr_map, or can be constructed as either
  ; a vector from the mapped, or as another variable from the map.

  ; First split the variable list
  components=STRSPLIT(variable_list,/EXTRACT,COUNT=ncomps,'&')  
  ; Populate the list of supported mapped routines
  cvar_list_mapped, ncvar_mapped, cvar_name_mapped, $
                    cnprog_req, cprog_name_req, $
                    cvar_call_mapped, tested=tested
  ; ncvars_map, which_var_arr_map contain the variables
  ; present in the mapped output.
  ; Populate the list of available/supported vectors
  cvar_vector_list, ncvar_vect, cvar_name_vect, $
                    cvar_nelements_vect,$
                    cvar_elements_vect, tested=tested_vect

  ; Now we cycle through each component and count the number we need
  ; checking if each one is first directly available from the mapped
  ; file, then whether it is a whose components are available from
  ; the file, then if it is a variable which can be constructed from
  ; the mapped file
  nvars=0
  for icomp=0, ncomps-1 do begin
     location=-1
     location=find_string_in_arr(nvars_map, which_var_arr_map, $
                                 components(icomp), /nofail)
     ; If found count it
     if (location ge 0) then begin
        nvars=nvars+1
     endif else begin
        ; Otherwise, is it a vector?
        location=find_string_in_arr(ncvar_vect, cvar_name_vect, $
                                    components(icomp), /nofail)
        ; If found we need to find the components, and count them
        if (location ge 0) then begin
           for ivect=0, cvar_nelements_vect(location)-1 do begin
              location_vect=-1
              location_vect=find_string_in_arr($
                            nvars_map, which_var_arr_map, $
                            cvar_elements_vect(location,ivect), /nofail)
              if (location_vect ge 0) then begin
                 ; Found it so count it
                 nvars=nvars+1
              endif else begin
                 print, 'Unable to find vector component: ', $
                        cvar_elements_vect(location,ivect)
                 print, 'in variables within mapped file: ', $
                        which_var_arr_map
                 print, 'Stopping in set_construct_details_map.pro'
                 stop
              endelse
           endfor
        endif else begin
           ; If we get her it will have to be constructed, so is
           ; it in the list
           location=find_string_in_arr(ncvar_mapped, cvar_name_mapped, $
                                       components(icomp), /nofail)
           ; Found it, then count it
           if (location ge 0) then begin
              nvars=nvars+1
           endif else begin
              print, 'Variable: ', components(icomp)
              print, 'Can not be restored or constructed from the mapped input'
              print, 'which includes: ', which_var_arr_map
              print, 'stopping in set_construct_details_map.pro'
              stop
           endelse
        endelse
     endelse
  endfor
  ; Now we have counted allocate the array and store
  which_var_arr=STRARR(nvars)
  var_count=0
  for icomp=0, ncomps-1 do begin
     location=-1
     location=find_string_in_arr(nvars_map, which_var_arr_map, $
                                 components(icomp), /nofail)
     ; If found store it
     if (location ge 0) then begin
        which_var_arr(var_count)=which_var_arr_map(location)
        var_count=var_count+1
     endif else begin
        ; Otherwise, is it a vector?
        location=find_string_in_arr(ncvar_vect, cvar_name_vect, $
                                    components(icomp), /nofail)
        ; If found we need to find the components, and count them
        if (location ge 0) then begin
           for ivect=0, cvar_nelements_vect(location)-1 do begin
              location_vect=-1
              location_vect=find_string_in_arr($
                            nvars_map, which_var_arr_map, $
                            cvar_elements_vect(location,ivect), /nofail)
              if (location_vect ge 0) then begin
                 ; Found so store it
                 which_var_arr(var_count)=which_var_arr_map(location_vect)
                 var_count=var_count+1
              endif else begin
                 print, 'Unable to find vector component: ', $
                        cvar_elements_vect(location,ivect)
                 print, 'in variables within mapped file: ', $
                        which_var_arr_map
                 print, 'Stopping in set_construct_details_map.pro'
                 stop
              endelse
           endfor
        endif else begin
           ; If we get her it will have to be constructed, so is
           ; it in the list
           location=find_string_in_arr(ncvar_mapped, cvar_name_mapped, $
                                       components(icomp), /nofail)
           ; Found it, then store it
           if (location ge 0) then begin
              which_var_arr(var_count)=cvar_name_mapped(location)
              var_count=var_count+1
           endif else begin
              print, 'Variable: ', components(icomp)
              print, 'Can not be restored or constructed from the mapped input'
              print, 'which includes: ', which_var_arr_map
              print, 'stopping in set_construct_details_map.pro'
              stop
           endelse
        endelse
     endelse
  endfor

  if (KEYWORD_SET(verbose)) then begin
     print, 'Found the following variables: ', which_var_arr
     print, 'Available from requested list: ', variable_list
     print, 'Either direct from map file: ', which_var_arr_map
     print, 'Or constructed as vectors from these'
     print, 'Or constructed from cvar_list_mapped.pro'
  endif
end

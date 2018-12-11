pro cvar_find_mapped, which_var, nvars, which_var_arr_map, $
                      nprog_req, prog_name_req, $
                      routine_call, $
                      call_var_index, $
                      var_tested, $
                      verbose=verbose
  ; This routine works out whether we can construct
  ; a variable from those available, and creates the 
  ; routine_call to do it
  ; It also returns call_index, which gives the locations
  ; within which_var_arr_map of the required variables (prog_name_req)

  ; First populate the list etc.
  cvar_list_mapped, ncvar_mapped, cvar_name_mapped, $
                    cnprog_req, cprog_name_req, $
                    cvar_call_mapped, tested=tested
  location=-1
  ; Need a useful failure message, hence nofail
  location=find_string_in_arr(ncvar_mapped, cvar_name_mapped, $
                              which_var, /nofail)
  if (location eq -1) then begin
     print, 'Unable to find variable: ', which_var
     print, 'in supported list from cvar_list_mapped'
     print, 'Stopping in cvar_find_mapped.pro'
     stop
  endif
  ; Save the basic variables required
  nprog_req=cnprog_req(location)
  prog_name_req=cprog_name_req(location,*)
  ; Create an array to keep track of prognostic locations
  call_var_index=safe_alloc_arr(1, nprog_req, /int_arr)
  ; Save the routine call and tested flag
  routine_call=cvar_call_mapped(location)
  var_tested=tested(location)

  ; Now do we have the required basic variables?
  for iprog=0, nprog_req-1 do begin
     ; Set the location of each
     ; Fail if we can't find it (i.e. no /nofail keyword)
     call_var_index(iprog)=find_string_in_arr(nvars, $
                                              which_var_arr_map, $
                                              prog_name_req(iprog))
  endfor

  ; Print what we have
  if (KEYWORD_SET(verbose)) then begin
     print, 'Searched for: ', which_var
     print, 'From list of options to construct from mapped'
     print, 'Using construction call:', routine_call
     print, 'Found following basic variables within mapped set available:'
     for iprog=0, nprog_req-1 do begin
        print, 'Basic (index, name):',$
               iprog, ' ', prog_name_req(iprog)
        print, 'From (index, name):', $
               call_var_index(iprog), ' ', $
               which_var_arr_map(call_var_index(iprog))
     endfor
  endif
end

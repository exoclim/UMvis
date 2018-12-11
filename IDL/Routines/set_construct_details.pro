pro set_construct_details, variable_list, $
                           nvars, which_var_arr, construction_calls, $
                           verbose=verbose
  ; This routine creates the list of variables 
  ; required for mapping and their construction procedure
  ; calls
  ; This routine checks the input
  ; First see how many components the variable_list has
  components=STRSPLIT(variable_list,/EXTRACT,COUNT=ncomps,'&')  
  ; Populate the list of available individual variables
  cvar_list, ncvar, cvar_name, cvar_call, tested=tested_single
  ; Populate the list of available/supported vectors
  cvar_vector_list, ncvar_vect, cvar_name_vect, $
                    cvar_nelements_vect,$
                    cvar_elements_vect, tested=tested_vect
  ; Now count the variables we need
  nvars=0
  for icomp=0, ncomps-1 do begin
     found=0
     components(icomp)=strcompress(components(icomp),/remove_all)
     ; For single variables just add one
     for icvar=0, ncvar-1 do begin
        if (components(icomp) eq cvar_name(icvar)) then begin
           nvars=nvars+1
           found=1
        endif
     endfor 
     ; For vectors we need to add the number of elements
     ; i.e. 2 for Horizvel: U and V
     for icvar_vect=0, ncvar_vect-1 do begin
        if (components(icomp) eq cvar_name_vect(icvar_vect)) then begin
           nvars=nvars+cvar_nelements_vect(icvar_vect)
           found=1
        endif
     endfor
     if (found eq 0) then begin
        print, 'Variable: ', components(icomp)
        print, 'Not found in list of scalar, or vectors'
        print, 'stopping in set_construct_details'
        print, 'Might you be using a constructed variable?'
        print, 'If so you must add /from_map_save to your call'
        stop
     endif
  endfor
  ; Allocate the array sizes
  which_var_arr=STRARR(nvars)
  construction_calls=STRARR(nvars)
  tested=INTARR(nvars)
  ; Now fill them
  var_count=0
  for icomp=0, ncomps-1 do begin
     for icvar=0, ncvar-1 do begin
        ; If a single variable add the name and call
        if (components(icomp) eq cvar_name(icvar)) then begin
           which_var_arr(var_count)=cvar_name(icvar)
           construction_calls(var_count)=cvar_call(icvar)
           tested(var_count)=tested_single(icvar)
           var_count=var_count+1
        endif
     endfor
     for icvar_vect=0, ncvar_vect-1 do begin
        ; For vectors we must find each element
        if (components(icomp) eq cvar_name_vect(icvar_vect)) then begin
           ; Loop over available single variables
           for ielement=0, cvar_nelements_vect(icvar_vect)-1 do begin
              which_var_arr(var_count)=$
                 cvar_elements_vect(icvar_vect, ielement)
              ; Find the required call
              found=0              
              for icvar=0, ncvar-1 do begin
                 if (which_var_arr(var_count) eq cvar_name(icvar)) then begin
                    construction_calls(var_count)=cvar_call(icvar)
                    tested(var_count)=tested_single(icvar)
                    found=1
                 endif
              endfor
              if (found eq 0) then begin
                 print, 'Unable to find vector:', components(icomp)
                 print, 'Component:', which_var_arr(var_count)
                 stop
              endif                 
              var_count=var_count+1
           endfor
        endif
     endfor ; icvar_vect
  endfor ; iplot

  if (KEYWORD_SET(verbose)) then begin
     print, 'Constructing variable list:', variable_list
     print, 'Using individual variables and calls:'
     for ivar=0, nvars-1 do begin
        print, ivar+1, 'Name: ',  which_var_arr(ivar)
        print, 'Call:', construction_calls(ivar)
        if (tested(ivar) eq 0) then $
           print, 'WARNING: this variable is untested'
     endfor
  endif
end

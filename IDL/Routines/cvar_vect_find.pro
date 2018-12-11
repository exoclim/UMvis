pro cvar_vect_find, which_var, $
                    found, $
                    nvector_comp, $
                    vector_comp_var, $
                    var_tested, $
                    verbose=verbose
  ; A simple routine which finds the variable in the vectors list
  ; returns found = 1 if found, and found =0 if not.
  ; The routine then returns the number of variables to make it
  ; and which variables are required, as long as whether the 
  ; vector is tested.

  ; Populate the list of available/supported vectors
  cvar_vector_list, ncvar_vect, cvar_name_vect, $
                    cvar_nelements_vect,$
                    cvar_elements_vect, tested=tested_vect
  ; Find the requested vector
  found=0
  for ivar=0, ncvar_vect-1 do begin
     if (which_var eq cvar_name_vect(ivar)) then begin
        found=1
        ; Create the string array
        nvector_comp=cvar_nelements_vect(ivar)
        vector_comp_var=STRARR(nvector_comp)
        for icomp=0, nvector_comp-1 do begin
           vector_comp_var(icomp)=cvar_elements_vect(ivar,icomp)
        endfor
        var_tested=tested_vect(ivar)
     endif
  endfor
end

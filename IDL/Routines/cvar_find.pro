pro cvar_find, which_var, $
               found, $
               routine_call, $
               var_tested, $
               verbose=verbose
  ; A simple routine which finds the variable in the list
  ; returns found = 1 if found, and found =0 if not.
  ; The routine_call and whether the variable is tested is
  ; also returned.

  ; Populate the list of available variables
  cvar_list, ncvar, cvar_name, cvar_call, tested=tested
  ; Find our requested variable
  location=find_string_in_arr(ncvar, cvar_name, which_var, /nofail)
  if (location eq -1) then begin
     found=0
     routine_call=0
     var_tested=0
  endif else begin
     found=1
     routine_call=cvar_call(location)
     var_tested=tested(location)
  endelse
end

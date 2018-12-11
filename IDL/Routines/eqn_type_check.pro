pro eqn_type_check, eqn_type=eqn_type
  ; A simple routine to check the equation type is 
  ; present and a valid option.

  err=0
  if (KEYWORD_SET(eqn_type)) then begin
     if (not (eqn_type eq 'shallow') and $
         not (eqn_type eq 'deep')) then err=1
  endif else begin
     err=1
  endelse

  if (err eq 1) then begin
     print,'***************************************'
     print, 'eqn_type required an either not set'
     print, 'Or invalid (deep or shallow required)'
     print,'***************************************'
     stop
  endif
end

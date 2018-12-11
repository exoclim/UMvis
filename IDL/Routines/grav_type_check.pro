pro grav_type_check, grav_type=grav_type
  ; A simple routine to check the equation type is 
  ; present and a valid option.

  err=0
  if (KEYWORD_SET(grav_type)) then begin
     if (not (grav_type eq 'constant') and $
         not (grav_type eq 'varying')) then err=1
  endif else begin
     err=1
  endelse

  if (err eq 1) then begin
     print,'***************************************'
     print, 'grav_type required an either not set'
     print, 'Or invalid (constant or varying required)'
     print,'***************************************'
     stop
  endif
end

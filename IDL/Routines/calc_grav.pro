function calc_grav,grav_surf, Radius, z, nvert, grav_type=grav_type, $
                   verbose=verbose
  ; This function returns the gravity as a function of
  ; height
  gravity=safe_alloc_arr(1, nvert, /float_arr)
  gravity(*)=grav_surf
  ; First check the grav_type is set ok
  grav_type_check, grav_type=grav_type
  IF (grav_type eq 'constant') THEN BEGIN
     IF (KEYWORD_SET(verbose)) then begin
        print, 'Using constant (with height) gravity'
        print, grav_surf
     endif
     gravity(*)=grav_surf
  ENDIF ELSE IF (grav_type eq'varying') THEN BEGIN
     IF (KEYWORD_SET(verbose)) then begin
        print, 'Using constant gravity varying with height'
        print, 'i.e. g=g_surf * (R_p/(R_P+z))^2.0'
        print, grav_surf, ' to ', $
               grav_surf*(Radius/(Radius+z(nvert-1)))^2.0
     endif
     for ivert=0, nvert-1 do begin
        gravity(ivert)=grav_surf*$
                       (Radius/(Radius+z(ivert)))^2.0
     endfor
  ENDIF ELSE IF (grav_type eq'self') THEN BEGIN
     print, 'Self-Gravity not coded yet!!!!!'
     stop
  ENDIF
  return, gravity
end

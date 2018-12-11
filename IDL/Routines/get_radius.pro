function get_radius, Radius, z, eqn_type=eqn_type
  ; This function calculates the radial height
  ; dependent on the equation type

  eqn_type_check, eqn_type=eqn_type
  if (eqn_type eq 'shallow') then begin
     radial_height=Radius
  endif else if (eqn_type eq 'deep') then begin
     radial_height=z+Radius
  endif
  return, radial_height
end



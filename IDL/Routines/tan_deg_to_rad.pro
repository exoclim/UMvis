function tan_deg_to_rad, degrees, pi
  ; A function to  take the tangent of an angle
  ; in radians, after converting it from degrees (input
  ; not converted)
  radians=deg_to_rad(degrees, pi)
  ; take tangent
  tan_radians=tan(radians)
  return, tan_radians
end

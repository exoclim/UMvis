function cos_deg_to_rad, degrees, pi
  ; A function to  take the cosine of an angle
  ; in radians, after converting it from degrees (input
  ; not converted)
  radians=deg_to_rad(degrees, pi)
  ; take cosine
  cos_radians=cos(radians)
  return, cos_radians
end

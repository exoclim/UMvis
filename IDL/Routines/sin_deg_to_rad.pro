function sin_deg_to_rad, degrees, pi
  ; A function to  take the sine of an angle
  ; in radians, after converting it from degrees (input
  ; not converted)
  radians=deg_to_rad(degrees, pi)
  ; take sine
  sin_radians=sin(radians)
  return, sin_radians
end

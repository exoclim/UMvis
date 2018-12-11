function mole_fraction_ccontours, plot_array, min_val, nconts
  ; Short function to create a standard set of contours
  min_data=1.0e-12;1.0E-12
  max_data=1.0e-3
  conts = FINDGEN(nconts)*(ALOG10(max_data)-ALOG10(min_data))/(nconts-1.0)+ALOG10(min_data)   
  conts = 10.^conts
  print, conts
  return, conts
end

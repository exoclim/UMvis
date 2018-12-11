function mole_fraction_contours, plot_array, min_val, nconts
  ; Short function to create a standard set of contours
  min_data=min(plot_array(where(plot_array gt min_val)));1.0E-12
  max_data=max(plot_array(where(plot_array gt min_val)));1.0e-5
  conts = FINDGEN(nconts)*(ALOG10(max_data)-ALOG10(min_data))/(nconts-1.0)+ALOG10(min_data)   
  conts = 10.^conts
  print, conts
  return, conts
end

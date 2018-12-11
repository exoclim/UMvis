pro default_plot_contour_format, nconts,$
                                 cont_thick, cont_lbl, cont_lines_col, $
                                 cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                                 foreground=foreground
  
  ; Procedure to setup the format of the lines used for contours
  ; Thickness of contour lines
  cont_thick=safe_alloc_arr(1, nconts, /int_arr)
  cont_thick(*)=1
  ; Which are labelled
  cont_lbl=safe_alloc_arr(1, nconts, /int_arr)
  ; Create label switch 
  if (KEYWORD_SET(cont_lbl_freq_ovrd)) then begin
     iswitch=cont_lbl_freq_ovrd
  endif else begin
     iswitch=2
  endelse
  cont_lbl=set_cont_lbl(nconts, iswitch)
  ; White lines
  cont_lines_col=safe_alloc_arr(1, nconts, /int_arr)
  cont_lines_col(*)=!P.Background
  ; Black lines if requested
  if (KEYWORD_SET(foreground)) then $
  cont_lines_col(*)=!P.Color
end

pro default_contours_format, plot_array, nconts, conts, ncoconts, coconts, $
                             coscale, nbar_names, bar_names, $
                             cont_lbl, cont_thick, cont_lines_col, $
                             txt_thick, txt_size, $
                             min_val, $
                             nconts_ovrd=nconts_ovrd,$
                             ncoconts_ovrd=ncoconts_ovrd,$
                             nbar_names_ovrd=nbar_names_ovrd, $
                             col_table=col_table, $
                             colscale_setup=colscale_setup, $
                             cont_lbl_ovrd=cont_lbl_ovrd, $
                             cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                             txt_thick_ovrd=txt_thick_ovrd, $
                             txt_size_ovrd=txt_size_ovrd, $
                             cont_thick_ovrd=cont_thick_ovrd, $
                             cont_lines_col_ovrd=cont_lines_col_ovrd, $
                             verbose=verbose    
  ; Routine to setup the default contours, colour
  ; scales and bar_names, and text/labelling

  ; Setup the contours
  if (KEYWORD_SET(nconts_ovrd)) then begin
     nconts=nconts_ovrd
  endif else begin
     nconts=20
  endelse
  conts=default_contours(plot_array, min_val, nconts)

  ; Setup the colour contours
  if (KEYWORD_SET(ncoconts_ovrd)) then begin
     ncoconts=ncoconts_ovrd
  endif else begin
     ncoconts=60
  endelse
  coconts=default_contours(plot_array, min_val, ncoconts)  

  ; Setup the colour scale
  ; Have we set a colour table?
  ; Or a scale?
  load_colour_table, coconts=coconts, col_table=col_table
  load_colour_scale, coconts, coscale, $
                     colscale_setup=colscale_setup
  
  ; Setup the bar_names
  if (KEYWORD_SET(nbar_names_ovrd)) then begin
     nbar_names=nbar_names_ovrd
  endif else begin
     nbar_names=7
  endelse
  bar_names=default_bar_names(nbar_names,$
                              ncoconts, coconts, coscale)

  ; Set default bakground and foreground colours  
  TVLCT, 255, 255, 255, 255     ; White color
  TVLCT, 0, 0, 0, 0             ; Black color
  !P.Color = 0
  !P.Background = 255

  ; Setup labelling
  default_plot_txt, txt_thick, txt_size
  ; Override if required
  ; How thick is the text
  if (KEYWORD_SET(txt_thick_ovrd)) then $
     txt_thick=txt_thick_ovrd
  if (KEYWORD_SET(txt_size_ovrd)) then $
     txt_size=txt_size_ovrd

  default_plot_contour_format,$
     nconts, $
     cont_thick, cont_lbl, cont_lines_col, $
     cont_lbl_freq_ovrd=cont_lbl_freq_ovrd
  ; Now apply overrides
  if (KEYWORD_SET(cont_thick_ovrd)) then $
     cont_thick=cont_thick_ovrd
  if (KEYWORD_SET(cont_lbl_ovrd)) then begin
     cont_lbl=cont_lbl_ovrd
     if (nconts ne n_elements(cont_lbl)) then begin
        print, 'Error in default_contours_format'
        print, 'number of contours, and requested labelling'
        print, 'incompatible:', nconts , $
               n_elements(cont_lbl)
        stop
     endif
  endif
  if (KEYWORD_SET(cont_lines_col_ovrd)) then begin
     cont_lines_col=cont_lines_col_ovrd
     if (nconts ne n_elements(cont_lines_col)) then begin
        print, 'Error in default_contours_format'
        print, 'number of contours, and requested colours'
        print, 'incompatible:', nconts , $
               n_elements(cont_lines_col)
        stop
     endif
  endif

  ; Inform user of settings
  if (KEYWORD_SET(verbose)) then begin
     print, 'Setup default contour and plot formatting'
  endif
end

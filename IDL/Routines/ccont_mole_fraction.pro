pro ccont_mole_fraction, plot_array, $
                       nconts, conts, ncoconts, coconts, $
                       coscale, nbar_names, bar_names, $
                       cont_lbl, cont_thick, cont_lines_col, $
                       txt_thick, txt_size, $
                       min_val, $
                       col_table=col_table, $
                       colscale_setup=colscale_setup, $
                       verbose=verbose
  
  ; Setup the contours
  nconts=20
  conts=mole_fraction_contours(plot_array, min_val, nconts)
  ; Setup the colour contours
  ncoconts=nconts*16
  coconts=mole_fraction_ccontours(plot_array, min_val, ncoconts)
  ; Setup the colour table
  if (NOT(KEYWORD_SET(col_table))) then $
     col_table='temperature'
  load_colour_table, coconts=coconts, col_table=col_table
  ; Default colour scale
  load_colour_scale, coconts, coscale
  ; Setup the contour plotting details
  default_plot_contour_format,$
     nconts, $
     cont_thick, cont_lbl, cont_lines_col
  nbar_names=7
  bar_names=default_bar_names(nbar_names, ncoconts, coconts, coscale)
  default_plot_txt, txt_thick, txt_size
end

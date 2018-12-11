pro ccont_gj1214b_uvel_bar_3000, $
   plot_array, $
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
  conts=safe_alloc_arr(1, nconts, /float_arr)
  conts=-200.0+200.0*indgen(nconts+1)
  ; Setup the colour contours
  ncoconts=nconts*8
  coconts=wind_contours(plot_array, min_val, ncoconts, $
                        fix_min=-30, fix_max=3000)
  ; Setup the colour table
  if (NOT(KEYWORD_SET(col_table))) then $
     col_table='wind'
  load_colour_table, coconts=coconts, col_table=74
  if (NOT(KEYWORD_SET(colscale_setup))) then $
     colscale_setup='wind'
  load_colour_scale, coconts, coscale, $
                     colscale_setup=colscale_setup
  ; Setup the contour plotting details
  default_plot_contour_format,$
     nconts, $
     cont_thick, cont_lbl, cont_lines_col, /foreground
  nbar_names=7
  bar_names=default_bar_names(nbar_names, ncoconts, coconts, coscale)
  default_plot_txt, txt_thick, txt_size
end

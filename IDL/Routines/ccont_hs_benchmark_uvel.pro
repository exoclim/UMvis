pro ccont_hs_benchmark_uvel, plot_array, $
                             nconts, conts, ncoconts, coconts, $
                             coscale, nbar_names, bar_names, $
                             cont_lbl, cont_thick, cont_lines_col, $
                             txt_thick, txt_size, $
                             min_val, $
                             col_table=col_table, $
                             colscale_setup=colscale_setup, $
                             verbose=verbose
  
  ; Setup the contours
  nconts=11            
  conts=safe_alloc_arr(1, nconts, /float_arr)
  conts(0)=-12.0
  conts(1)=-8.0
  conts(2)=-4.0
  conts(3)=0.0
  conts(4)=4.0
  conts(5)=8.0
  conts(6)=12.0
  conts(7)=16.0
  conts(8)=20.0
  conts(9)=24.0
  conts(10)=28.0
  ; Setup the colour contours
  ncoconts=nconts*4
  coconts=wind_contours(plot_array, min_val, ncoconts)
  ; Setup the colour table
  if (NOT(KEYWORD_SET(col_table))) then $
     col_table='wind'
  load_colour_table, coconts=coconts, col_table=col_table
  if (NOT(KEYWORD_SET(colscale_setup))) then $
     colscale_setup='wind'
  load_colour_scale, coconts, coscale, $
                     colscale_setup=colscale_setup
  ; Setup the contour plotting details
  default_plot_contour_format,$
     nconts, $
     cont_thick, cont_lbl, cont_lines_col
  nbar_names=7
  bar_names=default_bar_names(nbar_names, ncoconts, coconts, coscale)
  default_plot_txt, txt_thick, txt_size
end

pro ccont_std_hj_eddy, plot_array, $
                                    nconts, conts, ncoconts, coconts, $
                                    coscale, nbar_names, bar_names, $
                                    cont_lbl, cont_thick, cont_lines_col, $
                                    txt_thick, txt_size, $
                                    min_val, $
                                    col_table=col_table, $
                                    colscale_setup=colscale_setup, $
                                    verbose=verbose
  
  ; Setup the contours
  nconts=13
  conts=safe_alloc_arr(1, nconts, /float_arr)
  conts(0)=-0.05
  conts(1)=-0.01
  conts(2)=-0.005
  conts(3)=-0.001
  conts(4)=-0.0005
  conts(5)=-0.0001
  conts(6)=0.000
  conts(7)=0.0001
  conts(8)=0.0005
  conts(9)=0.001
  conts(10)=0.005
  conts(11)=0.01
  conts(12)=0.05
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

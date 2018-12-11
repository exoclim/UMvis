pro ccont_order_mag_scaled, plot_array, $
                                    nconts, conts, ncoconts, coconts, $
                                    coscale, nbar_names, bar_names, $
                                    cont_lbl, cont_thick, cont_lines_col, $
                                    txt_thick, txt_size, $
                                    min_val, $
                                    col_table=col_table, $
                                    colscale_setup=colscale_setup, $
                                    verbose=verbose
  
  ; Setup the contours
  nconts=12
  conts=safe_alloc_arr(1, nconts, /float_arr)
  conts(0)=-1.0
  conts(1)=-0.8
  conts(2)=-0.6
  conts(3)=-0.4
  conts(4)=-0.2
  conts(5)=0.0
  conts(6)=0.2
  conts(7)=0.4
  conts(8)=0.6
  conts(9)=0.8
  conts(10)=0.9
  conts(11)=1.0
  ; Now scale them to the values in the data.
  scale=max(abs(plot_array))
  ; Round to one significant figure
  scale=sigfig(scale, 1)
  conts(*)=scale*conts(*)
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

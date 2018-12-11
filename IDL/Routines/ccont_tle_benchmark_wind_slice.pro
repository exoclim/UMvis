pro ccont_tle_benchmark_wind_slice, plot_array, $
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
  conts(0)=-30.0
  conts(1)=-25.0
  conts(2)=-20.0
  conts(3)=-15.0
  conts(4)=-10.0
  conts(5)=-5.0
  conts(6)=0.0
  conts(7)=5.0
  conts(8)=10.0
  conts(9)=15.0
  conts(10)=20.0
  conts(11)=25.0
  conts(12)=30.0
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

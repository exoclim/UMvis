pro ccont_shj_benchmark_temp_slice, plot_array, $
                                    nconts, conts, ncoconts, coconts, $
                                    coscale, nbar_names, bar_names, $
                                    cont_lbl, cont_thick, cont_lines_col, $
                                    txt_thick, txt_size, $
                                    min_val, $
                                    col_table=col_table, $
                                    colscale_setup=colscale_setup, $
                                    verbose=verbose
  
  ; Setup the contours
  nconts=10      
  conts=safe_alloc_arr(1, nconts, /float_arr)
  conts(0)=1300.0
  conts(1)=1340.0
  conts(2)=1380.0
  conts(3)=1420.0
  conts(4)=1460.0
  conts(5)=1500.0
  conts(6)=1540.0
  conts(7)=1580.0
  conts(8)=1620.0
  conts(8)=1660.0
  conts(9)=1700.0
  ; Setup the colour contours
  ncoconts=nconts*4
  coconts=default_contours(plot_array, min_val, ncoconts)
  ; Setup the colour table
  if (NOT(KEYWORD_SET(col_table))) then $
     col_table='temperature'
  load_colour_table, col_table=col_table
  load_colour_scale, coconts, coscale, $
                     colscale_setup=colscale_setup
  ; Setup the contour plotting details
  default_plot_contour_format,$
     nconts, $
     cont_thick, cont_lbl, cont_lines_col
  ; Alter the line colours for colour plots  
  ; do half the contour labels in white
  cont_lines_col(0:((nconts-1)/2)-2)=!P.Background
  nbar_names=7
  bar_names=default_bar_names(nbar_names, ncoconts, coconts, coscale)
  default_plot_txt, txt_thick, txt_size
end

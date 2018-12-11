pro ccont_gj1214brt_temperature_100pa, plot_array, $
                                     nconts, conts, ncoconts, coconts, $
                                     coscale, nbar_names, bar_names, $
                                     cont_lbl, cont_thick, cont_lines_col, $
                                     txt_thick, txt_size, $
                                     min_val, $
                                     col_table=col_table, $
                                     colscale_setup=colscale_setup, $
                                     verbose=verbose
  
  ; Setup the contours
  nconts=7
  conts=safe_alloc_arr(1, nconts, /float_arr)
  conts=250.0+50.0*indgen(nconts+1)
  ; Setup the colour contours
  ncoconts=nconts*20
  coconts=default_contours(plot_array, min_val, ncoconts, $
                          fix_min=400, fix_max=550)
  ; Setup the colour table
  load_colour_table, coconts=coconts, col_table= 72, /reverse
  load_colour_scale, coconts, coscale, $
                     colscale_setup=colscale_setup
  ; Setup the contour plotting details
  default_plot_contour_format,$
     nconts, $
     cont_thick, cont_lbl, cont_lines_col, $
     cont_lbl_freq_ovrd=1;, /foreground
  nbar_names=7
  bar_names=default_bar_names(nbar_names, ncoconts, coconts, coscale)
  default_plot_txt, txt_thick, txt_size
end

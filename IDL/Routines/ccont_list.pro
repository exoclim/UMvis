pro ccont_list, nccont, ccont_name, ccont_call 
  ; This constructs a list of standard
  ; contour setups, and the calls to their routines
  ; WARNING: this is called within 
  ; set_contours_format.pro
  ; Therefore ALL names used as arguments, MUST
  ; be the same inside both procedures.
  ; A Standard call will look something like
  ; that in set_contours_format.pro, to 
  ; default_contours_format.pro (the structure
  ; in terms of what should be set should be similar).
  ; the routines themselves
  ; should be called: ccont_????.pro
  ; This list is selected from using the
  ; contour_setup (keyword)
  ; A FULL routine call would look like:
  ; ccont_NAME, plot_array, $
  ;             nconts, conts, ncoconts, coconts, $
  ;             coscale, nbar_names, bar_names, $
  ;             cont_lbl, cont_thick, cont_lines_col, $
  ;             txt_thick, txt_size, $
  ;             min_val, $
  ;             col_table=col_table, $
  ;             verbose=verbose

  ; The list of things the routine should set are:
  ; AND it is best to do them in this order
  ; (1)  contours
  ; SET: nconts
  ; Default: conts=default_contours(plot_array, min_val, nconts)
  ; (2)  colour contours
  ; Default: coconts=default_contours(plot_array, min_val, ncoconts)
  ; SET: ncoconts
  ; (3)  colour table  
  ; SET: col_table (optional, unset=BW)
  ; Default: load_colour_table, col_table=col_table
  ; TYPES in ccoltbl_list.pro
  ; (4)  colour scale
  ; SET: ncoconts (as 2)
  ; Default: coscale=default_coscale(ncoconts)
  ; (5)  thickness of contours 
  ; (6)  which contours are labeled 
  ; (7)  what colour are contour lines
  ; SET: nconts (as 1)
  ; Default: default_plot_contour_format, nconts,$
  ; cont_thick, cont_lbl, cont_lines_col
  ; (8)  names for colour bar
  ; SET: nbar_names and ncoconts, coconts, from 2.
  ; Default:
  ; bar_names=default_bar_names(nbar_names, ncoconts, coconts, coscale)
  ; (9)  thickness of text
  ; (10) size of text
  ; Default: default_plot_txt, txt_thick, txt_size

  ; To add a setup of contours etc
  ; increment this number
  nccont=43
  ; Array to hold the name, and the 
  ; routine call.
  ccont_name=safe_alloc_arr(1, nccont, /string_arr)
  ccont_call=safe_alloc_arr(1, nccont, /string_arr)
  ; Initialise a counter (to aid adding values)
  count=0

  ccont_name(count)='wind'
  ccont_call(count)='ccont_wind, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='temperature'
  ccont_call(count)='ccont_temperature, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hs_benchmark_temp'
  ccont_call(count)='ccont_hs_benchmark_temp, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hs_benchmark_uvel'
  ccont_call(count)='ccont_hs_benchmark_uvel, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='el_benchmark_temp'
  ccont_call(count)='ccont_el_benchmark_temp, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='el_benchmark_uvel'
  ccont_call(count)='ccont_el_benchmark_uvel, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='tle_benchmark_temp_slice'
  ccont_call(count)='ccont_tle_benchmark_temp_slice, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='tle_benchmark_wind_slice'
  ccont_call(count)='ccont_tle_benchmark_wind_slice, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='shj_benchmark_temp_mean'
  ccont_call(count)='ccont_shj_benchmark_temp_mean, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='shj_benchmark_temp_slice'
  ccont_call(count)='ccont_shj_benchmark_temp_slice, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='shj_benchmark_uvel'
  ccont_call(count)='ccont_shj_benchmark_uvel, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_benchmark_temp'
  ccont_call(count)='ccont_hd209458b_benchmark_temp, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_benchmark_uvel'
  ccont_call(count)='ccont_hd209458b_benchmark_uvel, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_benchmark_slice_213'
  ccont_call(count)='ccont_hd209458b_benchmark_slice_213, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_benchmark_slice_21600'
  ccont_call(count)='ccont_hd209458b_benchmark_slice_21600, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_benchmark_slice_4.69e5'
  ccont_call(count)='ccont_hd209458b_benchmark_slice_4_69e5, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_benchmark_slice_21.9e5'
  ccont_call(count)='ccont_hd209458b_benchmark_slice_21_9e5, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1
  
  ccont_name(count)='hd209458b_rt'
  ccont_call(count)='ccont_hd209458b_rt, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='hd209458b_logke'
  ccont_call(count)='ccont_hd209458b_logke, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='ageair'
  ccont_call(count)='ccont_ageair, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='std_hj_uvel'
  ccont_call(count)='ccont_std_hj_uvel, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='std_hj_lin_mmtm_low'
  ccont_call(count)='ccont_std_hj_lin_mmtm_low, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='std_hj_lin_mmtm_high'
  ccont_call(count)='ccont_std_hj_lin_mmtm_high, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='std_hj_isobaric_slice'
  ccont_call(count)='ccont_std_hj_isobaric_slice, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='std_hj_logke'
  ccont_call(count)='ccont_std_hj_logke, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='std_hj_eddy'
  ccont_call(count)='ccont_std_hj_eddy, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='order_mag_scaled'
  ccont_call(count)='ccont_order_mag_scaled, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214'
  ccont_call(count)='ccont_gj1214, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214_temp'
  ccont_call(count)='ccont_gj1214_temp, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1  

  ccont_name(count)='gj1214_wind'
  ccont_call(count)='ccont_gj1214_wind, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='mole_fraction'
  ccont_call(count)='ccont_mole_fraction, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214b_uvel_bar_500'
  ccont_call(count)='ccont_gj1214b_uvel_bar_500, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1
  
  ccont_name(count)='gj1214b_uvel_bar_1000'
  ccont_call(count)='ccont_gj1214b_uvel_bar_1000, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214b_uvel_bar_2000'
  ccont_call(count)='ccont_gj1214b_uvel_bar_2000, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

    ccont_name(count)='gj1214brt_uvel_bar_2000'
  ccont_call(count)='ccont_gj1214brt_uvel_bar_2000, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214b_uvel_rt_2000'
  ccont_call(count)='ccont_gj1214b_uvel_rt_2000, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214b_uvel_bar_3000'
  ccont_call(count)='ccont_gj1214b_uvel_bar_3000, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1

  ccont_name(count)='gj1214b_temperature'
  ccont_call(count)='ccont_gj1214b_temperature, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1  
  
  ccont_name(count)='gj1214b_temperature_100pa'
  ccont_call(count)='ccont_gj1214b_temperature_100pa, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1  
  
  ccont_name(count)='gj1214b_temperature_3000pa'
  ccont_call(count)='ccont_gj1214b_temperature_3000pa, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1
  
  ccont_name(count)='gj1214brt_temperature_100pa'
  ccont_call(count)='ccont_gj1214brt_temperature_100pa, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1  
  
  ccont_name(count)='gj1214brt_temperature_3000pa'
  ccont_call(count)='ccont_gj1214brt_temperature_3000pa, plot_array, nconts, conts, ncoconts, coconts, coscale, nbar_names, bar_names, cont_lbl, cont_thick, cont_lines_col, txt_thick, txt_size, min_val, col_table=col_table, colscale_setup=colscale_setup, verbose=verbose'
  count=count+1  
  
  ; Use this template to add another
  ; increment nccont
  ;ccont_name(count)=''
  ;ccont_call(count)='ccont_'
  ;count=count+1

end

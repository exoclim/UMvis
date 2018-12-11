pro construct_plot, variable_list, nvars, which_var_arr, $
                    plot_array, xaxis, yaxis, $
                    title, xtitle, ytitle, $
                    plot_fname, $
                    type_of_plot_var, $
                    min_val, $
                    plot_data_fname=plot_data_fname, $
                    contour_setup=contour_setup, $
                    nconts_ovrd=nconts_ovrd,$
                    conts_ovrd=conts_ovrd,$
                    ncoconts_ovrd=ncoconts_ovrd, $
                    coconts_ovrd=coconts_ovrd, $
                    coscale_ovrd=coscale_ovrd, $
                    col_table=col_table, $
                    colscale_setup=colscale_setup, $
                    nbar_names_ovrd=nbar_names_ovrd, $
                    bar_names_ovrd=bar_names_ovrd, $
                    cont_lbl_ovrd=cont_lbl_ovrd, $
                    cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                    txt_thick_ovrd=txt_thick_ovrd, $
                    txt_size_ovrd=txt_size_ovrd, $
                    cont_thick_ovrd=cont_thick_ovrd, $
                    cont_lines_col_ovrd=cont_lines_col_ovrd, $
                    vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
                    vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
                    missing_vect_ovrd=missing_vect_ovrd, $
                    projection=projection, $
                    proj_lon_ctr=proj_lon_ctr, $
                    proj_lat_ctr=proj_lat_ctr, $
                    plot_cbar=plot_cbar, $
                    ps=ps, xlog=xlog, ylog=ylog, $
                    verbose=verbose
  ; Routine to actually create the plot
  ; Check the plot requested consistency
  check_plot_req, variable_list, nvars, which_var_arr, $
                  plot_array, xaxis, yaxis, $
                  title, xtitle, ytitle, $
                  plot_fname, $
                  type_of_plot_var, $
                  min_val, $
                  contour_setup=contour_setup, $
                  nconts_ovrd=nconts_ovrd,$
                  conts_ovrd=conts_ovrd,$
                  ncoconts_ovrd=ncoconts_ovrd, $
                  coconts_ovrd=coconts_ovrd, $
                  coscale_ovrd=coscale_ovrd, $
                  col_table=col_table, $
                  colscale_setup=colscale_setup, $
                  nbar_names_ovrd=nbar_names_ovrd, $
                  bar_names_ovrd=bar_names_ovrd, $
                  cont_lbl_ovrd=cont_lbl_ovrd, $
                  cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                  txt_thick_ovrd=txt_thick_ovrd, $
                  txt_size_ovrd=txt_size_ovrd, $
                  cont_thick_ovrd=cont_thick_ovrd, $
                  cont_lines_col_ovrd=cont_lines_col_ovrd, $
                  vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
                  vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
                  missing_vect_ovrd=missing_vect_ovrd, $
                  projection=projection, $
                  proj_lon_ctr=proj_lon_ctr, $
                  proj_lat_ctr=proj_lat_ctr, $
                  plot_cbar=plot_cbar, $
                  ps=ps, xlog=xlog, ylog=ylog, $
                  verbose=verbose

  ; Setup the plot ancilliaries, such as contours
  ; colour scales, label sizes etc
  setup_plot_format, plot_array, nconts, conts, ncoconts, coconts, $
                     coscale, nbar_names, bar_names, $
                     cont_lbl, cont_thick, cont_lines_col, $
                     txt_thick, txt_size, $
                     vect_arr_lgth, vect_arr_thin, $
                     missing_vect, $
                     min_val, $
                     nvars, type_of_plot_var, $
                     contour_setup=contour_setup, $
                     nconts_ovrd=nconts_ovrd,$
                     conts_ovrd=conts_ovrd,$
                     ncoconts_ovrd=ncoconts_ovrd, $
                     coconts_ovrd=coconts_ovrd, $
                     coscale_ovrd=coscale_ovrd, $
                     col_table=col_table, $
                     colscale_setup=colscale_setup, $
                     nbar_names_ovrd=nbar_names_ovrd, $
                     bar_names_ovrd=bar_names_ovrd, $
                     cont_lbl_ovrd=cont_lbl_ovrd, $
                     cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                     txt_thick_ovrd=txt_thick_ovrd, $
                     txt_size_ovrd=txt_size_ovrd, $
                     cont_thick_ovrd=cont_thick_ovrd, $
                     cont_lines_col_ovrd=cont_lines_col_ovrd, $
                     vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
                     vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
                     missing_vect_ovrd=missing_vect_ovrd, $
                     verbose=verbose
  ; Save the plotting output if required
  if (KEYWORD_SET(plot_data_fname)) then begin
     print, 'Saving plot arrays etc as: ', plot_data_fname
     ; This should be neatened up **wORK**
     save, plot_array, xaxis, yaxis, $
           title, xtitle, ytitle, $
           plot_fname, $
           nvars, type_of_plot_var, $
           nconts, conts, ncoconts, coconts, $
           coscale, nbar_names, bar_names, $
           cont_lbl, cont_thick, cont_lines_col, $
           txt_thick, txt_size, $
           vect_arr_lgth, vect_arr_thin, $
           missing_vect, $
           min_val, $           
           filename=plot_data_fname
  endif

  ; Create the plot itself
  create_plot, plot_array, xaxis, yaxis, $
               title, xtitle, ytitle, $
               plot_fname, $
               type_of_plot_var, $
               nconts, conts, ncoconts, coconts, $
               coscale, nbar_names, bar_names, $
               cont_lbl, cont_thick, cont_lines_col, $
               txt_thick, txt_size, $
               vect_arr_lgth, vect_arr_thin, $
               missing_vect, $
               min_val, $
               projection=projection, $
               proj_lon_ctr=proj_lon_ctr, $
               proj_lat_ctr=proj_lat_ctr, $
               plot_cbar=plot_cbar, $
               ps=ps, xlog=xlog, ylog=ylog, $
               verbose=verbose
end

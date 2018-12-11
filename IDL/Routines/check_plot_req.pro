pro check_plot_req, variable_list, nvars, which_var_arr, $
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

  ; this routine makes sure the options selected etc
  ; are consistent
  ; **WORK** this needs extras adding to it.
  ; Setup err tracker
  err=0
  err_msg=''

  ; Line plots do not have contours, colour bars etc.
  for ivar=0, nvars-1 do begin
     if (type_of_plot_var(ivar) eq 'Line') then begin
        if (KEYWORD_SET(projection)) then begin
           err=1
           err_msg=err_msg+ ' Projection incompatible with line plot'
        endif
        if (KEYWORD_SET(plot_cbar)) then begin
           err=1
           err_msg=err_msg+ ' Colour bar incompatible with line plot'
        endif
     endif
  endfor
    
  if (err eq 1) then begin
     print, 'There is a problem with the consistency'
     print, 'of plot settings (check_plot_req):'
     print, err_msg
     stop
  endif
end

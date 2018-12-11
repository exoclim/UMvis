pro setup_plot_format, plot_array, nconts, conts, ncoconts, coconts, $
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
  ; A procedure to setup all of the formatting, and
  ; supplementary details for a plot, most of which can
  ; be manually overriden (_ovrd_
  ; Setup the contours (colour and not)
  ; We only need to setup contours, and the 
  ; default texts etc once. We also need to check which
  ; plot_array is the contour one.
  n_cont_plots=0
  for ivar=0, nvars-1 do begin
     ; Get the sort of plot (i.e. Vector_1, must be Vector etc)
     temp=STRSPLIT(type_of_plot_var(ivar),/EXTRACT,COUNT=ncomp,'_')
     if (ncomp gt 1) then begin
        plot_type=temp(0)
     endif else begin
        plot_type=temp
     endelse
     if (plot_type eq 'Contour') then begin
        icont=ivar
        n_cont_plots=n_cont_plots+1
     endif
  endfor

  if (n_cont_plots gt 1) then begin
     print, 'Currently can only handle one contour plot'
     print, 'as the contours themselves need to be made'
     print, 'into an array etc'
     print, 'Stopping in setup_plot_format'
     stop
  endif

  ; Now setup contours with the plot_array for the 
  ; contour plot.
  if (n_cont_plots gt 0) then begin
     set_contours_format, plot_array(icont,*,*),$
                          nconts, conts, ncoconts, coconts, $
                          coscale, nbar_names, bar_names, $
                          cont_lbl, cont_thick, cont_lines_col, $
                          txt_thick, txt_size, $
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
                          verbose=verbose
  endif else begin
     ; Otherwise zero the contour counts
     nconts=0
     ncoconts=0
     conts=0
     coconts=0
     coscale=0
     nbar_names=0
     bar_names=0
     cont_lbl=0
     cont_thick=0
     cont_lines_col=0
     ; Setup labelling
     default_plot_txt, txt_thick, txt_size
     ; Override if required
     ; How thick is the text
     if (KEYWORD_SET(txt_thick_ovrd)) then $
        txt_thick=txt_thick_ovrd
     if (KEYWORD_SET(txt_size_ovrd)) then $
        txt_size=txt_size_ovrd
  endelse
  
  ; Set the vector plotting
  set_vectors, vect_arr_lgth, vect_arr_thin, $
               missing_vect, $
               vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
               vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
               missing_vect_ovrd=missing_vect_ovrd, $
               verbose=verbose
end

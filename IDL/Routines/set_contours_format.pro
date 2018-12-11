pro set_contours_format, plot_array, nconts, conts, ncoconts, coconts, $
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
  ; See if we have selected some preset contours
  found=0
  if (KEYWORD_SET(contour_setup)) then begin
     ; Populate a list of contours settings calls
     ccont_list, nccont, ccont_name, ccont_call
     for icont=0, nccont-1 do begin
        if (contour_setup eq ccont_name(icont)) then begin
           found=1
           routine_call=ccont_call(icont)
        endif
     endfor
  endif
  if (found eq 1) then begin
     ; Setup preset contours etc
     if (KEYWORD_SET(verbose)) then $
        print, 'Loading preset contours using call:', $
               routine_call
     result=execute(routine_call)
  endif else begin
     if (KEYWORD_SET(verbose)) then $
        print, 'Constructing default contours'
     default_contours_format, plot_array, nconts, conts, ncoconts, coconts, $
                              coscale, nbar_names, bar_names, $
                              cont_lbl, cont_thick, cont_lines_col, $
                              txt_thick, txt_size, $
                              min_val, $
                              nconts_ovrd=nconts_ovrd,$
                              ncoconts_ovrd=ncoconts_ovrd,$
                              nbar_names_ovrd=nbar_names_ovrd, $
                              col_table=col_table, $
                              colscale_setup=colscale_setup, $
                              cont_lbl_ovrd=cont_lbl_ovrd, $
                              cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                              txt_thick_ovrd=txt_thick_ovrd, $
                              txt_size_ovrd=txt_size_ovrd, $
                              cont_thick_ovrd=cont_thick_ovrd, $
                              cont_lines_col_ovrd=cont_lines_col_ovrd, $
                              verbose=verbose     
  endelse

  ; Finally deal with overrides, we take precedence
  if (KEYWORD_SET(conts_ovrd)) then begin
     conts=conts_ovrd
     nconts=n_elements(conts)
  endif
  if (KEYWORD_SET(coconts_ovrd)) then begin
     coconts=coconts_ovrd
     ncoconts=n_elements(coconts)
  endif
  if (KEYWORD_SET(coscale_ovrd)) then begin
     coscale=coscale_ovrd
     ncoscale=n_elements(coconts)
     ; This should equal the number of 
     ; colour contours
     if (ncoconts ne ncoscale) then begin
        print, 'Error in number of override colour scale'
        print, 'Not the same as number of colour contours'
        stop        
     endif
     ncoconts=ncoscale
  endif
  if (KEYWORD_SET(bar_names_ovrd)) then begin
     bar_names=bar_names_ovrd
     nbar_names=n_elements(bar_names_ovrd)
  endif

  ; Now, if required, print out the levels used
  if (KEYWORD_SET(verbose)) then begin
     print, 'Using contours (n, values):', nconts, conts
     print, 'Using colour contours (n, values):', ncoconts, coconts
     print, 'Using colour scale (n, values):', ncoconts, coscale
     print, 'Using colour bar names (values):', bar_names
     print, 'Using contour labelling (1=yes, 0=no):', cont_lbl
     print, 'Using contours of thickness:', cont_thick
     print, 'Using contour colours:', cont_lines_col
     print, 'Using txt thickness:', txt_thick                     
  endif
end

pro set_plot_titles, planet_setup, vert_type, plot_grid_use, $
                     variable_list, $
                     xtitle, ytitle, title, $
                     plot_fname, $
                     which_var_arr, $
                     plot_name_ovrd=plot_name_ovrd, $
                     plot_title_ovrd=plot_title_ovrd,$
                     xtitle_ovrd=xtitle_ovrd, ytitle_ovrd=ytitle_ovrd, $
                     scale_x=scale_x, scale_y=scale_y, $
                     plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                     plot_dtime=plot_dtime, $
                     verbose=verbose
  ; This routine just creates the title, xtitle and ytitle
  ; for the plot, and file name
  ; Set the default plot title and file names
  default_name=planet_setup+'_'
  if (KEYWORD_SET(plot_eddy)) then begin
     add='eddy('+variable_list+')'
  endif else  if (KEYWORD_SET(plot_var_log)) then begin
     add='log('+variable_list+')'
  endif else if (KEYWORD_SET(plot_dtime)) then begin
     add='d('+variable_list+')_dt'
  endif else begin
     add=variable_list
  endelse
  default_name=default_name+add
  add=0
  title=default_name
  plot_fname=default_name+'.ps'
  default_name=0
  ; Now override the title or filename if requested
  if (KEYWORD_SET(plot_title_ovrd)) then begin
     if (plot_title_ovrd eq 'NO TITLE') then begin
        title=''
     endif else begin
        title=plot_title_ovrd
     endelse
  endif
  if (KEYWORD_SET(plot_name_ovrd)) then begin
     plot_fname=plot_name_ovrd+'.ps'
  endif
  ; We need to strip out the & for a file name
  temp_name=STRSPLIT(plot_fname,/EXTRACT,COUNT=ntemp, '&')
  plot_fname=''
  plot_fname=temp_name(0)
  for itemp=1, ntemp-1 do begin
     plot_fname=plot_fname+'_'+temp_name(itemp)
  endfor

  ; First do we have any scaling for the axes?
  ; Write out single significant figure scientific versions
  if (KEYWORD_SET(scale_x)) then begin
     cut_x=sigfig(scale_x,2)
     if (cut_x gt 100.0) then begin
        text_x=string(cut_x,format='(e9.1)')
     endif else begin
        text_x=string(cut_x)
     endelse
     scale_x_txt='x'+text_x
  endif else begin
     scale_x_txt=''
  endelse
  if (KEYWORD_SET(scale_y)) then begin
     cut_y=sigfig(scale_y,2)
     if (cut_y gt 100.0) then begin
        text_y=string(cut_y,format='(e9.1)')
     endif else begin
        text_y=string(cut_y)
     endelse
     scale_y_txt='x'+text_y
  endif else begin
     scale_y_txt=''
  endelse

  if (KEYWORD_SET(xtitle_ovrd)) then begin
     xtitle=xtitle_ovrd
  endif else begin
     ; Now construct the axes names
     if (plot_grid_use(0) eq 'x') then begin
        xtitle=cgsymbol('lambda')+'('+scale_x_txt+cgsymbol('deg')+')'
     endif
     if (plot_grid_use(1) eq 'x') then begin
        xtitle=cgsymbol('phi',/capital)+'('+scale_x_txt+cgsymbol('deg')+')'
     endif
     if (plot_grid_use(2) eq 'x') then begin
        xtitle=vert_type
        ; Set Units
        if (xtitle eq 'Sigma') then xtitle=scale_x_txt+cgsymbol('sigma')
        if (xtitle eq 'Pressure') then xtitle=xtitle+' ('+scale_x_txt+'Pa)'
        if (xtitle eq 'Height') then xtitle=xtitle+' ('+scale_x_txt+'m)'
     endif
     if (plot_grid_use(3) eq 'x') then begin
        xtitle='Time '+scale_x_txt+'(Days)'
     endif
  endelse

  if (KEYWORD_SET(ytitle_ovrd)) then begin
     ytitle=ytitle_ovrd
  endif else begin
     ; Assign Y axis title, accounting for
     ; line plots
     if (plot_grid_use(0) eq 'y') then begin
        ytitle=cgsymbol('lambda')+'('+scale_y_txt+cgsymbol('deg')+')'
     endif else if (plot_grid_use(1) eq 'y') then begin
        ytitle=cgsymbol('phi',/capital)+'('+scale_y_txt+cgsymbol('deg')+')'
        endif else if (plot_grid_use(2) eq 'y') then begin
        ytitle=vert_type
        ; Set Units
        if (ytitle eq 'Sigma') then ytitle=scale_y_txt+cgsymbol('sigma')
        if (ytitle eq 'Pressure') then ytitle=ytitle+' ('+scale_y_txt+'Pa)'
        if (ytitle eq 'Height') then ytitle=ytitle+' ('+scale_y_txt+'m)'
     endif else begin
        ; Deal with single line plot
        if (KEYWORD_SET(plot_eddy)) then begin
           ytitle='eddy('+which_var_arr+')'
        endif else  if (KEYWORD_SET(plot_var_log)) then begin
           ytitle='log('+which_var_arr+')'
        endif else if (KEYWORD_SET(plot_dtime)) then begin
           ytitle='d('+which_var_arr+')_dt'
        endif else begin
           ytitle=which_var_arr
        endelse
     endelse
     if (plot_grid_use(3) eq 'y') then begin
        ytitle='Time ('+scale_y_txt+'Days)'
     endif  
  endelse

  ; Remove White Space from Axes Labels
  xtitle=STRCOMPRESS(xtitle,/remove_all)
  ytitle=STRCOMPRESS(ytitle,/remove_all)


  if (KEYWORD_SET(verbose)) then begin
     print, 'Using plot title:', title
     print, 'Using xtitle:', xtitle
     print, 'Using ytitle:', ytitle
     print, 'Using plot file name:', plot_fname
  endif
end

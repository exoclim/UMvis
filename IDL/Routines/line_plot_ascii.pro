pro line_plot_ascii, fname, ixaxis, iyaxis, $
                     nheader, $
                     xrange=xrange, $
                     yrange=yrange, $
                     xconv=xconv, $
                     yconv=yconv, $
                     plot_fname_in=plot_fname_in, ps=ps, $
                     delim=delim, $
                     xtitle=xtitle, ytitle=ytitle, $
                     title=title, $
                     xlog=xlog, ylog=ylog, $
                     yrev=yrev, $
                     linestyle=linestyle, $  
                     color=color, $
                     overplot=overplot, $
                     isotropic=isotropic, $
                     relative_initial=relative_initial, $
                     relative_value=relative_value, $
                     nskip=nskip
                     
  ; This simple routine just creates a simple line plot
  ; from a file, given the columns of the file to read, and
  ; names for the axes, and output plot (as well as the number
  ; of header lines to skip).
  ; WARNING the columns numbers are 1, 2, 3 etc (i.e. not 0, 1)
  ; To create a multi version call this with /ps on the first
  ; and /overplot on the subsequent (oh and change linestyle)

  ; First setup which delimeter to use
  if (KEYWORD_SET(delim)) then begin
     delimiter=delim
  endif else begin
     delimiter=' '
  endelse

  ; Are we converting the X/Y axis
  if (KEYWORD_SET(xconv)) then begin
     xfactor=xconv
  endif else begin
     xfactor=1.0
  endelse
  if (KEYWORD_SET(yconv)) then begin
     yfactor=yconv
  endif else begin
     yfactor=1.0
  endelse

  ; If we are using ps file we need to make
  ; sure a file name is selected.
  plot_fname=''
  if (KEYWORD_SET(ps)) then begin
     ; What is the file name if require
     if (KEYWORD_SET(plot_fname_in)) then begin
        plot_fname=plot_fname_in+'.ps'
        print, 'Creating .ps file: ', plot_fname
     endif else begin
        print, 'Require a name for ps file'
        print, 'ps_fname_in'
        stop        
     endelse
  endif
  
  ; Open the file
  openr, lun, fname, /get_lun
  ; Define a string to read the lines
  line='' 
  ; Skip the header
  for ihead=0, nheader-1 do begin
     readf, lun, line
  endfor
  ; Count the lines (need long integers as large numbers!)
  ndata=ULONG(0)
  count=ULONG(0)
  while not EOF(lun) do begin
     readf, lun, line
     ; Are we skipping entries?
     if (KEYWORD_SET(nskip)) then begin
        ; Only count if we have skipped nskip entries
        if (count eq nskip) then begin
            ndata=ndata+1
            count=ULONG(0)
         endif else begin
            count=count+1
         endelse            
     endif else begin
        ; count as normal
        ndata=ndata+1
     endelse        
  endwhile
  if (ndata eq 0) then begin
     print, 'Did not record any data from file: ', $
            fname
     print, 'Either no data contained, skipped too many'
     print, 'entries'
     if (KEYWORD_SET(nskip)) then print, 'Counting every: ', nskip, $
                                         'th entry'
     stop
  endif else begin
     print, 'Counted: ', ndata, ' entries in: ', fname
     if (KEYWORD_SET(nskip)) then print, 'Counting every: ', nskip, $
                                         'th entry'
  endelse
  ; Close and reopen the file
  free_lun, lun
  openr, lun, fname, /get_lun
  ; Define output
  plot_array=FLTARR(ndata)
  xaxis=FLTARR(ndata)
  plot_array(*)=0
  xaxis(*)=0
  ; Reset the counter
  ndata=ULONG(0)
  ; Skip the header
  for ihead=0, nheader-1 do begin
     readf, lun, line
  endfor
  ; Now read in the data
  count=ULONG(0)
  while not EOF(lun) do begin
     readf, lun, line
     ; Only read if if we are not skipping
     if (KEYWORD_SET(nskip)) then begin
        ; Only read if we have skipped nskip entries
        if (count eq nskip) then begin
            ndata=ndata+1
            count=ULONG(0)
           ; Split the line by the delimiter
            line_array=STRSPLIT(line, $
                                /RegEx, /EXTRACT, COUNT=ncols,$
                                delimiter)
            ; Store the data from the required entry
            plot_array(ndata-1)=yfactor*line_array[iyaxis-1]
            xaxis(ndata-1)=xfactor*line_array[ixaxis-1]
         endif else begin
            count=count+1
         endelse            
      endif else begin
         ; read as normal
         ndata=ndata+1
         ; Split the line by the delimiter
         line_array=STRSPLIT(line, $
                             /RegEx, /EXTRACT, COUNT=ncols,$
                             delimiter)
         ; Store the data from the required entry
         plot_array(ndata-1)=yfactor*line_array[iyaxis-1]
         xaxis(ndata-1)=xfactor*line_array[ixaxis-1]
      endelse        
  endwhile
  ; Are we doing a relative plot 
  if (KEYWORD_SET(relative_initial)) then $
     plot_array(*)=plot_array(*)/plot_array(0)
  if (KEYWORD_SET(relative_value)) then $
     plot_array(*)=plot_array(*)/relative_value

  ; Close file and free unit number
  free_lun, lun
  ; Setup the range
  if (not (KEYWORD_SET(yrange))) then begin
     yrange=FLTARR(2)
     if (KEYWORD_SET(yrev)) then begin
        yrange(1)=min(plot_array)
        yrange(0)=max(plot_array)
     endif else begin
        yrange(0)=min(plot_array)
        yrange(1)=max(plot_array)
     endelse
  endif
  ; Setup a plot output window, file
  window_num=1
  if (not (KEYWORD_SET(overplot))) then begin
     start_plot, plot_fname, window_num, ps=ps 
     if (KEYWORD_SET(color)) then begin
        loadct, 5
        ; have to plot axes in default colour      
        plot, xaxis, plot_array(*), yrange=yrange, xrange=xrange, $
              title=title, xtitle=xtitle, ytitle=ytitle, $
              xlog=xlog, ylog=ylog, $
              linestyle=linestyle, $              
              color=0, background=255, $
              isotropic=isotropic, /YNOZERO, /nodata
        oplot, xaxis, plot_array(*), linestyle=linestyle, $
               color=color
     endif else begin
        plot, xaxis, plot_array(*), yrange=yrange, xrange=xrange, $
              title=title, xtitle=xtitle, ytitle=ytitle, $
              xlog=xlog, ylog=ylog, $
              linestyle=linestyle, $
              isotropic=isotropic, /YNOZERO
     endelse     
  endif else begin
     oplot, xaxis, plot_array(*), linestyle=linestyle, $
            color=color
  endelse
end

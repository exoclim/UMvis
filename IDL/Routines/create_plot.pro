pro create_plot, plot_array, xaxis, yaxis, $
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
  ; A procedure to actually create a plot
  ; Start a plotting windo if the first run
  window_num=1
  start_plot, plot_fname, window_num, ps=ps 
  ; Set up some sizes and ranges
  plot_size=size(plot_array)
  if (plot_size(0) ne 3) then begin
     print, 'Error in size of input plotting array'
     print, 'Expecting 3 dimensions (nvariables, nx, ny)'
     print, 'Got:', plot_size(0)
     print, 'Stoppping in create_plot.pro'
     stop
  endif
  nvar=plot_size(1)
  nx=n_elements(xaxis)
  ny=n_elements(yaxis)
  xrange=[xaxis(0),xaxis(nx-1)]
  yrange=[yaxis(0),yaxis(ny-1)]
  ; Set a default character size for axes labelling
  axes_size=txt_size+1.0
  if (KEYWORD_SET(verbose)) then begin
     print, 'Using an axes labelling character size of:', axes_size
     print, 'with contour etc, sizes as:', txt_size
     print, 'In routine create_plot.pro'
  endif

  ; If it is a projection we must setup the 
  ; mapping details
  extra_call=''
  if (KEYWORD_SET(projection)) then begin
     ; We need to add /overplot
     ; to the plotting calls
     extra_call=', /overplot'
     if (KEYWORD_SET(proj_lon_ctr)) then begin
        longitude_cen=proj_lon_ctr
     endif else begin
        longitude_cen=0.0
     endelse
     if (KEYWORD_SET(proj_lat_ctr)) then begin
        latitude_cen=proj_lat_ctr
     endif else begin
        latitude_cen=0.0
     endelse
     ; List of projections:, /AITOFF | , /ALBERS | , /AZIMUTHAL | ,
     ; /CONIC | , /CYLINDRICAL | , /GNOMIC | , /GOODESHOMOLOSINE | ,
     ; /HAMMER | , /LAMBERT | , /MERCATOR | , /MILLER_CYLINDRICAL | ,
     ; /MOLLWEIDE | , /ORTHOGRAPHIC | , /ROBINSON | , /SATELLITE | ,
     ; /SINUSOIDAL | , /STEREOGRAPHIC | , /TRANSVERSE_MERCATOR
     if (projection eq 'SATELLITE') then begin
        ; This is a really useful projection for showing the pole.
        map_set, latitude_cen, longitude_cen, /SATELLITE,/noer,/iso,$
                 xmargin=5, ymargin=5, sat_p=[1.04,0,0], /NoBorder 
     endif else if (projection eq 'ORTHOGRAPHIC') then begin
        map_set, latitude_cen, longitude_cen, /ORTHOGRAPHIC,/noer,/iso,$
                 xmargin=5, ymargin=5, /NoBorder
     endif else begin
        print, 'Projection type:', projection
        print, 'Either not setup or unavailable'
        print, 'stopping in create_plot.pro'
        stop
     endelse
     ; Plot the grid
     map_grid, charsize=1.5, latdel=20,$
               londel=30,$                 
               /no_grid,/label,/noerase,$
               clip_text=0, COLOR=!P.Color,latlab=longitude_cen-10,$
               lonlab=-2
  endif

  ; A few messages
  if (KEYWORD_SET(verbose)) then begin
     if (KEYWORD_SET(ps)) then $
        print, 'plotting postcript'
     if (KEYWORD_SET(xlog)) then $
        print, 'X-axis is logarithmic'
     if (KEYWORD_SET(ylog)) then $
        print, 'Y-axis is logarithmic'
     if (KEYWORD_SET(plot_cbar)) then $
        print, 'Adding colour bar'
     print, 'Using plot name:', $
            plot_fname        
  endif

  ; Fix the colours if we are using colour
  ; Not sure what this does, or if it is required
  if (ncoconts gt 0) then begin
     device, decomposed=0
  endif

  ; Loop over each plot elemenent and plot it 
  ; differently according to type
  ; Start a counter for vectors
  vect_count=0      
  for ivar=0, nvar-1 do begin
     ; Setup the plot type, in case it is a vector
     temp=STRSPLIT(type_of_plot_var(ivar),/EXTRACT,COUNT=ncomp,'_')
     if (ncomp gt 1) then begin
        plot_type=temp(0)
     endif else begin
        plot_type=temp
     endelse
     if (plot_type eq 'Line') then begin
        ; Start plot for first element
        if (ivar eq 0) then begin
           if (KEYWORD_SET(verbose)) then begin
              ; Print min/max
              print, 'Plotting Variable: ', ivar, ' with Min/Max: ', $
                     min(plot_array(ivar,*,0)), max(plot_array(ivar,*,0))
           endif
           plot_string='plot, xaxis, plot_array(ivar,*,0), yrange=yrange, title=title, xtitle=xtitle, ytitle=ytitle, xlog=xlog, ylog=ylog, isotropic=isotropic, charsize=axes_size, /YNOZERO'+extra_call
           result=execute(plot_string)
        endif else begin
           ; plot next entry
           iline=ivar
           ; Only 6 line styles (0-5)
           if (iline gt 5) then begin
              iline=iline-5
              if (KEYWORD_SET(verbose)) then $
                 print, 'Run out of linestyles, starting from zero'
           endif
           if (KEYWORD_SET(verbose)) then begin
              ; Print min/max
              print, 'Plotting Variable: ', ivar, ' with Min/Max: ', $
                     min(plot_array(ivar,*,0)), max(plot_array(ivar,*,0))
           endif
           plot_string='oplot, xaxis, plot_array(ivar,*,0),linestyle=iline'+extra_call
           result=execute(plot_string)
        endelse
     endif else if (plot_type eq 'Contour') then begin
        ; Contour plot
        ; Is this the first one?
        if (ivar eq 0) then begin
           ; If this is colour plot the colour information
           if (ncoconts gt 0) then begin
              plot_string='contour, plot_array(ivar,*,*), xaxis, yaxis, xrange=xrange, yrange=yrange, min_value=min_val, charsize=axes_size, levels=coconts, c_label=cont_lbl, c_thick=cont_thick, c_colors=coscale, title=title, xtitle=xtitle, ytitle=ytitle, xstyle=1, ystyle=1, c_linestyle=(coconts lt 0.000000), c_charsize=txt_size, c_charthick=txt_thick, xlog=xlog, ylog=ylog, /follow, /cell_fill, /noerase'+extra_call
              result=execute(plot_string)
           endif
           if (KEYWORD_SET(verbose)) then begin
              ; Print min/max
              print, 'Plotting Variable: ', ivar, ' with Min/Max: ', $
                     min(plot_array(ivar,*,*)), max(plot_array(ivar,*,*))
           endif
           plot_string='contour, plot_array(ivar,*,*), xaxis, yaxis, xrange=xrange, yrange=yrange, min_value=min_val, charsize=axes_size, levels=conts, c_label=cont_lbl, c_thick=cont_thick, c_colors=cont_lines_col, title=title, xtitle=xtitle, ytitle=ytitle, xstyle=1, ystyle=1, c_linestyle=(conts lt 0.000000), c_charsize=txt_size, c_charthick=txt_thick, xlog=xlog, ylog=ylog, /follow, /noerase'+extra_call
           result=execute(plot_string)
        endif else begin
           ; If this is colour plot the colour information
           if (ncoconts gt 0) then begin
              plot_string='contour, plot_array(ivar,*,*), xaxis, yaxis, xrange=xrange, yrange=yrange, min_value=min_val, charsize=axes_size, levels=coconts, c_label=cont_lbl, c_thick=cont_thick, c_colors=coscale, title=title, xtitle=xtitle, ytitle=ytitle, xstyle=1, ystyle=1, c_linestyle=(coconts lt 0.000000), c_charsize=txt_size, c_charthick=txt_thick, xlog=xlog, ylog=ylog, /follow, /cell_fill, /noerase'+extra_call
              result=execute(plot_string)
           endif
           ; If a subsequent plot we just plot the same calls
           if (KEYWORD_SET(verbose)) then begin
              ; Print min/max
              print, 'Plotting Variable: ', ivar, ' with Min/Max: ', $
                     min(plot_array(ivar,*,*)), max(plot_array(ivar,*,*))
           endif
           plot_string='contour, plot_array(ivar,*,*), xaxis, yaxis, xrange=xrange, yrange=yrange, min_value=min_val, charsize=axes_size, levels=conts, c_label=cont_lbl, c_thick=cont_thick, c_colors=cont_lines_col, title=title, xtitle=xtitle, ytitle=ytitle, xstyle=1, ystyle=1, c_linestyle=(conts lt 0.000000), c_charsize=txt_size, c_charthick=txt_thick, xlog=xlog, ylog=ylog, /follow, /noerase'+extra_call
           result=execute(plot_string)
        endelse
     endif else if (plot_type eq 'Vector') then begin      
        ; We need to count the vectors for the plot
        if (vect_count eq 0) then begin
           vec_size=INTARR(2)
           vec_size(0)=nx
           vec_size(1)=ny
           vector_1=safe_alloc_arr(2, vec_size, /float_arr)
           vector_1(*,*)=plot_array(ivar,*,*)
           vector_1=thin_vectors(vector_1, $
                                 nx, ny, vect_arr_thin,$
                                 missing_vect)
           vect_count=vect_count+1
        endif else if (vect_count eq 1) then begin
           ; If this is the second component in a vector
           ; plot it, and zero the counter
           vec_size=INTARR(2)
           vec_size(0)=nx
           vec_size(1)=ny
           vector_2=safe_alloc_arr(2, vec_size, /float_arr)
           vector_2(*,*)=plot_array(ivar,*,*)
           vector_2=thin_vectors(vector_2, $
                                 nx, ny, vect_arr_thin,$
                                 missing_vect)
           ; Is it the first plot?
           if (KEYWORD_SET(verbose)) then begin
              ; Print min/max
              print, 'Plotting Vector: ', vect_count, ' with Min/Max magnitude: ', $
                     min(sqrt(plot_array(ivar,*,*)^2.0+plot_array(ivar,*,*)^2.0)), $
                     max(sqrt(plot_array(ivar,*,*)^2.0+plot_array(ivar,*,*)^2.0))
           endif
           plot_string='velovect, vector_1, vector_2, xaxis, yaxis, length=vect_arr_lgth, xrange=xrange, yrange=yrange, missing=missing_vect, title=title, xtitle=xtitle, ytitle=ytitle, xstyle=1, ystyle=1, xlog=xlog, ylog=ylog, charsize=axes_size, nsum=1000.0, /follow, /noerase'+extra_call
           result=execute(plot_string)
           ; Rezero vector count
           vect_count=0
        endif
     endif
  endfor
  ; Add in a colour bar if requested
  if (KEYWORD_SET(plot_cbar)) then begin
     if (KEYWORD_SET(projection)) then begin
        colorbar, position=[0.15, 0.92, 0.85, 0.96], $
                  /top,$
                  charsize=txt_size, $
                  
                  divisions=nbar_names-1, $
                  ticknames=bar_names
     endif else begin
        ; The contours need to change depending on the values
; Previous settings colorbar, position=[0.1, 0.93, 0.95, 0.97],$
        colorbar, position=[0.1, 0.92, 0.94, 0.95],$
                  range=range, $
                  /top,$
                  charsize=txt_size, $
                  divisions=nbar_names-1, $
                  ticknames=bar_names
     endelse
  endif
end

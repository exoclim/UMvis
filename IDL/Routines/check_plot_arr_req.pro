pro check_plot_arr_req, vert_type, $
                        plot_grid_use_in=plot_grid_use_in, $
                        plot_grid_use, $
                        plot_limits_in=plot_limits_in, $
                        plot_limits, $
                        lon, lat, vert, $
                        time, $  
                        verbose=verbose
  ; Performs a few consistency checks for the
  ; requsted plot.
  ; **WORK** This should be continually updated
  ; Err flag
  err=0
  ; Err Message
  err_msg='check_plot_req.pro-Error:'
  ; Can't make a plot unless axes selected
  if (NOT(KEYWORD_SET(plot_grid_use_in))) then begin
     print, 'To make a plot you must select the axes etc'
     print, 'plot_grid_use_in, must be defined and filled'
     print, 'check_plot_arr_req'
     stop
  endif else begin
     plot_grid_use=plot_grid_use_in
  endelse
  ; Setup defaults for plot_limits
  if (KEYWORD_SET(plot_limits_in)) then begin
     plot_limits=plot_limits_in
  endif else begin
     plot_limits=STRARR(4,2)
     plot_limits(*,0)='min'
     plot_limits(*,1)='max'
  endelse

  ; Number of x-axis and y
  nx=0
  ny=0
  ; vert_type
  if (vert_type ne 'Height' and vert_type ne 'Pressure' and $
      vert_type ne 'Sigma') then begin
     err=1
     err_msg=err_msg+' vert_type not found'
  endif
  for idim=0, 3 do begin     
     ; plot_grid_use
     ; Is each field assigned a string
     ; is it blank?
     if (plot_grid_use(idim) eq '') then begin
        err=1
        err_msg=err_msg+' plot_grid_use has null entry'        
        ; Is it a standard use?
     endif else if (plot_grid_use(idim) ne 'mean' and $
                    plot_grid_use(idim) ne 'sum' and $
                    plot_grid_use(idim) ne 'min' and $
                    plot_grid_use(idim) ne 'max' and $
                    plot_grid_use(idim) ne 'x' and $
                    plot_grid_use(idim) ne 'y') then begin
        number_test=valid_num(plot_grid_use(idim))
        if (number_test eq 0) then begin
           err=1
           err_msg=err_msg+' plot_grid_use value not valid'
        endif else begin
           ; Otherwise is within the grid bounds
           if (idim eq 0) then begin
              if (float(plot_grid_use(idim)) lt min(lon) or $
                  float(plot_grid_use(idim)) gt max(lon)) then begin
                 err=1
                 err_msg=err_msg+' plot_grid_use, longitude requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(lon))+'-'+string(max(lon))
              endif
           endif else if (idim eq 1) then begin
              if (float(plot_grid_use(idim)) lt min(lat) or $
                  float(plot_grid_use(idim)) gt max(lat)) then begin
                 err=1
                 err_msg=err_msg+' plot_grid_use, latitude requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(lat))+'-'+string(max(lat))
              endif
           endif else if (idim eq 2) then begin
              if (float(plot_grid_use(idim)) lt min(vert) or $
                  float(plot_grid_use(idim)) gt max(vert)) then begin
                 err=1
                 err_msg=err_msg+' plot_grid_use, vertical coordinate requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(vert))+'-'+string(max(vert))
              endif
           endif else if (idim eq 3) then begin
              if (float(plot_grid_use(idim)) lt min(time) or $
                  float(plot_grid_use(idim)) gt max(time)) then begin
                 err=1
                 err_msg=err_msg+' plot_grid_use, time requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(time))+'-'+string(max(time))
              endif
           endif
        endelse
     endif
     ; Plot_limits
     if (plot_limits(idim,0) eq 'min' and plot_limits(idim,1) eq 'min') then begin
        print, 'Have selected a range from: ', plot_limits(idim,0), ' to ', plot_limits(idim,1)
        print, 'Does not compute!'
        stop
     endif else if (plot_limits(idim,0) eq 'max' and plot_limits(idim,1) eq 'max') then begin
        print, 'Have selected a range from: ', plot_limits(idim,0), ' to ', plot_limits(idim,1)
        print, 'Does not compute!'
        stop
     endif
     for i=0, 1 do begin        
        if (plot_limits(idim,i) ne 'min' and $
            plot_limits(idim,i) ne 'max') then begin           
           number_test=valid_num(plot_limits(idim,i))
           ; Is it a valid number
           if (number_test eq 0) then begin
              err=1
              err_msg=err_msg+' plot_limits value not valid'
           endif else begin
              ; Or is it in the bounds of the grid.
              if (idim eq 0) then begin
                 if (float(plot_limits(idim,i)) lt min(lon) or $
                     float(plot_limits(idim,i)) gt max(lon)) then begin
                 err=1
                 err_msg=err_msg+' plot_limits, longitude requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(lon))+'-'+string(max(lon))
              endif
              endif else if (idim eq 1) then begin
                 if (float(plot_limits(idim,i)) lt min(lat) or $
                     float(plot_limits(idim,i)) gt max(lat)) then begin
                    err=1
                    err_msg=err_msg+' plot_limits, latitude requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(lat))+'-'+string(max(lat))
                 endif
              endif else if (idim eq 2) then begin
                 if (float(plot_limits(idim,i)) lt min(vert) or $
                     float(plot_limits(idim,i)) gt max(vert)) then begin
                    err=1
                    err_msg=err_msg+' plot_limits, vertical coordinate requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(vert))+'-'+string(max(vert))
                 endif
              endif else if (idim eq 3) then begin
                 if (float(plot_limits(idim,i)) lt min(time) or $
                     float(plot_limits(idim,i)) gt max(time)) then begin
                    err=1
                    err_msg=err_msg+' plot_limits, time requested outside bounds (clever boundaries not coded yet)'+$
                         string(min(time))+'-'+string(max(time))
                 endif
              endif
           endelse
        endif
     endfor
     ; Finally quick check on number of axes
     if (plot_grid_use(idim) eq 'x') then nx=nx+1
     if (plot_grid_use(idim) eq 'y') then ny=ny+1
  endfor
  ; Do we have enough axes? Has to be at least 1 x axis, no more
  ; than one of each
  if (nx gt 1 or ny gt 1 or nx eq 0) then begin
     err=1
     err_msg=err_msg+' Incorrect number of axes selected'+' x:'$
             +string(nx)+' y:'+string(ny)
  endif

  if (err eq 1) then begin
     print, 'There is a problem with the consistency'
     print, 'of plot array settings (check_plot_arr_req):'
     print, err_msg
     stop
  endif
  ; Now we check the limits of the vertical
  if (vert_type eq 'Pressure' or vert_type eq 'Sigma') then begin
     if (plot_limits(2,0) ne 'min' and plot_limits(2,1) ne 'max') then begin
        if (plot_limits(2,0) gt plot_limits(2,1)) then begin
           print, 'Adopting vertical coordinate:', vert_type
           print, 'But min:', plot_limits(2,0), ' and max:', plot_limits(2,1)
           print, 'inconsistent-stop in check_plot_arr_req.pro'
           stop
        endif
     endif
  endif else if (vert_type eq 'Height') then begin
     if (plot_limits(2,0) ne 'min' and plot_limits(2,1) ne 'max') then begin
        if (plot_limits(2,0) gt plot_limits(2,1)) then begin
           print, 'Adopting vertical coordinate:', vert_type
           print, 'But min:', plot_limits(2,0), ' and max:', plot_limits(2,1)
           print, 'inconsistent-stop in check_plot_arr_req.pro'
           stop
        endif
     endif
  endif else begin
     print, 'Vert_type:', vert_type, ' not recognised'
     print, 'stop in check_plot_arr_req.pro'
     stop
  endelse
end

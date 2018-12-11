pro construct_plot_data, vert_type, plot_grid_use, $
                         variable_list, $
                         min_val, $
                         nvars, which_var_arr, $
                         var_array, grid_size, $
                         lon, lat, $
                         vert, time, $
                         plot_arr_size, $
                         plot_array, xaxis, yaxis, $
                         type_of_plot_var, $
                         scale_x=scale_x, scale_y=scale_y, $
                         plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                         plot_dtime=plot_dtime, $                      
                         verbose=verbose
  ; This procedure creates the plot array
  ; and also works out which type each plot is
  ; stored in type_of_plot_var

  ; The first task is to handle whether we are plotting an eddy,
  ; log or time derivative property
  for ivar=0, nvars-1 do begin
     if (KEYWORD_SET(plot_eddy)) then begin
        ; Derive the zonal eddy perturbation
        arr_size=INTARR(4)
        arr_size(0)=grid_size(0)
        arr_size(1)=grid_size(1)
        arr_size(2)=grid_size(2)
        arr_size(3)=grid_size(3)
        var_one=safe_alloc_arr(4, arr_size, /float_arr)
        var_one(*,*,*,*)=var_array(ivar,*,*,*,*)
        decomp_zonal_perturb, var_one, var_perturb,$
                              var_mean, min_val, /retain_size
        ; Replace variable and zero unrequired ones
        var_mean=0
        var_one=0
        var_array(ivar,*,*,*,*)=var_perturb(*,*,*,*)
        var_perturb=0        
     endif
     if (KEYWORD_SET(plot_var_log)) then begin
        var_array(ivar,*,*,*,*)=ALOG10(var_array(ivar,*,*,*,*))
     endif
     if (KEYWORD_SET(plot_dtime)) then begin
        if (grid_size(3) lt 3) then begin
           print, 'Not enough time points to perform'
           print, 'derivative.'
           print, 'Stopping in construct_plot_data.pro'
           stop
        endif
        ; Perform numerical derivative in time
        for ilon=0, grid_size(0)-1 do begin
           for ilat=0, grid_size(1)-1 do begin
              for ivert=0, grid_size(2)-1 do begin
                 ; Convert the time to seconds (from Earth days)
                 var_array(ivar, ilon, ilat, ivert, *)=$
                    deriv(time(*)*86400.0, $
                          var_array(ivar, ilon, ilat, ivert, *))
              endfor
           endfor
        endfor
     endif
  endfor

  ; Then find which are the x and y axis of the plot
  ndim=n_elements(grid_size)
  ; Default values are 1 (this allows line plots also)
  nx=1
  ny=1
  xcol=-1
  ycol=-1
  for idim=0, ndim-1 do begin
     if (plot_grid_use(idim) eq 'x') then begin
        nx=grid_size(idim)
        xcol=idim
        if (idim eq 0) then xaxis=lon
        if (idim eq 1) then xaxis=lat
        if (idim eq 2) then xaxis=vert
        if (idim eq 3) then xaxis=time
     endif
     if (plot_grid_use(idim) eq 'y') then begin
        ny=grid_size(idim)
        ycol=idim
        if (idim eq 0) then yaxis=lon
        if (idim eq 1) then yaxis=lat
        if (idim eq 2) then yaxis=vert
        if (idim eq 3) then yaxis=time
     endif
  endfor
  ; Quick sanity check
  if (xcol lt 0 and ycol lt 0) then begin
     print, 'Stop in construct_plot_data'
     print, 'array has neither an x or y column'
  endif
  arr_size=INTARR(3)
  arr_size(0)=nvars
  arr_size(1)=nx
  arr_size(2)=ny
  plot_array=safe_alloc_arr(3, arr_size, /float_arr)

  ; Now fill the array, for all variables
  ; The sizes should take care of themselves....
  for ivar=0, nvars-1 do begin
     for iy=0, ny-1 do begin    
        for ix=0, nx-1 do begin
           ; For line plots, no y is set
           if (ycol lt 0) then begin
              if (xcol eq 0) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,ix,*,*,*)
              if (xcol eq 1) then $                 
                 plot_array(ivar, ix, iy)=var_array(ivar,*,ix,*,*)
              if (xcol eq 2) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,*,ix,*)
              if (xcol eq 3) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,*,*,ix)
           endif else begin
              ; Otherwise it is a contour or vector quantity
              ; Need to cater for every combination of columns
              if (xcol eq 0 and ycol eq 1) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,ix,iy,*,*)
              if (xcol eq 0 and ycol eq 2) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,ix,*,iy,*)
              if (xcol eq 0 and ycol eq 3) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,ix,*,*,iy)
              if (xcol eq 1 and ycol eq 0) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,iy,ix,*,*)
              if (xcol eq 1 and ycol eq 2) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,ix,iy,*)
              if (xcol eq 1 and ycol eq 3) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,ix,*,iy)
              if (xcol eq 2 and ycol eq 0) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,iy,*,ix,*)
              if (xcol eq 2 and ycol eq 1) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,iy,ix,*)
              if (xcol eq 2 and ycol eq 3) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,*,ix,iy)
              if (xcol eq 3 and ycol eq 0) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,iy,*,*,ix)
              if (xcol eq 3 and ycol eq 1) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,iy,*,ix)
              if (xcol eq 3 and ycol eq 2) then $
                 plot_array(ivar, ix, iy)=var_array(ivar,*,*,iy,ix)
           endelse
           ; Clean any bad values
           if (plot_array(ivar,ix,iy) eq 'Inf' or $
               plot_array(ivar,ix,iy) eq '-Inf' or $
               plot_array(ivar,ix,iy) eq 'NaN' or $
               plot_array(ivar,ix,iy) eq '-NaN') then $
                  plot_array(ivar,ix,iy)=min_val               
        endfor
     endfor
  endfor

  ; Now we need to work out what sort of plot it is
  ; For line plots, all are simply a line
  type_of_plot_var=safe_alloc_arr(1, nvars, /string_arr)
  if (ycol lt 0 and xcol gt 0) then begin
     type_of_plot_var(*)='Line'
     ncomps=1
  endif else begin
     ; All others are either contours, or vectors,
     components=STRSPLIT(variable_list,/EXTRACT,COUNT=ncomps,'&')
     ; If the number of plot components matches the number of
     ; variables then all contours
     if (ncomps eq nvars) then begin
        type_of_plot_var(*)='Contour'
     endif else begin
        ; Now loop through and set variables
        ; to contours for singles and for vectors
        ; set each component to vector.        
        count=0
        vect_count=1
        for icomp=0, ncomps-1 do begin
           ; Is this variable a vector?
           cvar_vect_find, components(icomp), found, nvector_comps, $
                           vector_comp_var, var_tested, verbose=verbose
           if (found eq 1) then begin
              type_of_plot_var(count)='Vector'+'_'+string(vect_count)
              count=count+1
              ; Now set all the elements to vector
              for ivect=0, nvector_comps-2 do begin
                 type_of_plot_var(count)='Vector'+'_'+string(vect_count)
                 count=count+1                    
              endfor
              ; Move onto the next vector
              vect_count=vect_count+1
           endif else begin
              ; Otherwise is it a single variable?
              cvar_find, components(icomp), found, routine_call, var_tested, $
                         verbose=verbose
              if (found eq 1) then begin
                 type_of_plot_var(count)='Contour'
                 count=count+1
              endif else begin
                 print, 'Variable: ', components(icomp)
                 print, 'Not find in cvar_list or cvar_vector_list.pro'
                 print, 'Stopping in construct_plot_data'
                 stop                 
              endelse
           endelse
        endfor
     endelse
     ; Clean out white space
     for ivars=0, nvars-1 do begin
        type_of_plot_var(ivars)=strcompress(type_of_plot_var(ivars),/remove_all)
        if (KEYWORD_SET(verbose)) then $
           print, ivars,  ' Plot type: ', $
                  type_of_plot_var(ivars)
     endfor
  endelse
  if (KEYWORD_SET(verbose)) then begin
     print, 'Plotting number of variables:', nvars
     print, 'As number of plotting components:', ncomps
     print, 'From list:', variable_list
     print, 'Constructed using:', which_var_arr
     print, 'Requiring plot types:', type_of_plot_var
  endif

  ; Finally, if this is a line plot, we need a yrange/axis
  if (ycol lt 0 and xcol ge 0) then begin
     ; Find the range
     min_data=min(plot_array(where(plot_array gt min_val)))
     max_data=max(plot_array(where(plot_array gt min_val)))
     ; Choose a number of tickmarks
     ny=20
     ; Construct the axis
     yaxis=min_data+(max_data-min_data)*indgen(ny)/float(ny-1)
  endif
  ;  Set the plot_arr_size
  plot_arr_size=INTARR(2)
  plot_arr_size(0)=nx
  plot_arr_size(1)=ny
  ; Finally, get rid of the var_combined
  if (KEYWORD_SET(verbose)) then begin
     print, 'WARNING: zeroing variable arrays'
     print, 'only selected plot array left!'
     var_array=0
     grid_size=0
     lon=0
     lat=0
     lat=0
     vert=0
     time=0
  endif
  ;Finally, finally, scale the X or Y axis as required
  if (KEYWORD_SET(scale_x)) then begin
     xaxis=xaxis/scale_x
  endif
  if (KEYWORD_SET(scale_y)) then begin
     yaxis=yaxis/scale_y
  endif
end

pro load_colour_scale, coconts, $
                       coscale, $
                       colscale_setup=colscale_setup
  ; A routine to load the required colour scale
  ; First have we asked for a specific type 
  if (KEYWORD_SET(colscale_setup)) then begin
     ; Populate the available list
     ccolscale_list, ncolscale, ccolscale_name, ccolscale_call
     ; Try to find it
     found=0
     for icolscale=0, ncolscale-1 do begin
        if (string(colscale_setup) eq $
            ccolscale_name(icolscale)) then begin
           found=1
           routine_call=ccolscale_call(icolscale)
        endif
     endfor
     ; If found call it, if not attempt
     ; to load the colour scale
     if (found eq 1) then begin
        result=execute(routine_call)
     endif else begin
        print, 'Did not find colour scale:', colscale_setup
        print, 'in ccolscale_list.pro'
        stop        
     endelse
  endif else begin
     ; Otherwise load default scale
     ncoconts=n_elements(coconts)
     coscale=default_coscale(ncoconts)
  endelse
end

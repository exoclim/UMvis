pro load_colour_table, coconts=coconts, $
                       col_table=col_table, $
                       reverse=reverse
  ; A routine to load the required colour table
  ; First have we asked for a specific type of colour
  ; table
  ; Setup the foreground and background colours
  if (KEYWORD_SET(col_table)) then begin
     ; Populate the available list
     ccoltbl_list, ncoltbl, ccoltbl_name, ccoltbl_call
     ; Try to find it
     found=0
     for icoltbl=0, ncoltbl-1 do begin
        if (string(col_table) eq  ccoltbl_name(icoltbl)) then begin
           found=1
           routine_call=ccoltbl_call(icoltbl)
        endif
     endfor
     ; If found call it, if not attempt
     ; to load the table
     if (found eq 1) then begin
        result=execute(routine_call)
     endif else begin
        print, 'Attempting to load colour table:',$
               col_table
        loadct, fix(col_table)
     endelse
  endif else begin
     ; Otherwise load black and white
     loadct,0
  endelse
  if (KEYWORD_SET(reverse)) then begin
     reverse_ct
  endif
  ; Now ensure black text and white background
  ; or vice versa
  TVLCT, 255, 255, 255, 255  ; White
  TVLCT, 0, 0, 0, 0          ; Black
  !P.Color=0
  !P.Background=255
end

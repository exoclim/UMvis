pro set_labelling, nconts, $
                   cont_lbl, txt_thick, cont_thick, $
                   cont_lbl_ovrd=cont_lbl_ovrd, $
                   cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                   txt_thick_ovrd=txt_thick_ovrd, $
                   cont_thick_ovrd=cont_thick_ovrd, $
                   verbose=verbose
  ; Setup up some values for characters etc.
  ; How thick is the text
  if (KEYWORD_SET(txt_thick_ovrd)) then begin
     txt_thick=txt_thick_ovrd
  endif else begin
     txt_thick=1.3
  endelse
  ; How thick are the lines for each of the contours
  if (KEYWORD_SET(cont_thick_ovrd)) then begin
     cont_thick=cont_thick_ovrd
  endif else begin
     cont_thick=safe_alloc_arr(1, nconts, /int_arr)
     cont_thick(*)=1
  endelse
  ; Which contours are labelled
  if (KEYWORD_SET(cont_lbl_ovrd)) then begin
     cont_lbl=cont_lbl_ovrd
  endif else begin
     cont_lbl=safe_alloc_arr(1, nconts, /int_arr)
     ; Create label switch 
     icount=1
     if (KEYWORD_SET(cont_lbl_freq_ovrd)) then begin
        iswitch=cont_lbl_freq_ovrd
     endif else begin
        iswitch=2
     endelse
     for i=0, nconts-1 do begin
        icount=icount+1
        if (icount eq iswitch or icount gt iswitch) then begin
           cont_lbl(i)=1
           icount=0
        endif else begin
           cont_lbl(i)=0
        endelse
     endfor
  endelse
  if (KEYWORD_SET(verbose)) then begin
     print, 'Using text thickness:', txt_thick
     print, 'Thickness of contours:', cont_thick
     print, 'Labelling contours (0=no, 1=yes):', cont_lbl
  endif
end

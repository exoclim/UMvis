function set_cont_lbl, nconts, iswitch
  ; This function provides an array of
  ; integers, denoting the thickness of the
  ; contours.
  cont_lbl=safe_alloc_arr(1, nconts, /int_arr)
  icount=1
  for i=0, nconts-1 do begin
     icount=icount+1
     if (icount eq iswitch or icount gt iswitch) then begin
        cont_lbl(i)=1
        icount=0
     endif else begin
        cont_lbl(i)=0
     endelse
  endfor
  return, cont_lbl
end

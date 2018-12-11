function find_string_in_arr, nstrings, string_arr, target_string, $
                             nofail=nofail
  ; This simply locates a string in the string array
  ; matching the target and returns the index (-1 is returned when
  ; no match is failed).
  location=-1
    for istring=0, nstrings-1 do begin
     if (target_string eq string_arr(istring)) then begin
        if (location gt -1) then begin
           print, 'WARNING: multiple matches found for: ', $
                  target_string
           print, 'In: ', string_arr
           print, 'Using version with lowest index:', location 
           print, string_arr(location)
        endif else begin
           location=istring
        endelse        
     endif
  endfor
    if (not(KEYWORD_SET(nofail))) then begin
       if (location eq -1) then begin
          print, 'Failed to find: ', target_string
          print, 'In array: ', string_arr
          print, 'Stopping in find_string_in_arr.pro'
          stop
       endif
    endif
    return, location
 end

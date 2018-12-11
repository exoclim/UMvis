PRO ps_eof
DEVICE, /CLOSE_FILE
SET_PLOT, 'X'
END

PRO ps_file, psname, xsize=xsize, ysize=ysize, paper=paper, $
             land=land, fontsize=fontsize
; Version 1: 25/5/2007
; Version 2: 6/3/2008 Increase path_points from 1500 to 3000 -removed!!!

if not(keyword_set(fontsize)) then fontsize=8

if not(keyword_set(xsize)) then xsize=8.0
if not(keyword_set(ysize)) then ysize=8.0

SET_PLOT, 'PS'
; Old values, chopped off colour bar
;xoff0=0.75
;yoff0=5.0
xoff0=0.45
yoff0=5.0


if keyword_set(land) then begin
   if keyword_set(paper) then begin
      DEVICE, /COLOR, BITS_PER_PIXEL=8, FILENAME=psname,/landscape,$
              FONT_SIZE=fontsize,XSIZE=xsize, YSIZE=ysize, $
              YOFFSET=yoff0+6.0,XOFFSET=xoff0-0.6,  $
              /INCHES, /BOLD, /helvetica, font_index=3
                                ;,PATH_POINTS=1500
   endif else begin
      DEVICE, /COLOR, BITS_PER_PIXEL=8, FILENAME=psname,/landscape,$
              FONT_SIZE=fontsize,XSIZE=xsize, YSIZE=ysize, $
              YOFFSET=yoff0+6.0,XOFFSET=xoff0-0.6,  $
              /INCHES, /BOLD, /helvetica, font_index=3
                                ;,PATH_POINTS=1500
   endelse
endif else begin
   if keyword_set(paper) then begin
      DEVICE, /COLOR, BITS_PER_PIXEL=8, FILENAME=psname,/portrait,$
              FONT_SIZE=fontsize,XSIZE=xsize, YSIZE=ysize,YOFFSET=1.5,XOFFSET=-0.25,$
              /INCHES, /BOLD, /helvetica, font_index=3          ;,PATH_POINTS=1500
   endif else begin
      DEVICE, /COLOR, BITS_PER_PIXEL=8, FILENAME=psname,/portrait,$
              FONT_SIZE=fontsize,XSIZE=xsize, YSIZE=ysize,YOFFSET=1.5,XOFFSET=-0.25,$
              /INCHES, /BOLD, /helvetica, font_index=3    
   endelse
endelse
END



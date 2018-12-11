pro start_plot, plot_fname, window_num, ps=ps

  fontsize=10.0
  !P.Position=[0.12,0.12,0.95,0.90]
  if (KEYWORD_SET(ps)) then begin
     xsize=10.0
     ysize=8.0
     set_plot,'ps'
     ps_file, plot_fname,$
              fontsize=fontsize,$
              xsize=xsize, ysize=ysize, paper=paper, /land
     !p.thick=3.0
     !p.charthick=3.0
     !p.charsize=2.0
     !x.thick=3.0
     !y.thick=3.0
     !z.thick=3.0
  endif else begin
     set_plot,'x'
     window,  window_num, XSIZE=1024, YSIZE=900, TITLE='Fplot'
     !p.thick=1.0
     !p.charthick=1.0
     !p.charsize=1.6
     !x.thick=1.0
     !y.thick=1.0
  endelse
end

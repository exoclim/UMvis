pro convert_pdf_move_remote, $
   plot_name_ovrd=plot_name_ovrd, $
   remote_computer=remote_computer, $
   remote_folder=remote_folder, $
   keep_local_plots=keep_local_plots
    
; Routine to automatically convert ps to pdf and move to personal laptop in
; specified folder.

; Convert to PDF:
spawn, 'ps2pdf ' + plot_name_ovrd + '.ps'

; Rotate 180 degrees (for some reason the final plot is upside down):
spawn, 'pdf180 ' + plot_name_ovrd + '.pdf'
spawn, 'rm ' + plot_name_ovrd + '.pdf && mv ' + plot_name_ovrd + $
       '-rotated180.pdf ' + plot_name_ovrd + '.pdf'

; Crop whitespace
spawn, 'pdfcrop ' + plot_name_ovrd + '.pdf'
spawn, 'rm ' + plot_name_ovrd + '.pdf && mv ' + plot_name_ovrd + $
       '-crop.pdf ' + plot_name_ovrd + '.pdf'

; Copy to remote machine
spawn, 'scp ' + plot_name_ovrd + '.pdf ' + $
       remote_computer + ':' + remote_folder

if (NOT(KEYWORD_SET(keep_local_plots))) then begin
   print, 'WARNING: removing original .ps file'
   ; Remove original files
   spawn, 'rm ' + plot_name_ovrd + '.ps ' + plot_name_ovrd + '.pdf'
endif

end

pro ccolscale_list, ncolscale, ccolscale_name, ccolscale_call
  ; A routine creating the function/procedure
  ; call for all the available colour setups
  ; The usual call is "ccolscale_NAME, ARGS'
  ; But names can also be given to standard
  ; tables, i.e. temperature = 33
  ; WARNING: the routines are called in load_colour_table
  ; so the variables/argument names must be identical
  ; in this routine and the calling routine.
  
  ncolscale=1
  ccolscale_name=safe_alloc_arr(1, ncolscale, /string_arr)
  ccolscale_call=safe_alloc_arr(1, ncolscale, /string_arr)
  ; Initialise a counter
  count=0
  
  ccolscale_name(count)='wind'
  ccolscale_call(count)='ccolscale_wind, coconts, coscale'
  count=count+1

  ; Use this template to add another
  ; increment ncolscale
  ;ccolscale_name(count)=''
  ;ccolscale_call(count)=''
  ;count=count+1
end

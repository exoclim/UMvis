pro ccoltbl_list, ncoltbl, ccoltbl_name, ccoltbl_call
  ; A routine creating the function/procedure
  ; call for all the available colour tables
  ; The usual call is "ccoltbl_NAME, ARGS'
  ; But names can also be given to standard
  ; tables, i.e. temperature = 33
  ; WARNING: the routines are called in load_colour_table
  ; so the variables/argument names must be identical
  ; in this routine and the calling routine.
  
  ncoltbl=3
  ccoltbl_name=safe_alloc_arr(1, ncoltbl, /string_arr)
  ccoltbl_call=safe_alloc_arr(1, ncoltbl, /string_arr)
  ; Initialise a counter
  count=0
  
  ccoltbl_name(count)='temperature'
  ccoltbl_call(count)='loadct, 33'
  count=count+1

  ccoltbl_name(count)='wind'
  ccoltbl_call(count)='ccoltbl_wind, coconts'
  count=count+1

  ccoltbl_name(count)='exp_wind'
  ccoltbl_call(count)='ccoltbl_exp_wind, coconts'
  count=count+1

  ; Use this template to add another
  ; increment ncoltbl
  ;ccoltbl_name(count)=''
  ;ccoltbl_call(count)=''
  ;count=count+1
end

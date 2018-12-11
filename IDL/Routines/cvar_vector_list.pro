pro cvar_vector_list, ncvar, cvar_name, cvar_nelements,$
                      cvar_element, tested=tested
  ; This routine lists the available 2D vector
  ; plots and their required elements for
  ; iteration one and two.

; To add plotable vector increment this number
ncvar=4
cvar_name=safe_alloc_arr(1, ncvar, /string_arr)
cvar_nelements=safe_alloc_arr(1, ncvar, /int_arr)
; The maximum number of elements is 3]
arr_size=INTARR(2)
arr_size(0)=ncvar
arr_size(1)=3
cvar_element=safe_alloc_arr(2, arr_size, /string_arr)
; Array to state whether the variable is tested
; 0 is untested, 1 is tested
tested=INTARR(ncvar)

; Initialise the counter
count=0

cvar_name(count,0)='Horizvel'
cvar_nelements(count)=2
cvar_element(count,0)='Uvel'
cvar_element(count,1)='Vvel'
tested(count)=0
count=count+1

cvar_name(count,0)='Merivertvel'
cvar_nelements(count)=2
cvar_element(count,0)='Vvel'
cvar_element(count,1)='Wvel'
tested(count)=0
count=count+1

cvar_name(count,0)='Zonvertvel'
cvar_nelements(count)=2
cvar_element(count,0)='Uvel'
cvar_element(count,1)='Wvel'
tested(count)=0
count=count+1

cvar_name(count,0)='EP_flux'
cvar_nelements(count)=2
cvar_element(count,0)='EP_flux_lat'
cvar_element(count,1)='EP_flux_vert' 
tested(count)=0
count=count+1

; Use this template to add another
; increment ncvar
;cvar_name(count,0)=''
;cvar_nelements(count)=?
;cvar_element(count,0)=''
;cvar_element(count,1)=''
;tested(count)=0
;count=count+1

end

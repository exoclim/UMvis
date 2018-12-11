function safe_alloc_arr, $
   ndims, arr_size,$
   float_arr=float_arr, int_arr=int_arr,$
   string_arr=string_arr
  ; This routine allocates an array_out
  ; with dimensions, ndim, with
  ; sizes held in arr_size.
  ; it can be allocated as a float, or int or string
  ; It also stops the REALLY, REALLY annoying
  ; thing that ILD does which is dropping trailing
  ; array dimensions of 1 automatically!
  input_size=n_elements(arr_size)
  if (input_size ne ndims) then begin
     print, 'Error in safe_alloc_arr'
     print, 'Expecting array dimensions:', ndims
     print, 'But only have sizes for:', input_size
     stop
  endif
  
  if (KEYWORD_SET(float_arr) and KEYWORD_SET(int_arr)) then begin
     print, 'Can not allocate a float and int array'
     print, 'stop in safe_alloc_arr'
     stop
  endif
  if (KEYWORD_SET(float_arr) and KEYWORD_SET(string_arr)) then begin
     print, 'Can not allocate a float and string array'
     print, 'stop in safe_alloc_arr'
     stop
  endif
  if (KEYWORD_SET(string_arr) and KEYWORD_SET(int_arr)) then begin
     print, 'Can not allocate a string and int array'
     print, 'stop in safe_alloc_arr'
     stop
  endif

  ndims_max=5
  if (ndims eq 0) then begin
     print, 'Can not allocate array with zero dimensions'
     print, 'stop in safe_alloc_arr'
     stop
  endif
  if (ndims gt ndims_max) then begin
     print, 'Current maximum number of dimensions'
     print, 'in safe_alloc_arr:', ndims_max
     print, 'Can not allocate array with:', ndims
     print, 'stop in safe_alloc_arr'
     stop
  endif
  if (ndims eq 1) then begin
     ; Allocate array
     if (KEYWORD_SET(float_arr)) then $
        array_out=FLTARR(arr_size(0))
     if (KEYWORD_SET(int_arr)) then $
        array_out=INTARR(arr_size(0))
     if (KEYWORD_SET(string_arr)) then $
        array_out=STRARR(arr_size(0))
  endif else if (ndims eq 2) then begin
     ; Allocate array
     if (KEYWORD_SET(float_arr)) then $
        array_out=FLTARR(arr_size(0), arr_size(1))
     if (KEYWORD_SET(int_arr)) then $
        array_out=INTARR(arr_size(0), arr_size(1))
     if (KEYWORD_SET(string_arr)) then $
        array_out=STRARR(arr_size(0), arr_size(1))
     ; Deal with very irritating automatic
     ; truncation of trailing size 1 dimensions
     if (arr_size(1) eq 1) then $
        array_out=reform(array_out(*), $
                                arr_size(0), arr_size(1))
  endif else if (ndims eq 3) then begin
     ; Allocate array
     if (KEYWORD_SET(float_arr)) then $
        array_out=FLTARR(arr_size(0), arr_size(1), arr_size(2))
     if (KEYWORD_SET(int_arr)) then $
        array_out=INTARR(arr_size(0), arr_size(1), arr_size(2))
     if (KEYWORD_SET(string_arr)) then $
        array_out=STRARR(arr_size(0), arr_size(1), arr_size(2))
     ; Deal with very irritating automatic
     ; truncation of trailing size 1 dimensions
     if (arr_size(2) eq 1) then $
        array_out=reform(array_out(*,*), $
                                arr_size(0), arr_size(1), $
                                arr_size(2))
  endif else if (ndims eq 4) then begin
     ; Allocate array
     if (KEYWORD_SET(float_arr)) then $
        array_out=FLTARR(arr_size(0), arr_size(1), arr_size(2), $
                        arr_size(3))
     if (KEYWORD_SET(int_arr)) then $
        array_out=INTARR(arr_size(0), arr_size(1), arr_size(2), $
                         arr_size(3))
     if (KEYWORD_SET(string_arr)) then $
        array_out=STRARR(arr_size(0), arr_size(1), arr_size(2), $
                         arr_size(3))
     ; Deal with very irritating automatic
     ; truncation of trailing size 1 dimensions
     if (arr_size(3) eq 1) then $
        array_out=reform(array_out(*,*,*), $
                                  arr_size(0), arr_size(1), $
                                  arr_size(2), arr_size(3))     
  endif else if (ndims eq 5) then begin
     ; Allocate array
     if (KEYWORD_SET(float_arr)) then $
        array_out=FLTARR(arr_size(0), arr_size(1), arr_size(2), $
                        arr_size(3), arr_size(4))
     if (KEYWORD_SET(int_arr)) then $
        array_out=INTARR(arr_size(0), arr_size(1), arr_size(2), $
                        arr_size(3), arr_size(4))
     if (KEYWORD_SET(string_arr)) then $
        array_out=STRARR(arr_size(0), arr_size(1), arr_size(2), $
                        arr_size(3), arr_size(4))
     ; Deal with very irritating automatic
     ; truncation of trailing size 1 dimensions
     if (arr_size(4) eq 1) then $
        array_out=reform(array_out(*,*,*,*), $
                                    arr_size(0), arr_size(1), $
                                    arr_size(2), arr_size(3), $
                                    arr_size(4))          
  endif
  ; Final check 
  test_size=size(array_out)
  if (test_size(0) ne ndims) then begin
     print, 'Something wrong in safe_alloc_arr'
     print, 'Number of array dimensions:', test_size(0)
     print, 'not as requested:', ndims
     stop
  endif
  return, array_out
end

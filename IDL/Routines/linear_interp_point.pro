function linear_interp_point, ndims, var_in, var_grid,$
                              new_grid_pt,$
                              which_index, $
                              periodic=periodic, $
                              grid_period=grid_period, $
                              value=value,$
                              grid_boundaries=grid_boundaries, $
                              var_boundaries=var_boundaries, $
                              polar=polar,$
                              missing=missing, $
                              index_per=index_per, $
                              index_increment=index_increment
  ; This function interpolates, linearly,
  ; from the var_grid onto new_grid_pt
  ; for the value of var_in, which it returns 
  ; as var_out
  ; The boundary behaviour can be selected as either
  ; periodic, or as tending towards a value, or polar
  ; using the thus named keywords.
  ; If a value is selected, you must provide
  ; grid_boundaries(2)
  ; grid_boundaries(?)=value of grid at start(0)/end(1) boundary
  ; and var_boundaries(2)
  ; var_boundaries(?)=value of variable at start(0)/end(1) boundary
  ; for polar, index_per is the index of the periodic variable
  ; usually longitude
  ; For periodic and polar, we need the grid_period of the periodic
  ; dimension, usually longitude and therefore, 360
  ; it can handle 1d, 2d, 3d, or 4d arrays (i.e.var_in(*,*,*,*))
  ; ndims is a sanity check to make sure we have the number
  ; of dimensions expected
  ; and handles it automatically
  ; Finally, index_increment can be 'positive' or 'negative'
  ; and it tells the routines whether the axis is
  ; increasing with index i.e. height or decraesing i.e. pressure
  ; First we find the boundary values of the grid and indices
  find_interp_grid_boundaries, var_grid,$
                               new_grid_pt,$
                               periodic=periodic, $
                               grid_period=grid_period,$
                               value=value,$
                               grid_boundaries=grid_boundaries, $
                               polar=polar, $
                               missing=missing, $
                               grid_val_bounds, $
                               grid_index_bounds, $
                               index_increment=index_increment
  ; Now we have the indices of the end points we can
  ; find the variable at the interpolation points   
  ; We need to now how many dimensions the array has
  arr_dim=size(var_in)
  if (ndims ne arr_dim(0)) then begin
     print, 'Number of array dimensions:', arr_dim(0)
     print, 'Does not match that selected:', ndims
     print, 'stoppping in linear_inerp_point'
     stop
  endif

  if (arr_dim(0) gt 4 or arr_dim(0) lt 1) then begin
     if (arr_dim(0) gt 4) then $
        print, 'Array has too many dimensions (max=4):', arr_dim(0)
     if (arr_dim(0) lt 1) then $
        print, 'Array non-existent, size:', arr_dim(0)
     print, 'Stopping in linear_interp_variable'
     stop
  endif
  ; Construct the routine call dependant on the number
  ; of dimensions
  ; 1d is a special case
  number=STRCOMPRESS(STRING(arr_dim(0)),/remove_all)
  if (arr_dim(0) gt 1) then begin
     routine_call='var_interp_bounds=find_interp_var_boundaries_'+STRING(number)+'d(var_in, which_index, grid_index_bounds, periodic=periodic, value=value, var_boundaries=var_boundaries, polar=polar, missing=missing, index_per=index_per)'
  endif else begin
     routine_call='var_interp_bounds=find_interp_var_boundaries_1d(var_in, grid_index_bounds, periodic=periodic, value=value, var_boundaries=var_boundaries, missing=missing)'
  endelse
  result=execute(routine_call)
  ; Calculate the weight
  eta=linear_interp_eta(grid_val_bounds, new_grid_pt)
  ; Now perform the interpolation
  if (arr_dim(0) gt 1) then begin
     routine_call_two='var_out=linear_interp_'+number+'d(which_index, var_interp_bounds, eta)'
  endif else begin
     routine_call_two='var_out=linear_interp_'+number+'d(var_interp_bounds, eta)'
  endelse
  result_two=execute(routine_call_two)
  return, var_out
end

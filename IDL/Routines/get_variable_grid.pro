function get_variable_grid, fname, var_name, grid_index, $
                            verbose=verbose
  ; This routine reads in a required grid 
  ; (index=grid_index)
  ; for a named variable 
  read_netcdf_grid_info_only,fname,var_name,$
                             grid_name, $
                             grid_size, $
                             verbose=verbose
  read_netcdf_variable_only,fname,$
                            grid_name(grid_index),$
                            grid_out, $
                            verbose=verbose
  return, grid_out
end

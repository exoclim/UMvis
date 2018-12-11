pro construct_plot_array, vert_type,$
                          plot_grid_use_in=plot_grid_use_in, $
                          plot_limits_in=plot_limits_in, $
                          planet_setup, variable_list, $
                          p0, lid_height, pi, min_val, $
                          nvars, which_var_arr, $
                          var_combined, grid_size_combined,$
                          lon_combined, lat_combined, vert_combined, $
                          time_combined, $
                          var_vert_bounds_combined, $
                          plot_arr_size, $
                          plot_array, xaxis, yaxis, $
                          title, xtitle, ytitle, $
                          plot_fname, $
                          type_of_plot_var, $
                          plot_name_ovrd=plot_name_ovrd, $
                          meri_pt_mean=meri_pt_mean, $
                          plot_title_ovrd=plot_title_ovrd,$
                          xtitle_ovrd=xtitle_ovrd, ytitle_ovrd=ytitle_ovrd, $
                          scale_x=scale_x, scale_y=scale_y, $
                          plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                          plot_dtime=plot_dtime, $
                          verbose=verbose
  ; This routine construct the required plot arrays 
  ; from the variables stored in *combined* arrays.
  ; It also applies limits in plot_limits
  ; and performs actions in plot_grid_use (i.e. mean/sum or value)
  ; Plotting_array(plots,xaxis,yaxis)=FLTARR(plot_arr_size(0,1,2))
  if (KEYWORD_SET(verbose)) then $
     print, 'Constructing plot variable'
  ; Perform some consistency checks
  check_plot_arr_req, vert_type, $
                      plot_grid_use_in=plot_grid_use_in, $
                      plot_grid_use, $
                      plot_limits_in=plot_limits_in, $
                      plot_limits, $
                      lon_combined, lat_combined, vert_combined, $
                      time_combined, $  
                      verbose=verbose
  ; Setup the titles etc
  set_plot_titles, planet_setup, vert_type, plot_grid_use, $
                   variable_list, $
                   xtitle, ytitle, title, $
                   plot_fname, $
                   which_var_arr, $
                   plot_name_ovrd=plot_name_ovrd, $
                   plot_title_ovrd=plot_title_ovrd,$
                   xtitle_ovrd=xtitle_ovrd, ytitle_ovrd=ytitle_ovrd, $
                   scale_x=scale_x, scale_y=scale_y, $
                   plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                   plot_dtime=plot_dtime, $
                   verbose=verbose
  ; Create the actual x,y array and axes 
  ; WARNING: this routine zeros the *combined* arrays
  create_plot_arrays, vert_type,$
                      plot_grid_use, plot_limits, $
                      variable_list, $
                      p0, lid_height, pi, min_val, $
                      nvars, which_var_arr, $
                      var_combined, grid_size_combined,$
                      lon_combined, lat_combined, vert_combined, $
                      time_combined, $  
                      var_vert_bounds_combined, $                       
                      plot_arr_size, $
                      plot_array, xaxis, yaxis, $
                      type_of_plot_var, $
                      scale_x=scale_x, scale_y=scale_y, $
                      plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                      plot_dtime=plot_dtime, $                      
                      meri_pt_mean=meri_pt_mean, $
                      verbose=verbose
end

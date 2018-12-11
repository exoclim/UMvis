pro create_plot_arrays, vert_type,$
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
  ; A routine to create the plot data
  ; Loop over variables and perform cuts etc.
  for ivar=0, nvars-1 do begin
     ; Each of these routines, cuts and alters
     ; the input, so we need to preserve the common
     ; grid for every variable, otherwise on the first 
     ; variable it will be cut, and the second variable 
     ; is then limited according to this grid.
     loop_grid_size=grid_size_combined
     loop_lon=lon_combined
     loop_lat=lat_combined
     loop_vert=vert_combined
     loop_time=time_combined
     ; var_combined is a (var,lon,lat,vert,time), so change it
     ; to a um std (lon,lat,vert,time)
     ; It should be the ORIGINAL, uncut size
     var_loop=safe_alloc_arr(4, grid_size_combined, /float_arr)
     var_loop(*,*,*,*)=var_combined(ivar,*,*,*,*)
     limit_horiz_time_um_std, vert_type, plot_grid_use, plot_limits, $
                              var_loop, loop_grid_size, $
                              loop_lon, loop_lat, $
                              loop_vert, loop_time, $
                              verbose=verbose
     ; Vertical handled separately as reusing limit_horiz_time_um_std
     ; from mapping routines, and the vertical cutting is done in the
     ; vertical mapping section
     limit_vertical_um_std, vert_type,$
                            plot_grid_use(2), plot_limits(2,*), $
                            var_loop, loop_grid_size, $
                            loop_vert, $
                            verbose=verbose
     ; Handle any averaging etc, here we must perform
     ; the slicing in the vertical (so don't use /skip_vert_slice
     ; in arg list as used in limit_map.pro)
     mean_sum_slice, plot_grid_use, $
                     p0, lid_height, pi, min_val, $
                     var_loop, loop_grid_size, $
                     loop_lon, loop_lat, $
                     loop_vert, loop_time, $
                     var_vert_bounds_combined(ivar,*), $
                     meri_mean_pt=meri_mean_pt, $
                     vert_type=vert_type, $
                     var_type=which_var_arr(ivar), $
                     verbose=verbose
     ; Now var_loop has been cut, as has loop_grid_size
     ; loop_lon/lat etc.
     ; var_loop, now has the correct sizes and data
     ; we must replace these in var_combined
     ; The remaining values will be dropped
     var_combined(ivar, 0:loop_grid_size(0)-1, $
                  0:loop_grid_size(1)-1, $
                  0:loop_grid_size(2)-1, $
                  0:loop_grid_size(3)-1)=$
        var_loop(*,*,*,*)
     var_loop=0
  endfor
  ; Once all variables are done we must replace the 
  ; output sizes and grid with the loop version (which all
  ; should have been identical)
  grid_size_combined=loop_grid_size
  lon_combined=loop_lon
  lat_combined=loop_lat
  vert_combined=loop_vert
  time_combined=loop_time
  ; No we refill var_combined
  ; Currently this is too big, also holding
  ; left over data (i.e. var_grid_size larger
  ; than loop_grid_size)
  var_hold=var_combined
  ; Zero the old one and recreate it
  var_combined=0
  arr_size=INTARR(5)
  arr_size(0)=nvars
  arr_size(1)=grid_size_combined(0)
  arr_size(2)=grid_size_combined(1)
  arr_size(3)=grid_size_combined(2)
  arr_size(4)=grid_size_combined(3)
  var_combined=safe_alloc_arr(5, arr_size, /float_arr)
  ; Now fill it from the required elements of 
  ; var_hold, leaving the rest
  var_combined(*,*,*,*,*)=$
     var_hold(0:nvars-1, 0:grid_size_combined(0)-1, $
              0:grid_size_combined(1)-1, $
              0:grid_size_combined(2)-1, $
              0:grid_size_combined(3)-1)
  var_hold=0
     
  ; The result is a shrunken *combined* array
  ; Now we actually construct the plot_array
  ; WARNING: this routine zeros the *combined* arrays
  construct_plot_data, vert_type, plot_grid_use, $
                       variable_list, $
                       min_val, $
                       nvars, which_var_arr, $
                       var_combined(*,*,*,*,*), grid_size_combined, $
                       lon_combined, lat_combined, $
                       vert_combined, time_combined, $
                       plot_arr_size, $
                       plot_array, xaxis, yaxis, $
                       type_of_plot_var, $
                       scale_x=scale_x, scale_y=scale_y, $
                       plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                       plot_dtime=plot_dtime, $         
                       verbose=verbose
end

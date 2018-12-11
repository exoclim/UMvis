function um_plot_call_line, type 
  ; A simple function to make a string which can be used to
  ; call the um_plot routine with the full argument list
  ; Type denotes the 'type' of call'

  if (type eq 'full') then begin
     ; Write out the full call line
     um_call_line='um_plot, variable_list, vert_type, netcdf_name_key=netcdf_name_key, netcdf_um_in=netcdf_um_in, netcdf2_um_in=netcdf2_um_in,planet_setup_in=planet_setup_in, mapped_fname_in=mapped_fname_in, map_grid_use_in=map_grid_use_in, map_limits_in=map_limits_in, plot_grid_use_in=plot_grid_use_in, plot_limits_in=plot_limits_in, from_map_save=from_map_save, scratch_map_vars=scratch_map_vars, remapped_fname=remapped_fname, map_only=map_only, cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, planet_radius_ovrd=planet_radius_ovrd, p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, grav_surf_ovrd=grav_surf_ovrd, timestep_ovrd=timestep_ovrd, lid_height_ovrd=lid_height_ovrd, plot_name_ovrd=plot_name_ovrd, plot_data_fname=plot_data_fname, np_levels_ovrd=np_levels_ovrd, grav_type=grav_type, eqn_type=eqn_type, meri_mean_pt=meri_mean_pt, plot_title_ovrd=plot_title_ovrd, xtitle_ovrd=xtitle_ovrd, ytitle_ovrd=ytitle_ovrd, contour_setup=contour_setup, nconts_ovrd=nconts_ovrd, conts_ovrd=conts_ovrd, ncoconts_ovrd=ncoconts_ovrd, coconts_ovrd=coconts_ovrd, coscale_ovrd=coscale_ovrd, col_table=col_table, colscale_setup=colscale_setup, nbar_names_ovrd=nbar_names_ovrd, bar_names_ovrd=bar_names_ovrd, cont_lbl_ovrd=cont_lbl_ovrd, cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, txt_thick_ovrd=txt_thick_ovrd, cont_thick_ovrd=cont_thick_ovrd, cont_lines_col_ovrd=cont_lines_col_ovrd, vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, vect_arr_thin_ovrd=vect_arr_thin_ovrd, missing_vect_ovrd=missing_vect_ovrd, projection=projection, proj_lon_ctr=proj_lon_ctr, proj_lat_ctr=proj_lat_ctr, plot_cbar=plot_cbar, ps=ps, xlog=xlog, ylog=ylog, scale_x=scale_x, scale_y=scale_y, plot_eddy=plot_eddy, plot_var_log=plot_var_log, plot_dtime=plot_dtime, verbose=verbose'
  endif else begin
     print, '*******************************************'
     print, 'Other types of UM call not written out yet'
     print, 'You selected: ', type
     print, 'stopping in um_plot_call_full.pro'
     print, '*******************************************'
     stop
  endelse
  return, um_call_line
end

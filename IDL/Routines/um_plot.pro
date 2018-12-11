pro um_plot, $
   ; WARNING: this argument list is stored in string format in 
   ; ./UMVis/IDL/Control/um_plot_call_line.pro
   ; Change this, then change that!
   ; ***************************************************************
   ; Variables to map/plot (listed in cvar_list.pro, 
   ; cvar_list_mapped.pro, cvar_vector_list.pro)
   variable_list, $
   ; Type of vertical coordinate requested (Height, Pressure, Sigma)
   vert_type, $
   ; File containing the netcdf variable names
   netcdf_name_key=netcdf_name_key, $ 
   ; The filename of the UM netcdf output, if mapping
   netcdf_um_in=netcdf_um_in, $
   netcdf2_um_in=netcdf2_um_in, $
   ; The planet/GCM setup used
   planet_setup_in=planet_setup_in, $
   ; The name for the file containing the mapped variables
   mapped_fname_in=mapped_fname_in, $
   ; The limits etc., to decide which sections to map
   map_grid_use_in=map_grid_use_in, $
   map_limits_in=map_limits_in, $
   ; The limits etc., for plotting
   plot_grid_use_in=plot_grid_use_in, $
   plot_limits_in=plot_limits_in, $
   ; ***************************************************************
   ; What tasks to perform
   ; Are we starting from a mapped output (i.e. skip mapping)
   from_map_save=from_map_save, $
   ; Do not save the mapped output
   scratch_map_vars=scratch_map_vars, $
   ; If we are constructing variables from a mapped save
   ; do we then want to save these variables in a new file called:
   remapped_fname=remapped_fname, $
   ; Map only, and don't go on to plot
   map_only=map_only, $
   ; ***************************************************************
   ; Planet setup alterations
   ; List of override for values set in the planet_setup_list.pro
   cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, $
   planet_radius_ovrd=planet_radius_ovrd, $
   p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
   grav_surf_ovrd=grav_surf_ovrd, $
   timestep_ovrd=timestep_ovrd, $
   lid_height_ovrd=lid_height_ovrd, $
   ; ***************************************************************
   ; plot name overrides 
   ; Overrides for IO names
   ; Name of the plot file (ps)
   plot_name_ovrd=plot_name_ovrd, $
   ; Name to save the plot data
   plot_data_fname=plot_data_fname, $
   ; ***************************************************************
   ; The number of levels when mapping to pressure/sigma
   np_levels_ovrd=np_levels_ovrd, $
   ; Which gravity are we using ('constant'->g=g_surf)
   ; ('varying'->g=g_surf*(planet_radius/r)^2.0
   ; Equation type='deep', 'shallow'
   grav_type=grav_type, eqn_type=eqn_type, $
   ; Perform the meridional average in a pointwise fashion
   ; i.e. ignore the change in cell size with latitude
   meri_mean_pt=meri_mean_pt, $
   ; ***************************************************************
   ; Overrides for the plotting process
   plot_title_ovrd=plot_title_ovrd, $
   xtitle_ovrd=xtitle_ovrd, ytitle_ovrd=ytitle_ovrd, $
   ; Key Override: selects from a list (ccont_list.pro)
   ; to setup ALL the plotting details (i.e. contours, colour
   ; contours, bar names, colour scale..)
   contour_setup=contour_setup, $
   ; Overrides for number of, and values
   ; of contours, colour contours and colour scale
   nconts_ovrd=nconts_ovrd, $
   conts_ovrd=conts_ovrd, $
   ncoconts_ovrd=ncoconts_ovrd, $
   coconts_ovrd=coconts_ovrd, $
   coscale_ovrd=coscale_ovrd, $
   ; A way to setup from ccoltbl_list.pro, JUST
   ; the colour table used.
   col_table=col_table, $
   ; Setup for JUST the colour scale, from ccolscale_list.pro
   colscale_setup=colscale_setup, $
   ; Overrides for labels on colour bar
   nbar_names_ovrd=nbar_names_ovrd, $
   bar_names_ovrd=bar_names_ovrd, $
   ; Override for labeling of contours and thickness
   ;/colour of lines and text. As well as length
   ; and number of arrays for vectors (and missing value).
   cont_lbl_ovrd=cont_lbl_ovrd, $
   cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
   txt_thick_ovrd=txt_thick_ovrd, $
   cont_thick_ovrd=cont_thick_ovrd, $
   cont_lines_col_ovrd=cont_lines_col_ovrd, $
   vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
   vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
   missing_vect_ovrd=missing_vect_ovrd, $
   ; Option to select projections (create_plot.pro)
   ; And where to centre such projections
   projection=projection, $
   proj_lon_ctr=proj_lon_ctr, $
   proj_lat_ctr=proj_lat_ctr, $
   ; Add a colour bar
   plot_cbar=plot_cbar, $
   ; Select a hardcopy of the plot
   ps=ps, $
   ; Use log x or y axis
   xlog=xlog, ylog=ylog, $
   ; Scaling when plotting axes
   scale_x=scale_x, scale_y=scale_y, $
   ; Request an eddy/perturbation from zonal mean, log_10
   ; or change in time when plotting 
   plot_eddy=plot_eddy, plot_var_log=plot_var_log, $
   plot_dtime=plot_dtime, $
   ; Ask for all the messages from the code
   verbose=verbose

  ; This is a mapping/plotting tool for the UK Met Office (MO)
  ; Unified Model (UM) output, once converted to netCDF
  ; format.
  ; The routine has three stages
  ; 1, Map or construct required variables.
  ; 2, Construct the plot array.
  ; 3, Create the plot
  ; key inputs are:
  ; (1) variable_list=a list of variables to plot
  ; separated by '&'.
  ; Single=cvar_list.pro
  ; Vector=cvar_vector_list.pro
  ; (2) vert_type=Type of vertical axis (Height/Pressure/Sigma)
  ; (3) netcdf_um_in=netcdf file of UM output if creating from scratch
  ; (4) planet_setup_in=The planet setup again if creating from scratch,
  ; planet_setup_list.pro
  ; i.e. for (4) and (5) if going from a map file these are not required.
  ; (5) map_grid_use_in(4)=(lon,lat,vert,time)=How to map
  ; each dimension: mean, sum, all, or a set value
  ; set as default if not present
  ; (6) map_limits_in(4,2)=(lon,lat,vert,time-min,max)
  ; limits applied to each axis during mapping.
  ; Again default if not present
  ; (7) plot_grid_use_in(4)=As map_grid_use, but
  ; for plotting: mean, sum, x, y or a value.
  ; (8) plot_limits_in(4,2) as for mapping.
  ; (9) col_table (integer or string: which selects a type of colour
  ; table for the plot (load_colour_table.pro)
  ; The _in names are used so that default values
  ; can be applied when the input names are not set

  ; Help/instructions can be found at:
  ; https://wiki.exeter.ac.uk (Exexoclimes)
  ; or from Nathan Mayne (nathan@astro.ex.ac.uk)
 
  ; Politely welcome our user
  if (KEYWORD_SET(verbose)) then $
     print, 'Welcome to the Exeter University UM plotting tool'

  ; Key to assign names for each variable in netcdf
  IF (NOT(KEYWORD_SET(from_map_save))) then begin
     if (NOT(KEYWORD_SET(netcdf_name_key))) then begin
        netcdf_name_key='netcdf_names.key'
        print, '***WARNING: netcdf_name_key not set adopting default:', $
               netcdf_name_key
     endif
     ; Read in the name conversions from users netcdf file to UMvis
     netcdf_var_names=set_netcdf_var_names(netcdf_name_key, verbose=verbose)
  endif
  ; Construct the mapped variables
  ; Construct the set of variables required for this plot 
  ; and store them in a huge array. The procedure below
  ; also returns some constants etc.
  if (KEYWORD_SET(verbose)) then $
     print, 'Constructing Required Variables'
  create_all_variables, variable_list, $
                        vert_type, $
                        netcdf_var_names, $
                        netcdf_um_in=netcdf_um_in, $
                        netcdf2_um_in=netcdf2_um_in, $
                        planet_setup_in=planet_setup_in, $
                        mapped_fname_in=mapped_fname_in, $
                        map_grid_use_in=map_grid_use_in, $
                        map_limits_in=map_limits_in, $ 
                        cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, $
                        planet_radius_ovrd=planet_radius_ovrd, $
                        p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
                        grav_surf_ovrd=grav_surf_ovrd, $
                        timestep_ovrd=timestep_ovrd, $
                        lid_height_ovrd=lid_height_ovrd, $
                        np_levels_ovrd=np_levels_ovrd, $
                        grav_type=grav_type, eqn_type=eqn_type, $
                        meri_mean_pt=meri_mean_pt, $
                        from_map_save=from_map_save, $
                        scratch_map_vars=scratch_map_vars, $ 
                        remapped_fname=remapped_fname, $
                        pi, R, cp, kappa, planet_radius, p0, $
                        omega, grav_surf, timestep, lid_height, $
                        min_val, $         
                        mapped_fname, $
                        planet_setup, $
                        nvars, which_var_arr, $
                        var_combined, grid_size_combined, $
                        lon_combined, lat_combined, vert_combined, $
                        time_combined, $
                        var_vert_bounds_combined, $
                        verbose=verbose
  if (KEYWORD_SET(verbose)) then $
     print, 'Finished constructing/loading data array'

  if (not(KEYWORD_SET(map_only))) then begin
     ; Now we have constructed or loaded an array holding all the
     ; variables we required:
     ; var_combined(which_var_arr,lon_combined, 
     ; lat_combined, vert_combined, time_combined)
     ; Grid size: grid_size_combined
     ; Now, from this we construct the plot array,
     ; and apply limits to the axes, if requested.
     ; WARNING: this routine zeros the *combined* arrays
     construct_plot_array, vert_type, $
                           plot_grid_use_in=plot_grid_use_in, $
                           plot_limits_in=plot_limits_in, $
                           planet_setup, variable_list, $
                           p0, lid_height, pi, min_val, $
                           nvars, which_var_arr, $
                           var_combined, grid_size_combined, $
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
                           plot_title_ovrd=plot_title_ovrd, $
                           xtitle_ovrd=xtitle_ovrd, ytitle_ovrd=ytitle_ovrd, $
                           scale_x=scale_x, scale_y=scale_y, $
                           plot_eddy=plot_eddy, plot_var_log=plot_var_log,  $
                           plot_dtime=plot_dtime, $    
                           verbose=verbose

     ; Now we actually create the plot
     construct_plot, variable_list, nvars, which_var_arr, $
                     plot_array, xaxis, yaxis, $
                     title, xtitle, ytitle, $
                     plot_fname, $
                     type_of_plot_var, $
                     min_val, $
                     plot_data_fname=plot_data_fname, $
                     contour_setup=contour_setup, $
                     nconts_ovrd=nconts_ovrd, $
                     conts_ovrd=conts_ovrd, $
                     ncoconts_ovrd=ncoconts_ovrd, $
                     coconts_ovrd=coconts_ovrd, $
                     coscale_ovrd=coscale_ovrd, $
                     col_table=col_table, $
                     colscale_setup=colscale_setup, $
                     nbar_names_ovrd=nbar_names_ovrd, $
                     bar_names_ovrd=bar_names_ovrd, $
                     cont_lbl_ovrd=cont_lbl_ovrd, $
                     cont_lbl_freq_ovrd=cont_lbl_freq_ovrd, $
                     txt_thick_ovrd=txt_thick_ovrd, $
                     cont_thick_ovrd=cont_thick_ovrd, $
                     cont_lines_col_ovrd=cont_lines_col_ovrd, $
                     vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
                     vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
                     missing_vect_ovrd=missing_vect_ovrd, $
                     projection=projection, $
                     proj_lon_ctr=proj_lon_ctr, $
                     proj_lat_ctr=proj_lat_ctr, $
                     plot_cbar=plot_cbar, $
                     ps=ps, xlog=xlog, ylog=ylog, $
                     verbose=verbose
     if (KEYWORD_SET(ps)) then $
        device, /close
  endif else begin
     print, '----------------------------------------'
     print, '/map_only selected, so no plot produced'
     if (NOT(KEYWORD_SET(scratch_map_vars))) then begin
        print, '**/scratch_map_vars not selected so mapping output saved**'
     endif
     if (KEYWORD_SET(from_map_save)) then begin
        print, '**/from_map_save selected, yet no plot produced**'
     endif
     print, '----------------------------------------'
  endelse
  close,/all

  ; Politely wish the user a good day
  if (KEYWORD_SET(verbose)) then $
     print, "Thank you for using the UM plotting tool, have a nice day!"
end

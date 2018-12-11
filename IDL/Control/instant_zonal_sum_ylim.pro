pro instant_zonal_sum_ylim, $
   variable_list, $
   ; Vertical Coordinate for mapping
   vert_type, $
   ; Plot type specific arguments
   time_in, $
   ; Limits to y-axis
   ymin, ymax, $
   ; File for netcdf variable name information
   netcdf_name_key=netcdf_name_key, $
   ; UM filename
   netcdf_um_in=netcdf_um_in, $
   ; Second UM filename if making difference plot
   netcdf2_um_in=netcdf2_um_in, $
   ; Planet setup
   planet_setup_in=planet_setup_in, $
   ; Name of the mapped output/input
   mapped_fname_in=mapped_fname_in, $
   ; IO/ function selection
   ; Start from a mapped save (i.e. skip mapping)
   from_map_save=from_map_save, $
   ; Don't save the mapped variables for later plotting
   scratch_map_vars=scratch_map_vars, $
   ; Don't need to save remapped variables
   remapped_fname=remapped_fname, $
   ; Perform mapping only, i.e. don't plot
   map_only=map_only, $
   ; List of override for values set in the planet_setup_list.pro
   cp_ovrd=cp_ovrd, R_ovrd=R_ovrd, $
   planet_radius_ovrd=planet_radius_ovrd, $
   p0_ovrd=p0_ovrd, omega_ovrd=omega_ovrd, $
   grav_surf_ovrd=grav_surf_ovrd, $
   timestep_ovrd=timestep_ovrd, $
   lid_height_ovrd=lid_height_ovrd, $
   ; Overrides for IO names
   ; Name for the plot file (ps)
   plot_name_ovrd=plot_name_ovrd, $
   ; Name to save the plot data
   plot_data_fname=plot_data_fname, $
   ; Override for number of levels in vertical when
   ; plotting pressure or sigma (default is number of heights)
   np_levels_ovrd=np_levels_ovrd, $
   ; Which gravity are we using ('constant'->g=g_surf)
   ; ('varying'->g=g_surf*(planet_radius/r)^2.0
   ; Equation type='deep', 'shallow'
   grav_type=grav_type, eqn_type=eqn_type, $
   ; Perform the meridional average in a pointwise fashion
   ; i.e. ignore the change in cell size with latitude
   meri_mean_pt=meri_mean_pt, $
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
   ; Scale the axes for plotting
   scale_x=scale_x, scale_y=scale_y, $
   ; Request an eddy/perturbation from zonal mean, log_10
   ; or change in time when plotting 
   plot_eddy=plot_eddy, plot_var_log=plot_var_log, $
   plot_dtime=plot_dtime, $
   ; Ask for all the messages from the code
   verbose=verbose
  
; This is a basic template for running um_plot
; to map and/or plot some variables.
; Below are the minimal arguments and example choices
;-----------------------------------------------------
; How to map each dimension
; OPTIONAL-> DEFAULT='all'
; =mean, sum, all, x (for a value)
;map_grid_use_in=STRARR(4)
;map_grid_use_in(0)='mean' ; Longitude
;map_grid_use_in(0)='sum'  ; Longitude
;map_grid_use_in(0)='all'  ; Longitude
;map_grid_use_in(0)='0.0'  ; Longitude
;map_grid_use_in(1)='mean' ; Latitude
;map_grid_use_in(1)='sum'  ; Latitude
;map_grid_use_in(1)='all'  ; Latitude
;map_grid_use_in(1)='0.0'  ; Latitude
;map_grid_use_in(2)='mean' ; Vertical
;map_grid_use_in(2)='sum'  ; Vertical
;map_grid_use_in(2)='all'  ; Vertical
;map_grid_use_in(2)='0.0'  ; Vertical
;map_grid_use_in(3)='mean' ; Time
;map_grid_use_in(3)='sum'  ; Time
;map_grid_use_in(3)='all'  ; Time
;map_grid_use_in(3)='0.0'  ; Time
;-----------------------------------------------------
; Limits to grid during mapping
; OPTIONAL-> DEFAULT='min'/'max'
; These are ignored if the relevant
; map_grid_use is set to a value
map_limits_in=strarr(4,2)
map_limits_in(0,0)='min'    ; Longitude
map_limits_in(0,1)='max'    ; Longitude
map_limits_in(1,0)='min'    ; Latitude
map_limits_in(1,1)='max'    ; Latitude
map_limits_in(2,0)='min'    ; Height/Pressure/Sigma
map_limits_in(2,1)='max'    ; Height/Pressure/Sigma
map_limits_in(3,0)=time_in    ; Time
map_limits_in(3,1)=time_in      ; Time
;-----------------------------------------------------
; Use of each dimension when plotting
plot_grid_use_in=STRARR(4)
;plot_grid_use_in(0)='mean' ; Longitude
;plot_grid_use_in(0)='min' ; Longitude
;plot_grid_use_in(0)='min' ; Longitude
plot_grid_use_in(0)='sum'  ; Longitude
;plot_grid_use_in(0)='x'    ; Longitude
;plot_grid_use_in(0)='y'    ; Longitude
;plot_grid_use_in(0)='112.5'  ; Longitude
;plot_grid_use_in(1)='mean' ; Latitude
;plot_grid_use_in(1)='min' ; Latitude
;plot_grid_use_in(1)='max' ; Latitude
;plot_grid_use_in(1)='sum'  ; Latitude
plot_grid_use_in(1)='x'    ; Latitude
;plot_grid_use_in(1)='y'    ; Latitude
;plot_grid_use_in(1)='44.0'  ; Latitude
;plot_grid_use_in(2)='mean' ; Vertical
;plot_grid_use_in(2)='min' ; Vertical
;plot_grid_use_in(2)='max' ; Vertical
;plot_grid_use_in(2)='sum'  ; Vertical
;plot_grid_use_in(2)='x'    ; Vertical
plot_grid_use_in(2)='y'    ; Vertical
;plot_grid_use_in(2)='9.0e6'  ; Vertical
;plot_grid_use_in(3)='mean' ; Time
;plot_grid_use_in(3)='min' ; Time
;plot_grid_use_in(3)='max' ; Time
;plot_grid_use_in(3)='sum'  ; Time
;plot_grid_use_in(3)='x'    ; Time
;plot_grid_use_in(3)='y'    ; Time
plot_grid_use_in(3)=time_in  ; Time
;-----------------------------------------------------
; Limits to array when plotting (i.e. after mapping)
; OPTIONAL-> DEFAULT='min'/max
; These are ignored if a value is selected
; in the relevant plot_grid_use
plot_limits_in=strarr(4,2)
plot_limits_in(0,0)='min'    ; Longitude
plot_limits_in(0,1)='max'    ; Longitude
plot_limits_in(1,0)='min'    ; Latitude
plot_limits_in(1,1)='max'     ; Latitude
plot_limits_in(2,0)=ymin    ; Height/Pressure/Sigma
plot_limits_in(2,1)=ymax    ; Height/Pressure/Sigma
plot_limits_in(3,0)=time_in   ; Time
plot_limits_in(3,1)=time_in    ; Time
;-----------------------------------------------------

; The whole argument list is stored in a routine
call_line=um_plot_call_line('full')
result=execute(call_line)

end

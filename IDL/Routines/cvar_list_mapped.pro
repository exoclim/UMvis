pro  cvar_list_mapped, ncvar_mapped, cvar_name_mapped, $
                       cnprog_req, cprog_name_req, $
                       cvar_call_mapped, tested=tested
  ; This routine creates a list of all the variables
  ; which can be constructed from a pre-mapped set
  ; of basic prognostics (T, P, U, V, W, Density)
  ; If Pressure or Sigma is used then Height on these surfaces
  ; will also be required. 
  ; and creates the routine call for execution in 
  ; check_map_to_plot_var_list.pro
  ; This is only required where zonal perturbations
  ; from a mean are required, meaning if you want
  ; to do this in pressure coordinates you have to map first.
  ; Or in some other cirucmstances
  ; NOTE the variable names listed in the routine
  ; calls MUST match those in construct_from_mapped.pro
  ; KEY:
  ; THE INPUT:
  ; which_var_arr: names of these variables
  ; grid_size_combined: the sizes of the arrays of variables
  ; var_combined_full: the full set of variables
  ; lon_combined, lat_combined, vert_combined, time_combined: the grid
  ; vert_type: the vertical coordinate (Sigma, Pressure, Height)
  ; ver_vert_bounds_combined_full: the vertical boundary values
                                ; of each variable
  ; pi, R, cp, kapp, planet_radius, p0, omega, grav_surf, timestep,
                                ; lid_height, min_val: standard
                                ; meanings
  ; grav_type & eqn_type; will also be available and have standard
                                ; meanings
  ; CONSTRUCTION VARIABLES:
  ; nprog_req: the number of basic variables required
  ; prog_name_req: their names
  ; call_var_index: this array gives the positions of the 
  ; basic variables required to construct our target variables
  ; within the var_combined_full array.
  ; THE OUTPUT:
  ; var_constructed: this will be the new variable
  ; var_vert_bounds_constructed; the vertical boundaries
                                ; of the constructed variable.

  ; STANDARD CALL:
  ; cvar_map_NAME, VARIABLE NAMES and VALUES, $
  ;                BASIC VARIABLES REQUIRED AND INDEX, $
  ;                GRID VALUES, $
  ;                GRID_SIZE, $
  ;                VERTICAL BOUNDS AND TYPE
  ;                CONSTANTS, $
  ;                EQN TYPES ETC, $
  ;                OUTPUT, $
  ;                VERBOSITY FLAG
  ; LIKE:
;cvar_map_NAME, which_var, var_combined_full, $
;                 nprog_req, prog_name_req, call_var_index, $
;                 grid_size_combined, $
;                 lon_combined, lat_combined, vert_combined, time_combined, $
;                 var_vert_bounds_combined_full, vert_type, $
;                 pi, R, cp, kappa, planet_radius, p0, $
;                 omega, grav_surf, timestep, lid_height, $
;                 min_val, $
;                 grav_type=grav_type, eqn_type=eqn_type, $
;                 var_constructed, $
;                 var_vert_bounds_constructed, $
;                 verbose=verbose
; HOWEVER! It must appear as one continuous string i.e. drop the $ 
; continuations.
; NOTE: the variables nprog_req, and prog_name_req are the values
; for a single variable, selected from the full counterparts
; in this routine (cnprog_req and cprog_name_req).

  ; To add a constructable scalar increment this number
  ; then add its details at the bottom of this page.
  ncvar_mapped=18
  cvar_name_mapped=safe_alloc_arr(1, ncvar_mapped, /string_arr)
  cvar_call_mapped=safe_alloc_arr(1, ncvar_mapped, /string_arr)
  ; Keep track of the required basic variables
  ; wrongly termed prognostics here.
  cnprog_req=safe_alloc_arr(1, ncvar_mapped, /int_arr)
  ; We make the maximum number of basic variables ten
  prog_max=10
  prog_size=safe_alloc_arr(1, 2, /int_arr)
  prog_size(0)=ncvar_mapped
  prog_size(1)=prog_max
  cprog_name_req=safe_alloc_arr(2, prog_size, /string_arr)
  prog_size=0
  ; Make it start blank
  cprog_name_req(*,*)=''
  ; This is 0 if untested, and one if tested.
  tested=safe_alloc_arr(1, ncvar_mapped, /int_arr)
  ; Initialise counter
  count=0

  cvar_name_mapped(count)='linear_spec_zon_mmtm'
  cvar_call_mapped(count)='cvar_map_linear_spec_zon_mmtm, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=2
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  tested(count)=0
  count=count+1
  
  cvar_name_mapped(count)='zon_eddy_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=4
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Vvel'
  cprog_name_req(count,3)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='zon_mean_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=3
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='meri_eddy_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=4
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Vvel'
  cprog_name_req(count,3)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='meri_mean_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=4
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Vvel'
  cprog_name_req(count,3)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='meri_mean_sin_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=3
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Vvel'
  cprog_name_req(count,2)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='vert_eddy_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=4
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Wvel'
  cprog_name_req(count,3)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='vert_mean_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=4
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Wvel'
  cprog_name_req(count,3)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='vert_mean_cos_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=3
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Wvel'
  cprog_name_req(count,2)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='sum_eddy_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=5
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Vvel'
  cprog_name_req(count,3)='Wvel'
  cprog_name_req(count,4)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='sum_mean_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=5
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Vvel'
  cprog_name_req(count,3)='Wvel'
  cprog_name_req(count,4)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='sum_pump'
  cvar_call_mapped(count)='cvar_map_pumping_terms, which_var, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, pi, planet_radius, omega, timestep, lid_height, min_val, eqn_type=eqn_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=5
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Uvel'
  cprog_name_req(count,2)='Vvel'
  cprog_name_req(count,3)='Wvel'
  cprog_name_req(count,4)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='EKE'
  cvar_call_mapped(count)='cvar_map_eke, which_var, var_combined_full, var_vert_bounds_combined_full, grid_size_combined, nprog_req, prog_name_req, call_var_index, min_val, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=2
  cprog_name_req(count,0)='Uvel'
  cprog_name_req(count,1)='Vvel'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='hydrostasy'
  cvar_call_mapped(count)='cvar_map_hydrostasy, var_combined_full, nprog_req, prog_name_req, call_var_index, grid_size_combined, lon_combined, lat_combined, vert_combined, time_combined, var_vert_bounds_combined_full, vert_type, planet_radius, grav_surf, eqn_type=eqn_type, grav_type=grav_type, var_constructed, var_vert_bounds_constructed, verbose=verbose'
  cnprog_req(count)=2
  cprog_name_req(count,0)='Density'
  cprog_name_req(count,1)='Height_rho'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='jet_max_u_100pa'
  cvar_call_mapped(count)='cvar_map_jet_char, which_var, var_combined_full, lat_combined, vert_combined, var_vert_bounds_combined_full, grid_size_combined, nprog_req, prog_name_req, call_var_index, min_val, var_constructed, var_vert_bounds_constructed, vert_type, verbose=verbose'
  cnprog_req(count)=1
  cprog_name_req(count,0)='Uvel'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='jet_max_vert_100pa'
  cvar_call_mapped(count)='cvar_map_jet_char, which_var, var_combined_full, lat_combined, vert_combined, var_vert_bounds_combined_full, grid_size_combined, nprog_req, prog_name_req, call_var_index, min_val, var_constructed, var_vert_bounds_constructed, vert_type, verbose=verbose'
  cnprog_req(count)=1
  cprog_name_req(count,0)='Uvel'
  tested(count)=0
  count=count+1

  cvar_name_mapped(count)='eq_jet_breadth_100pa'
  cvar_call_mapped(count)='cvar_map_jet_char, which_var, var_combined_full, lat_combined, vert_combined, var_vert_bounds_combined_full, grid_size_combined, nprog_req, prog_name_req, call_var_index, min_val, var_constructed, var_vert_bounds_constructed, vert_type, verbose=verbose'
  cnprog_req(count)=1
  cprog_name_req(count,0)='Uvel'
  tested(count)=0
  count=count+1
  
  cvar_name_mapped(count)='eq_jet_depth_100pa'
  cvar_call_mapped(count)='cvar_map_jet_char, which_var, var_combined_full, lat_combined, vert_combined, var_vert_bounds_combined_full, grid_size_combined, nprog_req, prog_name_req, call_var_index, min_val, var_constructed, var_vert_bounds_constructed, vert_type, verbose=verbose'
  cnprog_req(count)=1
  cprog_name_req(count,0)='Uvel'
  tested(count)=0
  count=count+1
  

  ; EP ETC MUST BE ADDED: diff_stream, EP_flux_lat, EP_flux_height, div_EP_flux


; Use this template to make another (max of ten basic variables)
; cvar_name_mapped(count)='zon_eddy_pump'
; cvar_call_mapped(count)='CALL'
; cnprog_req(count)=
; cprog_name_req(count,0)=
; cprog_name_req(cout,1)=
; cprog_name_req(count,2)=
; cprog_name_req(count,3)=
; cprog_name_req(count,4)=
; cprog_name_req(count,5)=
; cprog_name_req(count,6)=
; cprog_name_req(count,7)=
; cprog_name_req(count,8)=
; cprog_name_req(count,9)=
; tested(count)=0
; count=count+1

end

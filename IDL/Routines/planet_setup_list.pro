pro planet_setup_list, nsetups, setup_names, R_list, cp_list, $
                       planet_radius_list, p0_list, omega_list, $
                       grav_surf_list, timestep_list
  ; This procedure simply populates the list
  ; of possible setups and their DEFAULT parameters
  ; these can be overwritten i.e. R_ovrd->R

  ; Adding a setup? Increment this
  nsetups=12
  setup_names=safe_alloc_arr(1, nsetups, /string_arr)
  R_list=safe_alloc_arr(1, nsetups, /float_arr)
  cp_list=safe_alloc_arr(1, nsetups, /float_arr)
  planet_radius_list=safe_alloc_arr(1, nsetups, /float_arr)
  p0_list=safe_alloc_arr(1, nsetups, /float_arr)
  omega_list=safe_alloc_arr(1, nsetups, /float_arr)
  grav_surf_list=safe_alloc_arr(1, nsetups, /float_arr)
  timestep_list=safe_alloc_arr(1, nsetups, /float_arr)

  ; Setup a counter to make adding setups easier
  count=0

  ; List setups
  ; Held-Suarez (Mayne et al., 2013)
  setup_names(count)='HS'
  R_list(count)=287.05
  cp_list(count)=1005.0
  planet_radius_list(count)=6.371e6
  p0_list(count)=1.0e5
  omega_list(count)=7.292e-5
  grav_surf_list(count)=9.80
  timestep_list(count)=1200.0
  count=count+1

  ; Tidally-Locked Earth (Mayne et al., 2013)
  setup_names(count)='TLE'
  R_list(count)=287.05
  cp_list(count)=1005.0
  planet_radius_list(count)=6.371e6
  p0_list(count)=1.0e5
  omega_list(count)=7.292e-5/365.0
  grav_surf_list(count)=9.80
  timestep_list(count)=1200.0
  count=count+1
  
  ; Earth-Like  (Mayne et al., 2013)
  setup_names(count)='EL'
  R_list(count)=287.05
  cp_list(count)=1005.0
  planet_radius_list(count)=6.371e6
  p0_list(count)=1.0e5
  omega_list(count)=7.292e-5
  grav_surf_list(count)=9.80
  timestep_list(count)=1200.0
  count=count+1

  ; Earth-Like +RT
  setup_names(count)='EL_RT'
  R_list(count)=287.05
  cp_list(count)=1005.0
  planet_radius_list(count)=6371229.0
  p0_list(count)=1.0e5
  omega_list(count)=7.292115373e-5
  grav_surf_list(count)=9.80665
  timestep_list(count)=1200.0
  count=count+1

  ; SHJ  (Mayne et al., 2014)
  setup_names(count)='SHJ'
  R_list(count)=3779.0
  cp_list(count)=13226.5
  planet_radius_list(count)=1.0e8
  p0_list(count)=1.0e5
  omega_list(count)=2.1e-5
  grav_surf_list(count)=8.0
  timestep_list(count)=1200.0
  count=count+1

  ; HD 209458b  (Mayne et al., 2014)
  setup_names(count)='HD209458b'
  R_list(count)=4593.0
  cp_list(count)=14308.4
  planet_radius_list(count)=9.44e7
  p0_list(count)=220.0e5
  omega_list(count)=2.06e-5
  grav_surf_list(count)=9.42
  timestep_list(count)=1200.0
  count=count+1

  ; HD 209458b coupled model
  setup_names(count)='HD209458b_RT'
  R_list(count)=3556.8
  cp_list(count)=1.3e4
  planet_radius_list(count)=9.00e7
  p0_list(count)=200.0e5
  omega_list(count)=2.06e-5
  grav_surf_list(count)=10.79
  timestep_list(count)=30.0
  count=count+1

  ; HD 189733b coupled model
  setup_names(count)='HD189733b_RT'
  R_list(count)=3556.8
  cp_list(count)=1.3e4
  planet_radius_list(count)=8.05e7
  p0_list(count)=200.0e5
  omega_list(count)=3.28e-5
  grav_surf_list(count)=22.49
  timestep_list(count)=30.0
  count=count+1

  ; Provisional Mars setup
  setup_names(count)='Mars'
  R_list(count)=287.05
  cp_list(count)=1005.0
  planet_radius_list(count)=3.3895e6
  p0_list(count)=1.0e5
  omega_list(count)=7.088218066303858e-5
  grav_surf_list(count)=3.711
  timestep_list(count)=1200.0
  count=count+1
  
  ; GJ 1214b  100X Solar
  setup_names(count)='GJ1214b_100s'
  R_list(count)=1917.3
  cp_list(count)=7.025e3
  planet_radius_list(count)=1.45e7
  p0_list(count)=200.0e5
  omega_list(count)=4.60e-5
  grav_surf_list(count)=12.2
  timestep_list(count)=30.
  count=count+1

  ; GJ 1214b 10x solar
  setup_names(count)='GJ1214b_10s'
  R_list(count)=3299.1
  cp_list(count)=1.15e4
  planet_radius_list(count)=1.45e7
  p0_list(count)=200.0e5
  omega_list(count)=4.60e-5
  grav_surf_list(count)=12.2
  timestep_list(count)=30.
  count=count+1

  ; GJ 1214b 1x solar
  setup_names(count)='GJ1214b_1s'
  R_list(count)=3573.5
  cp_list(count)=1.23e4
  planet_radius_list(count)=1.45e7
  p0_list(count)=200.0e5
  omega_list(count)=4.60e-5
  grav_surf_list(count)=12.2
  timestep_list(count)=30.
  count=count+1

  ; Use this template to add another
  ; increment nsetups
  ;setup_names(count)=''
  ;R_list(count)=
  ;cp_list(count)=
  ;planet_radius_list(count)=
  ;p0_list(count)=
  ;omega_list(count)=
  ;grav_surf_list(count)=
  ;timestep_list(count)=
  ;count=count+1

end

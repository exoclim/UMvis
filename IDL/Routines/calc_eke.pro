function calc_eke, u_in, v_in, min_val
  ; A small routine to calculate the Eddy Kinetic Energy
  ; EKE=(u_prime_lt^2 + v_prime_lt^2)/2
  ; Here X_prime_lt is the departure of X
  ; from the zonal and temporal mean.
  ; Given U and V on the same grid.

  ; First we create the zonal means (but need them
  ; full size i.e. not one element in longitude)
  u_bar_lon=zon_mean_um_std(u_in, min_val, $
                             /retain_size)
  v_bar_lon=zon_mean_um_std(v_in, min_val, $
                            /retain_size)
  ; Now the temporal mean
  u_bar_lon_t=time_mean_um_std(u_bar_lon, min_val, $
                               /retain_size)
  U_bar_lon=0
  v_bar_lon_t=time_mean_um_std(v_bar_lon, min_val, $
                               /retain_size)
  v_bar_lon=0
  ; Finally create perturbations, can't use
  ; decomp_zonal_perturb in this instance
  ; as this performs zonal implicitly again, and we have 
  ; done this already
  u_prime_lt=u_bar_lon_t
  u_prime_lt(*,*,*,*)=0.0
  u_prime_lt(*,*,*,*)=u_in(*,*,*,*)-u_bar_lon_t(*,*,*,*)
  u_bar_lon_t=0
  v_prime_lt=v_bar_lon_t
  v_prime_lt(*,*,*,*)=0.0
  v_prime_lt(*,*,*,*)=v_in(*,*,*,*)-v_bar_lon_t(*,*,*,*)
  ; Calculate EKE
  eke_out=0.5*((u_prime_lt(*,*,*,*)^2.0)+$
               (v_prime_lt(*,*,*,*)^2.0))
  u_prime_lt=0
  v_prime_lt=0
  return, eke_out
end

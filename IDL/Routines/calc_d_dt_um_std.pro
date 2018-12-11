function calc_d_dt_um_std, var_in, time
  ; A function which calculates the d/dt of 
  ; something

  ; Set up output
  d_dt=safe_alloc_um_std_template(var_in)
  d_dt(*,*,*,*)=0.0
  arr_dim=size(var_in)
  n_lon=arr_dim(1)
  n_lat=arr_dim(2)
  n_vert=arr_dim(3)
  n_time=arr_dim(4)
  ; Use third order accurate intrinsic derivative
  ; First create latitude in radians
  ; Calculate the t in seconds as
  ; t is in days (Earth).
  time_secs=time
  time_secs(*)=time(*)*60.0*60.0*24.0
  for ilon=0, n_lon-1 do begin
     for ilat=0, n_lat-1 do begin
        for ivert=0, n_vert-1 do begin
           d_dt(ilon,0:n_lat-1,ivert,itime)=$
              deriv(time_secs, $
                    var_in(ilon,ilat,ivert,0:n_time-1))
        endfor
     endfor
  endfor  
  return, d_dt
end

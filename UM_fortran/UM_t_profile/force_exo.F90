#if defined(A12_2A)
! *****************************COPYRIGHT*******************************
! (C) Crown copyright Met Office. All rights reserved.
! For further details please refer to the file COPYRIGHT.txt
! which you should have received as part of this distribution.
! *****************************COPYRIGHT*******************************
!
! Subroutine Force_exo

Subroutine Force_exo                                                    &
     &                        (row_length, rows, model_levels           &
     &,                        timestep                                 &
     &,                        SuHe_newtonian_timescale_ka              &
     &,                        SuHe_newtonian_timescale_ks              &
     &,                        SuHe_pole_equ_deltaT                     &
     &,                        SuHe_static_stab                         &
     &,                        SuHe_level_weight                        &
     &,                        SuHe_sigma_cutoff                        &
     &,                        L_SH_Williamson, SuHe_relax              &
     &,                        cos_theta_latitude                       &
     &,                        sin_theta_latitude, off_x, off_y         &
     &,                        exner_theta_levels                       &
     &,                        p_theta_levels, p_star                   &
     &,                        theta, theta_star                        &
                                ! Added by NJM 11/2011 for Exoplanetary benchmarks
     &,                        exo_benchmark_switch, cos_theta_longitude&
     &,                        r_theta_levels                           &
     &,                        halo_i, halo_j, timestep_number)

  ! Purpose:
  !          Provides temperature relaxation for  Exo planetary benchmarks
  !
  ! Code Owner: NJM University of Exeter
  ! This file belongs in section: Dynamics Advection
  !
  ! Code Description:
  !   Language: FORTRAN 77 + CRAY extensions
  !   This code is written to UMDP3 programming standards.

  ! Earth Radius also required, NJM 12/2012
  USE earth_constants_mod, ONLY: g,  earth_radius
  USE atmos_constants_mod, ONLY: kappa, R

  USE conversions_mod, ONLY: pi
  USE yomhook, ONLY: lhook, dr_hook
  USE parkind1, ONLY: jprb, jpim
  Implicit None

  ! Include physical constants

  Logical                                                           &
       &  L_SH_williamson

  Integer                                                           &
       &  row_length                                                      &
                                ! number of points on a row
       &, rows                                                            &
                                ! number of rows in a theta field
       &, model_levels                                                    &
                                ! number of model levels
       &, off_x                                                           &
                                ! Size of small halo in i
       &, off_y                                                           &
                                ! Size of small halo in j.
       &, halo_i                                                          &
                                ! Size of large halo in i
       &, halo_j                                                          &
                                ! Size of large halo in j.
       &, SuHe_relax   ! Switch to choose form of relaxtion

  Real                                                              &
       &  timestep

  Real                                                              &
       &  theta (1-off_x:row_length+off_x, 1-off_y:rows+off_y,            &
       &         model_levels)                                            &
       &, theta_star (1-off_x:row_length+off_x, 1-off_y:rows+off_y,       &
       &         model_levels)                                            &
       &, exner_theta_levels(1-off_x:row_length+off_x, 1-off_y:rows+off_y,&
       &         model_levels)                                            &
       &, p_theta_levels(1-off_x:row_length+off_x, 1-off_y:rows+off_y,    &
       &         model_levels)                                            &
       &, p_star(row_length, rows)                                        &
       &, cos_theta_latitude(1-off_x:row_length+off_x, 1-off_y:rows+off_y)&
       &, sin_theta_latitude(row_length, rows)

  ! Suarez Held variables

  Real                                                              &
       &  SuHe_newtonian_timescale_ka                                     &
       &, SuHe_newtonian_timescale_ks                                     &
       &, SuHe_pole_equ_deltaT                                            &
       &, SuHe_static_stab                                                &
       &, SuHe_level_weight(model_levels)                                 &
       &, SuHe_sigma_cutoff


  integer :: timestep_number

  ! Variables for the Exo-planetary Benchmarks
  ! added NJM 11/2011
  INTEGER :: exo_benchmark_switch
  real :: cos_theta_longitude(row_length, rows)
  ! Added for the Menou & Rauscher (2009) Earth-Like test
  ! Halo required for interpolation stencils-so don't
  ! need the extra elements
  real :: r_theta_levels(1-halo_i:row_length+halo_i,                      &
       &                 1-halo_j:rows+halo_j,0:model_levels)             
  ! This is distance from the centre of the Earth
  ! to get Z - earth_radius
  

  ! local variables

  Integer                                                           &
       &  i, j, k

  Real                                                              &
       &  temp1                                                           &
       &, temp2                                                           &
       &, theta_eq(row_length, rows,model_levels)                         &
       &, newtonian_timescale                                             &
       &, recip_kappa

  ! Williamson variables
  ! 1. parameters. NB: changing these WILL change answers
  Real                                                              &
       &  p_d                                                             &
       &, p_pl                                                            &
       &, lapse_rate_d                                                    &
       &, lapse_rate_i                                                    &
       &, delta_phi_0                                                     &
       &, A_will                                                          &
       &, phi_0                                                           &
       &, T_0

  ! 2. derived variables
  Real                                                              &
       &  p_i                                                             &
       &, p_eq                                                            &
       &, power_d                                                         &
       &, power_i                                                         &
       &, latitude                                                        &
       &, p_lim

  INTEGER(KIND=jpim), PARAMETER :: zhook_in  = 0
  INTEGER(KIND=jpim), PARAMETER :: zhook_out = 1
  REAL(KIND=jprb)               :: zhook_handle

  ! Local Variables required for Exo-Planetary Benchmarks
  ! Added by NJM 12/2011
  ! Height of tropopause in pressure (coordinates)
  real :: sigma_strat
  ! Vertical pressure coordinate
  real :: sigma
  ! The horizontal temperature gradient in tropospheric region
  real :: beta_trop
  ! Location of the top of the stratosphere in the Vertical grid
  integer :: strat_loc
  ! The Newtonian relaxation timescale, when set to a constant
  ! For example Earth-Like Heng et al (2011) 
  ! The code actually uses a reciprocal timescale multiplied by the
  ! timestep-explained below
  real :: newt_relax_const 
  ! Height of tropopause in metres 
  real :: z_strat
  ! The Lapse rate or vertical temperature gradient in troposphere
  ! K /m
  real :: gamma_trop
  ! The Tropopause temperature increment 
  ! K /m
  real :: delta_T_strat
  ! Temperature of the stratosphere, and surface, equator to pole diff and T_vert
  real :: T_strat, T_surf, delta_T_eq_pole, T_Vert
  ! Variables to construct the Temperature profile for HD209458b Benchmark
  ! Night side, day side and the Temperature in Iro et al (2005)
  real :: T_night, T_day, T_iro, T_night_min, T_day_min, max_newt
  ! The log(P/1bar) variable for polynomial fit
  real :: log_sigma
  
  ! The benchmark switch values
#include "exobench.h"

  ! No External routines

  ! ----------------------------------------------------------------------
  ! Section 1.  Calculate temperature relaxation forcing.
  ! ----------------------------------------------------------------------

  IF (lhook) CALL dr_hook('FORCE_EXO',zhook_in,zhook_handle)
  recip_kappa = 1. / kappa

  ! Simple Held-Suarez test
  if (exo_benchmark_switch == exo_hs) then
    T_strat=200.0
    T_surf=315.0
    delta_T_eq_pole=SuHe_pole_equ_deltaT 
     Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              ! calculate Theta_eq.
              temp1 = T_strat / exner_theta_levels(i,j,k)
              temp2 = T_surf - delta_T_eq_pole                                        &
                   &                    * sin_theta_latitude(i,j)                     &
                   &                    * sin_theta_latitude(i,j)                     &
                   &                    - SuHe_static_stab                            &
                   &                    * log(exner_theta_levels(i,j,k))              &
                   &                    * recip_kappa                                 &
                   &                    * cos_theta_latitude(i,j)                     &
                   &                    * cos_theta_latitude(i,j)
              theta_eq(i,j,k) = max(temp1, temp2)
           End Do
        End Do
     End Do
     ! Added by NJM 11/2011 for Tidally-Locked Earth
  else if (exo_benchmark_switch == exo_tle) then
    T_strat=200.0
    T_surf=315.0
    delta_T_eq_pole=SuHe_pole_equ_deltaT 
     Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              ! Adjust the Thermal Forcing to that prescribed in
              ! Merlis & Schneider (2010) and Later Heng et al (2011)
              ! Used cos(x-180)=-cos(x)
              ! Missing Final pressure term as using 
              ! potential temperature
              temp1 = T_strat / exner_theta_levels(i,j,k)
              temp2 = T_surf - delta_T_eq_pole                                        &
                   &         * cos_theta_longitude(i,j)                               &
                   &         * cos_theta_latitude(i,j)                                &
                   &         - SuHe_static_stab                                       &
                   &         * log(exner_theta_levels(i,j,k))                         &
                   &         * recip_kappa                                            &
                   &         * cos_theta_latitude(i,j)                                &
                   &         * cos_theta_latitude(i,j)          
              theta_eq(i,j,k) = max(temp1, temp2)
           End Do
        End Do
     End Do
  else if (exo_benchmark_switch == exo_el .or.                              &
          &exo_benchmark_switch == exo_shj) then
     ! Added by NJM 12/2011 for Menou & Rauscher (2009) Earth-like simulation
     ! And Menou & Rauscher (2009) Shallow Hot Jupiter Forcing
     ! They are put together as they both use similar equations
     ! Adjust the Thermal Forcing to that prescribed in
     ! Menou & Rauscher (2009) and Later Heng et al (2011)
     ! First the forcing is different if above the stratosphere
     ! Now we calculate the horizontal temperature differential (beta_trop)
     ! and vertical temperature profile
     ! The values of the constants is set accordingly
     if (exo_benchmark_switch == exo_el) then
        z_strat=1.2e4
        gamma_trop=6.5e-3
        delta_T_strat=2.0
        T_strat=212.0
        T_surf=288.0
        delta_T_eq_pole=SuHe_pole_equ_deltaT 
     else if (exo_benchmark_switch == exo_shj) then
        z_strat=2.0e6
        gamma_trop=2.0e-4
        delta_T_strat=10.0
        T_strat=1210.0
        T_surf=1600.0
        delta_T_eq_pole=300.0
     end if
     Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              temp1 = T_strat / exner_theta_levels(i,j,k)
              ! We Need the pressure at the top of the stratosphere, as defined
              ! by the constant value-Consider changing this to an interpolation
              ! The r_theta_levels is distance from Centre of the Earth
              strat_loc=minloc(abs(r_theta_levels(i,j,:)-Earth_radius-z_strat),1)
              sigma_strat=p_theta_levels(i,j,strat_loc)/p_star(i,j)
              ! sigma_strat should be ~0.22 for Earth and ~0.12 for Shallow Hot Jupiter
              ! We require Sigma coordinates for this forcing
              ! NOTE: Exner=(P/P0)^1/kappa /= Sigma = P/P_surf!
              sigma=p_theta_levels(i,j,k)/p_star(i,j)
              if (r_theta_levels(i,j,k)-Earth_radius <= z_strat) then
                 ! In the Stratosphere
                 beta_trop=sin(pi*(sigma-sigma_strat)/(2.0*(1.0-sigma_strat)))
                 T_vert=T_surf-gamma_trop*                                          &
                      & (z_strat+(r_theta_levels(i,j,k)-Earth_radius-z_strat)*0.5) + &
                      & ((gamma_trop*(r_theta_levels(i,j,k)-Earth_radius-z_strat)*0.5)**2.0+ &
                      &  delta_T_strat**2.0)**0.5
              else
                 ! Above Stratosphere
                 beta_trop=0.0
                 T_vert=T_surf-gamma_trop*z_strat+delta_T_strat
              end if
              ! Now set the equilibirum temperature for EL and SHJ
              ! Recall Using Potential TEMPERATURE
              ! Therefore, must convert the temperature to potential 
              ! temperature using the exner function (exner*theta=Temp)
              if (exo_benchmark_switch == exo_el) then
                 temp2          = (T_vert + beta_trop * delta_T_eq_pole                    &
                      &         * ((1.0/3.0)-sin_theta_latitude(i,j)*sin_theta_latitude(i,j))) &
                      &         / exner_theta_levels(i,j,k)
              else if (exo_benchmark_switch == exo_shj) then
                 ! Used cos(x-180)=-cos(x)
                 temp2          = (T_vert - beta_trop * delta_T_eq_pole                    &
                      &         * cos_theta_longitude(i,j)                                 &
                      &         * cos_theta_latitude(i,j))                                 &
                      &         / exner_theta_levels(i,j,k)
              end if              
              theta_eq(i,j,k) = temp2
           End Do
        End Do
     End Do
     ! Finally we need to set the Newtonian Relaxation timescale
     if (exo_benchmark_switch == exo_el) then
        ! Heng et al (2011) use 15 days, therefore  1.296e6 seconds
        SuHe_relax  =  3
        newt_relax_const = 1.296e6        
     else if (exo_benchmark_switch == exo_shj) then
        ! Heng et al (2011) use pi/Rotation period~1.731 days, 
        ! therefore 1.49558e5 seconds
        SuHe_relax  =  3
        newt_relax_const = 1.49558e5
     end if
  else if (exo_benchmark_switch == exo_hd209458b_bench) then
     ! Set the temperature profile and relaxation timescale
     Do k = 1, model_levels
       Do j = 1, rows
          Do i = 1, row_length
             ! First construct the pressure variable
             ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
             log_sigma=log10(p_theta_levels(i,j,k)/1.0e5)

!if (k==1) log_sigma=log10(21912860./1.0e5)
!if (k==2) log_sigma=log10(14734603./1.0e5)
!if (k==3) log_sigma=log10(9907814.0/1.0e5)
!if (k==4) log_sigma=log10(6662193.5/1.0e5)
!if (k==5) log_sigma=log10(4479778.5/1.0e5)
!if (k==6) log_sigma=log10(3012284.0/1.0e5)
!if (k==7) log_sigma=log10(2025514.8/1.0e5)
!if (k==8) log_sigma=log10(1361992.5/1.0e5)
!if (k==9) log_sigma=log10(915828.19/1.0e5)
!if (k==10) log_sigma=log10(615819.50/1.0e5)
!if (k==11) log_sigma=log10(414088.22/1.0e5)
!if (k==12) log_sigma=log10(278440.44/1.0e5)
!if (k==13) log_sigma=log10(187228.30/1.0e5)
!if (k==14) log_sigma=log10(125895.77/1.0e5)
!if (k==15) log_sigma=log10(84654.555/1.0e5)
!if (k==16) log_sigma=log10(56923.258/1.0e5)
!if (k==17) log_sigma=log10(38276.230/1.0e5)
!if (k==18) log_sigma=log10(25737.633/1.0e5)
!if (k==19) log_sigma=log10(17306.441/1.0e5)
!if (k==20) log_sigma=log10(11637.177/1.0e5)
!if (k==21) log_sigma=log10(7825.0483/1.0e5)
!if (k==22) log_sigma=log10(5261.6997/1.0e5)
!if (k==23) log_sigma=log10(3538.0608/1.0e5)
!if (k==24) log_sigma=log10(2379.0571/1.0e5)
!if (k==25) log_sigma=log10(1599.7220/1.0e5)
!if (k==26) log_sigma=log10(1075.6815/1.0e5)
!if (k==27) log_sigma=log10(723.30743/1.0e5)
!if (k==28) log_sigma=log10(486.36481/1.0e5)
!if (k==29) log_sigma=log10(327.04068/1.0e5)
!if (k==30) log_sigma=log10(219.90819/1.0e5)
!if (k==31) log_sigma=log10(147.87019/1.0e5)
!if (k==32) log_sigma=log10(99.430542/1.0e5)
!if (k==33) log_sigma=log10(66.858932/1.0e5)

             ! The night and day side temperature profile polynomial fits
             ! from Heng et al (2011), fit switches at 10bar (10.0e5 Pa)
             ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
             ! P<=10bar, (1.0e6 pascals)
             if (p_theta_levels(i,j,k) <= 1.0e6) then
                ! If the pressure gets too low cap the temperature
                ! at the temperature for the 0.1Pa point
                if (p_theta_levels(i,j,k) < 0.1)       &
                     & log_sigma=log10(0.1/1.0e5)
                T_night=(1388.2145+267.66586*log_sigma &
                     &  -215.53357*(log_sigma**2.0)    &
                     &  +61.814807*(log_sigma**3.0)    &
                     &  +135.68661*(log_sigma**4.0)   &
                     &  +2.0149044*(log_sigma**5.0)    &
                     &  -40.907246*(log_sigma**6.0)    &
                     &  -19.015628*(log_sigma**7.0)    &
                     &  -3.8771634*(log_sigma**8.0)    &
                     &  -0.38413901*(log_sigma**9.0)   &
                     &  -0.015089084*(log_sigma**10.0))     
                T_day=(2149.9581+4.1395571*(log_sigma) &
                     &  -186.24851*(log_sigma**2.0)    &
                     &  +135.52524*(log_sigma**3.0)    &
                     &  +106.20433*(log_sigma**4.0)    &
                     &  -35.851966*(log_sigma**5.0)    &
                     &  -50.022826*(log_sigma**6.0)    &
                     &  -18.462489*(log_sigma**7.0)    &
                     &  -3.3319965*(log_sigma**8.0)    &
                     &  -0.30295925*(log_sigma**9.0)   &
                     &  -0.011122316*(log_sigma**10.0))
             else
                T_night=(5529.7168-6869.6504*log_sigma &
                     &  +4142.7231*(log_sigma**2.0)    &
                     &  -936.23053*(log_sigma**3.0)    &
                     &  +87.120975*(log_sigma**4.0))  
                T_day=T_night
             end if
             ! Now apply the temperature, dependent on the location
             ! Note there is an error in Heng et al (2011) Eqn 26
             ! 90<phi<270 should be 90<theta<270
             ! Day side is 90<theta(longitude)<270
             ! Therefore, cos_theta_longitude <=0 
             ! Again using potential temperature so convert by /exner


! Now attempt to slowly increase the temperature contrast
! in this instance we are going to slowly cool the night side
! End contrast is 1000.0K so creep towards this** over 200 days
!THIS PNE IS CURRENTLY RUNNING-xabch, xabcn, xabcm!
! T_night=T_night+1000.0*(1.0-timestep*timestep_number/1.728e7)


!PERHAPS PUT THIS ABOVE JUST FOR <10bar and make it a steeper declining
! function, perhaps a 1/e type fall off?**


! Also try going the over direction i.e.
!T_day=T_day-1000.0*(1.0-timestep*timestep_number/1.728e7)


             ! An exponential decay over 100days
             ! For low pressure regions <10bar
             ! Do this for 200 days
             if (timestep*timestep_number < 1.728e7) then
                if (p_theta_levels(i,j,k) < 1.0e6)&
                     & T_night=T_night+1000.0*exp(-timestep*timestep_number/8.64e6)
                ! THIS IS NEW CODE i.e. xabcg et are not running with it
             else !TRY THIS NEXT
                ! ENFORCE AN ISOTHERMAL CORE OVER THE FIRST 200 days
                T_night=1575.0
             end if


             if (cos_theta_longitude(i,j) <= 0) then 
                temp2=((T_night**4.0 - (T_day**4.0 - T_night**4.0)  &
                     & *cos_theta_longitude(i,j)  &
                     & *cos_theta_latitude(i,j))**0.25) &
                     & / exner_theta_levels(i,j,k) 
             else 
                temp2=T_night / exner_theta_levels(i,j,k)
             end if

             


             !CAP IT*** WITH DAY NIGHT SIDE DEPENDENCE**
             ! COULD DO WITH A LATTITUDE DEPENDENCE ON NIGHT SIDE***
             
             ! We start by setting some minimum temperatures for the day and night side
             !******
             !THESE VALUES NEED SORTING
             !T_night_min=475.15112
             ! VALUE AT SMALLEST PRESSURE
            ! T_day_min=1472.6763
             !Perhaps day side is fine all the way
             !if (cos_theta_longitude(i,j) <= 0) then 
             !   temp1=((T_night_min**4.0 - (T_day_min**4.0 - T_night_min**4.0)  &
             !        & *cos_theta_longitude(i,j)  &
             !        & *cos_theta_latitude(i,j))**0.25) &
             !        & / exner_theta_levels(i,j,k) 
             !else
             !   temp1=T_night_min/exner_theta_levels(i,j,k)
             !endif
             
                          theta_eq(i,j,k) = temp2 
             !theta_eq(i,j,k)=max(temp2,temp1)
          End Do
       End Do
    End Do
    ! Finally se the type of relaxation timescale
    ! This uses a polynomial fit from Heng et al (2011)
    SuHe_relax  =  4
 end if
    
    ! ----------------------------------------------------------------------
    ! Section 2.  Calculate relaxation timescale.
    ! ----------------------------------------------------------------------

    if(SuHe_relax  ==  1)then
       Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              ! calculate relaxation term.
              newtonian_timescale = SuHe_newtonian_timescale_ka           &
                   &                          + ( SuHe_newtonian_timescale_ks -       &
                   &                              SuHe_newtonian_timescale_ka )       &
                   &                          * cos_theta_latitude(i,j) ** 4          &
                   &                          * SuHe_level_weight(k)

              theta_star(i,j,k) = theta_star(i,j,k) - timestep *          &
                   &                                    newtonian_timescale *         &
                   &                           (theta_star(i,j,k) - theta_eq(i,j,k))


           End Do
        End Do
     End Do

  elseif (SuHe_relax  ==  2)then

     Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              ! calculate relaxation term.
              ! temp1 is SuHe_level_weight(k)
              temp1 = (p_theta_levels(i,j,k)/p_star(i,j) - SuHe_sigma_cutoff) &
                   &                                      / (1.0 - SuHe_sigma_cutoff)
              newtonian_timescale = SuHe_newtonian_timescale_ka         &
                   &                          + ( SuHe_newtonian_timescale_ks -       &
                   &                              SuHe_newtonian_timescale_ka )       &
                   &                          * cos_theta_latitude(i,j) ** 4          &
                   &                          * max(0.0, temp1)

              theta_star(i,j,k) = theta_star(i,j,k) - timestep *        &
                   &                                    newtonian_timescale *         &
                   &                           (theta_star(i,j,k) - theta_eq(i,j,k))
           End Do
        End Do
     End Do
     ! Added by NJM 12/2012 to allow a constant relaxation timescale
  else if ( SuHe_relax == 3) then
     ! Now we must convert from the newtonian timescale in seconds 
     ! to that required by the code
     ! as Q=dT/dt=(Teq-T)/t_rad
     ! Therefore, dT=-(T-Teq)dt/t_rad
     ! Therefore, in this code newtonian_timescale=1/(t_rad(s))
     newtonian_timescale = 1.0/(newt_relax_const)
     Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              theta_star(i,j,k) = theta_star(i,j,k) - timestep *        &
                   &                                    newtonian_timescale *         &
                   &                           (theta_star(i,j,k) - theta_eq(i,j,k))
           End Do
        End Do
     End Do
  else if ( SuHe_relax == 4) then
     ! For this option the timescale comes from Heng et al (2011)
     ! polynomial fit
     Do k = 1, model_levels
        Do j = 1, rows
           Do i = 1, row_length
              ! First construct the pressure variable
              ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
              log_sigma=log10(p_theta_levels(i,j,k)/1.0e5)

!if (k==1) log_sigma=log10(21912860./1.0e5)
!if (k==2) log_sigma=log10(14734603./1.0e5)
!if (k==3) log_sigma=log10(9907814.0/1.0e5)
!if (k==4) log_sigma=log10(6662193.5/1.0e5)
!if (k==5) log_sigma=log10(4479778.5/1.0e5)
!if (k==6) log_sigma=log10(3012284.0/1.0e5)
!if (k==7) log_sigma=log10(2025514.8/1.0e5)
!if (k==8) log_sigma=log10(1361992.5/1.0e5)
!if (k==9) log_sigma=log10(915828.19/1.0e5)
!if (k==10) log_sigma=log10(615819.50/1.0e5)
!if (k==11) log_sigma=log10(414088.22/1.0e5)
!if (k==12) log_sigma=log10(278440.44/1.0e5)
!if (k==13) log_sigma=log10(187228.30/1.0e5)
!if (k==14) log_sigma=log10(125895.77/1.0e5)
!if (k==15) log_sigma=log10(84654.555/1.0e5)
!if (k==16) log_sigma=log10(56923.258/1.0e5)
!if (k==17) log_sigma=log10(38276.230/1.0e5)
!if (k==18) log_sigma=log10(25737.633/1.0e5)
!if (k==19) log_sigma=log10(17306.441/1.0e5)
!if (k==20) log_sigma=log10(11637.177/1.0e5)
!if (k==21) log_sigma=log10(7825.0483/1.0e5)
!if (k==22) log_sigma=log10(5261.6997/1.0e5)
!if (k==23) log_sigma=log10(3538.0608/1.0e5)
!if (k==24) log_sigma=log10(2379.0571/1.0e5)
!if (k==25) log_sigma=log10(1599.7220/1.0e5)
!if (k==26) log_sigma=log10(1075.6815/1.0e5)
!if (k==27) log_sigma=log10(723.30743/1.0e5)
!if (k==28) log_sigma=log10(486.36481/1.0e5)
!if (k==29) log_sigma=log10(327.04068/1.0e5)
!if (k==30) log_sigma=log10(219.90819/1.0e5)
!if (k==31) log_sigma=log10(147.87019/1.0e5)
!if (k==32) log_sigma=log10(99.430542/1.0e5)
!if (k==33) log_sigma=log10(66.858932/1.0e5)

              ! Different for P<10bar i.e 1.0e6 Pa
              ! Recall variable given as log(T_rad) in Heng et al (2011)
              ! Also we need 1/T_rad, s^-1
              ! Heng et al (2011) States that the fit for relaxation time
              ! is valid for 10 microbar (1Pa) <P<8.5bar (8.5e5Pa)
              ! I am not sure what this means you should do between 
              ! 8.5 and 10 bar????***
              if (p_theta_levels(i,j,k) < 1.0e6) then
                 ! If the pressure gets to low cap the relaxation time
                 ! at the value at 10microbar
                 if (p_theta_levels(i,j,k) < 1.0) &
                      &log_sigma=log10(1.0/1.0e5)
                 newtonian_timescale=1.0/(10.0**(5.4659686+1.4940124*log_sigma        &
                      & +0.66079196*(log_sigma**2.0)+0.16475329*(log_sigma**3.0) &
                      & +0.014241552*(log_sigma**4.0)))
              else

!WITH THE HOT SPIN UP I THINK WE MIGHT HAVE TO COOL THE CORE***
! AFTER A CERTAIN AMOUNT OF TIME THE WHOLE
! DOMAIN IS OUTSIDE THE PRESSURE OF 10 BAR(i.e.) THE LOWEST
! PRESSURE IS 100bar***


! THE VERSION WITHOUT THIS IS RUNNIGN xabcn, xabcm, xabch
! Need to cool the core as we heat it accidentally so try a relaxation time
! two hundred days over two hundred days
                 if (timestep*timestep_number < 1.728e7) then
                    newtonian_timescale=1.728e-7
                 else
                    newtonian_timescale=0.0
                 endif
              end if

              ! ATMosphere will respond quickest at hot spot

              ! ADD EXTRA CAP WITH DAY NIGHT SIDE DEPEDNECE
              ! PERHAPS USE LATTITUDE TERM ON NIGHT SIDE
! FOR LOW PRESSURES***, i.e. 1bar
!if (p_theta_levels(i,j,k) < 1.0e5) then
! WE think timescale is fastest at hotspot and atni-hotspot
!              newtonian_timescale=abs((newtonian_timescale)*cos_theta_longitude(i,j)&
!                   & *cos_theta_latitude(i,j))
! But we don't want it to become too slow
! So the slowest response should be the 
!Value at 1 bar
!max_newt=(1.0/292394.0)
!end if
!              if (cos_theta_longitude(i,j) <= 0) then 
!                 max_newt=(1.0/4327.9854)
!              else
!                 !FOR NIGHT SIDE VALUE AT 1mbar***
!                 max_newt=(1.0/4327.9854)
!              endif
!              
!              newtonian_timescale=max(max_newt,newtonian_timescale)

              theta_star(i,j,k) = theta_star(i,j,k) - timestep *        &
                   &                                    newtonian_timescale *         &
                   &                           (theta_star(i,j,k) - theta_eq(i,j,k))
           End Do
        End Do
     End Do
  else
     print*,'SuHe_relax = ',SuHe_relax,' not supported'
     print*,'Put correct value in IDEALISED NAMELIST - 1, 2 or 3'
     stop
  Endif   !  SuHe_relax  ==  1
  IF (lhook) CALL dr_hook('FORCE_EXO',zhook_out,zhook_handle)
  RETURN
END SUBROUTINE Force_exo
#endif

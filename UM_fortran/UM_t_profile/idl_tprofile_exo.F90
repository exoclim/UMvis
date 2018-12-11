#if defined(A12_2A)
! *****************************COPYRIGHT*******************************
! (C) Crown copyright Met Office. All rights reserved.
! For further details please refer to the file COPYRIGHT.txt
! which you should have received as part of this distribution.
! *****************************COPYRIGHT*******************************
! Subroutine IDL_tprofile_exo

      Subroutine IDL_tprofile_exo(                                         &
     &                      row_length, rows, model_levels              &
     &,                     me, off_x, off_y, halo_i, halo_j            &
     &,                     cos_theta_latitude                          &
     &,                     r_theta_levels, r_rho_levels                &
     &,                     eta_theta_levels, eta_rho_levels            &
     &,                     theta, exner_rho_levels, exner_theta_levels &
!  Profiles for fixed lbcs and sponge zones
     &,                     theta_ref, exner_ref                        &
!  Grid information
     &,                     height_domain, big_layers                   &
! Profile settings
     &,                     p_surface, theta_surface                    &
! Dynamical core settings
     &,                     SuHe_pole_equ_deltaT, SuHe_static_stab      &
     &,                     L_SH_Williamson                             &
!  Options
     &,                     L_code_test                                 &
! Exo planetary benchmark selection
     &,                     L_isothermal, exo_benchmark_switch)

! Purpose:
!          Sets up initial data for Exoplanetary Benchmarks
!          using the initial forcing prescribed in each case
!
!
! Code Owner: See Unified Model Code Owner's HTML page
! This file belongs in section: Dynamics Advection
!
! Code Description:
!   Language: FORTRAN 77 + CRAY extensions
!   This code is written to UMDP3 programming standards.
!
!
      USE atmos_constants_mod, ONLY:                                    &
          r, cp, kappa, p_zero 

      USE earth_constants_mod, ONLY: g, earth_radius
       
      USE conversions_mod, ONLY: pi

      USE yomhook, ONLY: lhook, dr_hook
      USE parkind1, ONLY: jprb, jpim
      Implicit None

      Integer                                                           &
     &  row_length                                                      &
                         ! number of points on a row
     &, rows                                                            &
                         ! number of rows in a theta field
     &, model_levels                                                    &
                         ! number of model levels
     &, big_layers                                                      &
                          ! number of isothermal layers
     &, halo_i                                                          &
                             ! Size of halo in i direction.
     &, halo_j                                                          &
                             ! Size of halo in j direction.
     &, off_x                                                           &
                             ! Size of small halo in i
     &, off_y                ! Size of small halo in j.

      Real                                                              &
     &  theta_surface                                                   &
     &, p_surface                                                       &
     &, height_domain

      Logical                                                           &
     & L_code_test    ! user switch

      Integer                                                           &
     &  me         ! My processor number


      Real                                                              &
           ! vertical co-ordinate information
     &  r_theta_levels(1-halo_i:row_length+halo_i                       &
     &,                1-halo_j:rows+halo_j,0:model_levels)             &
     &, r_rho_levels(1-halo_i:row_length+halo_i                         &
     &,              1-halo_j:rows+halo_j, model_levels)                &
     &, eta_theta_levels(0:model_levels)                                &
     &, eta_rho_levels(model_levels)                                    &
     &, cos_theta_latitude(1-off_x:row_length+off_x                     &
     &,                     1-off_y:rows+off_y)

!Output Arrays from this routine
      Real                                                              &
     &  theta(1-halo_i:row_length+halo_i                                &
     &,       1-halo_j:rows+halo_j, model_levels)                       &
     &, exner_rho_levels(1-halo_i:row_length+halo_i                     &
     &,                  1-halo_j:rows+halo_j, model_levels+1)          &
     &, exner_theta_levels(1-halo_i:row_length+halo_i                   &
     &,                    1-halo_j:rows+halo_j, model_levels)          &
     &, theta_ref(model_levels)                                         &
                                 !theta profile for use in sponge & lbcs
     &, exner_ref(model_levels + 1)  ! Exner profile for use in lbcs

! Suarez Held variables
      Real                                                              &
     &  SuHe_pole_equ_deltaT                                            &
     &, SuHe_static_stab

      Logical                                                           &
     &  L_SH_williamson

! local variables
      Integer                                                           &
     &  i, j, k

      Real                                                              &
     &  recip_kappa                                                     &
     &, exner_surface                                                   &
     &, temp1                                                           &
     &, temp2                                                           &
     &, weight                                                          &
     &, sigma_ref(model_levels)                                         &
     &, sigma_to_kappa(model_levels)

! Williamson variables1. 1. parameters.

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
     &, p_lim                                                           &
     &, minusgoverRTref

      Real                                                              &
     &  p_theta_levels(1-off_x:row_length+off_x, 1-off_y:rows+off_y     &
     &,    model_levels)

      ! The switch to decide which exo planetary benchmark is being run
      ! options in ./src/include/constants/exobench.h
      integer :: exo_benchmark_switch 
      ! A Variable to start the initial temperature 
      ! Closer to that required by the final test
      real :: T_surf, T_strat
      ! Do we want to start from an isothermal sphere
      logical :: L_isothermal
      ! Variable to assign a different static stability 
      ! parameter
      real :: static_stab

      INTEGER(KIND=jpim), PARAMETER :: zhook_in  = 0
      INTEGER(KIND=jpim), PARAMETER :: zhook_out = 1
      REAL(KIND=jprb)               :: zhook_handle


! The benchmark switch values
#include "exobench.h"

      IF (lhook) CALL dr_hook('IDL_TPROFILE_EXO',zhook_in,zhook_handle)
      ! Setup first guess of structure using hydrostatic approx
      ! and ideal gas
      recip_kappa=1.0/kappa 
      exner_surface = (p_surface/p_zero) ** kappa
      minusgoverRTref = - g / ( R * theta_surface)   
      !-----------------------------------------------------------------
      ! Section 1.1  Setup the Pressure Sigma Levels based on height
      !-------------------------------------------------------------------
      do k= 1, model_levels
         sigma_ref(k) = exp( minusgoverRTref *                           &
              &                       (r_theta_levels(1,1,k) -  Earth_radius ) )
         sigma_to_kappa(k) =  sigma_ref(k) ** kappa
      end do
            
      !-----------------------------------------------------------------
      ! Section 2  Force Temperature Profile
      !-------------------------------------------------------------------
      
      if (exo_benchmark_switch == no_exo) then
         if (me == 0) print*, 'EXO: Benchmark Not Required-Error'
         stop
         
         !-----------------------------------------------------------------
         ! Section 2.1  Zonally symmetric initial data based on dynamical core
         !              set up (Held-Suarez)
         ! Also applies to
         ! Section 2.2   Hypothetical Tidally-Locked Earth
         !                (Merlis & Schneider, 2010)              
         ! Section 2.3    'Shallow' Earth, or Earth-Like 
         !                (Menou & Rauscher, 2009)
         !-------------------------------------------------------------------
         
      elseif  (exo_benchmark_switch == exo_hd .or.                                       &
           &     exo_benchmark_switch == exo_tle .or.                                      &
           &     exo_benchmark_switch == exo_el .or.                                       &
           &     exo_benchmark_switch == exo_shjup .or.                                  &
           &     exo_benchmark_switch == exo_hd209458b_bench) then
         ! Set the default stratospheric temperature for Held-Suarez
         T_strat=200.0
         static_stab=SuHe_static_stab
         if (exo_benchmark_switch == exo_el) T_strat=212.0
         ! Stability parameter of 10.0 (i.e. HS is OK for this)
         if (exo_benchmark_switch == exo_shjup) T_strat=1210.0
         if (exo_benchmark_switch == exo_hd209458b_bench) then
            ! The static stability profile is estimated from 
            ! a linear fit to the night side profile in Figure 7
            ! of Heng et al (2011).
            T_strat=0.0
            static_stab=800.0
         end if
         if (L_isothermal .and. me ==0) print*, 'EXO: Using initially isothermal atmosphere'
         ! NOTE theta and theta_ref, contain temperature at the moment
         Do k = 1, model_levels
            if (L_isothermal) then
               ! If we are setting up an isothermal atmosphere
               ! set temperature to surface temperature everywhere
               theta(:,:,:)=theta_surface
               theta_ref(:)=theta_surface
            else
               ! For HD209458b-have an inactive isothermal region P>10 bar
               ! Then need smooth structure above
               if (exo_benchmark_switch == exo_hd209458b_bench .and. &
                    & sigma_ref(k)*p_surface > 1.0e6 ) then
                  theta(:,:,k)=theta_surface
                  theta_ref(k)=theta_surface
               else
                  ! Set up a smooth zonally symmetric temperature structure                 
                  temp1 = (theta_surface - static_stab * log(sigma_ref(k)))       &
                       &   * sigma_to_kappa(k)
                  theta(:,:,k) = max(T_strat, temp1)
                  ! NB  theta currently holds temperature
                  theta_ref(k) = max(T_strat, temp1)
               end if
            end if
         End Do
      end if
! ----------------------------------------------------------------------
! Section 3  Calculate pressure profile (overwriting dump)
! NB  theta currently holds temperature
! ----------------------------------------------------------------------
         if (me == 0) print*, 'EXO: Calculating Full Pressure Profile'

         do j = 1-off_y, rows+off_y
            Do i = 1-off_x, row_length+off_x
               exner_rho_levels(i,j,1) = exp( g *                            &
                    &                ( r_theta_levels(i,j,0) - r_rho_levels(i,j,1) )   &
                    &                               / ( Cp * theta(i,j,1) ) )
            end do
         end do
         
         Do k = 2, model_levels
            do j = 1-off_y, rows+off_y
               Do i = 1-off_x, row_length+off_x
                  exner_rho_levels(i,j,k) = exner_rho_levels(i,j,k-1) *       &
                       &          exp ( g * (r_rho_levels(i,j,k-1) - r_rho_levels(i,j,k)) &
                       &                                     / ( Cp * theta(i,j,k-1)))
               End Do
            End Do
         End Do 
         
         k = model_levels
         do j = 1-off_y, rows+off_y
            Do i = 1-off_x, row_length+off_x
               exner_rho_levels(i,j,k+1) = exner_rho_levels(i,j,k) *         &
                    &      exp (2.0 * g * (r_rho_levels(i,j,k) - r_theta_levels(i,j,k))&
                    &                                     / ( Cp * theta(i,j,k)))
            End Do
         End Do
         
         Do k = 1, model_levels - 1
            do j = 1-off_y, rows+off_y
               Do i = 1-off_x, row_length+off_x
                  weight = (r_rho_levels(i,j,k+1) - r_theta_levels(i,j,k))/   &
                       &                (r_rho_levels(i,j,k+1) - r_rho_levels(i,j,k))
                  exner_theta_levels(i,j,k) =   weight *                      &
                       &                                   exner_rho_levels(i,j,k) +      &
                       &                  (1.0 - weight) * exner_rho_levels(i,j,k+1)
               End Do
            End Do
         End Do
         k = model_levels
         do j = 1-off_y, rows+off_y
            Do i = 1-off_x, row_length+off_x
               exner_theta_levels(i,j,k) =   0.5 *                           &
                    &            (exner_rho_levels(i,j,k) + exner_rho_levels(i,j,k+1))
            End Do
         End Do
         
         if (me == 0) print*, 'EXO: Deriving Potential Temperature'

! ----------------------------------------------------------------------
! Section 4  Convert temperature to potential temperature
! ----------------------------------------------------------------------
         Do k = 1, model_levels
            do j = 1-off_y, rows+off_y
               Do i = 1-off_x, row_length+off_x
                  theta(i,j,k) =  theta(i,j,k) / exner_theta_levels(i,j,k)
               End Do
            End Do
         End Do
         
         !  exner_ref required to set lbcs - theta_ref contains temperature
         exner_ref(1) =  exp(- g * height_domain *                         &
              &                       eta_rho_levels(1) / ( Cp * theta_ref(1)))
         
         do k = 2,model_levels
            exner_ref(k)= exner_ref(k-1) *                                  &
                 &                                 exp(g * height_domain *          &
                 &                 (eta_rho_levels(k-1) - eta_rho_levels(k))        &
                 &                                     / ( Cp * theta_ref(k-1)))
         end do
         
         k = model_levels + 1
         exner_ref(k) = exner_ref(k-1) * exp( g * height_domain *          &
              &           2.0 * (eta_rho_levels(k-1) - eta_theta_levels(k-1))    &
              &                                   / ( Cp * theta_ref(k-1)))
         
         !  theta_ref contains temperature - convert to potential temperature
         do k = 1, model_levels
            theta_ref(k)= theta_ref(k) / exner_ref(k)
         end do
         
         IF (lhook) CALL dr_hook('IDL_TPROFILE_EXO',zhook_out,zhook_handle)
         RETURN
       END SUBROUTINE IDL_tprofile_EXO
     
#endif

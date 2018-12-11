program sponge
! This program recreates the sponge used
! in a model given the same set of input parameters

IMPLICIT NONE

! Method: The vertical damping term motivated by the results of 
!         Klemp JB, Dudhia J, Hassiotis AD. 2008."An upper gravity-wave
!         absorbing layer for NWP applications." Mon. Wea. Rev. 136, 
!         3987-4004.
!
!         Following Temam and Tribbia (2003) this damping term is 
!         formulated so that it is active in the hydrostatic formulation.
!         Although this means that in the the sponge layer hydrostatic
!         balance will not be strictly enforced.
!
!         Melvin et.al (2009) suggest a piecewise defined profile:
!
!                 /
!                 | 0, \eta < \eta_s
!                 |
!         \mu_w = <
!                 !             \pi  (eta-eta_sa)
!                 | \mu_bar sin(---  ------------)^2, \eta >= \eta_s
!                 |              2    (1-eta_s)
!                 \
!
!
!        Note that in this implementation eta is defined in terms of
!        xi_3:
!
!              xi_3_at_theta-earth_radius
!        eta = --------------------------,
!               domain_height
!
!        i.e. eta is not necessarily zero at ground level.



! The input variables from a model
! Which profile "./src/atmosphere/dynamics/init_vert_damp_mod.F90"
integer :: eg_vert_damp_profile
! The coefficient
real :: eg_vert_damp_coeff
! The top of the model (m)
real :: height_domain
! The start of the sponge layer in dimensionless height coords
real :: eg_damp_eta_start

! Grid and environment sizes
integer :: nheights, nlats
real :: planet_radius
real, allocatable, dimension(:) :: height_grid, lat_grid

! The output array
real, allocatable, dimension(:,:,:) :: mu_w

! Local variables
real :: eta_s, recip_one_m_etas, eta_jk, cos_lat
integer :: i,k

print*, 'This program will construct a sponge layer profile'
print*, 'Replicating that used in the UM'

print*, 'Please enter the Profile: eg_vert_damp_profile'
read(*,*) eg_vert_damp_profile

print*, 'Please enter the damping coefficient: eg_vert_damp_coeff'
read(*,*) eg_vert_damp_coeff

print*, 'Please enter the height of your model lid: height_domain'
read(*,*) height_domain

print*, 'Please enter the starting location of the layer: eg_damp_eta_start'
read(*,*) eg_damp_eta_start

! Now setup the domain sizes
print*, 'Please enter the Radius of the planet'
read(*,*) planet_radius

height_grid
mu_w
lat_grid

! WARNING REAL CODE HAS * TIMESTEP INCLUDED

SELECT CASE (eg_vert_damp_profile)

! No damping ---------------------------------------------------------
  CASE(zero_vert_damp_prof)

     mu_w = 0

! Standard -----------------------------------------------------------
  CASE(seventyfive_vert_damp_prof)

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=1, nheights
      DO j=1, nlats

          eta_jk = (height_grid(k)-planet_radius)                &
                         /height_domain

          IF (eta_jk>eta_s) THEN
             mu_w(j,k) = eg_vert_damp_coeff                      &
                  * SIN( 0.5*pi*(eta_jk-eta_s)                   &
                  *recip_one_m_etas)**2.0

          ELSE
            mu_w(j,k) = 0.0
          END IF
       END DO
    END DO
    
! Similar to Standard but thinner -----------------------------------------------------------
  CASE(custom_vert_damp_prof)

    eta_s = eg_damp_eta_start
    
    recip_one_m_etas = 1.0/(1.0-eta_s)
    
    DO k=1, nheights
       DO j=1, nlats
          
          eta_jk = (height_grid(k)-planet_radius)                &
               /height_domain
          
          IF (eta_jk>eta_s) THEN
             mu_w(j,k) = eg_vert_damp_coeff                          &
                  * SIN( 0.5*pi*(eta_jk-eta_s)                &
                  *recip_one_m_etas)**2.0
             
          ELSE
             mu_w(j,k) = 0.0
          END IF
          
       END DO
    END DO
 
! Polar damping ------------------------------------------------------

  CASE(polar_damp_prof) 

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=1, nheights
      DO j=1, nlats
         eta_jk = (height_grid(k)-planet_radius)                &
              /height_domain


          ! add polar dip

         cos_lat = cos(lat_grid(j))
         eta_jk = cos_lat*eta_jk+(1.0-cos_lat)
         
         IF (eta_jk>eta_s) THEN
            mu_w(j,k) = eg_vert_damp_coeff                          &
                 * SIN( 0.5*pi*(eta_jk-eta_s)                &
                 *recip_one_m_etas)**2.0
          ELSE
             mu_w(j,k) = 0.0
          END IF
          
       END DO
    END DO

! Polar damping 2 ----------------------------------------------------

  CASE(polar_damp_prof2) 

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=1, nheights
      DO j=1, nlats

         eta_jk = (height_grid(k)-planet_radius)                &
              /height_domain
         

          ! add polar dip

          cos_lat = cos(lat_grid(j))
          eta_jk = cos_lat*eta_jk+(1.0-cos_lat)

          IF (eta_jk>eta_s) THEN
             mu_w(j,k) = eg_vert_damp_coeff                          &
                  * (  SIN( 0.5*pi*(eta_jk-eta_s)             &
                  *recip_one_m_etas)**2.0             &
                  + SIN(lat_grid(j))**40.0                     &
                  )     
          ELSE
             mu_w(j,k) = 0.0
          END IF

        END DO
    END DO


GOT HERE


  CASE(polar_damp_prof2_NP) 

    eta_s = 0.75

    recip_one_m_etas = 1./(1.-eta_s)

    DO k=wdims%k_start,wdims%k_end
      DO j=wdims%j_start,wdims%j_end
        DO i=wdims%i_start,wdims%i_end

          eta_ijk = (xi3_at_theta(i,j,k)-earth_radius)                &
                         /height_domain


          ! add polar dip (North pole only)

          IF (xi2_p(j)>0.0) THEN
            cos_xi2 = cos(xi2_p(j))
            eta_ijk = cos_xi2*eta_ijk+(1.-cos_xi2)

            IF (eta_ijk>eta_s) THEN
              mu_w(i,j,k) = eg_vert_damp_coeff                        &
                         * (  SIN( 0.5*pi*(eta_ijk-eta_s)             &
                                  *recip_one_m_etas)**2.              &
                            + SIN(xi2_p(j))**40.                      &
                           )                                          &
                         * timestep

            ELSE
              mu_w(i,j,k) = 0.
            END IF
          ELSE
            eta_ijk = eta_ijk

            IF (eta_ijk>eta_s) THEN
              mu_w(i,j,k) = eg_vert_damp_coeff                        &
                         * (  SIN( 0.5*pi*(eta_ijk-eta_s)             &
                                  *recip_one_m_etas)**2.              &
                           )                                          &
                         * timestep

            ELSE
              mu_w(i,j,k) = 0.
            END IF
          END IF

        END DO
      END DO
    END DO

  CASE(polar_damp_prof2_narrow) 

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=wdims%k_start,wdims%k_end
      DO j=wdims%j_start,wdims%j_end
        DO i=wdims%i_start,wdims%i_end

          eta_ijk = (xi3_at_theta(i,j,k)-earth_radius)                &
                         /height_domain


          ! add polar dip

          cos_xi2 = cos(xi2_p(j))
          eta_ijk = cos_xi2*eta_ijk+(1.0-cos_xi2)

          cutoff_deg = 87.0
          cutoff_rad = cutoff_deg/180.*pi

          cutoff = 0.0

          IF ( ABS(xi2_p(j)) > cutoff_rad ) THEN

            cutoff = 1.0-cos(ABS(xi2_p(j)-cutoff_rad)/                &
                     (0.5*pi-cutoff_rad)*0.5*pi)**20

          END IF

          IF (eta_ijk>eta_s) THEN
            mu_w(i,j,k) = eg_vert_damp_coeff                          &
                         * (  SIN( 0.5*pi*(eta_ijk-eta_s)             &
                                  *recip_one_m_etas)**2.0             &
                            + cutoff                                  &
                           )                                          &
                         * timestep

          ELSE
            mu_w(i,j,k) = 0.0
          END IF

        END DO
      END DO
    END DO

  CASE(polar_damp_prof2_extra_narrow) 

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=wdims%k_start,wdims%k_end
      DO j=wdims%j_start,wdims%j_end
        DO i=wdims%i_start,wdims%i_end

          eta_ijk = (xi3_at_theta(i,j,k)-earth_radius)                &
                         /height_domain


          ! add polar dip

          cos_xi2 = cos(xi2_p(j))**.46
          eta_ijk = cos_xi2*eta_ijk+(1.0-cos_xi2)

          cutoff_deg = 87.0
          cutoff_rad = cutoff_deg/180.*pi

          cutoff = 0.0

          IF ( ABS(xi2_p(j)) > cutoff_rad ) THEN

            cutoff = 1.0-cos(ABS(xi2_p(j)-cutoff_rad)/                &
                     (0.5*pi-cutoff_rad)*0.5*pi)**20

          END IF

          IF (eta_ijk>eta_s) THEN
            mu_w(i,j,k) = eg_vert_damp_coeff                          &
                         * (  SIN( 0.5*pi*(eta_ijk-eta_s)             &
                                  *recip_one_m_etas)**2.0             &
                            + cutoff                                  &
                           )                                          &
                         * timestep

          ELSE
            mu_w(i,j,k) = 0.0
          END IF

        END DO
      END DO
    END DO

  CASE(polar_damp_prof3) 

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=wdims%k_start,wdims%k_end
      DO j=wdims%j_start,wdims%j_end
        DO i=wdims%i_start,wdims%i_end

          eta_ijk = (xi3_at_theta(i,j,k)-earth_radius)                &
                         /height_domain

          IF (eta_ijk>eta_s) THEN
            mu_w(i,j,k) = eg_vert_damp_coeff                          &
                         * (  SIN( 0.5*pi*(eta_ijk-eta_s)             &
                                  *recip_one_m_etas)**2.0             &
                           )                                          &
                         * timestep

          ELSE
            mu_w(i,j,k) = 0.0
          END IF

          mu_w(i,j,k) = mu_w(i,j,k) + eg_vert_damp_coeff              &
                            * SIN(xi2_p(j))**40.0                     &
                            * timestep

        END DO
      END DO
    END DO

! Constant -----------------------------------------------------------

  CASE(const_damp_prof) 

    eta_s = 0.75

    recip_one_m_etas = 1.0/(1.0-eta_s)

    DO k=wdims%k_start,wdims%k_end
      DO j=wdims%j_start,wdims%j_end
        DO i=wdims%i_start,wdims%i_end

           mu_w(i,j,k) = eg_vert_damp_coeff  * timestep

        END DO
      END DO
    END DO

  CASE default

    WRITE(message,*)  'vertical damping profile unknown'

    ErrorStatus = ABS (eg_vert_damp_profile)

    CALL ereport(RoutineName,ErrorStatus,message)

END SELECT

! Now set the start position to that actually used
 eg_damp_eta_start=eta_s






end program sponge

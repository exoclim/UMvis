module constants

IMPLICIT NONE
REAL, PARAMETER :: p_zero=220.0e5, recip_kappa=1.0/0.321
REAL, PARAMETER :: Earth_Radius=9.44e7
REAL, PARAMETER :: Cp=14308.4, kappa=0.321, R=4593.0
REAL, PARAMETER :: g=9.42
REAL, PARAMETER :: pi=4.0*atan(1.0)

! SIZE OF ARRAYS:

type dimen
   INTEGER :: i_start, i_end
   INTEGER :: j_start, j_end
   INTEGER :: k_start, k_end
end type dimen

type(dimen) :: tdims_s
type(dimen) :: tdims
type(dimen) :: pdims_s

INTEGER, PARAMETER :: tf_none=0, tf_HeldSuarez=1, tf_TLE=2, tf_EL=3 
INTEGER, PARAMETER :: tf_SHJ=4, tf_Jupiter=5, tf_HD209458b_Heng=6
INTEGER, PARAMETER :: tf_HD209458b_Heng_smooth=7
INTEGER, PARAMETER :: tf_HD209458b_iro=8
INTEGER, PARAMETER :: tf_HD189733b_Showman=9
INTEGER, PARAMETER :: tf_isothermal=100
INTEGER, PARAMETER :: tr_none=0, tr_HeldSuarez=1, tr_EL=2, tr_SHJ=3
INTEGER, PARAMETER :: tr_Jupiter=4, tr_HD209458b_Iro=5
INTEGER, PARAMETER :: tr_HD209458b_Showman=6, tr_HD189733b_Showman=7

! Spatial variables
!Cos(longitude)
REAL, DIMENSION(:), ALLOCATABLE :: Csxi1_p
! Cos(latitude)
REAL, DIMENSION(:), ALLOCATABLE :: Csxi2_p
! Sin(latitude)
REAL, DIMENSION(:), ALLOCATABLE :: Snxi2_p
! R, height from centre of Planet
REAL, DIMENSION(:,:,:), ALLOCATABLE :: r_theta_levels

INTEGER :: TIMESTEP

contains

  subroutine set_size()

  tdims_s%i_start=1
  tdims_s%i_end=144
  tdims_s%j_start=1
  tdims_s%j_end=90
  tdims_s%k_start=1
  tdims_s%k_end=200
  tdims%i_start=1
  tdims%i_end=144
  tdims%j_start=1
  tdims%j_end=90
  tdims%k_start=1
  tdims%k_end=200
  pdims_s%i_start=1
  pdims_s%i_end=144
  pdims_s%j_start=1
  pdims_s%j_end=90
  pdims_s%k_start=1
  pdims_s%k_end=200

  IF (ALLOCATED(Csxi1_p)) DEALLOCATE(Csxi1_p)
  ALLOCATE(Csxi1_p(pdims_s%i_start:pdims_s%i_end))
  IF (ALLOCATED(Csxi2_p)) DEALLOCATE(Csxi2_p)
  ALLOCATE(Csxi2_p(pdims_s%j_start:pdims_s%j_end))
  IF (ALLOCATED(Snxi2_p)) DEALLOCATE(Snxi2_p)
  ALLOCATE(Snxi2_p(pdims_s%j_start:pdims_s%j_end))
  IF (ALLOCATED(r_theta_levels)) DEALLOCATE(r_theta_levels)
  ALLOCATE(r_theta_levels(pdims_s%i_start:pdims_s%i_end,               &
     pdims_s%j_start:pdims_s%j_end,                                 &
     pdims_s%k_start:pdims_s%k_end))
end subroutine set_size
end module constants

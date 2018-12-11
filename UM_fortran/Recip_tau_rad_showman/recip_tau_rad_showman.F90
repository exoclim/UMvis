real function recip_tau_rad_showman(temperature, pressure_pa, planet)
implicit none
  ! A Function which called with a temperature and pressure in Kelvin 
  ! and Pascals (pressure_pa), 
  ! returns a newtonian timescale in Seconds
  ! pressure=Converted to bar
  real :: temperature, pressure, pressure_pa
  ! which planet? HD209458b or HD189733b
  character(len=*) :: planet
  integer :: n_press
  real, dimension(:), allocatable :: p_bar
  integer :: n_temp
  real, dimension(:), allocatable :: T_kelvin
  real, dimension(:,:), allocatable :: recip_tau_rad
  integer :: i
  ! Interpolation variables
  real :: diff_p, diff_T, eta_T, eta_p
  real  :: p_bot, p_top, T_bot, T_top
  integer :: p_loc, p_inc, T_loc, T_inc
  real, dimension(2) :: interp_T

  ! Convert pressure from Pa to bar
  pressure=pressure_pa*1.0e-5
  ! Now setup the arrays
  if (trim(planet) == 'HD209458b') then
     n_press=21
     n_temp=10
     allocate(T_kelvin(n_temp),p_bar(n_press),&
          recip_tau_rad(n_temp,n_press))
     ! Initialise
     recip_tau_rad(:,:)=0.0
     ! The timescale table from Showman et al (2008)
     p_bar(1)=0.00066
     p_bar(2)=0.00110
     p_bar(3)=0.00182
     p_bar(4)=0.00302
     p_bar(5)=0.00501
     p_bar(6)=0.00832
     p_bar(7)=0.01380
     p_bar(8)=0.02291
     p_bar(9)=0.03802
     p_bar(10)=0.06310
     p_bar(11)=0.10471
     p_bar(12)=0.17378
     p_bar(13)=0.28840
     p_bar(14)=0.47863
     p_bar(15)=0.79433
     p_bar(16)=1.31826
     p_bar(17)=2.18776
     p_bar(18)=3.63078
     p_bar(19)=6.02560
     p_bar(20)=10.00000
     p_bar(21)=16.59590
     do i=1, n_temp
        T_kelvin(i)=400.0+(i-1)*200.0
     end do
     !400K
     recip_tau_rad(1,1)=1.0/6.05e5
     recip_tau_rad(1,2)=1.0/6.16e5
     recip_tau_rad(1,3)=1.0/5.99e5
     recip_tau_rad(1,4)=1.0/5.20e5
     recip_tau_rad(1,5)=1.0/4.49e5
     recip_tau_rad(1,6)=1.0/4.20e5
     recip_tau_rad(1,7)=1.0/4.21e5
     recip_tau_rad(1,8)=1.0/4.57e5
     recip_tau_rad(1,9)=1.0/5.49e5
     recip_tau_rad(1,10)=1.0/6.72e5
     recip_tau_rad(1,11)=1.0/7.98e5
     recip_tau_rad(1,12)=1.0/8.85e5
     recip_tau_rad(1,13)=1.0/9.35e5
     recip_tau_rad(1,14)=1.0/9.14e5
     !600K
     recip_tau_rad(2,1)=1.0/1.16e4
     recip_tau_rad(2,2)=1.0/1.51e4
     recip_tau_rad(2,3)=1.0/1.99e4
     recip_tau_rad(2,4)=1.0/2.69e4
     recip_tau_rad(2,5)=1.0/3.51e4
     recip_tau_rad(2,6)=1.0/4.75e4
     recip_tau_rad(2,7)=1.0/6.34e4
     recip_tau_rad(2,8)=1.0/8.48e4
     recip_tau_rad(2,9)=1.0/1.16e5
     recip_tau_rad(2,10)=1.0/2.45e5
     recip_tau_rad(2,11)=1.0/4.16e5
     recip_tau_rad(2,12)=1.0/5.81e5
     recip_tau_rad(2,13)=1.0/7.01e5
     recip_tau_rad(2,14)=1.0/7.71e5
     !800K
     recip_tau_rad(3,1)=1.0/6.36e3
     recip_tau_rad(3,2)=1.0/8.24e3
     recip_tau_rad(3,3)=1.0/1.03e4
     recip_tau_rad(3,4)=1.0/1.30e4
     recip_tau_rad(3,5)=1.0/1.56e4
     recip_tau_rad(3,6)=1.0/1.97e4
     recip_tau_rad(3,7)=1.0/2.59e4
     recip_tau_rad(3,8)=1.0/3.37e4
     recip_tau_rad(3,9)=1.0/4.72e4
     recip_tau_rad(3,10)=1.0/8.12e4
     recip_tau_rad(3,11)=1.0/1.45e5
     recip_tau_rad(3,12)=1.0/2.76e5
     recip_tau_rad(3,13)=1.0/4.67e5
     recip_tau_rad(3,14)=1.0/6.28e5
     recip_tau_rad(3,15)=1.0/1.02e6
     !1000K
     recip_tau_rad(4,1)=1.0/4.85e3
     recip_tau_rad(4,2)=1.0/6.50e3
     recip_tau_rad(4,3)=1.0/8.10e3
     recip_tau_rad(4,4)=1.0/1.05e4
     recip_tau_rad(4,5)=1.0/1.21e4
     recip_tau_rad(4,6)=1.0/1.50e4
     recip_tau_rad(4,7)=1.0/1.78e4
     recip_tau_rad(4,8)=1.0/2.29e4
     recip_tau_rad(4,9)=1.0/2.84e4
     recip_tau_rad(4,10)=1.0/3.52e4
     recip_tau_rad(4,11)=1.0/5.89e4
     recip_tau_rad(4,12)=1.0/1.33e5
     recip_tau_rad(4,13)=1.0/2.51e5
     recip_tau_rad(4,14)=1.0/4.84e5
     recip_tau_rad(4,15)=1.0/9.15e5
     recip_tau_rad(4,16)=1.0/1.63e6
     recip_tau_rad(4,17)=1.0/3.02e6
     !1200K
     recip_tau_rad(5,1)=1.0/2.33e3
     recip_tau_rad(5,2)=1.0/2.99e3
     recip_tau_rad(5,3)=1.0/3.90e3
     recip_tau_rad(5,4)=1.0/5.12e3
     recip_tau_rad(5,5)=1.0/6.36e3
     recip_tau_rad(5,6)=1.0/8.58e3
     recip_tau_rad(5,7)=1.0/1.07e4
     recip_tau_rad(5,8)=1.0/1.52e4
     recip_tau_rad(5,9)=1.0/1.82e4
     recip_tau_rad(5,10)=1.0/2.49e4
     recip_tau_rad(5,11)=1.0/3.45e4
     recip_tau_rad(5,12)=1.0/5.60e4
     recip_tau_rad(5,13)=1.0/1.04e5
     recip_tau_rad(5,14)=1.0/2.40e5
     recip_tau_rad(5,15)=1.0/6.17e5
     recip_tau_rad(5,16)=1.0/1.50e6
     recip_tau_rad(5,17)=1.0/2.99e6
     recip_tau_rad(5,18)=1.0/5.79e6
     !1400K
     recip_tau_rad(6,1)=1.0/1.19e3
     recip_tau_rad(6,2)=1.0/1.56e3
     recip_tau_rad(6,3)=1.0/2.03e3
     recip_tau_rad(6,4)=1.0/2.76e3
     recip_tau_rad(6,5)=1.0/3.49e3
     recip_tau_rad(6,6)=1.0/4.80e3
     recip_tau_rad(6,7)=1.0/6.39e3
     recip_tau_rad(6,8)=1.0/9.13e3
     recip_tau_rad(6,9)=1.0/1.26e4
     recip_tau_rad(6,10)=1.0/1.77e4
     recip_tau_rad(6,11)=1.0/2.61e4
     recip_tau_rad(6,12)=1.0/4.03e4
     recip_tau_rad(6,13)=1.0/6.93e4
     recip_tau_rad(6,14)=1.0/1.30e5
     recip_tau_rad(6,15)=1.0/2.91e5
     recip_tau_rad(6,16)=1.0/6.82e5
     recip_tau_rad(6,17)=1.0/1.76e6
     recip_tau_rad(6,18)=1.0/4.59e6
     recip_tau_rad(6,19)=1.0/8.87e6
     !1600K
     recip_tau_rad(7,1)=1.0/7.38e2
     recip_tau_rad(7,2)=1.0/9.47e2
     recip_tau_rad(7,3)=1.0/1.24e3
     recip_tau_rad(7,4)=1.0/1.68e3
     recip_tau_rad(7,5)=1.0/2.14e3
     recip_tau_rad(7,6)=1.0/2.89e3
     recip_tau_rad(7,7)=1.0/3.96e3
     recip_tau_rad(7,8)=1.0/5.57e3
     recip_tau_rad(7,9)=1.0/7.14e3
     recip_tau_rad(7,10)=1.0/1.03e4
     recip_tau_rad(7,11)=1.0/1.61e4
     recip_tau_rad(7,12)=1.0/2.69e4
     recip_tau_rad(7,13)=1.0/4.76e4
     recip_tau_rad(7,14)=1.0/9.06e4
     recip_tau_rad(7,15)=1.0/1.82e5
     recip_tau_rad(7,16)=1.0/4.03e5
     recip_tau_rad(7,17)=1.0/1.00e6
     recip_tau_rad(7,18)=1.0/2.61e6
     recip_tau_rad(7,19)=1.0/8.06e6
     !1800K
     recip_tau_rad(8,1)=1.0/5.40e2
     recip_tau_rad(8,2)=1.0/6.60e2
     recip_tau_rad(8,3)=1.0/8.52e2
     recip_tau_rad(8,4)=1.0/1.15e3
     recip_tau_rad(8,5)=1.0/1.52e3
     recip_tau_rad(8,6)=1.0/2.12e3
     recip_tau_rad(8,7)=1.0/2.85e3
     recip_tau_rad(8,8)=1.0/3.93e3
     recip_tau_rad(8,9)=1.0/5.39e3
     recip_tau_rad(8,10)=1.0/7.87e3
     recip_tau_rad(8,11)=1.0/1.17e4
     recip_tau_rad(8,12)=1.0/1.92e4
     recip_tau_rad(8,13)=1.0/3.52e4
     recip_tau_rad(8,14)=1.0/6.68e4
     recip_tau_rad(8,15)=1.0/1.32e5
     recip_tau_rad(8,16)=1.0/3.00e5
     recip_tau_rad(8,17)=1.0/7.67e5
     recip_tau_rad(8,18)=1.0/2.06e6
     recip_tau_rad(8,19)=1.0/6.51e6
     recip_tau_rad(8,20)=1.0/2.21e7
     !2000K
     recip_tau_rad(9,1)=1.0/4.38e2
     recip_tau_rad(9,2)=1.0/5.04e2
     recip_tau_rad(9,3)=1.0/6.47e2
     recip_tau_rad(9,4)=1.0/8.72e2
     recip_tau_rad(9,5)=1.0/1.21e3
     recip_tau_rad(9,6)=1.0/1.85e3
     recip_tau_rad(9,7)=1.0/2.59e3
     recip_tau_rad(9,8)=1.0/3.49e3
     recip_tau_rad(9,9)=1.0/4.79e3
     recip_tau_rad(9,10)=1.0/6.97e3
     recip_tau_rad(9,11)=1.0/1.01e4
     recip_tau_rad(9,12)=1.0/1.69e4
     recip_tau_rad(9,13)=1.0/2.67e4
     recip_tau_rad(9,14)=1.0/4.92e4
     recip_tau_rad(9,15)=1.0/1.03e5
     recip_tau_rad(9,16)=1.0/2.43e5
     recip_tau_rad(9,17)=1.0/6.93e5
     recip_tau_rad(9,18)=1.0/1.70e6
     recip_tau_rad(9,19)=1.0/6.19e6
     recip_tau_rad(9,20)=1.0/2.17e7
     recip_tau_rad(9,21)=1.0/7.01e7
     !2200K
     recip_tau_rad(10,1)=1.0/3.83e2
     recip_tau_rad(10,2)=1.0/4.11e2
     recip_tau_rad(10,3)=1.0/5.25e2
     recip_tau_rad(10,4)=1.0/7.11e2
     recip_tau_rad(10,5)=1.0/1.04e3
     recip_tau_rad(10,6)=1.0/1.82e3
     recip_tau_rad(10,7)=1.0/2.72e3
     recip_tau_rad(10,8)=1.0/3.66e3
     recip_tau_rad(10,9)=1.0/5.06e3
     recip_tau_rad(10,10)=1.0/7.42e3
     recip_tau_rad(10,11)=1.0/1.09e4
     recip_tau_rad(10,12)=1.0/1.77e4
     recip_tau_rad(10,13)=1.0/2.89e4
     recip_tau_rad(10,14)=1.0/4.82e4
     recip_tau_rad(10,15)=1.0/1.28e5
     recip_tau_rad(10,16)=1.0/5.90e5
     recip_tau_rad(10,17)=1.0/7.37e5
     recip_tau_rad(10,18)=1.0/1.66e6
     recip_tau_rad(10,19)=1.0/8.65e6
     recip_tau_rad(10,20)=1.0/3.60e7
     recip_tau_rad(10,21)=1.0/9.39e7
  else if (trim(planet) == 'HD189733b') then
     n_press=28
     n_temp=9
     allocate(T_kelvin(n_temp),p_bar(n_press),&
          recip_tau_rad(n_temp,n_press))
     ! Initialise
     recip_tau_rad(:,:)=0.0
     ! Setup up data from Table in Showman et al (2008)
     p_bar(1)=0.00066
     p_bar(2)=0.00110
     p_bar(3)=0.00182
     p_bar(4)=0.00302
     p_bar(5)=0.00501
     p_bar(6)=0.00832
     p_bar(7)=0.01380
     p_bar(8)=0.02291
     p_bar(9)=0.03802
     p_bar(10)=0.06310
     p_bar(11)=0.10471
     p_bar(12)=0.17378
     p_bar(13)=0.28840
     p_bar(14)=0.47863
     p_bar(15)=0.79433
     p_bar(16)=1.31826
     p_bar(17)=2.18776
     p_bar(18)=3.63078
     p_bar(19)=6.02560
     p_bar(20)=10.00000
     p_bar(21)=16.59590
     p_bar(22)=27.54230
     p_bar(23)=45.70880
     p_bar(24)=75.85780
     p_bar(25)=125.89300
     p_bar(26)=208.92999
     p_bar(27)=346.73700
     p_bar(28)=575.44000
     do i=1, n_temp
        T_kelvin(i)=400.0+(i-1)*200.0
     end do
     ! 400K
     recip_tau_rad(1,1)=1.0/2.58e6
     recip_tau_rad(1,2)=1.0/1.87e6
     recip_tau_rad(1,3)=1.0/1.53e6
     recip_tau_rad(1,4)=1.0/1.11e6
     recip_tau_rad(1,5)=1.0/9.54e5 
     recip_tau_rad(1,6)=1.0/1.05e6
     recip_tau_rad(1,7)=1.0/1.34e6
     recip_tau_rad(1,8)=1.0/1.78e6
     recip_tau_rad(1,9)=1.0/1.86e6
     recip_tau_rad(1,10)=1.0/2.22e6
     recip_tau_rad(1,11)=1.0/2.55e6
     recip_tau_rad(1,12)=1.0/3.55e6
     recip_tau_rad(1,13)=1.0/4.55e6
     recip_tau_rad(1,14)=1.0/5.60e6
     recip_tau_rad(1,15)=1.0/6.64e6
     recip_tau_rad(1,16)=1.0/7.61e6
     recip_tau_rad(1,17)=1.0/9.59e6
     recip_tau_rad(1,18)=1.0/2.52e7
     recip_tau_rad(1,19)=1.0/5.96e7
     recip_tau_rad(1,20)=1.0/1.67e8
     ! 600K
     recip_tau_rad(2,1)=1.0/7.40e3
     recip_tau_rad(2,2)=1.0/9.32e3
     recip_tau_rad(2,3)=1.0/1.19e4
     recip_tau_rad(2,4)=1.0/1.54e4
     recip_tau_rad(2,5)=1.0/1.94e4
     recip_tau_rad(2,6)=1.0/2.54e4
     recip_tau_rad(2,7)=1.0/3.27e4
     recip_tau_rad(2,8)=1.0/4.30e4
     recip_tau_rad(2,9)=1.0/5.77e4
     recip_tau_rad(2,10)=1.0/8.71e4
     recip_tau_rad(2,11)=1.0/1.44e5
     recip_tau_rad(2,12)=1.0/2.43e5
     recip_tau_rad(2,13)=1.0/7.25e5
     recip_tau_rad(2,14)=1.0/2.17e6
     recip_tau_rad(2,15)=1.0/3.78e6
     recip_tau_rad(2,16)=1.0/5.50e6
     recip_tau_rad(2,17)=1.0/7.73e6
     recip_tau_rad(2,18)=1.0/2.03e7
     recip_tau_rad(2,19)=1.0/5.22e7
     recip_tau_rad(2,20)=1.0/1.61e8
     recip_tau_rad(2,21)=1.0/4.91e8
     recip_tau_rad(2,22)=1.0/1.80e9
     ! 800K
     recip_tau_rad(3,1)=1.0/4.84e3
     recip_tau_rad(3,2)=1.0/6.48e3
     recip_tau_rad(3,3)=1.0/8.42e3
     recip_tau_rad(3,4)=1.0/1.07e4
     recip_tau_rad(3,5)=1.0/1.22e4
     recip_tau_rad(3,6)=1.0/1.42e4
     recip_tau_rad(3,7)=1.0/1.69e4
     recip_tau_rad(3,8)=1.0/2.05e4
     recip_tau_rad(3,9)=1.0/2.56e4
     recip_tau_rad(3,10)=1.0/3.64e4
     recip_tau_rad(3,11)=1.0/5.11e4
     recip_tau_rad(3,12)=1.0/1.03e5
     recip_tau_rad(3,13)=1.0/2.40e5
     recip_tau_rad(3,14)=1.0/4.30e5
     recip_tau_rad(3,15)=1.0/9.20e5
     recip_tau_rad(3,16)=1.0/3.39e6
     recip_tau_rad(3,17)=1.0/5.87e6
     recip_tau_rad(3,18)=1.0/1.47e7
     recip_tau_rad(3,19)=1.0/3.82e7
     recip_tau_rad(3,20)=1.0/1.15e8
     recip_tau_rad(3,21)=1.0/3.83e8
     recip_tau_rad(3,22)=1.0/1.70e9
     recip_tau_rad(3,23)=1.0/4.97e9
     ! 1000K
     recip_tau_rad(4,1)=1.0/3.33e3
     recip_tau_rad(4,2)=1.0/4.25e3
     recip_tau_rad(4,3)=1.0/5.44e3
     recip_tau_rad(4,4)=1.0/7.13e3
     recip_tau_rad(4,5)=1.0/8.34e3
     recip_tau_rad(4,6)=1.0/1.01e4
     recip_tau_rad(4,7)=1.0/1.14e4
     recip_tau_rad(4,8)=1.0/1.27e4
     recip_tau_rad(4,9)=1.0/1.44e4
     recip_tau_rad(4,10)=1.0/2.08e4
     recip_tau_rad(4,11)=1.0/3.02e4
     recip_tau_rad(4,12)=1.0/5.55e4
     recip_tau_rad(4,13)=1.0/1.00e5
     recip_tau_rad(4,14)=1.0/2.33e5
     recip_tau_rad(4,15)=1.0/5.28e5
     recip_tau_rad(4,16)=1.0/1.47e6
     recip_tau_rad(4,17)=1.0/4.02e6
     recip_tau_rad(4,18)=1.0/9.04e6
     recip_tau_rad(4,19)=1.0/2.42e7
     recip_tau_rad(4,20)=1.0/6.87e7
     recip_tau_rad(4,21)=1.0/2.20e8
     recip_tau_rad(4,22)=1.0/8.98e8
     recip_tau_rad(4,23)=1.0/3.54e9
     recip_tau_rad(4,24)=1.0/9.04e9
     recip_tau_rad(4,25)=1.0/1.02e10
     ! 1200K
     recip_tau_rad(5,1)=1.0/1.61e3
     recip_tau_rad(5,2)=1.0/2.08e3
     recip_tau_rad(5,3)=1.0/2.65e3
     recip_tau_rad(5,4)=1.0/3.43e3
     recip_tau_rad(5,5)=1.0/4.26e3
     recip_tau_rad(5,6)=1.0/5.50e3
     recip_tau_rad(5,7)=1.0/6.79e3
     recip_tau_rad(5,8)=1.0/8.95e3
     recip_tau_rad(5,9)=1.0/1.12e4
     recip_tau_rad(5,10)=1.0/1.39e4
     recip_tau_rad(5,11)=1.0/1.76e4
     recip_tau_rad(5,12)=1.0/2.74e4
     recip_tau_rad(5,13)=1.0/5.43e4
     recip_tau_rad(5,14)=1.0/9.63e4
     recip_tau_rad(5,15)=1.0/2.15e5
     recip_tau_rad(5,16)=1.0/5.06e5
     recip_tau_rad(5,17)=1.0/1.34e6
     recip_tau_rad(5,18)=1.0/3.74e6
     recip_tau_rad(5,19)=1.0/9.70e6
     recip_tau_rad(5,20)=1.0/2.72e7
     recip_tau_rad(5,21)=1.0/8.97e7
     recip_tau_rad(5,22)=1.0/3.25e8
     recip_tau_rad(5,23)=1.0/1.23e9
     recip_tau_rad(5,24)=1.0/4.69e9
     recip_tau_rad(5,25)=1.0/1.03e10 
     recip_tau_rad(5,26)=1.0/9.10e9
     ! 1400K
     recip_tau_rad(6,1)=1.0/7.84e2
     recip_tau_rad(6,2)=1.0/1.03e3
     recip_tau_rad(6,3)=1.0/1.34e3
     recip_tau_rad(6,4)=1.0/1.78e3
     recip_tau_rad(6,5)=1.0/2.28e3
     recip_tau_rad(6,6)=1.0/3.00e3
     recip_tau_rad(6,7)=1.0/3.82e3
     recip_tau_rad(6,8)=1.0/5.31e3
     recip_tau_rad(6,9)=1.0/7.00e3
     recip_tau_rad(6,10)=1.0/8.90e3
     recip_tau_rad(6,11)=1.0/1.33e4
     recip_tau_rad(6,12)=1.0/1.88e4
     recip_tau_rad(6,13)=1.0/3.01e4
     recip_tau_rad(6,14)=1.0/4.94e4
     recip_tau_rad(6,15)=1.0/1.03e5
     recip_tau_rad(6,16)=1.0/2.58e5
     recip_tau_rad(6,17)=1.0/6.56e5
     recip_tau_rad(6,18)=1.0/1.68e6
     recip_tau_rad(6,19)=1.0/4.37e6
     recip_tau_rad(6,20)=1.0/1.30e7
     recip_tau_rad(6,21)=1.0/4.55e7
     recip_tau_rad(6,22)=1.0/1.70e8
     recip_tau_rad(6,23)=1.0/6.43e8
     recip_tau_rad(6,24)=1.0/2.43e9
     recip_tau_rad(6,25)=1.0/8.99e9
     recip_tau_rad(6,26)=1.0/1.05e10
     ! 1600K
     recip_tau_rad(7,1)=1.0/4.25e2
     recip_tau_rad(7,2)=1.0/5.73e2
     recip_tau_rad(7,3)=1.0/7.58e2
     recip_tau_rad(7,4)=1.0/1.05e3
     recip_tau_rad(7,5)=1.0/1.35e3
     recip_tau_rad(7,6)=1.0/1.77e3
     recip_tau_rad(7,7)=1.0/2.25e3
     recip_tau_rad(7,8)=1.0/2.93e3
     recip_tau_rad(7,9)=1.0/3.94e3
     recip_tau_rad(7,10)=1.0/5.38e3
     recip_tau_rad(7,11)=1.0/7.97e3
     recip_tau_rad(7,12)=1.0/1.23e4
     recip_tau_rad(7,13)=1.0/1.97e4
     recip_tau_rad(7,14)=1.0/3.52e4
     recip_tau_rad(7,15)=1.0/6.57e4
     recip_tau_rad(7,16)=1.0/1.30e5
     recip_tau_rad(7,17)=1.0/2.89e5
     recip_tau_rad(7,18)=1.0/6.95e5
     recip_tau_rad(7,19)=1.0/1.87e6
     recip_tau_rad(7,20)=1.0/5.86e6
     recip_tau_rad(7,21)=1.0/2.18e7
     recip_tau_rad(7,22)=1.0/8.51e7
     recip_tau_rad(7,23)=1.0/3.31e8
     recip_tau_rad(7,24)=1.0/1.30e9
     recip_tau_rad(7,25)=1.0/5.10e9
     recip_tau_rad(7,26)=1.0/1.98e10
     recip_tau_rad(7,27)=1.0/9.19e9
     ! 1800K
     recip_tau_rad(8,1)=1.0/2.45e2
     recip_tau_rad(8,2)=1.0/3.38e2
     recip_tau_rad(8,3)=1.0/4.58e2
     recip_tau_rad(8,4)=1.0/6.66e2
     recip_tau_rad(8,5)=1.0/8.60e2
     recip_tau_rad(8,6)=1.0/1.11e3
     recip_tau_rad(8,7)=1.0/1.39e3
     recip_tau_rad(8,8)=1.0/1.67e3
     recip_tau_rad(8,9)=1.0/2.18e3
     recip_tau_rad(8,10)=1.0/3.12e3
     recip_tau_rad(8,11)=1.0/5.15e3
     recip_tau_rad(8,12)=1.0/8.52e3
     recip_tau_rad(8,13)=1.0/1.42e4
     recip_tau_rad(8,14)=1.0/2.58e4
     recip_tau_rad(8,15)=1.0/4.76e4
     recip_tau_rad(8,16)=1.0/9.42e4
     recip_tau_rad(8,17)=1.0/2.07e5
     recip_tau_rad(8,18)=1.0/5.34e5
     recip_tau_rad(8,19)=1.0/1.52e6
     recip_tau_rad(8,20)=1.0/5.08e6
     recip_tau_rad(8,21)=1.0/1.86e7
     recip_tau_rad(8,22)=1.0/6.80e7
     recip_tau_rad(8,23)=1.0/2.60e8
     recip_tau_rad(8,24)=1.0/1.02e9
     recip_tau_rad(8,25)=1.0/3.98e9
     recip_tau_rad(8,26)=1.0/1.51e10
     recip_tau_rad(8,27)=1.0/5.67e10
     recip_tau_rad(8,28)=1.0/1.54e10
     ! 2000K
     recip_tau_rad(8,1)=1.0/1.49e2
     recip_tau_rad(8,2)=1.0/2.09e2
     recip_tau_rad(8,3)=1.0/2.91e2
     recip_tau_rad(8,4)=1.0/4.48e2
     recip_tau_rad(8,5)=1.0/5.76e2
     recip_tau_rad(8,6)=1.0/7.24e2
     recip_tau_rad(8,7)=1.0/8.95e2
     recip_tau_rad(8,8)=1.0/9.79e2
     recip_tau_rad(8,9)=1.0/1.20e3
     recip_tau_rad(8,10)=1.0/1.80e3
     recip_tau_rad(8,11)=1.0/3.39e3
     recip_tau_rad(8,12)=1.0/6.20e3
     recip_tau_rad(8,13)=1.0/1.07e4
     recip_tau_rad(8,14)=1.0/2.02e4
     recip_tau_rad(8,15)=1.0/3.63e4
     recip_tau_rad(8,16)=1.0/7.01e4
     recip_tau_rad(8,17)=1.0/1.52e5
     recip_tau_rad(8,18)=1.0/4.36e5
     recip_tau_rad(8,19)=1.0/1.40e6
     recip_tau_rad(8,20)=1.0/5.59e6
     recip_tau_rad(8,21)=1.0/1.97e7
     recip_tau_rad(8,22)=1.0/6.68e7
     recip_tau_rad(8,23)=1.0/2.39e8
     recip_tau_rad(8,24)=1.0/8.98e8
     recip_tau_rad(8,25)=1.0/3.41e9
     recip_tau_rad(8,26)=1.0/1.32e10
     recip_tau_rad(8,27)=1.0/5.14e10
     recip_tau_rad(8,28)=1.0/1.30e11
  else
     print*, 'Planet:', trim(planet), ' not suported'
     stop
  endif
  ! Now handle the interpolation
  ! Find the closest pressure (whilst converting to bar)
  p_loc=minloc(abs(p_bar(:)-pressure),1)
  diff_p=pressure-p_bar(p_loc)
  ! Now the Temperature
  T_loc=minloc(abs(T_kelvin(:)-temperature),1)
  diff_T=temperature-T_kelvin(T_loc)
  ! Now we check if we are at the edges
  ! Pressure Limits First, over top or
  ! under bottom just use top or bottom value
  ! Otherwise Find interpolation point
  if (diff_p < 0.0) then
     if (p_loc == 1) then
        p_inc=0
     else
        p_inc=-1
     endif
  else if (diff_p > 0.0) then
     if (p_loc == n_press) then
        p_inc=0
     else
        p_inc=+1
     endif
  endif
  ! Same for temperature
  if (diff_T < 0.0) then
     if (T_loc == 1) then
        T_inc=0
     else
        T_inc=-1
     endif
  else if (diff_T > 0.0) then
     if (T_loc == n_temp) then
        T_inc=0
     else
        T_inc=+1
     endif
  endif
  ! Now perform the interpolation
  ! First interpolate for the pressure points at both
  ! bounding temperatures
  ! Pressure weighting
  if (p_inc == 0) then
     eta_p=0.5
  else
     if (p_inc == +1) then
        p_bot=p_bar(p_loc)
        p_top=p_bar(p_loc+p_inc)
     else if (p_inc == -1) then
        p_bot=p_bar(p_loc+p_inc)
        p_top=p_bar(p_loc)
     endif
     eta_p=(pressure-p_bot)/&
          (p_top-p_bot)
  endif

  ! Now interpolate for pressure
  if (p_inc == 0 .or. p_inc == +1) then
     interp_T(1)=(1.0-eta_p)*recip_tau_rad(T_loc,p_loc)+&
          eta_p*recip_tau_rad(T_loc,p_loc+p_inc)
     interp_T(2)=(1.0-eta_p)*recip_tau_rad(T_loc+T_inc,p_loc)+&
          eta_p*recip_tau_rad(T_loc+T_inc,p_loc+p_inc)
  else
     interp_T(1)=(1.0-eta_p)*recip_tau_rad(T_loc,p_loc+p_inc)+&
          eta_p*recip_tau_rad(T_loc,p_loc)
     interp_T(2)=(1.0-eta_p)*recip_tau_rad(T_loc+T_inc,p_loc+p_inc)+&
          eta_p*recip_tau_rad(T_loc+T_inc,p_loc)
  endif
  ! Temperature weightings
  if (T_inc == 0) then
     eta_T=0.5
  else
     if (T_inc == +1) then
        T_bot=T_kelvin(T_loc)
        T_top=T_kelvin(T_loc+T_inc)
     else if (T_inc == -1) then
        T_bot=T_kelvin(T_loc+T_inc)
        T_top=T_kelvin(T_loc)
     endif
     eta_T=(temperature-T_bot)/&
          (T_top-T_bot)
  endif
  ! Now interpolate for the Temperature
  if (T_inc == 0 .or. T_inc == +1) then
     recip_tau_rad_showman=(1.0-eta_T)*interp_T(1)+&
          eta_T*interp_T(2)
  else
     recip_tau_rad_showman=(1.0-eta_T)*interp_T(2)+&
          eta_T*interp_T(1)
  endif
     deallocate(T_kelvin,p_bar,recip_tau_rad)
  return
end function recip_tau_rad_showman

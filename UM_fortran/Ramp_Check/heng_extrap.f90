program heng_extrap
  ! This program is designed to check various extrapolations etc of the 
  ! Heng profiles
  use night
  use day
  use constants

  IMPLICIT NONE
  real, dimension(:), allocatable :: exner, press, temp
  real :: min_press, max_press, step
  integer :: n_press, ipress, choice, ios
  character(len=10000) :: output
  integer :: smooth, nsmooth, i
  character(len=100), dimension(:), allocatable :: smooth_type

  choice_do: do
     print*, 'Which profile would you like to see?'
     print*, '(1) Night side'
     print*, '(2) Day side'
     print*, '(3) Difference day-night'
     read(*,*) choice
     if (choice==1 .or. choice==2 .or. choice==3) exit choice_do
  end do choice_do

  nsmooth=5
  if (allocated(smooth_type)) deallocate(smooth_type)
  allocate(smooth_type(nsmooth))
  smooth_type(1)='None'
  smooth_type(2)='Exponential smoothing P>1.0e6Pa and P<100.0 (UM VERSION)'
  smooth_type(3)='Exponential smoothing P>1.0e6Pa and P<10.0 (UM VERSION)'
  smooth_type(4)='Exponential smoothing P>1.0e6Pa and P<1.0 (UM VERSION)'  
  smooth_type(5)='Exponential smoothing P>1.0e6Pa and P<0.1 (UM VERSION)'  

  smooth_do: do
     print*, 'Which smoothing profile would you like to see?'
     do i=0, nsmooth-1
        print*, i, smooth_type(i+1)
     end do
     read(*,*) smooth
     if (smooth >-1 .and. smooth <nsmooth) exit smooth_do
  end do smooth_do

  print*, 'Please enter a minimum and maximum pressure in Pa'
  read(*,*) min_press, max_press
  print*, 'And a number of pressure points(distributed in log space)'
  read(*,*) n_press
  if (allocated(press)) deallocate(press)
  if (allocated(temp)) deallocate(temp)
  if (allocated(exner)) deallocate(exner)
  allocate(exner(n_press),press(n_press))
  allocate(temp(n_press))

  step=(log10(max_press)-log10(min_press))/(n_press-1)

  print*, 'Enter a filename to store the output'
  read(*,'(a)') output
  open(unit=1, file=trim(output), iostat=ios)
  if (ios<0) then
     print*, 'Problem with this file'
     stop
  end if
  if (choice==1) write(1,*) 'Heng Night side profile'
  if (choice==2) write(1,*) 'Heng Day side profile'
  if (choice==3) write(1,*) 'Contrast Heng rofile'
  write(1,*) 
  write(1,*) 'Level, Pressure, Temperature, Exner Pressure, log(p(bar)), p(bar)'

  do ipress=1, n_press
     press(ipress)=10.0**(log10(max_press)-(ipress-1.0)*step)
     exner(ipress)=(press(ipress)/p_zero)**(1.0/recip_kappa)
     if (choice==1) temp(ipress)=hot_jup_night_temp(exner(ipress), smooth)
     if (choice==2) temp(ipress)=hot_jup_day_temp(exner(ipress), smooth)
     if (choice==3) THEN
        temp(ipress)=hot_jup_day_temp(exner(ipress), smooth)&
             -hot_jup_night_temp(exner(ipress), smooth)
     END IF
     write(1,*) ipress, press(ipress), temp(ipress), exner(ipress),&
          LOG10(press(ipress)/1.0e5), press(ipress)/1.0e5







  end do
  close(1)

end program heng_extrap

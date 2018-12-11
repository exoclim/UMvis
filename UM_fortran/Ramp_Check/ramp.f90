program ramp
use night
use day

implicit none

integer :: timestep_number
real :: timestep
real :: alpha
real :: heat_tscale
character(len=1000) :: output
integer :: i, ios
!variables to calculate temperatures
real :: exner
integer :: smooth, nsmooth
character(len=100), dimension(:), allocatable :: smooth_type
real :: T_night, T_day, T_diff, T_diff_max

print*, 'Please enter the timestep (in seconds)'
read(*,*) timestep
print*, 'Please enter the heat_tscale (in seconds)'
read(*,*) heat_tscale
print*, 'Please enter the current timestep_number'
read(*,*) timestep_number

print*, 'Current alpha value is:'

IF (timestep*timestep_number > heat_tscale) THEN
   alpha=1.0
ELSE 
   alpha=(timestep_number*timestep)/heat_tscale
END IF


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

print*, alpha
! 1e-6 bar =0.1 Pa
exner=(0.1/220e5)**0.321
T_night=hot_jup_night_temp(exner, smooth)
T_day=hot_jup_day_temp(exner, smooth)
T_diff_max=(T_night**4.0 + (T_day**4.0 - T_night**4.0))**0.25
print*, 'Maximum Temperature difference:', T_diff_max
T_diff=(T_night**4.0 + alpha * (T_day**4.0 - T_night**4.0))**0.25
print*, 'Current is:', T_diff

print*, 'Please enter a filename:'
read(*,'(a)') output

open(unit=1, file=trim(output), iostat=ios)
  if (ios<0) then
     print*, 'Problem with this file'
     stop
  end if



write(1,*) 'Ramp fraction over timescale:', heat_tscale, ' seconds'
write(1,*) ' up to timestep number:', timestep_number, ' using steps:', timestep
write(1,*) 'Columns are timestep, time(days), alpha, alpha**0.25, T_night(p=1e-6 bar), T_day(p=1e-6bar), T-diff (p=1e-6bar)'



do i=0, timestep_number
IF (i*timestep > heat_tscale) THEN
   alpha=1.0
ELSE 
   alpha=(timestep*i)/heat_tscale
END IF
write(1,*) i, (i*timestep/(60.0*60.0*24.0)), alpha, alpha**0.25,&
     T_diff

end do

close(1)



end program ramp

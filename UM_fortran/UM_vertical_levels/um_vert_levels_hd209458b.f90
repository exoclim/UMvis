program um_vert_levels_hd209458b
  ! This program constructs vertical levels based on 
  ! Prescribed sigma distribution and a sigma to altitude mapping
  use quad
  implicit none 

  real :: xval, yval
  real, dimension(:), allocatable :: x, y
  character(len=1) :: flag
  integer :: opt, ios, iread
  integer :: n_entries
  character(len=50) :: data_file
  real :: max_sig, min_sig, sig_sep, top_of_model_m, A, B, C
  integer :: n_sig, i, n, max
  real, allocatable, dimension(:) :: sigma, vert_m_rho
  real, allocatable, dimension(:) :: vert_m_theta, eta_rho, eta_theta
  character(len=100), allocatable, dimension(:) :: eta_rho_format, eta_theta_format
  character(len=100) :: write_string
  real :: test, eta, eta_hat
  logical :: smoothing
  smoothing=.true.

  if (smoothing) print*, 'WARNING: Smoothing model to integer values'
  print*, 'This program creates the sigma levels for HD209458b, using the prescription'
  print*, 'Of Heng et al (2011), Appendix A'
  print*, 'IT ACTUALLY WORKS IN PRESSURE:' 
  print*, 'Please enter A (0.1):'
  read(*,*) A
  print*, 'Please enter B (3,1,0.3):'
  read(*,*) B
  print*, 'Please enter C (12.7):'
  read(*,*) C
  print*, 'Now the number of Levels (i.e. theta, or rho+1)'
  read(*,*) n_sig
  allocate(sigma(n_sig))
  do i=1,n_sig
     eta=0.0+(i-0.99)/(n_sig-1.0)
     eta_hat=A*eta+(1.0-A)*(eta**B)
     sigma(i)=exp(-eta_hat*C)*220.0e5
  end do

  allocate(vert_m_rho(n_sig-1))
  allocate(vert_m_theta(n_sig))
  allocate(eta_rho(n_sig-1))
  allocate(eta_theta(n_sig))
  allocate(eta_theta_format(n_sig))
  allocate(eta_rho_format(n_sig-1))

  ! Now we need to read in the required conversions
  print*, 'Please enter the filename containing:'
  print*, 'X=Sigma, Y=Vertical Height (m)'
  print*, 'From which to interpolate'
  read(*,'(a)')data_file
  open(unit=1, file=trim(data_file), iostat=ios)
  if (ios<0) then
     print*, 'Problem with this file'
     stop
  end if
  ! Count entries
  n_entries=0
  count_do:  do 
     read(1,*,iostat=ios) test
     if (ios<0) exit count_do
     n_entries=n_entries+1
  end do count_do
  print*, 'Counted:', n_entries
  rewind(1)
  allocate(x(n_entries),y(n_entries))
  x=0
  y=0
  do iread=1, n_entries
     read(1,*) x(iread), y(iread)
  end do
  close(1)
  !Finally, do the interpolation
  ! But enforce the first level
  vert_m_theta(1)=0.0
  do i=2, n_sig
     if (sigma(i) <= maxval(x(:)) .and. sigma(i) >= minval(x(:))) then
        vert_m_theta(i)=nint(quadint(x, y, sigma(i), flag))
        if (flag=='1') then
           print*, 'Problem interpolating these values'
        end if
     else 
        print*, 'Attempting extrapolation for value:', sigma(i)
        print*, 'Where array max is:', maxval(x(:))
        print*, 'And array min is:', minval(x(:))
        ! dy/dx of top two points times by dx to the required point+ the
        ! last height
        vert_m_theta(i)=((y(n_entries)-y(n_entries-1))/(x(n_entries)-x(n_entries-1)))&
             *(sigma(i)-x(n_entries))+y(n_entries)
     end if
  end do
! Set the top of the model
  top_of_model_m=vert_m_theta(n_sig)
  ! Now calculate the rho levels and eta values
  ! The first level is set
  vert_m_rho(1)=0.5*vert_m_theta(2)
  do i=2, n_sig-1
     vert_m_rho(i)=0.5*(vert_m_theta(i)+vert_m_theta(i+1))
  end do
  ! Now calculate the eta values
  eta_rho=vert_m_rho/top_of_model_m
  eta_theta=vert_m_theta/top_of_model_m
  ! Create the etas in the required namelist format
  do i=1, n_sig-1
     write(eta_theta_format(i),'(f10.8)') eta_theta(i)
     write(eta_rho_format(i),'(f10.8)') eta_rho(i)
  end do
  write(eta_theta_format(n_sig),'(f10.8)') eta_theta(n_sig)
  ! Force first theta to be 0.0
  eta_theta(1)=0.0
  ! Now print
  print*, 'Please enter a file for the output:'
  read(*,'(a)') data_file
  open(unit=1, file=trim(data_file), iostat=ios)
  write(1,*) 'THETA LEVELS'
  do i=1, n_sig
     write(1,*) 'THETA Level:', i, ' Sigma:',sigma(i), &
          ' Height-Theta(m):', vert_m_theta(i), ' Eta-Theta:', eta_theta(i)
  end do
  write(1,*)
  write(1,*) 'RHO LEVELS'
  do i=1, n_sig-1
     write(1,*) 'RHO Level:', i, &
          ' Height-Rho(m):', vert_m_rho(i), ' Eta-Rho:', eta_rho(i)
  end do
  close(1)
  
  print*, 'Please enter a file the namelist format output:'
  read(*,'(a)') data_file
  open(unit=1, file=trim(data_file), iostat=ios)
  write(1,*) '&VERTLEVS'
  write(1,*)
  write(write_string,*) top_of_model_m
  write(1,*) ' z_top_of_model = ', trim(write_string),','
  write(write_string,*) n_sig-1
  write(1,*) ' first_constant_r_rho_level = ', trim(write_string), ','
  write(1,*) 'eta_theta='
  write_theta: do n=1, int(n_sig/5)+1
     max=5*n
     if (n==int(n_sig/5)+1) max=n_sig
     write(write_string,*) (trim(eta_theta_format(i)), ',', i=((n-1)*5)+1, max)
     write(1,*) trim(write_string)
  end do write_theta
  write(1,*) 'eta_rho='
  write_rho: do n=1, int((n_sig-1)/5)+1
     max=5*n
     if (n==int(n_sig/5)+1) max=n_sig-1
     write(write_string,*) (trim(eta_rho_format(i)), ',', i=((n-1)*5)+1, max)
     write(1,*) trim(write_string)
  end do write_rho


print*, 'The pressure at theta levels'
do i=1, n_sig
   if (i < n_sig .and. i >0) then
      print*, i, sigma(i)*220.0e5, vert_m_theta(i), (vert_m_theta(i+1)-vert_m_theta(i))/(vert_m_theta(i)-vert_m_theta(i-1))
else
      print*, i, sigma(i)*220.0e5, vert_m_theta(i)
endif

end do

  write(1,*) '/'
  close(1)
end program um_vert_levels_hd209458b

 
  

program uni_levels
  implicit none

  ! This software simply creates the file
  ! for eta values of uniform space levels

  real :: height_domain
  integer :: n_levs, i, ios, max, j
  real, dimension(:), allocatable :: eta_theta, eta_rho
  character(len=100) :: fname, write_string
  character(len=100), dimension(:), allocatable :: eta_format
  real :: step

  print*, 'Please enter the height of your domain'
  read(*,*) height_domain
  print*, 'Please enter the number of levels'
  read(*,*) n_levs

  allocate(eta_theta(n_levs+1),eta_rho(n_levs), eta_format(n_levs+1))

  eta_theta(1)=0.0
  step=1.0/n_levs
  do i=1, n_levs
     eta_theta(i+1)=step*real(i)
     eta_rho(i)=step/2.0+eta_theta(i)
  end do

  print*, 'Please enter the name of the output file'
  read(*,'(a)') fname

  open(unit=1, file=trim(fname), iostat=ios)
  if (ios<0) then
     print*, 'Problem opening:',trim(fname)
     stop
  end if

  write(1,*) '&VERTLEVS'
  write(1,*)
!  write(write_string,'(es10.1)') height_domain
  write(write_string,*) height_domain
  write(1,*) ' z_top_of_model = ', trim(write_string),','
  write(write_string,*) n_levs
  write(1,*) ' first_constant_r_rho_level = ', trim(write_string), ','
  write(1,*) 'eta_theta='
  do i=1, n_levs+1
!     write(eta_format(i),'(f8.6)') eta_theta(i)
     write(eta_format(i),*) eta_theta(i)
  end do
  do i=1, int((n_levs+1)/5)+1
     max=5*i
     if (i == int((n_levs+1)/5)+1) max=n_levs+1
     write(1,*) (trim(eta_format(j)), ',  ', j=5*(i-1)+1, max)
  end do
  write(1,*) 'eta_rho='
  do i=1, n_levs
!     write(eta_format(i),'(f8.6)') eta_rho(i)
     write(eta_format(i),*) eta_rho(i)
  end do
  write_rho: do i=1, int(n_levs/5)+1
     max=5*i
     if (i == int(n_levs/5)+1) max=n_levs
     write(1,*) (trim(eta_format(j)), ',  ', j=5*(i-1)+1, max)
  end do write_rho
  write(1,*) '/'
  close(1)

  ! Now print diagnostics
  print*, 'Derived Following Levels:'
  print*, 'Level, Theta Height, Rho Height, theta(K-K+1/K-K-1)'
  print*, '0 0 0 0'
  do i=2, n_levs+1
     if (i<n_levs+1) then
        print*, i-1, eta_theta(i)*height_domain, eta_rho(i-1)*height_domain&
             , (eta_theta(i+1)-eta_theta(i))/(eta_theta(i)-eta_theta(i-1))
     else
        print*, i-1, eta_theta(i)*height_domain, eta_rho(i-1)*height_domain, '0'
     endif
  end do


end program uni_levels

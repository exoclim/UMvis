program vert_nl
! This program reads in the levels from a vertical namelist and prints
! out their absolute value and d(eta)/dz values
! It also prints out the maximum vertical velocity for a given timestep
 
INTEGER, PARAMETER :: model_levels_max=200

! Lowest level where rho level has a constant radius,
! i.e. not terrain following
REAL :: first_constant_r_rho_level 
REAL :: z_top_of_model ! height (m)
REAL :: eta_theta (model_levels_max+1) ! Theta Levels (fraction)
REAL :: eta_rho (model_levels_max) ! Rho Levels (fraction)
INTEGER :: i, nlevels
CHARACTER(LEN=1000) :: fname, outname
REAL :: timestep

Namelist /VERTLEVS/&
     first_constant_r_rho_level, z_top_of_model, eta_theta, eta_rho

print*, 'Please enter the file name for the vertical level namelist:'
read(*,'(a)') fname
print*, 'Please enter the number of model levels'
read(*,*) nlevels

OPEN (10,file=fname)
READ (Unit = 10, nml=VERTLEVS)

print*, 'Please enter the used timestep in seconds'
read(*,*) timestep

print*, 'Please enter file name to store the eta output'
read(*,'(a)') outname
OPEN (11,file=outname)

write(11,*) 'Vertical Level (eta) structure from namelist: ', trim(fname) 
write(11,*) ' N levels=', nlevels
write(11,*) 'Level  eta_theta, d(eta)/dz, eta_rho, d(eta)/dz'
write(11,*) 1, eta_theta(1), eta_theta(1), &
        eta_rho(1), eta_rho(1)
do i=2, nlevels
   write(11,*) i, eta_theta(i), eta_theta(i)-eta_theta(i-1), &
        eta_rho(i), eta_rho(i)-eta_rho(i-1), &
        eta_rho(i)-eta_rho(i-1)/timestep
end do

close(10)
close(11)

print*, 'Please enter file name to store the distance and courant output'
read(*,'(a)') outname
OPEN (12,file=outname)

write(12,*) 'Vertical Level (distance) structure from namelist: ', trim(fname) 
write(12,*) ' N levels=', nlevels
write(12,*) 'Level  theta, d(theta)/dz, rho, d(rho)/dz, w_max(theta), w_max(rho)'
write(12,*) 1, eta_theta(1)*z_top_of_model, eta_theta(1)*z_top_of_model, &
        eta_rho(1)*z_top_of_model, eta_rho(1)*z_top_of_model,&
        eta_theta(1)*z_top_of_model/timestep, eta_rho(1)*z_top_of_model/timestep
do i=2, nlevels
   write(12,*) i, eta_theta(i)*z_top_of_model, (eta_theta(i)-eta_theta(i-1))*z_top_of_model, &
        eta_rho(i)*z_top_of_model, (eta_rho(i)-eta_rho(i-1))*z_top_of_model, &
        (eta_theta(i)-eta_theta(i-1))*z_top_of_model/timestep, &
        (eta_rho(i)-eta_rho(i-1))*z_top_of_model/timestep
end do




end program vert_nl

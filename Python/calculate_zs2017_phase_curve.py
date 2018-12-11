from scipy.interpolate import interp1d
from scipy.interpolate import interp2d
from pylab import *
import netCDF4 as nc
import sys

# Number of phase points
nphase = 100
# Latitude of observer
lat_obs = pi/2.
# Stefan-boltzmann
sigma = 5.670367e-8

def read_variable_4d(fname,varname):

  # Open netcdf file
  data = nc.Dataset(fname,'r')

  # Read variable dimensions
  dims      = data.variables[varname].dimensions
  time      = data.variables[dims[0]][:]
  height    = data.variables[dims[1]][:]
  latitude  = data.variables[dims[2]][:]
  longitude = data.variables[dims[3]][:]

  # Read variable
  variable = data.variables[varname][:,:,:,:]

  return time, height, longitude, latitude, variable

# Function to interpolate temperature onto pressure level
def interp_temp(nlat,nlon,temp_3d,pressure,plevel):

  # Define new 2D temperature array
  temp = np.zeros((nlat,nlon))
  
  # Loop over columns and interpolate temperature onto requested pressure level
  for i in range(nlat):
    for j in range(nlon):
      f = interp1d(pressure[:,i,j],temp_3d[:,i,j])
      temp[i,j] = f(plevel)
  
  return temp

# Function to calculate simple phase curve based on temperature 
# on a specific pressure level (Zhang & Showman 2017)
# Note: parts of this code are based on a similar calculation in ATMO
# originally written by DSA 
def calculate_zs17_phase_curve(fname, fname_out,time = 1000.,p_zero = 200e5,R = 3573.5,cp = 1.23e4,plevel=3000.,rp=1.45e7):

  time_um, height, longitude, latitude, pressure = read_variable_4d(fname,'p')
  time_um, height, longitude, latitude, potential_temperature = read_variable_4d(fname,'theta')
  
  itime = argmin(abs(time-time_um))
  potential_temperature = potential_temperature[itime,:,:,:]
  pressure = pressure[itime,:,:,:]
  
  flux = np.zeros(nphase)
  
  
  # Convert potential temperature to temperature
  temp_3d = potential_temperature/(p_zero/pressure)**(R/cp)
  
  # Adjust UM coordinates
  latitude = pi/2. - latitude
  latitude = latitude[::-1]
  temp_3d = temp_3d[:,::-1,:]
  pressure = pressure[:,::-1,:]
  
  
  # Number of latitude and longitude points in UM grid
  nlat = latitude.size
  nlon = longitude.size
  
  # Convert UM longitude and latitude into radians
  latitude = latitude*pi/180.
  longitude = longitude*pi/180.
  
  # Phase angle grid
  phase = linspace(0.,2*pi,nphase)
  
  # Create new latitude and longitude grid for integration
  phi_int = linspace(0.,2*pi,nlon)
  dphi = (2*pi-0.)/nlon
  theta_int = linspace(0.,pi/2.,nlat/2)
  dtheta = (pi/2.-0.)/(nlat/2)
  
  # Interpolate 3D temperature field into requested pressure level
  temp = interp_temp(nlat,nlon,temp_3d,pressure,plevel)
  
  # Loop over phase angle
  for i in range(nphase):
  
    print 'Calculating flux at phase point: ',i+1,'/',nphase
    
    # Set current longitude of observer
    long_obs = 2*pi-phase[i]
    
    # Define new temperature array
    temp_int = np.zeros((nlat/2,nlon))
    f = interp2d(longitude,latitude,temp)
    # Loop over latitude
    for itheta in range(nlat/2):
      # Loop over longitude
      for iphi in range(nlon):
        
        # Convert current latitude and longitude into cartesian coordinates
        x = sin(theta_int[itheta])*cos(phi_int[iphi])
        y = sin(theta_int[itheta])*sin(phi_int[iphi])
        z = cos(theta_int[itheta])
        
        # Transform coordinates
        x_um = z
        y_um = y
        z_um = -x
        
        # Convert to spherical coordinates
        theta_um = math.acos(z_um)
        phi_um   = math.atan2(y_um,x_um) + pi
        
        # Rotate
        phi_um = phi_um + long_obs
        theta_um = theta_um + (lat_obs - pi/2.)
        
        # Ensure phi_um and theta_um are between 0 and 2pi and 0 and pi
        x_um = sin(theta_um)*cos(phi_um)
        y_um = sin(theta_um)*sin(phi_um)
        z_um = cos(theta_um)
        theta_um = math.acos(z_um)
        phi_um = math.atan2(y_um,x_um) + pi
        
        # Interpolate to get current temperature point 
        temp_int[itheta,iphi] = f(phi_um,theta_um)
        temp_int[itheta,iphi] = temp_int[itheta,iphi]**4.*sigma*rp**2.*cos(phi_int[iphi])**2.*cos(theta_int[itheta])

    # Integrate over theta  
    temp_int_theta = np.zeros(nlon)
    for iphi in range(nlon):
      for itheta in range(nlat/2-1):
        temp_int_theta[iphi] = temp_int_theta[iphi] + (temp_int[itheta,iphi]+temp_int[itheta+1,iphi])/2.*dtheta
        
    # Integrate over phi
    temp_int_phi = 0.
    for iphi in range(nlon-1):
      temp_int_phi = temp_int_phi + (temp_int_theta[iphi]+temp_int_theta[iphi+1])/2.*dphi
      
    flux[i] = temp_int_phi
  
  # Calculate normalised flux
  mean_flux = mean(flux)
  normalised_flux = np.zeros(nphase)
  for i in range(nphase):
    normalised_flux[i] = (flux[i]-mean_flux)/mean_flux 
    
  phase = phase*180./pi
  
  # Save to text file
  array = vstack((phase,normalised_flux)).T
  savetxt(fname_out,array)
  

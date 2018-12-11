# Python routines to read and plot UM phase curves and emission spectra

# import modules
from   pylab   import *
import netCDF4 as nc
import numpy   as np
from   scipy.interpolate import *
import sys

# Some constants
# Solar Radius (m)
rsun    = 695700E+03
# Earth Radius (m)
rearth  = 6371E+03
# Jupiter radius (m)
rjup    = 69911E+03

# Function to read UM output (netcdf format)
# Assumes SW and LW fluxes are in separate files
# and that normal and clear-sky fluxes are in same files
def read_um_file(fname,fname_key,type,start_trim,end_trim):
	
	# read netcdf names key file
	keys = np.genfromtxt(fname_key,dtype='str')

	# define dictionary
	dict = {}
	a =  keys[:,0].tolist()
	b = keys[:,1].tolist()
	# create dictionary of variables
	for i in range(5):
		dict[a[i]] = b[i]
	
	# Load netCDF file
	data = nc.Dataset(fname,'r')

	# Copy fluxes in trimmed range and sum over latitude/longtiude
	if type in ['sw','sw_cs','lw','lw_cs','trans']:
		fp = (data.variables[dict[type]][start_trim:end_trim,:,:,:].sum(3)).sum(2)
	elif type == 'sw+lw':
		fp = ((data.variables[dict['sw']][start_trim:end_trim,:,:,:].sum(3)).sum(2) + 
			(data.variables[dict['lw']][start_trim:end_trim,:,:,:].sum(3)).sum(2))
	elif type == 'sw_cs+lw_cs':
		fp = ((data.variables[dict['sw_cs']][start_trim:end_trim,:,:,:].sum(3)).sum(2) + 
			(data.variables[dict['lw_cs']][start_trim:end_trim,:,:,:].sum(3)).sum(2))
	else:
		print 'Error: reading netcdf file'
		sys.exit()
		
	# Copy time
	time = data.variables['t'][:]
	
	# Copy dimensions
	# Number of time points
	ntime  = data.variables['t'].size
	# Number of wavebands
	nband  = data.variables['pseudo'].size
	
	return ntime, nband, fp, time
	
# Function to read text file containing phase angles
def read_um_phase_file(fname,nlines):

	# Load datafile
	f = open(fname,'r')
	
	# Define new list
	p = []
	# Read phase angles
	for i in range(nlines):
		line = f.readline()
		line = line.strip()
		columns = line.split()
		p.append(columns[5])
	
	# Convert to np array
	p = np.asarray(p)
	
	# Convert to float
	p = p.astype(np.float)
	
	# Convert into degrees
	phase_angle = p*180./pi

	return phase_angle
	
# Function to read UM spectral file to get 
# waveband limits
def read_spectral_file(fname,nband):

	# Waveband limits
	nubandmin = []
	nubandmax = []
	
	f = open(fname, 'r')
	
	nhead = 28
	# Burn Header
	for i in range(nhead):
		line = f.readline()
	
	# Read waveband limits
	for i in range(nband):
		line = f.readline()
		line = line.strip()
		columns = line.split()
		
		nubandmin.append(columns[1])
		nubandmax.append(columns[2])
		
	# Convert list to np array
	nubandmin = np.asarray(nubandmin)
	nubandmax = np.asarray(nubandmax)
	
	# Convert string to float
	nubandmin = nubandmin.astype(np.float)
	nubandmax = nubandmax.astype(np.float)
	
	return nubandmin, nubandmax

# Function to read stellar flux from UM spectral file
def read_spectral_file_stellar_flux(fname,nband):

	fstar = []
	
	f = open(fname, 'r')
	
	nhead = 532
	# Burn Header
	for i in range(nhead):
		line = f.readline()
	
	# Read in stellar spectrum
	for i in range(nband):
		line = f.readline()
		line = line.strip()
		columns = line.split()
		
		fstar.append(columns[1])
		
	# Convert list to np array
	fstar = np.asarray(fstar)
	
	# Convert to float
	fstar = fstar.astype(np.float)
	
	return fstar
	
	
# Function to read stellar spectrum from ATMO format spectral file
def read_atmo_stellar_spectrum(fname):

	# Load netcdf file
	data = nc.Dataset(fname)
	
	# Wavenumber
	nu = data.variables['nu'][:]
	# Irradiance
	f = data.variables['hnu'][:]
	
	# Convert from per wavenumber to per wavelength
	f = f*nu**2.
	
	# Convert wavenumber into wavelength (SI)
	nu = 1./nu   # cm-1 -> cm
	nu = nu/100. # cm   -> m
	
	# Convert irradiance into SI (W/m^2/m) from CGS (erg/s/cm^2/ster/cm)
	f = f*1e-7*1e6
	f = f*4.*pi
	
	return nu, f
	
def read_instrument_response(instrument):

	if instrument=='Spitzer3.6':
	  fresponse='/data/bd257/observations/instrument_response/spitzer_irac/3.6channel.dat'
	elif instrument=='Spitzer4.5':
	  fresponse='/data/bd257/observations/instrument_response/spitzer_irac/4.5channel.dat'

	f = np.loadtxt(fresponse,skiprows=3)
	channel_wl = f[:,0]*1.0e-6 # convert to SI
	response   = f[:,1]

	return channel_wl, response
	
# Function to calculate central wavelength of band from waveband limits
def calculate_nu(nubandmin,nubandmax):

	nu = 0.5*(nubandmin+nubandmax)
	
	return nu

# Function to interpolate and integrate stellar spectrum into wavebands 
def interpolate_stellar_spectrum(nu,numin,numax,nband,fs):

	# Extend the stellar spectrum range
	# Phoenix spectrum does not extend low enough lambda. Fudge to 0.1um and copy flux value at 0.2um
	nu = np.append(nu,1e-7)
	fs = np.append(fs,fs[nu.size-2])
	print 'Warning: Extending Phoenix spectrum to 0.1 um - copying value at lowest available wavelength'
	
	# integrated flux
	fint = np.zeros(nband)
	
	# Integrate spectral flux into waveband using trapezoidal rule
	# Number of points for integration
	npoints = 10000 
	for ib in range(nband):
		nuint = linspace(numin[ib],numax[ib],npoints)
		f = interp1d(nu[::-1],fs[::-1])
		floc = f(nuint)
		# Trapezoid rule - integrated flux in band
		fint[ib] = (numax[ib]-numin[ib])/(2.*(npoints-1))*(floc[0]+floc[-1]+sum(2.*floc[1:-2]))

	return fint

def tick_function(t,p,newt):

	f = interp1d(t,p)
	newp = f(newt)
	print newp
	
	return ["%.0f" % x for x in newp]
	

# Main function to plot phase curve
def plot_phase_curve(
fname='',              # Input Filename: netcdf file containing global fluxes 
fname_phase='',        # Input Filename: text file containing phase angle at each time point
fname_spec='',         # Input Filename: UM spectral file
fname_stellar_spec='', # Input Filename: ATMO format stellar spectrum
fname_key='',          # Input Filename: text file with netcdf variable names
type='',               # Type of spectrum: sw, sw_cs, lw or lw_cs
use_um_stellar_flux = True, # Get stellar flux from spectral file
instrument = '',
rel_flux = False,
scale_flux = False,
sc = 0.,               # Solar constant
numin=0.,            # Minimum waveband number to include
numax=0.,            # Maximum waveband number to include
start_trim=0,          # First phase point to include in plot
end_trim=0,            # Second phase point to include in plot
rs=0.,                 # Stellar radius
P=0.,                  # Orbital period of planet in days
rp=0.,                 # Planet radius
ztop=0.,               # Model height
zph=0.,                # Height of photosphere
add_phase_lines=False, # Add lines on plot at 90, 180 and 270 degrees
color='black',         # Plot colour
leg=True,              # Include legend
linestyle='-',         # Plot inestyle
linewidth=2.,          # Plot linewidth
marker='',
label='',
showfig=True):           # Show figure on screen

	f_err = False
	# Check input
	if fname == '':
		fname_err = 'UM netcdf file'
		f_err     = True
	if fname_phase == '':
		fname_err = 'Phase angle text file'
		f_err     = True
	if fname_spec == '':
		fname_err = 'Spectral file'
		f_err     = True
	if fname_stellar_spec == '' and use_um_stellar_flux == False:
		fname_err = 'Stellar spectrum file'
		f_err     = True
	if fname_key == '':
		fname_err = 'Netcdf variable key file'
		f_err     = True

	if f_err == True:
		print 'Error: ',fname_err,' not specified'
		sys.exit()
	
	# Initialise - setup to include 2 x-axes
	fig = figure(1)
	ax1 = fig.add_subplot(111)
	ax2 = ax1.twiny()
	
  # Read netCDF file
	ntime, nband, fp, time = read_um_file(fname,fname_key,type,start_trim,end_trim)
	
	# Read phase angles
	phase_angle = read_um_phase_file(fname_phase,ntime)
	
	# Trim phase angle and time arrays
	if start_trim != 0 or end_trim != 0:
		
		# Trim phase_angle and data_array
		phase_angle = phase_angle[start_trim:end_trim]
		
		# Trim time and normalise so that first time point is zero
		time = time[start_trim:end_trim]
		time = time-min(time)
    
    # New number of time points
		ntime = phase_angle.size

    # Print to screen
		print 'Data has been trimmed to ', ntime, ' points:'
		print '  minimum phase angle = ', min(phase_angle), 'degrees'
		print '  maximum phase angle = ', max(phase_angle), 'degrees'
	
	# Call function to read spectral files
	nubandmin, nubandmax = read_spectral_file(fname_spec,nband)	
	
	# Call function to calculate central wavelength of band
	nu = calculate_nu(nubandmin,nubandmax)
	
	if use_um_stellar_flux == True:
		# Get normalised flux in each band
		fstar = read_spectral_file_stellar_flux(fname_spec,nband)
		# Multiply by solar constant
		fstarint = fstar*sc
	else:
		# Call function to read stellar irradiation spectrum
		nu_star, fstar = read_atmo_stellar_spectrum(fname_stellar_spec)

		# Call function to interpolate and integrate stellar spectrum into bands
		# fstarint is the integrated stellar flux in band
		fstarint = interpolate_stellar_spectrum(nu_star,nubandmin,nubandmax,nband,fstar)

		# Get stellar flux at surface of star 
		fstarint = fstarint*(rs*rsun)**2.
	
	# Check to see if wavelengths increase
	if any(diff(nu)) > 0:
	  nu = nu[::-1]
	  nubandmin = nubandmin[::-1]
	  nubandmax = nubandmax[::-1]
	  fp = fp[:,::-1]
	  fstarint = fstarint[::-1]
	
	# Calculate spectral fluxes
	if (instrument=='Spitzer3.6' or instrument=='Spitzer4.5'):
		# Calculate spectral flux
		fp = fp/(nubandmax-nubandmin)
		fstarint = fstarint/(nubandmax-nubandmin)

		# Define flux ratio array
		fpfs = np.zeros(ntime)

		# Read instrument response function
		wl, response = read_instrument_response(instrument)

    # Loop over times and compute fpfs integrated over instrument channel
		for it in range(ntime):

			flux = fp[it,:]/fstarint[:]
			# interpolate fpfs
			f = interp1d(nu,flux)
			fnew = f(wl)

			# calculate integrates flux
			fpfs[it] = sum(response*fnew)/sum(response)
	
	# sum flux over requested bands
	elif instrument=='':
		
		# Define flux ratio array
		fpfs = np.zeros(ntime)
		
		# Get band numbers for requested spectral range
		ibandmin = argmin(abs(nu-numin))
		ibandmax = argmin(abs(nu-numax))
		
		# Sum the flux across the planet and within requested waveband limits
		print 'Getting flux within wavelength limits : ', nubandmin[ibandmin],' m and ', nubandmax[ibandmax],' m'
		for it in range(ntime):
		  fpfs[it] = sum(fp[it,ibandmin:ibandmax])/sum(fstarint[ibandmin:ibandmax])
		label='%.2f'%(nubandmin[ibandmin]*1e6)+' - '+'%.2f'%(nubandmax[ibandmax]*1e6)+' $\mu$m'

	
	# Plot relative flux (relative to flux at phase = 180 deg)
	if rel_flux == True:
	  
	  # Interpolate to get flux at 180 degrees 
	  phase_base = 180.
	  f = interp1d(phase_angle,fpfs)
	  fpfs_base = f(phase_base)
	  
	  # Take relative flux
	  fpfs = fpfs/fpfs_base
	  
	# else if scaling flux
	elif scale_flux == True:
	
	  fpfs = fpfs*(rp+zph)**2/(rp+ztop)**2
	
	
	
	# Plot phase curve linearly in time
	ax1.plot(time,fpfs*100.,color=color,linestyle=linestyle,marker=marker,linewidth=linewidth,label=label)
	
	ax1.set_xlabel('Time [days]',fontsize=20)
	
	# Set lower x-axis limits
	ax1.set_xlim(0.,P)
	
	# Create second x-axis with phases
	ax2.set_xlim(ax1.get_xlim())

	# Phases to go on second x-axis
	phases = np.array([90.,180.,270.])
	
	# Get elapsed time for these phases
	f = interp1d(phase_angle,time)
	new_tick_locations = f(phases)
	
	# Set second x-axis tick values
	ax2.set_xticks(new_tick_locations)
	ax2.set_xticklabels(tick_function(time,phase_angle,new_tick_locations))

	# Add vertical lines at important phases
	if add_phase_lines == True:
		lines = [90.,180.,270.]
		f = interp1d(phase_angle,time)
		for l in lines:
			x = f(l)
			ax2.plot([x,x],[1e-20,1e-1],color='black',linestyle=':')
	
	# Show legend
	if leg == True:
		ax1.legend(loc=0,fontsize=10).draw_frame(0)
		
	# Set y-axis to logarithmic 
	#ax1.set_yscale('log')
	# Set axis labels
	ax2.set_xlabel('Phase Angle [$\degree$]',fontsize=20)
	if rel_flux == True:
		ax1.set_ylabel('Relative flux',fontsize=20)
	else:
		ax1.set_ylabel('$F_p$/$F_s$ [10$^{-2}$]',fontsize=20)
		
	# Show figure on screen
	if showfig == True:
		show()

# Main function to plot emission spectrum
def plot_emission_spectrum(
fname='',              # Input Filename: UM output netcdf file
fname_phase='',        # Input Filename: text file containing phase angle at each time point
fname_spec='',         # Input Filename: UM spectral file
fname_stellar_spec='', # Input Filename: ATMO format stellar spectrum (if needed)
fname_key='',          # Input Filename: text file with netcdf variable names
type='',               # Type of spectrum: sw, sw_cs, lw or lw_cs
use_um_stellar_flux = True, # Use stellar spectrum from UM spectral file
sc = 0.,               # Solar constant
rs=0.,                 # Stellar radius
phase=0.,              # Phase angle at which to plot spectrum
linestyle='-',         # Plot linestyle
color='black',         # Plot colour
linewidth=2.,          # Plot linewidth
alpha=1.,              # Plot alpha 
label='',              # Plot label
start_trim=0,          # Integers to trim orbit
end_trim=0,            # Integers to trim orbit
showfig=True):         # Show figure on screen


  # Read netCDF file
	ntime, nband, fp, time = read_um_file(fname,fname_key,type,start_trim,end_trim)
	
	# Read phase angles
	phase_angle = read_um_phase_file(fname_phase,ntime)
	
	# Trim phase angle and time arrays
	if start_trim != 0 or end_trim != 0:
		
		# Trim phase_angle and data_array
		phase_angle = phase_angle[start_trim:end_trim]
		
		# Trim time and normalise so that first time point is zero
		time = time[start_trim:end_trim]
		time = time-min(time)
    
    # New number of time points
		ntime = phase_angle.size

    # Print to screen
		print 'Data has been trimmed to ', ntime, ' points:'
		print '  minimum phase angle = ', min(phase_angle), 'degrees'
		print '  maximum phase angle = ', max(phase_angle), 'degrees'
	
	# Index of closest phase angle to requested
	iphase = argmin(abs(phase_angle-phase))
	fp_at_phase = fp[iphase,:]
	print 'Requested phase angle ', phase, ' degrees:'
	print '  using phase angle', phase_angle[iphase], ' degrees'

	# Check if data array contains (-)infinities and replace with zero
	if inf in fp_at_phase:
	  fp_at_phase[fp_at_phase == inf] = 0.
	  print 'Warning: infinities are present in array, replacing with zero'
	if -inf in fp_at_phase:
	  fp_at_phase[fp_at_phase == -inf] = 0.
	  print 'Warning: -infinities are present in array, replacing with zero'

	# Read UM spectral file to get wavelength limits of bands
	nubandmin, nubandmax = read_spectral_file(fname_spec,nband)

	# Calculate wavelength at centre of bands
	nu = calculate_nu(nubandmin,nubandmax)

	if use_um_stellar_flux == True:
	
		# Read UM spectral file to get normalise stellar flux in each band
		fstar = read_spectral_file_stellar_flux(fname_spec,nband)
		# Multiply by stellar constant
		fstarint = fstar*sc
		
	else:
		# Call function to read stellar irradiation spectrum
		nu_star, fstar = read_atmo_stellar_spectrum(fname_stellar_spec)

		# Call function to interpolate and integrate stellar spectrum into bands
		# fstarint is the integrated stellar flux in band
		fstarint = interpolate_stellar_spectrum(nu_star,nubandmin,nubandmax,nband,fstar)

		# Get stellar flux at surface of star 
		fstarint = fstarint*(rs*rsun)**2.

	# Take fp/fs ratio
	fpfs = fp_at_phase/fstarint

	# If zeros in array, set to small number (cannot take log of zero)
	if 0. in fpfs:
		fpfs[fpfs == 0.] = 1.0E-30
		print 'Warning: zeros exist in fpfs, replacing with zeros'

	# Convert variables to plotting units
	nu_plot   = nu*1e6    # meters
	fpfs_plot = fpfs*100. # [x10^-2]

	# Plot
	plot(nu_plot,fpfs_plot,color=color,linestyle=linestyle,linewidth=linewidth,label=label,alpha=alpha)
	
	# Set axis labels
	ylabel('$F_p/F_s$ [$10^{-2}$]',fontsize=20)
	xlabel('Wavelength [$\mu$m]',fontsize=20)
	
	# Add legend
	if label != '':
		legend(loc=0,fontsize=15).draw_frame(0)
	
	# Show figure on screen
	if showfig == True:
		show()


# Function to plot transmission spectrum
def plot_transmission_spectrum(
fname = '',
fname_spec='',         # Input Filename: UM spectral file
fname_key='',
type='trans',
sc = 0.,
rs = 0.,
ztop = 0.,
start_trim =0,
end_trim=0,
label='',
linestyle='-',
color='black',
shift=0.
):

		# Read netcdf file
		ntime, nband, trans, time = read_um_file(fname,fname_key,type,start_trim,end_trim)

		# Read UM spectral file to get wavelength limits of bands
		nubandmin, nubandmax = read_spectral_file(fname_spec,nband)

		# Calculate wavelength at centre of bands
		nu = calculate_nu(nubandmin,nubandmax)
		
		itime = 0.
		# Get transmission at closest time
		itrans = argmin(abs(itime-time))
		trans = trans[itime,:]

		fstar = read_spectral_file_stellar_flux(fname_spec,nband)
		fstar = fstar*sc

		# Calculate radius ratio
		rprs = ztop**2./rs**2.
		rprs = rprs - (trans/fstar)
		rprs = rprs**(0.5)

		semilogx(nu*1e6,(rprs+shift),label=label,color=color,linestyle=linestyle)
		
		if label != '':
		  legend(loc=0,fontsize=20).draw_frame(0)


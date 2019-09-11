# Python routines to read and plot UM phase curves and emission spectra

# import modules
from   pylab   import *
import netCDF4 as nc
import numpy   as np
from   scipy.interpolate import *

# Some constants
# Solar Radius (m)
rsun    = 695700E+03
# Earth Radius (m)
rearth  = 6371E+03
# Jupiter radius (m)
rjup    = 69911E+03
# Astronomical Unit (m)
AU      = 1.49597870700E+11

# Function to read UM output (netcdf format)
# Assumes SW and LW fluxes are in separate files
# and that normal and clear-sky fluxes are in same files
def read_um_file(fname,ncdf_name,start_trim,end_trim):

  # Load netCDF file
  data = nc.Dataset(fname,'r')

  # Get variable and sum over all latitudes and longitudes
  fp = (data.variables[ncdf_name][start_trim:end_trim,:,:,:].sum(3)).sum(2)

  # Copy time (assume time variable has netcdf name of 't')
  time = data.variables['t'][start_trim:end_trim]

  # Get dimensions
  # Number of time points
  ntime  = time.size
  # Number of wavebands
  nband  = data.variables['pseudo'].size

  return ntime, nband, fp, time
	
# Function to read text file containing phase angles
def read_um_phase_file(fname,nlines,start_trim,end_trim):

	# Load datafile
	f = open(fname,'r')
	
	# Define new list
	p = []
	# Read phase angles
	for line in f:
		line = line.strip()
		columns = line.split()
		p.append(columns[5])
	
	# Convert to np array
	p = np.asarray(p)
	
	# Convert to float
	p = p.astype(np.float)
	
	# Convert into degrees
	phase_angle = p*180./pi
	
	# Trim
	phase_angle = phase_angle[start_trim:end_trim]
	
	return phase_angle
	
# Function to read UM spectral file to get 
# waveband limits
def read_spectral_file(fname,nband):

	# Waveband limits
	nubandmin = []
	nubandmax = []

	f = open(fname, 'r')

	band_block = True
	while band_block:
		line = f.readline()
		line = line.strip()
		columns = line.split()

		if columns[0]=='Band':
			band_block = False 

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
	
	band_block = True
	while band_block:
		line = f.readline()
		line = line.strip()
		columns = line.split()
                
		if columns[0]=='Normalized':
			band_block = False 
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
		
def read_instrument_response(instrument):

	if instrument=='Spitzer3.6':
	  fresponse='/data/bd257/observations/instrument_response/spitzer_irac/3.6channel.dat'
	elif instrument=='Spitzer4.5':
	  fresponse='/data/bd257/observations/instrument_response/spitzer_irac/4.5channel.dat'

	f = np.loadtxt(fresponse,skiprows=3)
	channel_wl = f[:,0]*1.0e-6 # convert to SI
	response   = f[:,1]

	return channel_wl, response

# Function to read stellar spectrum from either
# UM spectral file for ATMO format file
def get_stellar_spectrum(fname,nband,sc,rs):

  # Read normalised stellar spectrum from UM spectral file
  fstar = read_spectral_file_stellar_flux(fname,nband)
  # Convert to absolute values
  fstar = fstar*sc

  return fstar

# Function to calculate the phase curve from UM output
def construct_phase_curve(fname,fname_phase,fname_spec,ncdf_name,
  instrument,numin,numax,
  rel_flux,scale_flux,
  start_trim,end_trim,
  sc,rs,rp,zph,ztop):

  # Read netCDF file
	ntime, nband, fp, time = read_um_file(fname,ncdf_name,start_trim,end_trim)
	
	# Read phase angles
	phase_angle = read_um_phase_file(fname_phase,ntime,start_trim,end_trim)

	# Read band wavelength limits from UM spectral file
	nubandmin, nubandmax = read_spectral_file(fname_spec,nband)	

	# Calculate wavelength in center of band
	nu = calculate_nu(nubandmin,nubandmax)

	# Read stellar spectrum
	fstar = get_stellar_spectrum(fname_spec,nband,sc,rs)

	# Check to see if wavelengths increase, if not reverse arrays
	if any(diff(nu)) > 0:
		nu = nu[::-1]
		nubandmin = nubandmin[::-1]
		nubandmax = nubandmax[::-1]
		fp = fp[:,::-1]
		fstar = fstar[::-1]

	# Bin spectrum over requested wavelengths
	# If specific instrument selected
	if (instrument=='Spitzer3.6' or instrument=='Spitzer4.5'):
	
		# Calculate spectral flux
		fp = fp/(nubandmax-nubandmin)
		fstar = fstar/(nubandmax-nubandmin)

		# Define flux ratio array
		fpfs = np.zeros(ntime)

		# Read instrument response function
		wl, response = read_instrument_response(instrument)

		# Loop over times and compute fpfs integrated over instrument channel
		for itime in range(ntime):

			flux_ratio = fp[itime,:]/fstar[:]
			# interpolate fpfs
			f = interp1d(nu,flux_ratio)
			fnew = f(wl)
			# calculate integrated flux
			fpfs[itime] = sum(response*fnew)/sum(response)

	# Sum over requested wavelength limits
	elif instrument==None:

		# Define flux ratio array
		fpfs = np.zeros(ntime)

		# Get band numbers for requested spectral range
		ibandmin = argmin(abs(nu-numin))
		ibandmax = argmin(abs(nu-numax))

		# Sum the flux across the planet and within requested waveband limits
		print 'Getting flux within wavelength limits : ', nubandmin[ibandmin],' m and ', nubandmax[ibandmax],' m'
		for itime in range(ntime):
			fpfs[itime] = sum(fp[itime,ibandmin:ibandmax])/sum(fstar[ibandmin:ibandmax])
		label='%.2f'%(nubandmin[ibandmin]*1e6)+' - '+'%.2f'%(nubandmax[ibandmax]*1e6)+' $\mu$m'

	# Normalise fp/fs to value at phase = 180
	if rel_flux == True:

		# Interpolate to get flux at 180 degrees 
		phase_base = 180.
		f = interp1d(phase_angle,fpfs)
		fpfs_base = f(phase_base)

		# Take relative flux
		fpfs = fpfs/fpfs_base

	# Scale flux 
	elif scale_flux == True:

		fpfs = fpfs*(rp+zph)**2/(rp+ztop)**2

        #fpfs = fpfs*rp**2/rs**2

	return time, phase_angle, fpfs

# Function read and post-process emission spectrum
def construct_emission_spectrum(fname,fname_phase,fname_spec,
    ncdf_name,start_trim,end_trim,flux_ratio,sc,rp,phase,
    fname_txt_output):

  # Read netCDF file
  ntime, nband, fp, time = read_um_file(fname,ncdf_name,start_trim,end_trim)

  # Read phase angle
  phase_angle = read_um_phase_file(fname_phase,ntime,start_trim,end_trim)

  # Trim phase angle and time arrays
  if start_trim != 0 or end_trim != 0:
    time = time[start_trim:end_trim]
    # Reset time so that initial time is zero
    time = time-min(time)
    # New number of time points
    ntime = phase_angle.size
  
    # Print trim info
    print 'Data has been trimmed to ', ntime, ' points:'
    print '  minimum phase angle = ', min(phase_angle), 'degrees'
    print '  maximum phase angle = ', max(phase_angle), 'degrees'
 
  # Get data at closest requested phase
  iphase = argmin(abs(phase_angle-phase))
  fp_at_phase = fp[iphase,:]
  print 'Requested phase angle ', phase, ' degrees:'
  print '  using data at closest point, phase angle', phase_angle[iphase], ' degrees'    

  # Check if data array contains (-)infinities and replace with zero
  if inf in fp_at_phase:
    fp_at_phase[fp_at_phase == inf] = 0.
    print 'Warning: infinities are present in array, replacing with zero - please check this is ok'
  if -inf in fp_at_phase:
    fp_at_phase[fp_at_phase == -inf] = 0.
    print 'Warning: -infinities are present in array, replacing with zero - please check this is ok'

  # Read spectral file to get wavelength limits of bands and calculate band center wavelength
  nubandmin, nubandmax = read_spectral_file(fname_spec,nband)
  nu = calculate_nu(nubandmin,nubandmax)

  # Get stellar flux
  # Read UM spectral file to get normalise stellar flux in each band
  fstar = read_spectral_file_stellar_flux(fname_spec,nband)
  # Multiply by stellar constant to get absolute stellar flux
  fstarint = fstar*sc

  # Take fp/fs ratio
  if flux_ratio==True:
    fpfs = fp_at_phase/fstarint
  # Else plot planet emission flux
  else:
    fpfs = fp_at_phase
    # Get flux at surface of planet
    fpfs = fpfs*AU**2/rp**2

  # Check if infinities in fpfs - likely due to 0. stellar flux in some bands
  if inf in fpfs:
    fpfs[fpfs==inf]   = 1e-50
    print 'Warning: replacing inf with 1e-50'
    print ' this is likely ok and due to some bands having zero stellar flux, but please check!'

  # Write processed data to an ascii file if fname_txt_output is defined
  if fname_txt_output==None:
    print 'fname_txt_output is not defined, will not save processed data to ascii'
  else:
    print 'saving processed data to: ',fname_txt_output
    f = open(fname_txt_output,'w')
    # Write header
    f.write('Wavelength [m]  Fp/Fs'+' \n')
    for i in range(nu.size):
      f.write((str('%1.4e'%nu[i])+' '+str('%1.4e'%fpfs[i])+' \n'))
      
  return nu, fpfs

# Function read and post-process transmission spectrum
def construct_transmission_spectrum(fname,fname_phase,fname_spec,
    ncdf_name,start_trim,end_trim,sc,rp,rs,
    ztop,fname_txt_output):

  # Read netcdf file
  ntime, nband, trans, time = read_um_file(fname,ncdf_name,start_trim,end_trim)

  # Read UM spectral file to get wavelength limits of bands
  nubandmin, nubandmax = read_spectral_file(fname_spec,nband)

  # Calculate wavelength at centre of bands
  nu = calculate_nu(nubandmin,nubandmax)

  itime = 0.
  # Get transmission at closest time
  itrans = argmin(abs(itime-time))
  trans = trans[0,:]

  # Get stellar flux from UM spectral file
  fstar = read_spectral_file_stellar_flux(fname_spec,nband)

  # Convert from relative flux to absolute flux
  fstar = fstar*sc

  # Calculate radius ratio (actually this is the square of the radius ratio - (Rp/Rs)**2)
  rprs = ztop**2./rs**2.
  rprs = rprs - (trans/fstar)

  # Get rid of nans and infs (these can exist because some bands have zero stellar flux)
  rprs[isnan(rprs)] = 0.

  # Write processed data to an ascii file if fname_txt_output is defined
  if fname_txt_output==None:
    print 'fname_txt_output is not defined, will not save processed data to ascii'
  else:
    print 'saving processed data to: ',fname_txt_output
    f = open(fname_txt_output,'w')
    # Write header
    f.write('Wavelength [m]  (Rp/Rs)^2'+' \n')
    for i in range(nu.size):
      f.write((str('%1.4e'%nu[i])+' '+str('%1.4e'%rprs[i])+' \n'))
      
  return nu, rprs

# Function to calculate central wavelength of band from waveband limits
def calculate_nu(nubandmin,nubandmax):

	nu = 0.5*(nubandmin+nubandmax)
	
	return nu

def tick_function(t,p,newt):

	f = interp1d(t,p)
	newp = f(newt)
	print newp
	
	return ["%.0f" % x for x in newp]
	
# Main function to plot phase curve
def plot_phase_curve(
fname=None,              # Input Filename: netcdf file containing global fluxes 
fname_phase=None,        # Input Filename: text file containing phase angle at each time point
fname_spec=None,         # Input Filename: UM spectral file
fname_save=None,         # Output Filename: Save figure to .ps of .pdf if defined
fname_txt_output=None,   # Output Filename: Save processed data as ascii file if defined
ncdf_name=None,          # Name of variable in netcdf file
instrument = None,      # Choose either 'Spitzer3.6' or 'Spitzer4.5' to get flux in channel or use numin and numax
rel_flux = False, # Plot the relative flux, normalised to flux at 180 phase angle 
scale_flux = False, # Scale the flux using height of photosphere (zph)
plot_as_time = False, # Plot phase curve as function of time rather than phase angle
plot_zellem2014 = False, # Plot the Zellem et al 2014 HD 209 4.5 observed phase curve
sc = None,               # Solar constant
numin=0.,            # Minimum waveband number to include
numax=0.,            # Maximum waveband number to include
start_trim=None,          # First phase point to include in plot
end_trim=None,            # Second phase point to include in plot
rs=None,                 # Stellar radius
P=None,                  # Orbital period of planet in days
rp=None,                 # Planet radius
ztop=None,               # Model height
zph=None,                # Height of photosphere
add_phase_lines=True, # Add lines on plot at 90, 180 and 270 degrees
color='black',         # Plot colour
leg=True,              # Include legend
linestyle='-',         # Plot inestyle
linewidth=2.,          # Plot linewidth
marker='',
label='',
showfig=True):           # Show figure on screen

  # Calculate phase curve
  time, phase, fpfs = construct_phase_curve(fname,fname_phase,fname_spec,ncdf_name,
    instrument,numin,numax,
    rel_flux,scale_flux,
    start_trim,end_trim,
    sc,rs,rp,zph,ztop)

  # Initialise - setup to include 2 x-axes
  fig = figure(1)
  ax1 = fig.add_subplot(111)
  # Setup second x-axis
  if plot_as_time:
    ax2 = ax1.twiny()

  if plot_as_time:
    ax1.plot(time,fpfs,color=color,linestyle=linestyle,marker=marker,linewidth=linewidth,label=label)
    ax1.set_xlabel('Time [days]',fontsize=20)
  else:
    ax1.plot(phase,fpfs,color=color,linestyle=linestyle,marker=marker,linewidth=linewidth,label=label)
    ax1.set_xlabel('Phase angle [deg]',fontsize=20)

  # Plot HD~209458b 4.5 micron phase curve (Zellem et al 2014)
  if plot_zellem2014:
    plot_zellem_curve(phase)

  # Add second 'phase' x-axis
  if plot_as_time:
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

    ax2.set_xlabel('Phase Angle [$\degree$]',fontsize=20)

    # Add vertical lines at important phases
    if add_phase_lines == True:
      lines = [90.,180.,270.]
      f = interp1d(phase_angle,time) 
      for l in lines:
        x = f(l)
        ax2.plot([x,x],[1e-20,1.],color='black',linestyle=':')

  # Show legend
  if leg == True:
    ax1.legend(loc=0,fontsize=15).draw_frame(0)

  # Set y-axis to logarithmic 
  # Set y-axis labels
  if rel_flux == True:
    ax1.set_ylabel('Relative flux',fontsize=20)
  else:
    ax1.set_ylabel('$F_p$/$F_s$',fontsize=20)
    ticklabel_format(style='sci', axis='y', scilimits=(0,0))

  # Write data to text file
  if fname_txt_output is not None:
    f = open(fname_txt_output,'w')
    # Write header
    f.write('Phase  Fp/Fs')
    for i in range(nu.size):
      f.write((str('%1.4e'%phase[i])+' '+str('%1.4e'%fpfs[i])+' \n'))

  if fname_save==None:
    print 'fname_save not defined, will not save figure'
  else:
    savefig(fname_save)

  # Show figure on screen
  if showfig == True:
    show()

# Function to plot zellem et al 2014 HD 209458b 4.5 micron phase curve
def plot_zellem_curve(phase_angle):

	# Zellem 4.5 micron phase curve for HD 209458b
	hd209_phase_4p5um = lambda c_0, phase_angle: c_0 - \
		0.0410e-2*cos(phase_angle) + 0.0354e-2*sin(phase_angle)
		
	plot(phase_angle,hd209_phase_4p5um(9.81e-4,radians(phase_angle)),color='black',linewidth=2)
	# Add 1 sigma errors
	fill_between(phase_angle,hd209_phase_4p5um(9.81e-4,radians(phase_angle)),\
	hd209_phase_4p5um(9.81e-4+0.0123e-2,radians(phase_angle)),color='grey',alpha='0.5')
	fill_between(phase_angle,hd209_phase_4p5um(9.81e-4,radians(phase_angle)), \
	hd209_phase_4p5um(9.81e-4-0.0123e-2,radians(phase_angle)),color='grey',alpha='0.5')

# Main function to plot emission spectrum
def plot_emission_spectrum(
fname=None,              # Input Filename: UM output netcdf file
fname_phase=None,        # Input Filename: text file containing phase angle at each time point
fname_spec=None,         # Input Filename: UM spectral file
fname_save=None,         # Output Filename: Save figure to .ps of .pdf if defined
fname_txt_output=None,   # Output Filename: Save processed data as ascii file if defined
ncdf_name=None,        # Name of variable in netCDF file
sc = None,               # Solar constant
rs=None,                 # Stellar radius
rp=None,                 # Planet radius (m)
phase=None,              # Phase angle at which to plot spectrum
linestyle='-',         # Plot linestyle
color='black',         # Plot colour
linewidth=2.,          # Plot linewidth
alpha=1.,              # Plot alpha 
label=None,              # Plot label
start_trim=None,          # Integers to trim orbit
end_trim=None,            # Integers to trim orbit
all_phases=False,      # Plot all phase on one figure
flux_ratio=True,       # Plot flux ratio or physical planetary flux
showfig=True):         # Show figure on screen

  # Check start_trim and end_trim are defined
  if start_trim==None or end_trim==None:
    print 'Error: both start_trim and end_trim must be defined'

  # Read and post-process emission spectrum
  nu, fpfs = construct_emission_spectrum(fname,fname_phase,fname_spec,
    ncdf_name,start_trim,end_trim,flux_ratio,sc,rp,phase,
    fname_txt_output)

  # Convert variables to plotting units
  nu_plot   = nu*1e6 # microns

  # Plot
  plot(nu_plot,fpfs,color=color,linestyle=linestyle,linewidth=linewidth,label=label,alpha=alpha)
  
  # Set axis labels
  ylabel('$F_p/F_s$',fontsize=20)
  xlabel('Wavelength [$\mu$m]',fontsize=20)

  # Add legend
  if label!=None:
    legend(loc=0,fontsize=15).draw_frame(0)
    
  if fname_save==None:
    print 'fname_save not defined, will not save figure'
  else:
    savefig(fname_save)
    
  # Show figure on screen
  if showfig == True: 
    show()

# Function to plot transmission spectrum
def plot_transmission_spectrum(
fname=None,              # Input Filename: UM output netcdf file
fname_phase=None,        # Input Filename: text file containing phase angle at each time point
fname_spec=None,         # Input Filename: UM spectral file
fname_save=None,         # Output Filename: Save figure to .ps of .pdf if defined
fname_txt_output=None,   # Output Filename: Save processed data as ascii file if defined
ncdf_name=None,        # Name of variable in netCDF file
sc = None,               # Solar constant (Wm-2)
rs=None,                 # Stellar radius (m)
rp=None,                 # Planet radius (m)
ztop = 0.,               # Height at top of the atmosphere (m)
start_trim=None,          # Integers to trim orbit
end_trim=None,            # Integers to trim orbit
linewidth=1,
label=None,
linestyle='-',
color='black',
alpha=1.,
shift=0.,
showfig=False
):
 
  # Check start_trim and end_trim are defined
  if start_trim==None or end_trim==None:
    print 'Error: both start_trim and end_trim must be defined'
    
  # Read and post-process transmission spectrum
  # Return wavelength (m) and (Rp/Rs)**2
  nu, rprs = construct_transmission_spectrum(fname,fname_phase,fname_spec,
    ncdf_name,start_trim,end_trim,sc,rp,rs,
    ztop,fname_txt_output)

  nu_plot = nu*1e6 # microns

  # Plot transit depth: (Rp/Rs)**2
  plot(nu_plot,rprs,label=label,color=color,linestyle=linestyle,linewidth=linewidth,alpha=alpha)

  ylabel('$(R_p/R_s)^2$',fontsize=15)
  xlabel('Wavelength $\mu$m]',fontsize=20)

  # Add legend
  if label!=None:
    legend(loc=0,fontsize=15).draw_frame(0)
    
  if fname_save==None:
    print 'fname_save not defined, will not save figure'
  else:
    savefig(fname_save)
    
  # Show figure on screen
  if showfig == True: 
    show()


from pylab import *
from netCDF4 import *
from scipy.interpolate import *

# Default parameters for coupled model:
gas_constant_default  = 3556.8
specific_heat_default = 1.3e4
pref_default   = 200.0E5

# Function to plot PT-profile
def plot_um_pt(ifig=1, file='xafrk.nc', long=0., lat=0., time=500., tit='', \
    label='', color = '', linewidth=1., linestyle='-', marker='', \
    figsize=(8.,6.), clear=False, pref=pref_default, \
    specific_heat=specific_heat_default, gas_constant=gas_constant_default,showfig=True):
	
  # ifig: index of the figure
  # file: input netCDF UM output file
  # long: longitude at which to plot PT profile
  # lat: latitude at which to plot PT-profile
  # time: time at which to plot PT-profile [day]
  # title: plot title
  # label: curve label, default ''
  # color: curve color, python's default color choice if =''
  # linewidth: line width of the curves
  # linestyle: line style
  # marker: marker symbol
  # clear: erase previous curves if True, default False
  # pref: reference surface pressure used in UM

  fid = Dataset(file, 'r')
  
  # Read dimensions
  dims = fid.variables['theta'].dimensions
  time_um = fid.variables[dims[0]][:]
  height_um = fid.variables[dims[1]][:]
  lat_um = fid.variables[dims[2]][:]
  long_um = fid.variables[dims[3]][:]
  
  # Get indices to use
  itime = argmin(abs(time_um - time))
  print 'Time: ', time_um[itime], ' days'
  ilong = argmin(abs(long_um - long))
  print 'Longitude: ', long_um[ilong]
  ilat = argmin(abs(lat_um - lat))
  print 'Longitude: ', lat_um[ilat]
  
  # Read pressure and potential temperature
  pressure = fid.variables['p'][itime,:,ilat,ilong]
  temperature = fid.variables['theta'][itime,:,ilat,ilong]
  
  # Convert potential temperature to temperature
  temperature = temperature* \
      (pressure/pref)**(gas_constant/specific_heat)
  

  figure(ifig,figsize=figsize)
  if clear:
    clf()
  if (color==''):
    semilogy(temperature, pressure, label=label, lw=linewidth, \
        linestyle=linestyle, marker=marker)
  else:
    semilogy(temperature, pressure, label=label, color=color, \
        lw=linewidth, linestyle=linestyle, marker=marker)
  
  if (tit != ''):
    title(tit,fontsize=12)
  xlabel('Temperature [K]',fontsize=20)
  ylabel('Pressure [Pa]',fontsize=20)
  
  # Inert y-axis
  ha = gca()
  ha.set_ylim([max(ha.get_ylim()), min(ha.get_ylim())])

  if (not label==''):
      legend(prop=prop).draw_frame(0)
  if showfig == True:
      show()
  
# Function to read PT-profile
def read_um_pt(file='xafrk.nc', long=0., lat=0., time=500., pref=pref_default, \
    specific_heat=specific_heat_default, gas_constant=gas_constant_default):
	
  # ifig: index of the figure
  # file: input netCDF UM output file
  # long: longitude at which to plot PT profile
  # lat: latitude at which to plot PT-profile
  # time: time at which to plot PT-profile [day]
  # title: plot title
  # label: curve label, default ''
  # color: curve color, python's default color choice if =''
  # linewidth: line width of the curves
  # linestyle: line style
  # marker: marker symbol
  # clear: erase previous curves if True, default False
  # pref: reference surface pressure used in UM

  fid = Dataset(file, 'r')
  
  # Read dimensions
  dims = fid.variables['theta'].dimensions
  time_um = fid.variables[dims[0]][:]
  height_um = fid.variables[dims[1]][:]
  lat_um = fid.variables[dims[2]][:]
  long_um = fid.variables[dims[3]][:]
  
  # Get indices to use
  itime = argmin(abs(time_um - time))
  print 'Time: ', time_um[itime], ' days'
  ilong = argmin(abs(long_um - long))
  print 'Longitude: ', long_um[ilong]
  ilat = argmin(abs(lat_um - lat))
  print 'Longitude: ', lat_um[ilat]
  
  # Read pressure and potential temperature
  pressure = fid.variables['p'][itime,:,ilat,ilong]
  temperature = fid.variables['theta'][itime,:,ilat,ilong]
  
  # Convert potential temperature to temperature
  temperature = temperature* \
      (pressure/pref)**(gas_constant/specific_heat)
  
  return pressure, temperature

# Function to write PT-profile to new file (Atmo input units)
def write_um_pt(file='xafrk.nc', fileout='pt_um.ncdf', long=0., lat=0., time=500., pref=pref_default, \
	specific_heat=specific_heat_default, gas_constant=gas_constant_default):
	
  # ifig: index of the figure
  # file: input netCDF UM output file
  # fileout: output netCDF file
  # long: longitude at which to plot PT profile
  # lat: latitude at which to plot PT-profile
  # time: time at which to plot PT-profile [day]
  # title: plot title
  # label: curve label, default ''
  # color: curve color, python's default color choice if =''
  # linewidth: line width of the curves
  # linestyle: line style
  # marker: marker symbol
  # clear: erase previous curves if True, default False
  # pref: reference surface pressure used in UM

  fid = Dataset(file, 'r')
  
  # Read dimensions
  dims = fid.variables['theta'].dimensions
  time_um = fid.variables[dims[0]][:]
  height_um = fid.variables[dims[1]][:]
  lat_um = fid.variables[dims[2]][:]
  long_um = fid.variables[dims[3]][:]
  
  # Get indices to use
  itime = argmin(abs(time_um - time))
  print 'Time: ', time_um[itime], ' days'
  ilong = argmin(abs(long_um - long))
  print 'Longitude: ', long_um[ilong]
  ilat = argmin(abs(lat_um - lat))
  print 'Longitude: ', lat_um[ilat]
  
  # Read pressure and potential temperature
  pressure = fid.variables['p'][itime,:,ilat,ilong]
  temperature = fid.variables['theta'][itime,:,ilat,ilong]
  
  # Convert potential temperature to temperature
  temperature = temperature* \
      (pressure/pref)**(gas_constant/specific_heat)
      
  # Convert pressure to dyn cm-2
  pressure = pressure*10.
  
  # Dimension length
  ndepth = pressure.size
  
  # Define new netCDF file for output
  # Units and format suitable for direct Atmo input
  fout = Dataset(fileout, 'w',format='NETCDF3_CLASSIC')
  fout.createDimension('nlevel',ndepth)
  ttout = fout.createVariable('temperature','f8',('nlevel'))
  ppout = fout.createVariable('pressure','f8',('nlevel'))
  ttout.units = 'K'
  ppout.units = 'dyn cm-2'
  
  ttout[:] = temperature[::-1]
  ppout[:] = pressure[::-1]
  
  fout.close()

# Function to plot PT-profile
def plot_um_p(ifig=1, file='xafrk.nc', long=0., lat=0., time=500., tit='', \
    label='', color = '', linewidth=1., linestyle='-', marker='', \
    figsize=(8.,6.), clear=False, pref=pref_default, \
    specific_heat=specific_heat_default, gas_constant=gas_constant_default):
	
  # ifig: index of the figure
  # file: input netCDF UM output file
  # long: longitude at which to plot PT profile
  # lat: latitude at which to plot PT-profile
  # time: time at which to plot PT-profile [day]
  # title: plot title
  # label: curve label, default ''
  # color: curve color, python's default color choice if =''
  # linewidth: line width of the curves
  # linestyle: line style
  # marker: marker symbol
  # clear: erase previous curves if True, default False
  # pref: reference surface pressure used in UM

  fid = Dataset(file, 'r')
  
  # Read dimensions
  dims = fid.variables['theta'].dimensions
  time_um = fid.variables[dims[0]][:]
  height_um = fid.variables[dims[1]][:]
  lat_um = fid.variables[dims[2]][:]
  long_um = fid.variables[dims[3]][:]
  
  # Get indices to use
  itime = argmin(abs(time_um - time))
  print 'Time: ', time_um[itime], ' days'
  ilong = argmin(abs(long_um - long))
  print 'Longitude: ', long_um[ilong]
  ilat = argmin(abs(lat_um - lat))
  print 'Longitude: ', lat_um[ilat]
  
  # Read pressure and potential temperature
  pressure = fid.variables['p_1'][itime,:,ilat,ilong]
  
  # Convert pressure to bar
  pressure = pressure*1e-5

  figure(ifig,figsize=figsize)
  if clear:
    clf()
  if (color==''):
    semilogy(height_um, pressure, label=label, lw=linewidth, \
        linestyle=linestyle, marker=marker)
  else:
    semilogy(height_um, pressure, label=label, color=color, \
        lw=linewidth, linestyle=linestyle, marker=marker)
  
  if (tit != ''):
    title(tit,fontsize=12)
  xlabel('Height [m]')
  ylabel('$P$ [bar]')
  
  # Inert y-axis
  ha = gca()
  ha.set_ylim([max(ha.get_ylim()), min(ha.get_ylim())])

  if (not label==''):
      legend(prop=prop).draw_frame(0)
  show()

def plot_am(file='conservation.dat',tspd=2880.,relative=True):
  
  # file: filename with angular momentum data
  # tspd: number of time steps per day
  # relative: normalise angular momentum
  
  data = loadtxt(file, skiprows=1, usecols=(0, 2))
  
  if relative:
    plot(data[:,0]/tspd, data[:,1]/data[0,1] - 1.)
    ylabel(r'Normalised ngular momentum')
  else:
    plot(data[:,0]/tspd, data[:,1])
    ylabel(r'Angular momentum [Nms]')

  xlabel(r'Time [day]')
  
  show()

def read_am(file='conservation.dat',tspd=2880.,relative=True):
  
  # file: filename with angular momentum data
  # tspd: number of time steps per day
  # relative: normalise angular momentum
  
  data = loadtxt(file, skiprows=1, usecols=(0, 2))
  
  if relative:
    return data[:,0]/tspd, data[:,1]/data[0,1]
  else:
    return data[:,0]/tspd, data[:,1]

# Function to create a hemispheric average of the PT profile and write it to an ATMO format PT file
def write_hemisphere_avg(file='/home/dsa206/UM_netcdf/HD209/xagbc.nc',fileout='pt_um.ncdf',hemisphere='Dayside'):

	#Read an inital PT profile to get vertical domain size
	pressure,temperature = read_um_pt(file=file)

	#Create arrays
	temperature_avg = np.zeros(len(pressure))
	pressure_avg    = np.zeros(len(pressure))
	temperature_sum = np.zeros(len(pressure))
 
 	#Set new pressure scale (so that all columns can be calculated on same pressure grid)
	pmin = 1.0
	pmax = 7.0
	pressure_new = np.logspace(pmin,pmax,len(pressure))
	
	#Set latitude and longitude limits
	lat_min  = -90
	lat_max  =  90
	
	if hemisphere == 'Dayside':
		long_min =  90
		long_max = 270
	
	if hemisphere == 'Nightside':
		long_min = 270
		long_max = 270 + 180
	
	sum = 0.
	
	#Loop over latitude and longitude
	for ilong in range(long_min,long_max):
		
		if ilong < 360:
			ilong_loc = ilong
		if ilong >= 360:
			ilong_loc = ilong-360
			
		for ilat in range(lat_min,lat_max):
			
			#Read current PT profile
			pressure,temperature = read_um_pt(file=file,long=ilong_loc,lat=ilat,time=1400.)
			
			#interpolate PT profile
			print len(pressure),len(temperature)
			fint = interp1d(pressure[::-1],temperature[::-1])
			temperature_new = fint(pressure_new)
			
			#Add current PT profile to the total (note: area-weighted)
			temperature_sum = temperature_sum + temperature_new*math.cos(math.radians(ilat))
			sum = sum + math.cos(math.radians(ilat))
			
	#Take the average
	temperature_avg = temperature_sum/sum
	
	# Convert pressure to dyn cm-2
	pressure = pressure_new*10.

	# Dimension length
	ndepth = pressure.size

	# Define new netCDF file for output
	# Units and format suitable for direct Atmo input
	fout = Dataset(fileout, 'w',format='NETCDF3_CLASSIC')
	fout.createDimension('nlevel',ndepth)
	ttout = fout.createVariable('temperature','f8',('nlevel'))
	ppout = fout.createVariable('pressure','f8',('nlevel'))
	ttout.units = 'K'
	ppout.units = 'dyn cm-2'

	ttout[:] = temperature_avg[:]
	ppout[:] = pressure[:]

	fout.close()
	
def plot_windmax(file='',wind='uvw',linewidth=2,linestyle='-',
timestep=30.,color='',
leg=True,showfig=True):

	data = loadtxt(file)

	time = data[:,0]*timestep/60./60./24. # time in days

	if wind=='u' or wind=='uvw':
		if color == '':
			colorplot='blue'
		else:
			colorplot=color
		plot(time,data[:,1],linestyle=linestyle,linewidth=linewidth,color=colorplot,label='$u$')
	if wind=='v' or wind=='uvw':
		if color == '':
			colorplot='green'
		else:
			colorplot = color
		plot(time,data[:,2],linestyle=linestyle,linewidth=linewidth,color=colorplot,label='$v$')
	if wind=='w' or wind=='uvw':
		if color == '':
			colorplot = 'red'
		else:
			colorplot = color
		plot(time,data[:,3],linestyle=linestyle,linewidth=linewidth,color=colorplot,label='$w$')

	xlabel('Time [days]',fontsize=20)
	ylabel('Wind Velocity [ms$^{-1}$]',fontsize=20)

	if leg == True:
		legend(loc=0,fontsize=15).draw_frame(0)

	if showfig == True:
		show()
	
def plot_conservation_diag(file='',
timestep=30., # timestep of simulation in s
linewidth=2,
linestyle='-',
label='',
color='',
showfig=True):

	data = loadtxt(file)
	
	time = data[:,0]*timestep/60./60./24. # time in days
	rel_ang_mom = data[:,2]/data[0,2]*100. # in %
	
	if color == '':
		color='blue'
		
	plot(time,rel_ang_mom,linewidth=linewidth,linestyle=linestyle,color=color,label=label)
	
	xlabel('Time [days]',fontsize=20)
	ylabel('Relative Angular Momentum [%]',fontsize=20)
	
	if label != '':
		legend(loc=0,fontsize=15).draw_frame(0)
	
	if showfig==True:
		show()
		
def plot_heating_rate(file='',
long=0.,
lat=0.,
time=0.,
type='sw',
label='',
color='black',
linewidth=2,
linestyle='-',
showfig=True):

	data = Dataset(file,'r')

	dims = data.variables['p'].dimensions
	time_um = data.variables[dims[0]][:]
	height_um = data.variables[dims[1]][:]
	lat_um = data.variables[dims[2]][:]
	long_um = data.variables[dims[3]][:]

	# Get heating rate at requested point
	# Get indices to use
	itime = argmin(abs(time_um - time))
	print 'Time: ', time_um[itime], ' days'
	ilong = argmin(abs(long_um - long))
	print 'Longitude: ', long_um[ilong]
	ilat = argmin(abs(lat_um - lat))
	print 'Longitude: ', lat_um[ilat]
	
	if type == 'sw':
		var_name = 'swhr'
	elif type == 'lw':
		var_name = 'lwhr'
  
	# Read pressure and heating rate
	pressure = data.variables['p'][itime,:,ilat,ilong]
	heat_rate = data.variables[var_name][itime,:,ilat,ilong]
	#heat_rate_sw = data.variables['swhr'][itime,:,ilat,ilong]
	#heat_rate_lw = data.variables['lwhr'][itime,:,ilat,ilong]
	
	#heat_rate = heat_rate_sw+heat_rate_lw
	
	# Get pressures in cell center
	pressure_center = np.zeros(height_um.size-1)
	for i in range(height_um.size-1):
		pressure_center[i] = sqrt(pressure[i]*pressure[i+1])

	plot(heat_rate,pressure_center,color=color,linestyle=linestyle,label=label,linewidth=linewidth)
	
	yscale('log')
	ylim(1e7,10.)
	
	xlabel('Heating Rate [K/s]',fontsize=20)
	ylabel('Pressure [Pa]',fontsize=20)
	
	if label != '':
		legend(loc=0,fontsize=10).draw_frame(0)
	
	if showfig==True:
		show()
  
def plot_wind_velocity_pressure(file='',
long=0.,
lat=0.,
time=0.,
type='sw',
label='',
color='black',
linewidth=2,
linestyle='-'):

	data = Dataset(file,'r')

	dims = data.variables['p'].dimensions
	time_um = data.variables[dims[0]][:]
	height_um = data.variables[dims[1]][:]
	lat_um = data.variables[dims[2]][:]
	long_um = data.variables[dims[3]][:]

	# Get heating rate at requested point
	# Get indices to use
	itime = argmin(abs(time_um - time))
	print 'Time: ', time_um[itime], ' days'
	ilong = argmin(abs(long_um - long))
	print 'Longitude: ', long_um[ilong]
	ilat = argmin(abs(lat_um - lat))
	print 'Longitude: ', lat_um[ilat]
	
	if type == 'u':
		varname = 'u'
	elif type == 'v':
		varname = 'v'
	elif type == 'w':
		varname = 'dz_dt'
  
	# Read pressure and heating rate
	pressure = data.variables['p'][itime,:,ilat,ilong]
	#heat_rate = data.variables[var_name][itime,:,ilat,ilong]
	wind = data.variables[varname][itime,:,ilat,ilong]

	plot(wind,pressure,color=color,linestyle=linestyle,label=label,linewidth=linewidth)
	
	yscale('log')
	ylim(1e7,10.)
	
	xlabel('Wind [m/s]',fontsize=20)
	ylabel('Pressure [Pa]',fontsize=20)
	
	if label != '':
		legend(loc=0,fontsize=10).draw_frame(0)
	
	show()
	
	
def get_wind_velocity(file='',time=0.,long=0.,lat=0.,type='u',
pref=pref_default,specific_heat=specific_heat_default, gas_constant=gas_constant_default):

	data = Dataset(file,'r')
	
        
	dims = data.variables['p'].dimensions
        time_um = data.variables[dims[0]][:]
        height_um = data.variables[dims[1]][:]
        lat_um = data.variables[dims[2]][:]
        long_um = data.variables[dims[3]][:]

        # Get heating rate at requested point
        # Get indices to use
        itime = argmin(abs(time_um - time))
        print 'Time: ', time_um[itime], ' days'
        ilong = argmin(abs(long_um - long))
        print 'Longitude: ', long_um[ilong]
        ilat = argmin(abs(lat_um - lat))
        print 'Longitude: ', lat_um[ilat]

	if type == 'u':
                varname = 'u'
        elif type == 'v':
                varname = 'v'
        elif type == 'w':
                varname = 'dz_dt'

	pressure = data.variables['p'][itime,:,ilat,ilong]
        wind = data.variables[varname][itime,:,ilat,ilong]

	return pressure, wind

from pylab import *

def plot_phase_curve(fname,color='blue',linewidth=2,linestyle='-',label='Phase Curve'):

  # Read file
  data = loadtxt(fname)
  
  plot(data[:,0],data[:,1],label=label,linewidth=linewidth,color=color,linestyle=linestyle)
  
  xlim(0.,360.)
  
  xlabel('Phase Angle [Deg]',fontsize=20)
  ylabel('Normalised Flux',fontsize=20)
  
  legend(loc=0,fontsize=15).draw_frame(0)

# Plot simple phase curves for GJ1214b simulations 
# Standard
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at098/zs17_phase_curve_u-at098_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at124/zs17_phase_curve_u-at124_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at098_u-at124_phase_curve.pdf')
clf()

# Small Radius
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at111/zs17_phase_curve_u-at111_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at129/zs17_phase_curve_u-at129_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)    
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at111_u-at129_phase_curve.pdf')
clf()

# Fast Winds
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at401/zs17_phase_curve_u-at401_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at404/zs17_phase_curve_u-at404_p3000.dat',
  color='red',
  label='Primitive')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-aw761/zs17_phase_curve_u-aw761_p3000.dat',
  color='green',
  label='Deep')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at401_u-at404_phase_curve.pdf')
clf()

# Fast Winds + Small Radius
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at403/zs17_phase_curve_u-at403_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at409/zs17_phase_curve_u-at409_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at403_u-at409_phase_curve.pdf')
clf()

# Small Radius + Slow Rotator
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-ax467/zs17_phase_curve_u-ax467_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-ax466/zs17_phase_curve_u-ax466_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-ax467_u-ax466_phase_curve.pdf')
clf()

# Fast rotator
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at411/zs17_phase_curve_u-at411_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at413/zs17_phase_curve_u-at413_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)    
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at411_u-at413_phase_curve.pdf')
clf()

# CO2
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at112/zs17_phase_curve_u-at112_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at127/zs17_phase_curve_u-at127_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)    
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at112_u-at127_phase_curve.pdf')
clf()

# Large radius
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at415/zs17_phase_curve_u-at415_p3000.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at417/zs17_phase_curve_u-at417_p3000.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at415_u-at417_phase_curve.pdf')
clf()


# 100 PA
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at098/zs17_phase_curve_u-at098_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at124/zs17_phase_curve_u-at124_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at098_u-at124_phase_curve_p100.pdf')
clf()

# Small Radius
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at111/zs17_phase_curve_u-at111_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at129/zs17_phase_curve_u-at129_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)    
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at111_u-at129_phase_curve_p100.pdf')
clf()

# Fast Winds
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at401/zs17_phase_curve_u-at401_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at404/zs17_phase_curve_u-at404_p100.dat',
  color='red',
  label='Primitive')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-aw761/zs17_phase_curve_u-aw761_p100.dat',
  color='green',
  label='Deep')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at401_u-at404_phase_curve_p100.pdf')
clf()

# Fast Winds + Small Radius
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at403/zs17_phase_curve_u-at403_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at409/zs17_phase_curve_u-at409_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at403_u-at409_phase_curve_p100.pdf')
clf()

# Small Radius + Slow Rotator
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-ax467/zs17_phase_curve_u-ax467_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-ax466/zs17_phase_curve_u-ax466_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-ax467_u-ax466_phase_curve_p100.pdf')
clf()

# Fast rotator
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at411/zs17_phase_curve_u-at411_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at413/zs17_phase_curve_u-at413_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)    
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at411_u-at413_phase_curve_p100.pdf')
clf()

# CO2
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at112/zs17_phase_curve_u-at112_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at127/zs17_phase_curve_u-at127_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)    
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at112_u-at127_phase_curve_p100.pdf')
clf()

# Large radius
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at415/zs17_phase_curve_u-at415_p100.dat',
  color='blue',
  label='Full')
plot_phase_curve(fname='/home/njm202/UM/Analysis/Prim_vs_Full/Data/Phase_curves/u-at417/zs17_phase_curve_u-at417_p100.dat',
  color='red',
  label='Primitive')

title('',fontsize=20)  
savefig('/home/njm202/UM/Analysis/Prim_vs_Full/PS/Phase_curves/u-at415_u-at417_phase_curve_p100.pdf')
clf()


#!/usr/bin/python
# ----- Header --------------------------------------------------------------- #
import vtk
from   tvtk import array_handler as ah
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.tri as tri
from matplotlib.legend_handler import HandlerLine2D
import numpy as np
import time
import os
# ---------------------------------------------------------------------------- #

def openvtu(filename):

    # Initialize VTK reader
    reader = vtk.vtkXMLUnstructuredGridReader()
    reader.SetFileName(filename)
    reader.Update()

    # Get data
    data = reader.GetOutput()

    # SPH particle positions
    vtk_points = data.GetPoints().GetData()
    points     = ah.vtk2array(vtk_points)

    # Read Fluid field
    vtk_fluid = data.GetPointData().GetArray('Fluid')
    fluid     = ah.vtk2array(vtk_fluid)

    # Read Fluid field
    vtk_color = data.GetPointData().GetArray('Color')
    color     = ah.vtk2array(vtk_color)

    # Read Velocity fields
    vtk_velocityX = data.GetPointData().GetArray('Velocity x')

    return points,color

if __name__ == '__main__':

    # Box sizes
    BOXY  = 0.6*10.0**-2
    BOXX  = BOXY*5
    REVXMIN = 0.45*BOXX
    REVXMAX = BOXX-4*1.7*(BOXY/200)*1.5

    from optparse import OptionParser

    parser = OptionParser()
    parser.add_option("-l","--label"    ,type=int ,dest="label"    ,default=True)
    parser.add_option("-t","--ticks"    ,type=int ,dest="ticks"    ,default=True)
    parser.add_option("-f","--filename",type=str  ,dest="filename",default=None)
    parser.add_option("-x","--xmin"    ,type=float,dest="xmin"    ,default=None)
    parser.add_option("-X","--xmax"    ,type=float,dest="xmax"    ,default=None)
    parser.add_option("-y","--ymin"    ,type=float,dest="ymin"    ,default=None)
    parser.add_option("-Y","--ymax"    ,type=float,dest="ymax"    ,default=None)
    parser.add_option("-s","--size"    ,type=float,dest="size"    ,default=4.0)
    parser.add_option("-n","--name"    ,type=str  ,dest="name"    ,default='Test')
    (options, args) = parser.parse_args()

    # Open VTU file and read positions and colors
    p,c  = openvtu(options.filename)

    # Species
    solids   = p[np.where(c==0)]
    nwetting = p[np.where(c==1)]
    wetting  = p[np.where(c==2)]

    print ("solids")
    print (solids)

    print ("non-wetting")
    print (nwetting)

    print ("wetting")
    print (wetting)

    # Xmin/max
    xmin = 0.013 if options.xmin == None else options.xmin
    xmax = 0.028 if options.xmax == None else options.xmax
    ymin = 0.0  if options.ymin == None else options.ymin
    ymax = BOXY if options.ymax == None else options.ymax

    # Plot particles
    # Compute figure size
    fig_width_pt  = 2*246.0                    # Get this from LaTeX using \showthe\columnwidth
    inches_per_pt = 1.0/72.27                  # Convert pt to inch
    golden_mean   = (np.sqrt(5)-1.0)/2.0       # Aesthetic ratio
    fig_width     = fig_width_pt*inches_per_pt # Width in inches
    fig_height    = fig_width*golden_mean*1.3  # Height in inches
    fig_size      = [fig_width*1.5,fig_height] # Figure size

    # Set rc parameters
    params = {'backend'              :'pdf',
              'axes.labelsize'       :14,
              'text.fontsize'        :14,
              'legend.fontsize'      :10,
              'xtick.labelsize'      :12,
              'ytick.labelsize'      :12,
              'figure.subplot.top'   :0.9,
              'figure.subplot.left'  :0.15,
              'figure.subplot.right' :0.9,
              'figure.subplot.bottom':0.1,
              'figure.subplot.hspace':0.3,
              'text.usetex'          :True}
              # 'text.latex.preamble'  :['\usepackage{bm}','\usepackage{arev}']}
              #'figure.figsize'       :fig_size}
    plt.rcParams.update(params)

    # Create figure instance
    fig = plt.figure()
    ax  = fig.add_subplot(111, aspect='equal', autoscale_on=False,
                         xlim=(xmin,xmax), ylim=(ymin,ymax))

    # Plot particles
    p1, = ax.plot(solids.T[0]  ,solids.T[1]  ,'bo',markersize=options.size,markeredgecolor='none',label='Rigid Grains')
    p3, = ax.plot(nwetting.T[0],nwetting.T[1],'o',color='gray',markersize=options.size,markeredgecolor='none',label='Non-Wetting')
    p2, = ax.plot(wetting.T[0] ,wetting.T[1] ,'o',color='red',markersize=options.size,markeredgecolor='none',label='Wetting')



    if options.label:
        # Generate Legend
        leg = ax.legend(bbox_to_anchor=(0.0, 1.02, 1.0, 0.102), loc=3,
                   ncol=3, mode="expand", borderaxespad=0.,
                   handler_map={p1: HandlerLine2D(numpoints=8),p2: HandlerLine2D(numpoints=8), p3: HandlerLine2D(numpoints=8)})
        for color,text in zip(['b','k','r'],leg.get_texts()):
            text.set_color(color)

    ax.set_xticks([])
    ax.set_yticks([])
    if options.ticks:
        ax.set_xticks([xmin,xmax])
        ax.set_xticklabels( ('{0:.1f} mm'.format(xmin*100),'{0:.1f} mm'.format(xmax*100)))
        ax.set_yticks([ymin,ymax])
        ax.set_yticklabels( ('{0:.1f} mm'.format(ymin*100),'{0:.1f} mm'.format(ymax*100)))

    plt.show()
    #exportfile = options.name
    #plt.savefig(exportfile + '.eps')
    #plt.savefig(exportfile + '.pdf')

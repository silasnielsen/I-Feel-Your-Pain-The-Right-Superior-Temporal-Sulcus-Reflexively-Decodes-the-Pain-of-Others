# -*- coding: utf-8 -*-
"""
Created on Tue Nov 27 17:19:31 2012

@author: khm
"""

from psychopy import visual,core ,event
import numpy,time
mywin=visual.Window(color=(-1,-1,-1))

r=50
p=numpy.linspace(numpy.pi,0,100)
xy=list()
xy.append((0,0))
for i in p:xy.append((r*numpy.cos(i),r*numpy.sin(i)))
xy.append((0,0))
line=visual.ShapeStim(mywin,lineColor=None,fillColor=(1,-1,-1),closeShape=True,vertices=xy,units='pix',interpolate=False)
circle=visual.Circle(mywin,45,edges=20,fillColor=(-1,-1,-1),units='pix',lineColor=None,interpolate=False)



for pos in numpy.linspace(0,1,50):
    xx=numpy.int(pos*100.)
    #x+=(numpy.random.random(1)-.5)
    #xx=numpy.int(x)    
    line.setFillColor((-1,1,-1))
    line.setLineColor((-1,1,-1))    
    line.setVertices(xy)
    line.draw()
    line.setFillColor((1,-1,-1))
    line.setLineColor((1,-1,-1))
    line.setVertices(xy[0:xx+1])
    line.draw()
  
    circle.draw()
    mywin.flip()
time.sleep(1)
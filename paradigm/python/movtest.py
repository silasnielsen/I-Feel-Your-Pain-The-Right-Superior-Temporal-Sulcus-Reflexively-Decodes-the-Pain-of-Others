# -*- coding: utf-8 -*-
"""
Created on Thu Jan 17 10:43:53 2013

@author: KHM
"""
from psychopy import visual,core ,event, gui
import time,numpy,threading,ctypes,datetime,scipy.io

import fMRIlib_inpout32
import winsound,time

win=visual.Window(color=(-1,-1,-1),fullscr=False)
movie=visual.MovieStim(win,filename='Hammer0001.avi',units='norm',pos=(0,0),size=(1,1))
#movie.loadMovie(filename='Hammer0001.avi')
win.flip()
movie.play()
#movie.setAutoDraw(True)
t=time.clock()
while (time.clock()-t)<60:
    movie.draw()
    win.flip()
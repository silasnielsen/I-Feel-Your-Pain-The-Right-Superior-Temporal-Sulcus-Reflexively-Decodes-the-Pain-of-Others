#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 11 12:02:27 2012

@author: khm
"""
from psychopy import visual,core ,event, gui
import time,numpy,threading,ctypes,datetime,scipy.io,Image

import fMRIlib_inpout32
import winsound

def stimulate(trigger,triggerPort,triggerval,timer,onsets,N,duration=1.,stimtime=0.01):
    trigger.Out32(triggerPort,0)    
    for i in range(len(onsets)):
        if timer.stop:
            break
        timer.realWait(onsets[i])
        for ii in range(N):
            trigger.Out32(triggerPort,triggerval)
            timer.absWait(stimtime)
            trigger.Out32(triggerPort,0)
            timer.absWait(duration/N)

if __name__ == '__main__':
    mywin=visual.Window()
    inputM=fMRIlib_inpout32.inputMonitor()
    inputM.timer.stop=False
    trigger=ctypes.windll.inpout32
    breaktime=9.
    trigger.Out32(0xE800,0)
    triggerPort=0xE800
    triggerval=255
    stopstim=False
    N=20
    duration=1.
    stimtime=0.01
    inputM.waitTrigger() #wait for trigger
    while not(stopstim):
        inputM.timer.absWait(breaktime)
        for ii in range(N):
            trigger.Out32(triggerPort,triggerval)
            inputM.timer.absWait(stimtime)
            trigger.Out32(triggerPort,0)
            inputM.timer.absWait(duration/N)
        if len(event.getKeys('q'))>0: stopstim=True
    

    inputM.stopAll()
    mywin.close()
    core.quit()
    inputM=None
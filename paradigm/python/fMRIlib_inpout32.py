# -*- coding: utf-8 -*-
"""
Created on Thu Jul  7 11:03:00 2011

@author: Kristoffer H. Madsen (DRCMR)
"""
import ctypes

import time, sys
import threading, numpy
from psychopy import event
#Modified from psycopy's core.py script

try:
    import pyglet.media
    import pyglet.window.get_platform
    havePyglet = True
except:
    havePyglet = False

#set the default timing mechanism
"""(The difference in default timer function is because on Windows,
clock() has microsecond granularity but time()'s granularity is 1/60th
of a second; on Unix, clock() has 1/100th of a second granularity and
time() is much more precise.  On Unix, clock() measures CPU time 
rather than wall time.)"""
if sys.platform == 'win32':
    getTime = time.clock
else:
    getTime = time.time


class absSleepClass:
    
    def __init__(self):
        self.lasttime=getTime()
        self.inittime=self.lasttime
    
 
    def absWait(self,secs, hogCPUperiod=0.2,overhead=0.0):
        targettime=self.lasttime+secs
        ttime=targettime-overhead
        timeleft=ttime-getTime()
        #if timeleft<0:
        #    print "Error: Time already passed"
            
        if timeleft>hogCPUperiod:
            time.sleep(timeleft-hogCPUperiod)
            
        while getTime()<ttime:
            #let's see if pyglet collected any event in meantime
            try:
                pyglet.media.dispatch_events()#events afor sounds/video should run independently of wait()
                wins = pyglet.window.get_platform().get_default_display().get_windows()
                for win in wins: win.dispatch_events()#pump events on pyglet windows            
            except:
                pass #presumably not pyglet
            time.sleep(0.0)
        self.lasttime=targettime
        
    def timePassed(self):
        return getTime()-self.inittime
    
    def timePassedSinceLast(self):
        return getTime()-self.lasttime

    def resetlast(self):
        self.lasttime=getTime()
    
    def reset(self):
        self.lasttime=getTime()
        self.inittime=self.lasttime
        
    def timeAtLastReset(self):
        return self.inittime
    
    def realWait(self,target):
        self.absWait(target-self.timePassed())
        
def int2logical(a,bitlength=None):
    if bitlength==None:
        bitlength=numpy.ceil(numpy.log2(a+1))
    if a==0:
        return numpy.zeros(bitlength,dtype=bool)
    else:
        k={'0':[0,0,0],'1':[0,0,1],'2':[0,1,0],'3':[0,1,1],
           '4':[1,0,0],'5':[1,0,1],'6':[1,1,0],'7':[1,1,1]}
        a=oct(a)[1:]
        nb=len(a)*3
        out=numpy.zeros(numpy.max((nb,bitlength)),dtype=bool)
        i=0
        for c in a:
            out[i:i+3]=k[c]
            i += 3
        return out[::-1][0:bitlength]

def getTriggerState(trigger,triggerPort,triggerbit):
    if triggerPort==None:
        return None
    else:
        out=trigger.Inp32(triggerPort)
        #print out
        return int2logical(out,8)[triggerbit]

def eventLoopInp32(inputM):    
    bitlength=8
    out=int2logical(inputM.trigger.Inp32(inputM.inputPort),bitlength)
    oldout=out.copy()
    while not(inputM.stop):
        out=int2logical(inputM.trigger.Inp32(inputM.inputPort),bitlength)
        idx=numpy.nonzero(out<>oldout)
        oldout=out.copy()
        for i in idx[0]:
            inputM.keypresses.append((numpy.sign(out[i]-0.5)*(i+10),inputM.timer.timePassed()))
        time.sleep(inputM.polltime)

def waitTriggerLoop(self,resettimer=False,allowKeyboard=False):
        self.triggerState=getTriggerState(self.trigger,self.triggerPort,self.triggerbit)
        while not(self.stop):
            state=getTriggerState(self.trigger,self.triggerPort,self.triggerbit)
            #print state
            if not(state==self.triggerState) or (allowKeyboard and len(event.getKeys('c'))>0):
                self.triggerTime=getTime()
                if resettimer:
                    self.timer.inittime=self.triggerTime
                    self.timer.lasttime=self.triggerTime
                self.triggerState=state
                self.triggerTimes.append(self.triggerTime)
            time.sleep(self.polltime)

class inputMonitor:
    def __init__(self,inputPort=0xE800,triggerPort=None,triggerbit=5,polltime=0.,useKeyboard=False,triggerMonitor=False):
        if triggerPort==None and not(inputPort==None):
            self.triggerPort=inputPort+1
        else:
            self.triggerPort=triggerPort
        if not(inputPort == None):
            try:
                self.trigger=ctypes.windll.inpout32
                self.trigger.Out32(0xe482,32)
                self.trigger.Out32(inputPort+2,32)
            except:
                try:
                    self.trigger=ctypes.windll.inpoutx64
                    self.trigger.Out32(0xe482,32)
                    self.trigger.Out32(inputPort+2,32)
                except:
                    print 'Parallel port initialization failed'
                    self.trigger=None
                        
        else:
            self.trigger = None
#        self.pokeys=None
#        try:
#            import win32com.client
#            tmp=win32com.client.Dispatch('PoKeysDevice_DLL.PoKeysDevice')
#            tmp.EnumerateDevices()
#            if tmp.ConnectToDevice(0):
#                self.pokeys=tmp
#                print 'PoKeys connection OK'
#        except:
#            self.pokeys=None
#            print 'poKeys connection failed!'
        self.inputPort=inputPort        
        self.useKeyboard=useKeyboard
        self.triggerbit=triggerbit
        self.polltime=polltime
        self.triggerState = getTriggerState(self.trigger,self.triggerPort,self.triggerbit)
        self.initTime = getTime()
        self.timer = absSleepClass()  
        self.triggerTimes = list()
        self.keypresses=list()
        self.stop=False
        self.timemarks=list()
        self.resppos=0
        self.triggerMonitor=triggerMonitor
        self.triggerThread=None
        
    def startEventLoop(self):
        self.eventLoop = threading.Thread(target=eventLoopInp32, args=(self,))
        self.eventLoop.start()
        
    def setMark(self,timemark=None):
        if timemark==None:
            self.timemarks.append(self.timer.timePassed())
        else:
            self.timemarks.append(timemark)
        self.resppos=len(self.keypresses)
        if self.useKeyboard:
            event.clearEvents()
    def getKeys(self,keyList=None,timemark=True):
        out=list()        
        if (len(self.keypresses)-self.resppos)>0:            
            for i in range(self.resppos,len(self.keypresses)):
                if keyList==None:
                    out.append(self.keypresses[i])
                elif self.keypresses[i][0] in keyList:
                    out.append(self.keypresses[i])
        if timemark and len(self.timemarks)>0:
            for k in range(len(out)): out[k] = (out[k][0],out[k][1]-self.timemarks[-1])
        self.resppos=len(self.keypresses)
        if self.useKeyboard:
            outk=event.getKeys(keyList,True)
            for i in range(len(outk)):
                if len(self.timemarks)>0:
                    out.append((outk[i][0],outk[i][1]-self.timemarks[-1]-self.timer.inittime))
                else:
                    out.append((outk[i][0],outk[i][1]-self.timer.inittime))
            event.clearEvents()
        return out
    
    def waitTrigger(self,resettimer=True,allowKeyboard=True):
        self.triggerState=getTriggerState(self.trigger,self.triggerPort,self.triggerbit)
        while not(self.stop):
            state=getTriggerState(self.trigger,self.triggerPort,self.triggerbit)
            #print state
            if not(state==self.triggerState) or (allowKeyboard and len(event.getKeys('c'))>0):
                self.triggerTime=getTime()
                if resettimer:
                    self.timer.inittime=self.triggerTime
                    self.timer.lasttime=self.triggerTime
                self.triggerState=state
                self.triggerTimes.append(self.triggerTime)
                if self.triggerMonitor:
                    self.triggerMonitor = threading.Thread(target=waitTriggerLoop, args=(self,False,False))
                    self.triggerMonitor.start()
                break
            time.sleep(self.polltime)
           
    def stopAll(self,timeout=0.5):
        self.stop=True
        time.sleep(timeout)
        try:
            self.eventLoop.join(1)
        except:
            self.eventLoop=None
        if self.triggerMonitor:
            ITI=numpy.diff(self.triggerTimes)*1000.
            mITI=numpy.mean(ITI)
            sITI=numpy.std(ITI)
            print '%i triggers detected, mean ITI: %f, std ITI: %f'%(len(self.triggerTimes),mITI,sITI)

    def waitKey(self,keyList):
        stop=False        
        while not(stop):
            out=self.getKeys(keyList)
            if len(out)>0:
                stop=True
                return out
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 10 11:11:13 2012

@author: Kristoffer H. Madsen@Danish Research Centre for MR
Script for recording from PicoLog 1216 device (USB), uses the compiled PL1000.dll interface
meaning it it Windows only (32 bit or WOW64).

#Initialize via something like:
from picolog_recorder import interface
pico=interface(samplerate=100,filename='test.txt')
#if a filename is provided the recorded values will be dumped to the file as space seperated strings

#Then start the aqusition with
pico.start()
#the variable interface.currentValue will contain the last observed value
#Stop the aqusition with
interface.close()
"""

import ctypes
import threading
import time

class interface():
    def __init__(self,channel=1,samplerate=50,buffersize=0,filename=None):
        self.handle       = ctypes.c_ushort()        
        self.opened       = False
        self.stop         = False
        self.status       = None
        self.currentValue = None
        self.samples      = list()
        self.c            = ctypes.c_ushort(channel)
        self.nc           = ctypes.c_ulong(1)
        self.scantime     = 1./samplerate
        self.samplerate   = samplerate
        if self.scantime<0.5:
            window=1
        else:
            window=self.scantime*2
        self.us_block = ctypes.c_ulong(int(round(window*1000000)))
        self.nS       = ctypes.c_ulong(int(round(window*samplerate)))
        self.maxValue = ctypes.c_ushort()
        self.nSbuf    = self.nS.value
        setval        = ctypes.c_ushort*int(self.nSbuf)
        self.values   = setval(0)
        self.loop     = None
        self.overflow = ctypes.c_ushort(0)
        self.pl=ctypes.windll.LoadLibrary('PL1000.dll')
        self.connect()
        if filename==None:
            self.file=None
        else:
            self.file= open(filename, 'w')
        if self.opened and self.maxValue>0:
            #setup trigger
            self.status   = self.pl.pl1000SetTrigger(self.handle, False, 0, 0, 0, 0, 0, 0, 0)
            #print self.status
            
            self.status   = self.pl.pl1000SetInterval(self.handle, ctypes.byref(self.us_block), self.nS, ctypes.byref(self.c) ,self.nc)  
            print self.status
        else:
            print "Device initialization failed."
        
    def connect(self):
        self.opened   = self.pl.pl1000OpenUnit(ctypes.byref(self.handle))==0
        print 'opened: %s' % self.opened
        self.status = self.pl.pl1000MaxValue(self.handle, ctypes.byref(self.maxValue))

    def getValuesLoop(self):
        
        triggerIndex=ctypes.c_ulong(0)
        while self.stop==False:
            nSrec=ctypes.c_ulong(self.nSbuf)
            status=self.pl.pl1000GetValues(self.handle, ctypes.byref(self.values), ctypes.byref(nSrec), ctypes.byref(self.overflow), ctypes.byref(triggerIndex))
            #print self.status
            if status==0 and nSrec.value>0:
                #self.samples.append(self.values[0:nSrec.value])
                if self.file<>None:
                    self.file.write(' '.join(str(x) for x in self.values[0:nSrec.value])+' ')
                #print nSrec.value
                #print self.values[nSrec.value-1]
                self.currentValue=self.values[nSrec.value-1]  
                #print self.overflow
            time.sleep(self.scantime)
        self.status=self.pl.pl1000Stop(self.handle)

    def start(self):
        self.status = self.pl.pl1000Run(self.handle, self.nS, 2)
        print 'status: %f' % self.status
        self.loop = threading.Thread(target=self.getValuesLoop, args=())
        self.loop.start()
        
    def close(self):
        self.stop=True
        if self.loop<>None: self.loop.join(5.)
        
        self.pl.pl1000CloseUnit(self.handle)
        if self.file<>None: self.file.close()
        self.opened=False
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 11 12:02:27 2012

@author: khm
"""
import time,numpy,threading,ctypes,datetime,scipy.io
from psychopy import visual,core ,event, gui
import fMRIlib_inpout32
import winsound

def stimulate(trigger,triggerPort,triggerval,timer,onsets,N,stopobj,duration=1.,stimtime=0.01):
    for i in range(len(onsets)):
        if stopobj.stop: break
        timer.realWait(onsets[i])
        for ii in range(N):
            if stopobj.stop: break
            trigger.Out32(triggerPort,triggerval)
            stopobj.eventList.append((1,stopobj.timer.timePassed()))
            timer.absWait(stimtime)
            trigger.Out32(triggerPort,0)
            stopobj.eventList.append((0,stopobj.timer.timePassed()))
            timer.absWait(duration/N)

if __name__ == '__main__':
    N=30
    minISI=7.
    maxISI=9.
    VAStime=4.
    timeafterVAS=2.    
    meanISI=(maxISI+minISI)/2.
    rangeISI=(maxISI-minISI)

    startwait=2.
    stimonset=numpy.hstack((0.,numpy.cumsum(meanISI+(numpy.random.random(N)-.5)*rangeISI)))+startwait
    gain=numpy.random.random(N)*5.+5.
    
    angle=numpy.random.rand(N)*360
    
    mywin1 = visual.Window([800,600]) #create a window
    lognobox=gui.Dlg(title='Subject information')
    lognobox.addField('Logno:','')
    lognobox.addField('Randomseed','0')
    lognobox.show()
    if gui.OK:
        logno=lognobox.data[0]
        randomseed=int(lognobox.data[1])
        print logno
    else:
        print 'user cancelled'
        
    numpy.random.seed(randomseed) #seed for random initialization
    mywin1.close()    
    mywin=visual.Window(color=(-1,-1,-1),fullscr=True)
    mywin.setMouseVisible(False)
    inputM=fMRIlib_inpout32.inputMonitor(triggerPort=0xE800,triggerbit=6,polltime=0.001)
    trigger=ctypes.windll.inpout32
    #inputM.startEventLoop()
    
    #mov=visual.MovieStim(mywin,filename='Hammer0001.avi',units='norm',size=(1.60,1.60),pos=(0,0))
    maxbar=[-.9,.9]
    bary=[-0.95,-0.85]
    bar=visual.ShapeStim(mywin, units='norm', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0), lineColorSpace='rgb',\
        fillColor=(1,-1,-1), fillColorSpace='rgb', vertices=((maxbar[0], bary[0]), (maxbar[0], bary[1]), (maxbar[1], bary[1]), (maxbar[1], bary[0])),\
        closeShape=True, pos=(0, 0), size=1, ori=0.0, interpolate=True,\
        lineRGB=None, fillRGB=None, name='', autoLog=True)
    timestamp=time.time()
    timestamp_readable=datetime.datetime.fromtimestamp(timestamp).strftime('%Y%m%d_%H-%M-%S')
    matfile = '%s_Empathy_%s.mat' % (logno,timestamp_readable)
    logfile = open('%s_Empathy_%s.log' % (logno,timestamp_readable),'w')
    r=[45,50]
    res=200
    p=numpy.linspace(numpy.pi,0,res)
    xy=list()
    for i in p: xy.append((r[0]*numpy.cos(i),r[0]*numpy.sin(i)))
    for i in p[::-1]: xy.append((r[1]*numpy.cos(i),r[1]*numpy.sin(i)))
    arcxy=list()    
    arcxy.append((0,0))    
    for i in p: arcxy.append((r[1]*numpy.cos(i),r[1]*numpy.sin(i)))
    arcxy.append((0,0))
    cirmask=visual.Circle(mywin, radius=r[0], edges=64, units='pix',fillColor=(-1,-1,-1),interpolate=True,lineColor=(-1,-1,-1))
    arc=visual.ShapeStim(mywin, units='pix', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=(1,-1,-1), fillColorSpace='rgb',\
     vertices=arcxy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)    
    
    
    maskcirr=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(-1.0, -1.0, -1.0),\
     lineColorSpace='rgb', fillColor=(1,-1,-1), fillColorSpace='rgb',\
     vertices=((-r[1], -r[1]), (-r[1],0),(r[1], 0), (r[1], -r[1])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    maskcirg=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(-1.0, -1.0, -1.0),\
     lineColorSpace='rgb', fillColor=(-1,1,-1), fillColorSpace='rgb',\
     vertices=((-r[1], -r[1]), (-r[1],0),(r[1], 0), (r[1], -r[1])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    maskcirb=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(-1.0, -1.0, -1.0),\
     lineColorSpace='rgb', fillColor=(-1,-1,-1), fillColorSpace='rgb',\
     vertices=((-r[1], -r[1]), (-r[1],0),(r[1], 0), (r[1], -r[1])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    
    dial=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=xy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    
    dial1=visual.ShapeStim(mywin, units='pix', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=xy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)    

    dial2=visual.ShapeStim(mywin, units='pix', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=(1,-1,-1), fillColorSpace='rgb',\
     vertices=xy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    
    needle=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=((-r[0]+2,0),(-r[1]-4,0)), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=0.8, depth=0,\
     interpolate=False, lineRGB=None, fillRGB=None)
    
    center=visual.Circle(mywin,radius=3,edges=32,units='pix')
    
    tnum=visual.TextStim(mywin,'text',pos=(0,.1))
    fixation=visual.TextStim(mywin,'+',pos=(0,0))
    
    from picolog_recorder import interface
    pico=interface(samplerate=100,filename=None)
    pico.start()
    
    
    while pico.currentValue==None and len(event.getKeys('escape'))<1:
        time.sleep(0.01)
    print 'PicoLog initialized'
    #event.waitKeys('c')
        
    def drawSpeedo(pos=0.5,oldValue=None,gainval=1,flipthreshold=0.1,minval=15,maxval=4095,angle=0):     
        sliderval=float(pico.currentValue) /float(pico.maxValue.value)
        if oldValue==None:
            oldValue=sliderval
        if pico.currentValue>maxval:
            oldValue=sliderval
        if pico.currentValue<minval:
            oldValue=sliderval
        change = sliderval-oldValue
        #if numpy.abs(change)>flipthreshold:
        #    change -= numpy.sign(change)
        if numpy.abs(change)>flipthreshold:
            change=0
        pos += gainval*change
        if pos>1: pos=1
        if pos<0: pos=0
        #x2=numpy.round(pos*(float(pico.maxValue.value)/10.))/float(pico.maxValue.value)*10.
        xx=numpy.int(numpy.round(pos*res))
        x2=numpy.int(numpy.round(pos*180.))
        arc.setFillColor((1,-1,-1))
        arc.setLineColor((1,-1,-1))        
        arc.setVertices(arcxy[0:xx+1])
        arc.setOri(angle)
        arc.draw()
        arc.setFillColor((-1,1,-1))
        arc.setLineColor((-1,1,-1))
        arc.setOri(angle)
        arc.setVertices(arcxy[-1:xx:-1])
        arc.draw()
        cirmask.setOri(angle)
        cirmask.draw()

        needle.setOri(x2+angle)
        needle.setLineColor((1,1,1))
        needle.draw()        
        needle.setOri(angle)
        needle.setLineColor((1,-1,-1))
        needle.draw()
        
        return (sliderval,pos)


    
    stim=threading.Thread(target=stimulate, args=(trigger,0xE800,255,inputM.timer,stimonset[0:-1],20,inputM))
    

    inputM.waitTrigger() #wait for trigger
    winsound.Beep(440,500)
    stim.start()
    frametimes=list()
    frametimes.append(inputM.timer.timePassed())
    lastrate=list()
    rates=list()
    rawvals=list()
    rates.append(0.)
    rawvals.append(float(pico.currentValue))
    for i in range(N):
        cpos=0.0
        lastrate.append(0)
        coldValue=None
        trial=0
        cangle=numpy.float(angle[i])
        cgain=numpy.float(gain[i])
        print 'Trial %i, onset: %fs, gain: %f, angle: %f' % (i,stimonset[i],cgain,cangle)
        while inputM.timer.timePassed()<stimonset[i+1]:
            t=inputM.timer.timePassed()
            if t>=(stimonset[i+1]-timeafterVAS-VAStime) and t<(stimonset[i+1]-timeafterVAS):
                (coldValue,cpos)=drawSpeedo(cpos,coldValue,gainval=cgain,angle=cangle)
                showVAS=True
                lastrate[i]=cpos
            else:
                showVAS=False
            fixation.draw()
            rawval=float(pico.currentValue)
            
            #(coldValue,cpos)=drawSlider(cpos,coldValue,5)
            #tnum.setText('%i'%pico.currentValue)
            #tnum.draw()
            mywin.flip()
            frametimes.append(inputM.timer.timePassed())
            rates.append(cpos)
            rawvals.append(rawval)
            logfile.write('%i;%f;%f;%f;%f;%f;%i;%d\n'%(i,frametimes[-1],(frametimes[-1]-frametimes[-2])*1000.,cpos,cgain,cangle,rawval,showVAS))
        print 'Rating: %f' % (lastrate[i])
              
        if len(event.getKeys('escape'))>0: break
        #time.sleep(5./1000)
    #mov.stop()
    
    mywin.clearBuffer()
    mywin.flip()
    d=dict()
    inputM.stopAll()
    
    d['stimonset']=stimonset
    d['frametimes']=frametimes
    d['gain']=gain
    d['angle']=angle
    d['lastrate']=lastrate
    d['randomseed']=randomseed
    d['logno']=logno
    d['N']=N
    d['minISI']=minISI
    d['maxISI']=maxISI
    d['VAStime']=VAStime
    d['timeafterVAS']=timeafterVAS
    d['meanISI']=meanISI
    d['rangeISI']=rangeISI
    d['startwait']=startwait    
    d['rawvals']=rawvals
    d['rates']=rates
    d['TLLout']=inputM.eventList
    scipy.io.savemat(matfile,d,oned_as='row')
    time.sleep(3.)    
    pico.close()
    logfile.close()
    logfile=None
    
    mywin.close()
    core.quit()
    inputM=None
    pico=None   
    
    #time.sleep(3.)
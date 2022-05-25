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
    for i in range(len(onsets)):
        timer.realWait(onsets[i])
        for ii in range(N):
            trigger.Out32(triggerPort,triggerval)
            timer.absWait(stimtime)
            trigger.Out32(triggerPort,0)
            timer.absWait(duration/N)

if __name__ == '__main__':
    intp=False    
    N=30
    minISI=7.
    maxISI=9.
    VAStime=4.
    timeafterVAS=2.    
    meanISI=(maxISI+minISI)/2.
    rangeISI=(maxISI-minISI)
    randomseed=0
    numpy.random.seed(randomseed) #seed for random initialization
    startwait=2.
    stimonset=numpy.hstack((0.,numpy.cumsum(meanISI+(numpy.random.random(N)-.5)*rangeISI)))+startwait
    print stimonset
    gain=numpy.random.random(N)*5.+5.
    
    angle=numpy.random.rand(N)*360
    
    mywin1 = visual.Window([512,512]) #create a window
    lognobox=gui.Dlg(title='Subject information')
    lognobox.addField('Logno:','')
    lognobox.addField('Randomseed','0')
    lognobox.show()
    if gui.OK:
        logno=lognobox.data[0]
        seqNo=int(lognobox.data[1])
        print logno
    else:
        print 'user cancelled'
        
    mywin1.close()    
    mywin=visual.Window([1024,1024],color=(-1,-1,-1),fullscr=False)
    mywin.setMouseVisible(False)
    inputM=fMRIlib_inpout32.inputMonitor(triggerPort=0xE800,triggerbit=6,polltime=0.001)
    trigger=ctypes.windll.inpout32
    #inputM.startEventLoop()
    
    movie=visual.MovieStim(mywin,filename='Session 1.avi',units='norm',pos=(0,0),size=(1,1))
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
    cirmask=visual.Circle(mywin, radius=r[0], edges=64, units='pix',fillColor=(-1,-1,-1),interpolate=intp,lineColor=(-1,-1,-1))
    arc=visual.ShapeStim(mywin, units='pix', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=(1,-1,-1), fillColorSpace='rgb',\
     vertices=arcxy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)    
    
    
    maskcirr=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(-1.0, -1.0, -1.0),\
     lineColorSpace='rgb', fillColor=(1,-1,-1), fillColorSpace='rgb',\
     vertices=((-r[1], -r[1]), (-r[1],0),(r[1], 0), (r[1], -r[1])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)
    maskcirg=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(-1.0, -1.0, -1.0),\
     lineColorSpace='rgb', fillColor=(-1,1,-1), fillColorSpace='rgb',\
     vertices=((-r[1], -r[1]), (-r[1],0),(r[1], 0), (r[1], -r[1])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)
    maskcirb=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(-1.0, -1.0, -1.0),\
     lineColorSpace='rgb', fillColor=(-1,-1,-1), fillColorSpace='rgb',\
     vertices=((-r[1], -r[1]), (-r[1],0),(r[1], 0), (r[1], -r[1])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)
    
    dial=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=xy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)
    
    dial1=visual.ShapeStim(mywin, units='pix', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=xy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)    

    dial2=visual.ShapeStim(mywin, units='pix', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=(1,-1,-1), fillColorSpace='rgb',\
     vertices=xy, closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=1, depth=0,\
     interpolate=intp, lineRGB=None, fillRGB=None)
    
    needle=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=((-r[0]+2,0),(-r[1]-4,0)), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=0.8, depth=0,\
     interpolate=False, lineRGB=None, fillRGB=None)
    
    center=visual.Circle(mywin,radius=3,edges=32,units='pix')
    
    tnum=visual.TextStim(mywin,'text',pos=(0,.1))
    fixation=visual.TextStim(mywin,'+',pos=(0,0))
    
    def picodummy():
        pico.currentValue=0
        pico.maxValue.value=4095
        while 1:
            pico.currentValue+=1
            if pico.currentValue>4095:
                pico.currentValue=0            
            time.sleep(0.01)
    
    
    from picolog_recorder import interface
    picoOn=0
    pico=interface(samplerate=100,filename=None)
    if picoOn:    
        pico.start()
    else:
        threading.Thread(target=picodummy, args=()).start()
    
    while pico.currentValue==None and len(event.getKeys('escape'))<1:
        time.sleep(0.01)
    print 'PicoLog initialized'
    #event.waitKeys('c')
    
    def predraw(pos=0.5,gainval=1,angle=0):     
        
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
        
        fr=mywin._getFrame(buffer='back')
   
        speedo=visual.BufferImageStim(mywin,interpolate=True)
        #pxtable=numpy.zeros(256*3,dtype=numpy.int)
        a = numpy.asarray(fr).copy()
        #a=255*numpy.ones_like(a,dtype=numpy.int)
        
        a[numpy.sum(a,2)<>0,:]=255
        #pxtable[0]=255
        #pxtable[1]=255
        #pxtable[2]=255
        #fr=fr.point(pxtable)
        fr=Image.fromarray(a,fr.mode)
        #speedo.setMask(fr)
        #mywin.clearBuffer()

        return fr    
    
        
    def drawSpeedo(pos=0.5,oldValue=None,gainval=1,flipthreshold=0.1,minval=15,maxval=4095,angle=0):     
        sliderval=float(pico.currentValue) /float(pico.maxValue.value)
        angle=0        
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
        imbuffer.setTex(mywin._getFrame(buffer='back'))
        
        mywin.clearBuffer()
        
   

        return (sliderval,pos)

    def drawSpeedo2(pos=0.5,oldValue=None,gainval=1,flipthreshold=0.1,minval=15,maxval=4095,angle=0):     
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
        #xx=numpy.int(numpy.round(pos*res))
        #x2=numpy.int(numpy.round(pos*180.))
        #arc.setFillColor((1,-1,-1))
        #arc.setLineColor((1,-1,-1))        
        #arc.setVertices(arcxy[0:xx+1])
        #arc.setOri(angle)
        #arc.draw()
        #arc.setFillColor((-1,1,-1))
        #arc.setLineColor((-1,1,-1))
        #arc.setOri(angle)
        #arc.setVertices(arcxy[-1:xx:-1])
        #arc.draw()
        #cirmask.setOri(angle)
        #cirmask.draw()

        #needle.setOri(x2+angle)
        #needle.setLineColor((1,1,1))
        #needle.draw()        
        #needle.setOri(angle)
        #needle.setLineColor((1,-1,-1))
        #needle.draw()
        #fr=mywin._getFrame()
        #print fr.getpixel((0,0))
        #pixmap=range(256)
        #fr=fr.point(pixmap)
        #print fr.getdata()
#        print fr.getim()
#        print fr.getdata()        
        #speedo=visual.BufferImageStim(mywin)
        #speedo.setMask(fr)
        #mywin.clearBuffer()

        return (sliderval,pos)
    
    trigger.Out32(0xE800,0)
    stim=threading.Thread(target=stimulate, args=(trigger,0xE800,255,inputM.timer,stimonset[0:-1],20))
    
    #pre generate speedo
    sp=list()
    pres=100
    #posvec=numpy.arange(0,1,1./pres)
    #for k in posvec: sp.append(predraw(k))
    mask=predraw(0)
    imbuffer=visual.BufferImageStim(mywin)
    imbuffer=visual.PatchStim(mywin)
    imbuffer.setMask(mask)
    mywin.clearBuffer()
    fixation.draw()
    mywin.flip()    
    inputM.waitTrigger() #wait for trigger
    winsound.Beep(440,500)
    #stim.start()
    frametimes=list()
    frametimes.append(inputM.timer.timePassed())
    lastrate=list()
    rates=list()
    rawvals=list()
    rates.append(0.)
    rawvals.append(float(pico.currentValue))
    
    
    
    movie.play()
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
            #movie.setMask(mask)
            movie.draw()          
            if showVAS:
                imbuffer.setOri(cangle)
                imbuffer.setMask(mask)
                imbuffer.draw()
                #cidx=int(round(cpos*pres))
                #sp[cidx].setOri(cangle)
                #sp[cidx].draw()
            mywin.flip()
            frametimes.append(inputM.timer.timePassed())
            rates.append(cpos)
            rawvals.append(rawval)
            print (frametimes[-1]-frametimes[-2])*1000
            logfile.write('%i;%f;%f;%f;%f;%f;%i;%d\n'%(i,frametimes[-1],(frametimes[-1]-frametimes[-2])*1000.,cpos,cgain,cangle,rawval,showVAS))
        print 'Rating: %f' % (lastrate[i])
        
              
        if len(event.getKeys('escape'))>0: break
        #time.sleep(5./1000)
    #mov.stop()
    
    mywin.clearBuffer()
    mywin.flip()
    d=dict()
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
    scipy.io.savemat(matfile,d,oned_as='row')
    time.sleep(3.)    
    pico.close()
    logfile.close()
    logfile=None
    inputM.stopAll()
    mywin.close()
    core.quit()
    inputM=None
    pico=None   
    
    #time.sleep(3.)
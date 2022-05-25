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
    for i in range(len(onsets)):
        timer.realWait(onsets[i])
        for ii in range(N):
            trigger.Out32(triggerPort,triggerval)
            timer.absWait(stimtime)
            trigger.Out32(triggerPort,0)
            timer.absWait(duration/N)

if __name__ == '__main__':
    #session=1
    #picoOn=0
    mywin1 = visual.Window([512,512]) #create a window
    lognobox=gui.Dlg(title='Subject information')
    lognobox.addField('Logno:','')
    lognobox.addField('Session','1')   
    lognobox.addField('Randomseed','0')     
    lognobox.addField('Training','1')
    #lognobox.addField('Picodevice','1')
    lognobox.show()
    if gui.OK:
        logno=lognobox.data[0]
        seqNo=int(lognobox.data[2])
        session=int(lognobox.data[1])
        train=int(lognobox.data[3])
        #picoOn=int(lognobox.data[4])
        
        print logno
    else:
        print 'user cancelled'
    if session==3:
		sessionr=3
		session=2
		sessiontxt=1
	elif session==4:
		sessionr=4
		session=1
		sessiontxt=2
	else:
		sessiontxt=session
		sessionr=session
		
    picoOn=1
    mywin1.close()    
    if session==1: 
        moffset=(-24,5-60)
    if session==2:
        moffset=(-5,25-60)
        
    intp=True
    N=86
    minISI=7.
    maxISI=9.
    VAStime=4.
    timeafterVAS=2.
    timeStim=2.
    timeBeforeVAS=2.
    meanISI=(maxISI+minISI)/2.
    rangeISI=(maxISI-minISI)
    randomseed=0
    numpy.random.seed(randomseed) #seed for random initialization
    startwait=2.
    navn='Mie'
    #stimonset=numpy.hstack((0.,numpy.cumsum(meanISI+(numpy.random.random(N)-.5)*rangeISI)))+startwait
    #stimStrength=(numpy.random.random(N)-.5)*2.
    #print stimonset
    gain=numpy.random.random(N)*2.+2. #Gain value
    stimonset = [float(line) for line in open('onsets%d.txt'%session)]
    #print stimonset    
    stimonset.append(stimonset[-1]+10)
    stimonset=numpy.array(stimonset)
    stimonset+=0.5
    pausetime=20.
    angle=numpy.random.rand(N)*360
    stimintensity = [float(line) for line in open('intensity%d.txt'%session)]
    stimintensity = stimintensity-numpy.min(stimintensity)
    randomintensity=((numpy.random.permutation(stimintensity))/numpy.max(stimintensity))+.5
    #print randomintensity
        
    stimintensity=numpy.linspace(0,1,N)**(1./0.33)*255.
    stimintensity=stimintensity/255.
    randomintensity=numpy.random.permutation(stimintensity)
    #print stimintensity
    mywin=visual.Window([1280,1024],color=(-1,-1,-1),fullscr=True,screen=0)
    mywin.setMouseVisible(False)
    inputM=fMRIlib_inpout32.inputMonitor()
    trigger=ctypes.windll.inpout32
    #inputM.startEventLoop()
    if sessiontxt==1:
        introtxt=visual.TextStim(mywin,text=u'Vurder hvor lyst krydset er',alignHoriz='center')
    elif sessiontxt==2:
        introtxt=visual.TextStim(mywin,text=u'Helt sort - ingen smerte\nHelt hvid - v\u00e6rst t\u00e6nkelige smerte',alignHoriz='center')
    

    #waittxt=visual.TextStim(mywin,text=u'Fors\u00f8get forts\u00e6tter om et sekund',alignHoriz='center')
    waittxt1=visual.TextStim(mywin,text=u'Mie har bedt om en pause',alignHoriz='center',pos=(0,.1))
    waittxt2=visual.TextStim(mywin,text=u'Fors\u00f8get forts\u00e6tter om',alignHoriz='center',pos=(0,0))
    waittxt3=visual.TextStim(mywin,text='10',alignHoriz='center',pos=(0,-.1))
    
    waitdur=2.
    if session==1: wtimes=numpy.array((247.8672,481.2064,1000))
    if session==2: wtimes=numpy.array((247.8672,480.9124,1000))
    clockoffset=((0,0),(0,0),(0,0))
    if session==2:
        clockoffset=((-70,0),(0,0),(0,0))
    
    if not(train):
        for i in wtimes:
            wtimes[wtimes>i]+=pausetime
            if session==1: stimonset[stimonset>i]+=pausetime#-3.03#Compensate 3 sec. black screen
            if session==2: stimonset[stimonset>i]+=pausetime#-3.4#Compensate 3 sec. black screen
        
    movie=visual.MovieStim(mywin,filename='Session %d_24.avi'%session,units='pix',pos=moffset,autoLog=False)#,size=(640,480))
    backg=visual.ShapeStim(mywin,units='pix',size=movie.size,lineColor=(0.5,0.,0.),fillColor=(0.5,0.,0.),closeShape=True,vertices=((-1,-1),(-1,1),(1,1),(1,-1)))
    
    if sessiontxt==2:
        intro=list()
        intro.append(visual.TextStim(mywin,text=u'Under den næste skanning vil du se præcist det samme på skærmen:\n%s der får stød, og et kryds som drejer og skifter farve.'%navn))
        intro.append(visual.TextStim(mywin,text=u'Din opgave ændrer sig nu. Kig på krydset i midten. Vurder, hvor ondt du tror det gjorde på %s. Ignorer farveskiftet på krydset.'%navn))
        intro.append(visual.TextStim(mywin,text=u'Når skalaen dukker op, skal du bedømme, hvor ondt det gjorde på hende: Jo mere hvidt du drejer op på, jo mere ondt vurderer du, at hun havde, da hun fik det elektriske stød.'))
        intro.append(visual.TextStim(mywin,text=u'Hvis du slet ikke drejer, er skalaen helt sort - det betyder, at du slet ikke mener, det gjorde ondt på hende, altså ingen smerte. Hvis du drejer den op på helt hvid, betyder det, at du vurderer, at hun lige oplevede den værst tænkelige smerte.'))
        intro.append(visual.TextStim(mywin,text=u'Når skalaen er så hvid, som du synes afspejler %ss smerte, skal du holde knappen der, indtil skalaen forsvinder - dvs. ligesom før skal du IKKE skrue tilbage på nul (helt sort). Og ligesom før har du ikke ret lang tid til at beslutte dig.'%navn))
        intro.append(visual.TextStim(mywin,text=u'Du skal stadig holde øjnene rettet mod krydset i midten hele tiden.'))
        intro.append(visual.TextStim(mywin,text=u'Det beløb, du får udbetalt til sidst, afhænger stadig af, hvor korrekte dine svar er. Vi ved, hvor ondt det gjorde på Mie, fordi hun vurderede sin smerte på den samme skala, som den du ser.'))
    
    timetxt=visual.TextStim(mywin,text='',units='pix',alignHoriz='right',alignVert='bottom',pos=(movie.size[0]/2.+moffset[0],-movie.size[1]/2.+moffset[1]),height=20)
    maxbar=[-.9,.9]
    bary=[-0.95,-0.85]
    bar=visual.ShapeStim(mywin, units='norm', lineWidth=1.0, lineColor=(1.0, 1.0, 1.0), lineColorSpace='rgb',\
        fillColor=(1,-1,-1), fillColorSpace='rgb', vertices=((maxbar[0], bary[0]), (maxbar[0], bary[1]), (maxbar[1], bary[1]), (maxbar[1], bary[0])),\
        closeShape=True, pos=(0, 0), size=1, ori=0.0, interpolate=True,\
        lineRGB=None, fillRGB=None, name='', autoLog=True)
    timestamp=time.time()
    timestamp_readable=datetime.datetime.fromtimestamp(timestamp).strftime('%Y%m%d_%H-%M-%S')
    matfile = '%s_session%d_Empathy_%s.mat' % (logno,sessionr,timestamp_readable)
    logfile = open('%s_session%d_Empathy_%s.log' % (logno,sessionr,timestamp_readable),'w')
    r=[45,50]
    rr=numpy.mean(r)
    rd=numpy.diff(r)
    res=200
    ares=(numpy.pi/180)*5
    pxl=numpy.linspace(0,1,numpy.ceil(numpy.pi*r[1]/(numpy.sin(ares)*r[1])))
    p=numpy.linspace(numpy.pi,0,res)
    xy=list()
    
    for i in p: xy.append((r[0]*numpy.cos(i),r[0]*numpy.sin(i)))
    #for i in p[::-1]: xy.append((r[1]*numpy.cos(i),r[1]*numpy.sin(i)))
    arcxy=list()    
    #arcxy.append((0,0))    
    for i in p: arcxy.append((r[1]*numpy.cos(i),r[1]*numpy.sin(i)))
    #arcxy.append((0,0))
    cirmask=visual.Circle(mywin, radius=r[0], edges=64, units='pix',fillColor=(-1,-1,-1),interpolate=intp,lineColor=(-1,-1,-1))
    arc=visual.ShapeStim(mywin, units='pix', lineWidth=rd, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=arcxy, closeShape=False,\
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
    
    timetext=visual.TextStim(mywin,'0',pos=(-.8,-.8))
    
    needle=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=((-r[0]+2,0),(-r[1]-4,0)), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=0.8, depth=0,\
     interpolate=False, lineRGB=None, fillRGB=None)
    needle2=visual.ShapeStim(mywin, units='pix', lineWidth=2.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=((-r[0],0),(-r[1],0),(-numpy.cos(ares)*r[1],numpy.sin(ares)*r[1]),(-numpy.cos(ares)*r[0],numpy.sin(ares)*r[0])), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=0.8, depth=0,\
     interpolate=False, lineRGB=None, fillRGB=(1,1,1))
    
    center=visual.Circle(mywin,radius=3,edges=32,units='pix')
    
    fix1=visual.ShapeStim(mywin, units='pix', lineWidth=10.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=((-30,0),(30,0)), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=0.8, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    
    
    fix2=visual.ShapeStim(mywin, units='pix', lineWidth=10.0, lineColor=(1.0, 1.0, 1.0),\
     lineColorSpace='rgb', fillColor=None, fillColorSpace='rgb',\
     vertices=((0,-30),(0,30)), closeShape=True,\
     pos=(0, 0), size=1, ori=0.0, opacity=0.8, depth=0,\
     interpolate=True, lineRGB=None, fillRGB=None)
    
    tnum=visual.TextStim(mywin,'text',pos=(0,.1))
    fixation=visual.TextStim(mywin,'+',pos=(0,0))
    
    def picodummy():
        pico.currentValue=0
        pico.maxValue.value=4095
        while not(pico.stopdummy):
            pico.currentValue+=(numpy.random.random(1)-.5*(pico.currentValue/pico.maxValue.value))*10
            if pico.currentValue>4095:
                pico.currentValue=0            
            time.sleep(0.025)
    
    
    from picolog_recorder_multich import interface

    pico=interface(channels=[1],samplerate=500,filename=None,datasecs=100)
    
    if picoOn:    
        pico.start()
    else:
        pico.stopdummy=False
        picot=threading.Thread(target=picodummy, args=()).start()
    
    while pico.currentValue==None and len(event.getKeys('escape'))<1:
        time.sleep(0.01)
    print 'PicoLog initialized'
    #event.waitKeys('c')
    
    def predraw(pos=0.5,gainval=1,angle=0,mask=False):     
        
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
            #pxtable=numpy.zeros(256*3,dtype=numpy.int)
        a = numpy.asarray(fr).copy()
            #a=255*numpy.ones_like(a,dtype=numpy.int)
        
        a[numpy.sum(a,2)<>0,:]=255

        fr=Image.fromarray(a,fr.mode)
            
            
        
        speedo=visual.BufferImageStim(mywin,interpolate=True)
        
        speedo.setMask(fr)
        mywin.clearBuffer()

        return speedo
    
        
    def drawSpeedo(pos=0.5,oldValue=None,gainval=1,flipthreshold=0.1,minval=15,maxval=4095,angle=0):
        #sliderval=float(pico.currentValue) /float(pico.maxValue.value)
        #angle=0
        slidervalr=int(numpy.mean(pico.getSamples(inputM.timer.timePassed()+inputM.timer.inittime-0.1)))
        
        sliderval=slidervalr/float(pico.maxValue.value)
        if oldValue==None:
            oldValue=sliderval
        if slidervalr>maxval:
            oldValue=sliderval
        if slidervalr<minval:
            oldValue=sliderval
        change = sliderval-oldValue
        #if sliderval>0.9 and change<0:
        #    change=0
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
        #arc.setFillColor((1,-1,-1))
        arc.setLineColor((1,1,1))        
        arc.setVertices(arcxy[0:xx+1])
        arc.setOri(angle)
        arc.draw()
        #arc.setFillColor((-1,1,-1))
        arc.setLineColor((-1,-1,-1))
        arc.setOri(angle)
        if len(arcxy[-1:xx:-1])>0:
            arc.setVertices(arcxy[-1:xx:-1])
            arc.draw()
        #cirmask.setOri(angle)
        #cirmask.draw()
        #for i in pxl:
        #    a=180*i
        #    if a>x2:
        #        needle2.setLineColor((-1,1,-1))
        #        needle2.setFillColor((-1,1,-1))
        #    else:
        #        needle2.setLineColor((1,-1,-1))
        #        needle2.setFillColor((1,-1,-1))
        #    needle2.setOri(a+angle)
            #needle.setLineColor((1,1,1))
        #    needle2.draw()
        needle.setOri(x2+angle)
        needle.setLineColor((1,1,1))
        needle.draw()        
        needle.setOri(angle)
        needle.setLineColor((1,1,1))
        needle.draw()
        #imbuffer.setTex(mywin._getFrame(buffer='back'))
        
        #mywin.clearBuffer()
        
   

        return (sliderval,pos)

    def drawSpeedo2(pos=0.5,oldValue=None,gainval=1,flipthreshold=0.1,minval=15,maxval=4095,angle=0):     
        sliderval=float(pico.currentValue)/float(pico.maxValue.value)
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
    
    #trigger.Out32(0xE800,0)
    #stim=threading.Thread(target=stimulate, args=(trigger,0xE800,255,inputM.timer,stimonset[0:-1],20))
    
    #pre generate speedo
    #sp=list()
    #pres=10
    #posvec=numpy.arange(0,1,1./pres)
    #for k in posvec:sp.append(predraw(k))
#    mask=predraw(0,mask=True)
    #imbuffer=visual.BufferImageStim(mywin)
    #imbuffer=visual.PatchStim(mywin)
    #imbuffer.setMask(mask)
    mywin.clearBuffer()
    #fixation.draw()
#    inputM.triggerMonitor=True

    if sessiontxt==2:
        for i in intro:
            i.draw()
            mywin.flip()
            #event.waitKeys(keyList='space')
            time.sleep(17)
            mywin.flip()
            time.sleep(1)
    introtxt.draw()
    mywin.flip()
    scantime=pico.scantime
    pico.scantime=.1
    inputM.waitTrigger() #wait for trigger
    winsound.Beep(440,500)
    pico.scantime=scantime
    time.sleep(0.1)
    #stim.start()
    frametimes=list()
    frametimes.append(inputM.timer.timePassed())
    lastrate=list()
    rates=list()
    rawvals=list()
    rates.append(0.)

    rawvals.append(int(numpy.mean(pico.getSamples(inputM.timer.timePassed()+inputM.timer.inittime-0.1))))
    
    
    
    
    #movie.draw()
    moviepart=0
    movie.seek(0)
    movie.play()
    oneshot=True
    kk=0
    resumemovie=False
    waspaused=False
    playmovie=True
    adjtime=0
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
            if train:
                backg.draw()
            else:
                if resumemovie:
                    movie.play()
                    moviepart+=1
                    resumemovie=False
                if playmovie:
                    movie.draw()
                    timetxt.setPos((clockoffset[moviepart][0]+movie.size[0]/2.+moffset[0],-movie.size[1]/2.+moffset[1]+clockoffset[moviepart][1]))
                    timetxt.setText('%s'%(datetime.datetime.fromtimestamp(time.time()).strftime('%d/%m/%Y %H:%M:%S')))
                    #timetxt.draw()
            if t>(stimonset[i]+timeBeforeVAS) and t<=(stimonset[i]+timeBeforeVAS+VAStime):
                (coldValue,cpos)=drawSpeedo(cpos,coldValue,gainval=cgain,angle=cangle)
                showVAS=True
                lastrate[i]=cpos
            else:
                showVAS=False
            if t>(stimonset[i]) and t<(stimonset[i]+timeStim):
                #fixation.setColor((stimStrength[i],stimStrength[i],stimStrength[i]))
                #fixation.setOri(45.)
                fix1.setLineColor(((randomintensity[i]*2)-1,(randomintensity[i]*2)-1,(randomintensity[i]*2)-1))
                fix1.setOri(45.)
                fix2.setLineColor(((randomintensity[i]*2)-1,(randomintensity[i]*2)-1,(randomintensity[i]*2)-1))
                fix2.setOri(45.)
            else:
                fix1.setLineColor((-1,-1,-1))
                fix1.setOri(0.)
                fix2.setLineColor((-1,-1,-1))
                fix2.setOri(0.)
            if (t>wtimes[kk] and t<(wtimes[kk]+pausetime)) and train==0:
                if not(waspaused):
                    movie.pause()
                    #print inputM.timer.timePassed()
                #waittxt1.draw()
                waittxt2.draw()
                waittxt3.setText('%0.0f sekunder'%numpy.ceil(wtimes[kk]+pausetime-t))
                waittxt3.draw()
                waspaused=True
                playmovie=False
            else:
                playmovie=True
                if waspaused:
                    #print inputM.timer.timePassed()
                    resumemovie=True
                    waspaused=False
                fix1.draw()
                fix2.draw()
            if t>(wtimes[kk]+pausetime+1):
                kk+=1
            
            #timetext.setPos((-.8,-.8)) 
            #timetext.setText('%f'%t)
            #timetext.draw()
            rawval=int(numpy.mean(pico.getSamples(inputM.timer.timePassed()+inputM.timer.inittime-0.1)))
            #(coldValue,cpos)=drawSlider(cpos,coldValue,5)
            #tnum.setText('%i'%pico.currentValue)
            #tnum.draw()
            #movie.setMask(mask)
            #movie.draw()          
            #if showVAS:
                #imbuffer.setOri(cangle)
                #imbuffer.setMask(mask)
                #imbuffer.draw()
                #cidx=int(round(cpos*pres))
                #sp[cidx].setOri(cangle)
#                sp[cidx].setMask(mask)
                #sp[cidx].draw()
            mywin.flip()
            frametimes.append(inputM.timer.timePassed())
            rates.append(cpos)
            rawvals.append(rawval)
            #print (frametimes[-1]-frametimes[-2])*1000
            logfile.write('%i;%f;%f;%f;%f;%f;%i;%d\n'%(i,frametimes[-1]+adjtime,(frametimes[-1]-frametimes[-2])*1000.,cpos,cgain,cangle,rawval,showVAS))
            #timetext.setPos((-.8,-.7))            
            #timetext.setText('%f'%movie._player._get_time())
            #movie._player._get_time
            #timetext.draw()
            if oneshot and inputM.timer.timePassed()>.5:
                adjtime=inputM.timer.timePassed()-movie._player._get_time()
                inputM.timer.inittime+=adjtime
                inputM.timer.lasttime+=adjtime
                oneshot=False
            
        print 'Rating: %f' % (lastrate[i])
        
              
        if len(event.getKeys('q'))>0: break
        #time.sleep(5./1000)
    #mov.stop()
    
    mywin.clearBuffer()
    mywin.flip()
    d=dict()
    d['stimonset']=stimonset+adjtime
    d['frametimes']=numpy.array(frametimes)+adjtime
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
    d['randomintensity']=randomintensity
    d['adjtime']=adjtime
    d['wtimes']=wtimes
    scipy.io.savemat(matfile,d,oned_as='row')
    time.sleep(0.)    
    pico.close()
    logfile.close()
    logfile=None
    inputM.stopAll()
    mywin.close()
    core.quit()
    inputM=None
    pico=None   
    #print inputM.triggerTimes
    if not(picoOn):
        pico.stopdummy=True
        picot.join(1)
        picot=None
    #time.sleep(3.)
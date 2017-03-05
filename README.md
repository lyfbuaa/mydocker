# docker
docker images(base on fedora docker image(>22))

update Dockerfile's 'from' image name at first

reference:http://blog.sina.com.cn/s/blog_47e1dbd70102wek5.html

##1.docker xxnet  ---Dockerfile-xxnet 
  xxnet: https://github.com/XX-net/XX-net

  e.g.run :
      docker run --name myxxnet -d --cpuset-cpus=0,1 --cpu-shares=2 -m 128m --cap-drop ALL -u developer f23-xxnet:1.2
  
  admin console : http://containerIP:8085<br/>
  proxy:http://containerIP:8087<br/>
        http://containerIP:8086/proxy.pac<br/>

##2.docker firefox
####1) Dockerfile-firefox 
      (vnc mode(Xvfb+X11vnc+fluxbox),support chinese, flash)
      e.g.run :
        docker run -d -e PULSE_SERVER=10.0.2.15:4713 -u developer firefox:1.1
  
      set PULSE_SERVER for sound on host(reference using Pulse network audio)

      access: vncviewer containerIP    (password:1234)
      
####2)Dockerfile-firefox-2  
      (non vnc mode,no support chinese)
      e.g.run :
        docker run -e DISPLAY --privileged -v /tmp/.X11-unix:/tmp/.X11-unix  firefox-2:1.0
        
####3)Dockerfile-isolated_firefox 
     (vnc mode(Xvfb+X11vnc+fluxbox),no support chinese,  from redhat website)
      e.g.run :
        docker run -v /sys/fs/cgroup:/sys/fs/cgroup:ro isolated_firefox
####4)Dockerfile-gui-novnc
     (vnc mode(Xvfb+X11vnc+fluxbox+novnc),support chinese, flash)
      e.g.run :
        docker run -d -e PULSE_SERVER=10.0.2.15:4713 -u developer firefox:1.1
  
      set PULSE_SERVER for sound on host(reference using Pulse network audio)

      access: vncviewer containerIP    (password:1234)
      or :http://containerIP:6080   (password:1234) (browser need support html5)

####5)Dockerfile-gui-xpra-xephyr
     (Xvfb+xpra+xephyr,support chinese, flash)
      e.g.run :
        docker run --rm -e PULSE_SERVER=10.0.2.15:4713 -u developer firefox:1.1
       
      access: xpra attach tcp:containIP:8900
     
####6)Dockerfile-gui-novnc-supervisor
     (vnc mode(Xvfb+X11vnc+fluxbox+novnc),support chinese, flash)
      e.g.run :  
        docker run -d -e PULSE_SERVER=10.0.2.15:4713 -u developer firefox:1.1   
     
      access: vncviewer containerIP    (password:1234)
      or :http://containerIP:6080   (password:1234) (browser need support html5)
     
      supervisor cosole:http://containerIP:9001 (admin/admin)
           
##3.docker gui  (base on 2.1、2.4、2.5、2.6)
    
     e.g.run :
     docker run -d --name guibase -v /home/user/test:/data --privileged -e APP_START=/data/firefox -e PULSE_SERVER=10.0.2.15:4713 -u developer guibase

     APP_START: your gui program  
     
     For xfce4-desktop:
     a.group install 'Xfce Desktop'
     b.APP_START :  xfce4-session --display=:1
     c.delete "fluxbox -display $DISPLAY &"  from sh script
     
     For wine:
     install wine*
     a.Xvfb :99 -screen 0 1366x768x24 &
     b.x11vnc -forever -rfbauth ~/.vnc/passwd -display :99 &
     c.DISPLAY=:99 wine /X.exe
     or
     a.docker run  -it --name wine -e DISPLAY -v /game/:/data  -v /tmp/.X11-unix:/tmp/.X11-unix  --privileged -u developer wine:1.0 bash
     b.wine /data/starcraft2/StarCraft\ II/StarCraft\ II.exe --setregion=CN --setlanguage=enUS





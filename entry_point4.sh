#!/bin/bash

# 等待Xvfb程序启动完成
if [ $1=="xvfb" ]; then
	for i in $(seq 1 20); do
	  xdpyinfo -display $DISPLAY >/dev/null 2>&1
	  if [ $? -eq 0 ]; then
		break
	  fi
	  echo Waiting xvfb...
	  sleep 0.5
	done
fi

if [ $1=="fluxbox" ]; then
	for i in $(seq 1 20); do
	  FLUXBOX_PID=`ps -ef|grep fluxbox | awk '{print $1}' |sed -n '1p'`
	  if [ $? -eq 0 ]; then
		break
	  fi
	  echo Waiting xvfb...
	  sleep 0.5
	done
fi

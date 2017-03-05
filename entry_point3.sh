#!/bin/bash

# 将屏幕分辨率和色彩深度的环境变量组合成
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

# 注册结束信号的捕获器，当容器结束时，尝试让应用程序优雅的关闭
function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}
trap shutdown SIGTERM SIGINT

# xpra，并记录下xpra程序的PID
  xpra start --start-child="Xephyr :200 -ac -screen $GEOMETRY -ac +extension RANDR" $DISPLAY \
  --bind-tcp=0.0.0.0:8900 --no-mdns --no-notifications 
NODE_PID=`ps -ef|grep Xorg | awk '{print $1}' |sed -n '1p'`

# 等待xpra程序启动完成
for i in $(seq 1 20); do
  xpra info >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    break
  fi
  echo Waiting xpra...
  sleep 0.5
done

# 后台运行窗口管理器Fluxbox
DISPLAY=:200  fluxbox  &

DISPLAY=:200  $APP_START &
APP_PID=$!
wait $APP_PID

# 由于所有服务都是后台启动的，最后这个wait确保了在程序结束前，容器不会停止
wait $NODE_PID

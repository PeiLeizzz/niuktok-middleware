source configs/rocketmq.env

CUR_PATH=$(pwd)

# 创建 host 持久化地址，日志、配置、数据
[[ -d $VOLUME_PATH/nameserver/logs/ ]] && echo "$VOLUME_PATH/nameserver/logs/ exits" || sudo mkdir -p $VOLUME_PATH/nameserver/logs/
[[ -d $VOLUME_PATH/nameserver/bin/ ]] && echo "$VOLUME_PATH/nameserver/bin/ exits" || sudo mkdir -p $VOLUME_PATH/nameserver/bin/
[[ -d $VOLUME_PATH/broker/logs/ ]] && echo "$VOLUME_PATH/broker/logs/ exits" || sudo mkdir -p $VOLUME_PATH/broker/logs/
[[ -d $VOLUME_PATH/broker/store/ ]] && echo "$VOLUME_PATH/broker/store/ exits" || sudo mkdir -p $VOLUME_PATH/broker/store/
[[ -d $VOLUME_PATH/broker/conf/ ]] && echo "$VOLUME_PATH/broker/conf/ exits" || sudo mkdir -p $VOLUME_PATH/broker/conf/
[[ -d $VOLUME_PATH/broker/bin/ ]] && echo "$VOLUME_PATH/broker/bin/ exits" || sudo mkdir -p $VOLUME_PATH/broker/bin/

sudo cp rocketmq/runserver.sh $VOLUME_PATH/nameserver/bin/runserver.sh
sudo cp rocketmq/runbroker.sh $VOLUME_PATH/broker/bin/runbroker.sh
sudo cp configs/broker.conf $VOLUME_PATH/broker/conf/broker.conf

cd $VOLUME_PATH
sudo chmod -R 777 .

cd $CUR_PATH
docker-compose -f docker/rocketmq.dockercompose.yaml --env-file configs/rocketmq.env up -d
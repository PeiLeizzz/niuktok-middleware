source configs/redis.env

ENV=$1

if [[ $ENV =~ dev ]]; then REDIS_PORT=$DEV_HOST_PORT;
elif [[ $ENV =~ prod ]]; then REDIS_PORT=$PORT_HOST_PORT; fi

# redis 外部端口，镜像名和容器名
REDIS_CONTAINER_NAME=$CONTAINER_NAME-$ENV
REDIS_IMAGE_NAME=$IMAGE_NAME
REDIS_LOCAL_PATH=$VOLUME_PATH/$ENV

if [[ $REDIS_PORT == '' ]]; then
    echo 'The env was not in the right format, please check.' && exit 1
else 
    echo local dir is $REDIS_LOCAL_PATH
fi

[[ -d $REDIS_LOCAL_PATH/conf/ ]] && echo "$REDIS_LOCAL_PATH/conf/ exits" || sudo mkdir -p $REDIS_LOCAL_PATH/conf/
[[ -d $REDIS_LOCAL_PATH/data/ ]] && echo "$REDIS_LOCAL_PATH/data/ exits" || sudo mkdir -p $REDIS_LOCAL_PATH/data/

sudo cp configs/redis.conf $REDIS_LOCAL_PATH/conf/

cd $REDIS_LOCAL_PATH
sudo chmod -R 777 .
sudo chmod -R 755 ./conf

docker run --restart=always \
-p $REDIS_PORT:6379 \
--name $REDIS_CONTAINER_NAME \
-v $REDIS_LOCAL_PATH/conf/redis.conf:/etc/redis/redis.conf \
-v $REDIS_LOCAL_PATH/data:/data \
-d $REDIS_IMAGE_NAME redis-server /etc/redis/redis.conf

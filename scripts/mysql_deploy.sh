source configs/mysql.conf

CUR_PATH=$(pwd)
ENV=$1
# mysql 外部端口，镜像名和容器名
if [[ $ENV =~ dev ]]; then MYSQL_PORT=$DEV_HOST_PORT;
elif [[ $ENV =~ prod ]]; then MYSQL_PORT=$PORT_HOST_PORT; fi

MYSQL_CONTAINER_NAME=$CONTAINER_NAME-$ENV
MYSQL_IMAGE_NAME=$CONTAINER_NAME:$ENV
MYSQL_LOCAL_PATH=$VOLUME_PATH/$ENV

if [[ $MYSQL_PORT == '' ]]; then
    echo 'The env was not in the right format, please check.' && exit 1
else 
    echo local dir is $MYSQL_LOCAL_PATH
fi

# 创建 host 持久化地址，日志、配置、数据
[[ -d $MYSQL_LOCAL_PATH/logs/ ]] && echo "$MYSQL_LOCAL_PATH/logs/ exits" || sudo mkdir -p $MYSQL_LOCAL_PATH/logs/
[[ -d $MYSQL_LOCAL_PATH/conf/ ]] && echo "$MYSQL_LOCAL_PATH/conf/ exits" || sudo mkdir -p $MYSQL_LOCAL_PATH/conf/
[[ -d $MYSQL_LOCAL_PATH/data/ ]] && echo "$MYSQL_LOCAL_PATH/data/ exits" || sudo mkdir -p $MYSQL_LOCAL_PATH/data/
[[ -d $MYSQL_LOCAL_PATH/setup/ ]] && echo "$MYSQL_LOCAL_PATH/setup/ exits" || sudo mkdir -p $MYSQL_LOCAL_PATH/setup/


if [[ "$(sudo docker ps -a | grep $MYSQL_CONTAINER_NAME)" ]]; then 
    sudo docker stop $MYSQL_CONTAINER_NAME; 
fi

# 添加日志配置
sudo cp configs/mysql.cnf $MYSQL_LOCAL_PATH/conf/
# 添加 sql 脚本
sudo cp database/* $MYSQL_LOCAL_PATH/setup/

# 设置 docker 权限
cd $MYSQL_LOCAL_PATH
sudo chmod -R 777 .
sudo chmod -R 755 ./conf

cd $CUR_PATH
if [[ "$(sudo docker ps -a | grep $MYSQL_CONTAINER_NAME)" ]]; then sudo docker stop $MYSQL_CONTAINER_NAME && sudo docker rm $MYSQL_CONTAINER_NAME; fi

sudo docker build --build-arg SETUP_PATH=/var/setup/mysql -f docker/mysql.dockerfile -t $MYSQL_IMAGE_NAME .
sudo docker run -id --restart always -e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD -p $MYSQL_PORT:3306 -v $MYSQL_LOCAL_PATH/data/:/var/lib/mysql -v $MYSQL_LOCAL_PATH/conf/:/etc/mysql/conf.d -v $MYSQL_LOCAL_PATH/logs/:/var/log/mysql -v $MYSQL_LOCAL_PATH/setup/:/var/setup/mysql --name $MYSQL_CONTAINER_NAME $MYSQL_IMAGE_NAME

# 删除因重复 build 而产生的悬挂镜像
if [[ "$(sudo docker images -f "dangling=true" -q)" ]]; then sudo docker rmi $(sudo docker images -f "dangling=true" -q); fi

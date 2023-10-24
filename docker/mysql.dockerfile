FROM mysql:latest

#设置免密登录
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

ARG SETUP_PATH
WORKDIR ${SETUP_PATH}

# NOTE: 初始建表脚本仅当 volume 为空时才会运行，不会影响已有 volume 数据
COPY database/*.sql /docker-entrypoint-initdb.d/

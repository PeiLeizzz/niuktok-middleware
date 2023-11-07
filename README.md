# niuktok-middleware
> 第二届七牛云 1024 创作节参赛作品中间件部署侧

## 部署

- 依赖
    - Docker
    - Docker-Compose
- 默认版本
    - MySQL: 8.0.27
    - Redis: 6.2.3
    - Nacos: 2.2.3
    - RocketMQ: 5.1.4（暂未使用）
- 配置：统一放在 `configs/` 目录下，其中 nacos 的相关配置需要参照 [nacos 官方仓库](https://github.com/nacos-group/nacos-docker)修改 `/docker/nacos-docker` 工程的内容
    - 注意此处的配置会影响后端工程的配置
- 脚本：MySQL & Redis 分环境单独形成容器，Nacos & RocketMQ 暂未分环境
    - MySQL: `sudo bash scripts/mysql_deploy.sh dev`
    - Redis: `sudo bash scripts/redis_deploy.sh dev`
    - Nacos: `sudo bash scripts/nacos_deploy.sh`
    - RocketMQ: `sudo bash scripts/rocketmq_deploy.sh`
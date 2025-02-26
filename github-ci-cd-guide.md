# GitHub CI/CD 配置指南

本文档指导你如何为Vue项目设置GitHub Actions CI/CD流程，实现自动构建Docker镜像并部署。

## 前提条件

1. 拥有一个GitHub账号
2. 拥有一个Docker Hub账号（或其他容器镜像仓库账号）
3. 拥有一个可以SSH访问的部署服务器

## GitHub Secrets 配置

在GitHub仓库中，需要设置以下Secrets（密钥）：

1. 在GitHub仓库页面，点击 `Settings` > `Secrets and variables` > `Actions`
2. 点击 `New repository secret` 添加以下密钥：

- `DOCKERHUB_USERNAME`: Docker Hub用户名
- `DOCKERHUB_TOKEN`: Docker Hub访问令牌（不要使用密码，应该在Docker Hub创建访问令牌）
- `SSH_HOST`: 部署服务器的IP地址或域名
- `SSH_USERNAME`: SSH用户名
- `SSH_PRIVATE_KEY`: SSH私钥（确保对应的公钥已添加到服务器authorized_keys中）

## 工作流说明

工作流文件 `.github/workflows/docker-build-deploy.yml` 包含两个主要作业：

### 构建作业 (build)

1. 检出代码
2. 设置Node.js环境
3. 安装项目依赖
4. 运行测试（如有）
5. 登录Docker Hub
6. 构建Docker镜像并推送到Docker Hub

### 部署作业 (deploy)

1. 通过SSH连接到部署服务器
2. 拉取最新的Docker镜像
3. 使用docker-compose重新启动应用

## 触发条件

该CI/CD流程在以下情况下触发：

- 当代码推送到main或master分支时
- 当创建针对main或master分支的Pull Request时
- 手动触发（通过GitHub Actions界面）

## 部署服务器配置

确保部署服务器上已准备好以下内容：

1. 安装Docker和docker-compose
2. 创建适当的docker-compose.yml文件
3. 确保项目目录结构正确

## 示例docker-compose.yml

在部署服务器的应用目录中，创建一个docker-compose.yml文件：

```yaml
version: '3'

services:
  web:
    image: 用户名/vue-app:latest
    container_name: vue-app
    restart: always
    ports:
      - "80:80"
```

## 故障排除

如果CI/CD流程失败，请检查：

1. GitHub Actions日志以了解具体错误
2. 确认所有Secrets是否正确设置
3. 确认部署服务器是否可以正常访问
4. 确认Docker Hub凭据是否有效

## 安全注意事项

- 定期更新Docker Hub访问令牌
- 使用最小权限原则配置SSH用户
- 考虑为生产环境和测试环境设置不同的分支和工作流 
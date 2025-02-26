# CI/CD 配置说明

## 概述

本项目使用 GitHub Actions 配置了完整的 CI/CD 流水线，包含以下阶段：

1. **构建与测试**：运行代码检查、类型检查和构建
2. **Docker 镜像构建与推送**：构建 Docker 镜像并推送至 Docker Hub
3. **部署**：将应用部署到生产服务器

## 配置步骤

### 1. GitHub Secrets 配置

在 GitHub 仓库设置中添加以下 Secrets：

- `DOCKER_USERNAME`: Docker Hub 用户名
- `DOCKER_PASSWORD`: Docker Hub 密码或访问令牌
- `DEPLOY_HOST`: 部署服务器 IP 地址
- `DEPLOY_USERNAME`: 部署服务器登录用户名
- `DEPLOY_KEY`: 部署服务器 SSH 私钥

### 2. 配置 SSH 密钥

1. 生成 SSH 密钥对：

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f deploy_key
   ```

2. 将公钥 `deploy_key.pub` 添加到服务器的 `~/.ssh/authorized_keys`

3. 将私钥内容添加到 GitHub Secrets 中的 `DEPLOY_KEY`

### 3. 分支设置

确保您的主分支名称是 `main` 或 `master`，否则需要在工作流文件中调整分支名称。

## 工作流程触发

该 CI/CD 流水线在以下情况下触发：

- 推送代码到 `main` 或 `master` 分支
- 创建针对 `main` 或 `master` 分支的 Pull Request
- 手动触发工作流程（通过 GitHub Actions 界面）

## 注意事项

1. Pull Request 只会执行构建和测试阶段，不会执行 Docker 镜像构建和部署
2. 只有推送到 `main` 或 `master` 分支时才会执行完整流程（包括部署）
3. 确保服务器已安装 Docker 并且用户有权限运行 Docker 命令

## 自定义

根据项目需求，您可能需要调整以下内容：

- 端口映射配置（目前设置为 80:80）
- Docker 镜像标签策略
- 部署环境（如添加测试环境、预发环境等）
- 添加自动化测试步骤

如需更多帮助，请参考 [GitHub Actions 文档](https://docs.github.com/en/actions)。

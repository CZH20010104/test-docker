# GitLab CI/CD 配置说明

## 概述

本项目使用 GitLab CI/CD 配置了完整的流水线，包含以下阶段：

1. **测试**：运行代码检查和类型检查
2. **构建**：构建Vue应用
3. **Docker**：构建并推送Docker镜像
4. **部署**：将应用部署到生产服务器

## 配置步骤

### 1. GitLab CI/CD 变量配置

在 GitLab 项目的 设置 > CI/CD > 变量 中添加以下变量：

- `SSH_PRIVATE_KEY`: 部署服务器的SSH私钥（确保添加为"文件"类型）
- `SSH_KNOWN_HOSTS`: 部署服务器的SSH公钥指纹（可以通过 `ssh-keyscan 服务器IP` 获取）
- `DEPLOY_USER`: 部署服务器的用户名
- `DEPLOY_HOST`: 部署服务器的IP地址或域名

GitLab自带的CI变量会自动处理Docker注册表认证：

- `CI_REGISTRY`: GitLab容器注册表地址
- `CI_REGISTRY_USER`: GitLab容器注册表用户名
- `CI_REGISTRY_PASSWORD`: GitLab容器注册表密码
- `CI_REGISTRY_IMAGE`: 项目容器注册表路径

### 2. 配置 SSH 密钥

1. 生成 SSH 密钥对：

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f deploy_key
   ```

2. 将公钥 `deploy_key.pub` 添加到服务器的 `~/.ssh/authorized_keys`

3. 将私钥内容添加到 GitLab CI/CD 变量 `SSH_PRIVATE_KEY`

4. 获取服务器 SSH 指纹并添加到 `SSH_KNOWN_HOSTS` 变量：
   ```bash
   ssh-keyscan -H 服务器IP > known_hosts
   cat known_hosts
   ```

### 3. 启用容器注册表

在 GitLab 项目设置中启用容器注册表功能，以便存储Docker镜像。

## 工作流程触发

该 CI/CD 流水线在以下情况下触发：

- 推送代码到默认分支（通常是 `main` 或 `master`）
- 创建合并请求

## 注意事项

1. 部署到生产环境是手动触发的（需要在GitLab管道界面点击"部署生产"阶段的播放按钮）
2. 只有默认分支才会执行Docker镜像构建和部署
3. 确保服务器已安装Docker并且用户有权限运行Docker命令
4. 使用GitLab自带的容器注册表简化了配置

## 自定义

根据项目需求，您可能需要调整以下内容：

- 添加更多环境（如测试环境、预发环境）
- 调整缓存策略
- 添加更多的测试步骤
- 修改部署策略（如使用Kubernetes或其他部署方法）

如需更多帮助，请参考 [GitLab CI/CD 文档](https://docs.gitlab.com/ee/ci/)。

# 阶段1：构建生产代码
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 阶段2：托管静态文件
FROM nginx:1.24-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
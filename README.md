# 校园论坛系统

一个基于 Vue 3 + Spring Boot 的现代化校园论坛系统，支持用户发帖、评论、板块管理等功能。

## 🛠 技术栈

### 前端
| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.22 | 使用 Composition API 和 `<script setup>` 语法 |
| TypeScript | 5.9 | 完整的类型支持 |
| Vite | 7.1.11 | 现代化的前端构建工具 |
| Vue Router | 4.6.3 | 官方路由管理 |
| Pinia | 3.0.3 | 状态管理 |
| Element Plus | 2.11.8 | UI 组件库 |
| Axios | 1.13.2 | HTTP 客户端 |
| @kangc/v-md-editor | 2.3.18 | Markdown 编辑器 |
| highlight.js | 11.11.1 | 代码高亮 |
| Sass | 1.94.2 | CSS 预处理器 |

### 后端
| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.3.5 | 主框架 |
| Java | 21 | 使用最新的 Java 特性 |
| MyBatis-Plus | 3.5.10.1 | ORM 框架 |
| Spring Security | - | 安全框架 |
| JWT (jjwt) | 0.11.5 | 令牌认证 |
| Knife4j | 4.3.0 | API 文档 (OpenAPI 3) |
| Lombok | 1.18.34 | 代码简化 |
| Hutool | 5.8.27 | Java 工具库 |
| MySQL | 8.0 | 数据库 |
| Redis | - | 缓存 |
| Maven | - | 项目构建 |

## 📁 项目结构

```
forum/
├── backend/          # 后端服务
│   └── src/main/java/com/ljx/forum/
│       ├── common/       # 公共配置、异常处理
│       ├── config/       # 配置类
│       ├── controller/   # 控制器
│       ├── service/      # 服务层
│       ├── mapper/       # 数据访问层
│       ├── entity/       # 实体类
│       ├── dto/          # 数据传输对象
│       ├── vo/           # 视图对象
│       └── security/     # 安全相关
└── frontend/         # 前端应用
    ├── src/
    │   ├── api/          # API 接口
    │   ├── components/   # 可复用组件
    │   ├── layout/       # 布局组件
    │   ├── router/       # 路由配置
    │   ├── store/        # Pinia 状态管理
    │   ├── utils/        # 工具函数
    │   └── views/        # 页面组件
    │       ├── auth/     # 登录注册
    │       ├── forum/    # 论坛相关
    │       ├── admin/    # 管理员后台
    │       └── user/     # 用户中心
    └── package.json
```

## 🚀 功能特性

### 用户系统
- ✅ 用户注册/登录（JWT 认证）
- ✅ 个人信息管理（头像、昵称）
- ✅ 积分系统
- ✅ 三级权限体系（普通用户/板主/管理员）

### 论坛功能
- ✅ 多板块管理
- ✅ 帖子发布（支持 Markdown）
- ✅ 评论系统（支持楼中楼）
- ✅ 帖子搜索
- ✅ 浏览量统计
- ✅ 帖子置顶

### 管理功能
- ✅ 管理员后台（用户管理、内容审核）
- ✅ 板主后台（板块管理）
- ✅ 消息中心（评论通知、系统消息）

## 📦 快速开始

### 环境要求
- Java 21
- Node.js ^20.19.0 或 >=22.12.0
- MySQL 8.0

### 后端启动
```bash
cd backend
# 修改 application.yml 中的数据库配置
# 运行 Maven 构建
mvn clean install
# 启动应用
mvn spring-boot:run
```

API 文档访问：http://localhost:8080/doc.html

### 前端启动
```bash
cd frontend
# 安装依赖
npm install
# 启动开发服务器
npm run dev
```

应用访问：http://localhost:5173

## 📊 数据库设计

### 核心表结构
- **sys_user** - 用户表（角色权限、积分）
- **forum_board** - 板块表
- **forum_post** - 帖子表（标题、内容、统计）
- **forum_comment** - 评论表（支持楼中楼）
- **sys_message** - 消息通知表

## 🔑 默认账号

- **管理员**: 154284221 / qwaszx123

## 📝 主要接口

### 认证相关
- POST /api/auth/login - 用户登录
- POST /api/auth/register - 用户注册
- GET /api/auth/profile - 获取用户信息

### 论坛相关
- GET /api/posts - 获取帖子列表（支持分页）
- GET /api/posts/{id} - 获取帖子详情
- POST /api/posts - 发布帖子
- POST /api/posts/{id}/comments - 发表评论

### 管理相关
- GET /api/admin/users - 用户管理
- GET /api/admin/posts - 帖子管理
- GET /api/moderator/boards - 板块管理

## 💡 技术亮点

1. **前后端分离**：RESTful API 设计，职责清晰
2. **现代化技术栈**：Vue 3 + Spring Boot 3，使用最新特性
3. **无状态认证**：JWT 令牌，支持分布式部署
4. **完善的权限控制**：基于角色的访问控制（RBAC）
5. **Markdown 支持**：富文本编辑，代码高亮
6. **统一响应格式**：Result<T> 封装所有接口返回
7. **TypeScript 支持**：前端全面类型安全
8. **API 文档**：Knife4j 自动生成接口文档

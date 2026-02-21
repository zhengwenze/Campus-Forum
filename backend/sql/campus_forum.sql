/*
 Navicat Premium Dump SQL

 Source Server         : MySQL 8.0
 Source Server Type    : MySQL
 Source Server Version : 80018 (8.0.18)
 Source Host           : localhost:3306
 Source Schema         : campus_forum

 Target Server Type    : MySQL
 Target Server Version : 80018 (8.0.18)
 File Encoding         : 65001

 Date: 21/02/2026 21:37:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for forum_board
-- ----------------------------
DROP TABLE IF EXISTS `forum_board`;
CREATE TABLE `forum_board`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '板块ID',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '板块名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '板块描述',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序优先级',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '板块表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of forum_board
-- ----------------------------
INSERT INTO `forum_board` VALUES (1, '校园杂谈', '聊聊学校里的新鲜事', 1, NULL, '2025-11-21 13:24:10');
INSERT INTO `forum_board` VALUES (2, '技术交流', '代码、算法、作业求助', 2, NULL, '2025-11-21 13:24:10');
INSERT INTO `forum_board` VALUES (3, '二手交易', '毕业甩卖，好物流转', 3, NULL, '2025-11-21 13:24:10');
INSERT INTO `forum_board` VALUES (5, '考试资料', '考试资料', 0, '', '2026-02-10 13:20:02');

-- ----------------------------
-- Table structure for forum_comment
-- ----------------------------
DROP TABLE IF EXISTS `forum_comment`;
CREATE TABLE `forum_comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL COMMENT '所属帖子',
  `user_id` bigint(20) NOT NULL COMMENT '评论人',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '父评论ID(用于盖楼，可空)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NULL DEFAULT 0,
  `root_id` bigint(20) NULL DEFAULT 0 COMMENT '根评论ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post`(`post_id` ASC) USING BTREE,
  INDEX `idx_root_id`(`root_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of forum_comment
-- ----------------------------
INSERT INTO `forum_comment` VALUES (9, 2, 1, '太贵了', 0, '2025-11-22 17:34:49', 0, 0);
INSERT INTO `forum_comment` VALUES (10, 2, 1, '回复 @ljx1230 : 死穷逼', 9, '2025-11-22 17:34:58', 0, 9);
INSERT INTO `forum_comment` VALUES (11, 3, 1, '当然可以', 0, '2025-11-22 20:55:06', 0, 0);
INSERT INTO `forum_comment` VALUES (12, 3, 1, '回复 @ljx1230 : 被裁员前的幻想罢了', 11, '2025-11-22 20:55:24', 0, 11);
INSERT INTO `forum_comment` VALUES (13, 1, 1, '测试1', 0, '2025-11-23 20:13:16', 0, 0);
INSERT INTO `forum_comment` VALUES (14, 1, 1, '测试2', 0, '2025-11-23 20:14:19', 0, 0);
INSERT INTO `forum_comment` VALUES (15, 1, 2, '测试2', 0, '2025-11-23 20:15:15', 0, 0);
INSERT INTO `forum_comment` VALUES (16, 1, 2, '再测试一下', 0, '2025-11-24 15:28:43', 0, 0);
INSERT INTO `forum_comment` VALUES (17, 1, 2, '测试一下一键清空1', 0, '2025-11-24 15:29:04', 0, 0);
INSERT INTO `forum_comment` VALUES (18, 1, 2, '测试一下一键清空2', 0, '2025-11-24 15:29:06', 0, 0);
INSERT INTO `forum_comment` VALUES (19, 1, 2, '测试一下一键清空3', 0, '2025-11-24 15:31:57', 0, 0);
INSERT INTO `forum_comment` VALUES (20, 1, 2, '测试一下一键清空4', 0, '2025-11-24 15:32:00', 0, 0);
INSERT INTO `forum_comment` VALUES (21, 1, 2, '测试一下一键清空5', 0, '2025-11-24 15:32:03', 0, 0);
INSERT INTO `forum_comment` VALUES (22, 7, 6, '您好！', 0, '2026-02-10 13:01:52', 0, 0);
INSERT INTO `forum_comment` VALUES (23, 8, 6, '学长精心整理资料真不错', 0, '2026-02-10 16:36:08', 0, 0);
INSERT INTO `forum_comment` VALUES (24, 8, 6, '回复 @111111 : 666', 23, '2026-02-10 16:36:15', 0, 23);
INSERT INTO `forum_comment` VALUES (25, 7, 7, '666', 0, '2026-02-10 17:26:47', 0, 0);
INSERT INTO `forum_comment` VALUES (26, 7, 7, '回复 @111111 : Hello!', 22, '2026-02-10 17:26:57', 0, 22);

-- ----------------------------
-- Table structure for forum_post
-- ----------------------------
DROP TABLE IF EXISTS `forum_post`;
CREATE TABLE `forum_post`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `board_id` int(11) NOT NULL COMMENT '板块ID',
  `user_id` bigint(20) NOT NULL COMMENT '作者ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容(Markdown源码)',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览量',
  `reply_count` int(11) NULL DEFAULT 0 COMMENT '回复数',
  `is_top` tinyint(1) NULL DEFAULT 0 COMMENT '是否置顶',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_board`(`board_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of forum_post
-- ----------------------------
INSERT INTO `forum_post` VALUES (2, 3, 1, '卖考研资料', '## 李林六套卷 5元\n', 24, 2, 0, '2025-11-22 14:37:15', '2025-11-22 17:34:58', 0);
INSERT INTO `forum_post` VALUES (3, 2, 1, '学java能赚大钱吗', '学java能赚大钱吗？编辑后。。。', 13, 2, 0, '2025-11-22 20:54:49', '2025-11-22 20:55:24', 0);
INSERT INTO `forum_post` VALUES (5, 1, 4, '测试11111', '冲刺冲刺吃', 0, 0, 0, '2025-11-30 16:11:34', '2025-11-30 16:11:34', 0);
INSERT INTO `forum_post` VALUES (6, 1, 4, '测试22222', '2therrthhr', 0, 0, 0, '2025-11-30 16:11:44', '2025-11-30 16:11:44', 0);
INSERT INTO `forum_post` VALUES (7, 1, 5, '测试111111', '**测试111111**', 12, 3, 1, '2026-02-10 12:47:07', '2026-02-10 17:26:57', 0);
INSERT INTO `forum_post` VALUES (8, 5, 6, '学长精心整理资料', '**学长精心整理资料**', 4, 2, 0, '2026-02-10 13:21:22', '2026-02-10 16:36:15', 0);

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_id` bigint(20) NOT NULL COMMENT '发送者ID(0代表系统)',
  `to_id` bigint(20) NOT NULL COMMENT '接收者ID',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型: COMMENT/CHAT/SYSTEM',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息内容或关联ID',
  `is_read` tinyint(1) NULL DEFAULT 0 COMMENT '是否已读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_to_user`(`to_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_message
-- ----------------------------
INSERT INTO `sys_message` VALUES (1, 2, 1, 'COMMENT', 'POST:1:测试2', 1, '2025-11-23 20:15:15');
INSERT INTO `sys_message` VALUES (2, 1, 2, 'CHAT', '测试私信', 1, '2025-11-23 20:18:47');
INSERT INTO `sys_message` VALUES (3, 2, 1, 'CHAT', '测试未读消息1', 1, '2025-11-24 13:49:50');
INSERT INTO `sys_message` VALUES (4, 2, 1, 'CHAT', '测试未读消息2', 1, '2025-11-24 13:50:04');
INSERT INTO `sys_message` VALUES (5, 1, 2, 'CHAT', '123', 1, '2025-11-24 14:50:45');
INSERT INTO `sys_message` VALUES (6, 2, 1, 'CHAT', '测试未读消息3', 1, '2025-11-24 13:50:04');
INSERT INTO `sys_message` VALUES (7, 1, 2, 'CHAT', '222', 1, '2025-11-24 15:27:59');
INSERT INTO `sys_message` VALUES (8, 1, 2, 'CHAT', '测试一下实时性', 1, '2025-11-24 15:28:16');
INSERT INTO `sys_message` VALUES (9, 2, 1, 'COMMENT', 'POST:1:再测试一下', 1, '2025-11-24 15:28:43');
INSERT INTO `sys_message` VALUES (10, 2, 1, 'COMMENT', 'POST:1:测试一下一键清空1', 1, '2025-11-24 15:29:04');
INSERT INTO `sys_message` VALUES (11, 2, 1, 'COMMENT', 'POST:1:测试一下一键清空2', 1, '2025-11-24 15:29:06');
INSERT INTO `sys_message` VALUES (12, 2, 1, 'COMMENT', 'POST:1:测试一下一键清空3', 1, '2025-11-24 15:31:57');
INSERT INTO `sys_message` VALUES (13, 2, 1, 'COMMENT', 'POST:1:测试一下一键清空4', 1, '2025-11-24 15:32:00');
INSERT INTO `sys_message` VALUES (14, 2, 1, 'COMMENT', 'POST:1:测试一下一键清空5', 1, '2025-11-24 15:32:03');
INSERT INTO `sys_message` VALUES (16, 1, 3, 'CHAT', 'hello，可以聊一聊吗？', 1, '2025-11-26 14:36:24');
INSERT INTO `sys_message` VALUES (17, 3, 1, 'CHAT', '可以呀', 1, '2025-11-26 14:36:47');
INSERT INTO `sys_message` VALUES (18, 1, 3, 'CHAT', '??', 1, '2025-11-26 14:37:04');
INSERT INTO `sys_message` VALUES (19, 3, 1, 'CHAT', 'd(=^･ω･^=)b', 1, '2025-11-26 14:37:13');
INSERT INTO `sys_message` VALUES (20, 6, 5, 'COMMENT', 'POST:7:您好！', 0, '2026-02-10 13:01:52');
INSERT INTO `sys_message` VALUES (21, 7, 5, 'COMMENT', 'POST:7:666', 0, '2026-02-10 17:26:47');
INSERT INTO `sys_message` VALUES (22, 7, 6, 'COMMENT', 'POST:7:回复了你的评论: Hello!', 1, '2026-02-10 17:26:57');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(加密)',
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `score` int(11) NULL DEFAULT 0 COMMENT '积分',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'USER' COMMENT '角色: USER/ADMIN/MODERATOR',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '逻辑删除: 0正常, 1删除',
  `board_id` int(11) NULL DEFAULT NULL COMMENT '负责的板块ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, '154284220', '$2a$10$N1zllEgWwS5.dmBco0oyRu0IRL3yVKgEaWZTxAikoIqqWgSi/cKgC', 'ljx1230', 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png', '154284550@qq.com', 28, 'MODERATOR', '2025-11-21 14:51:02', '2025-11-27 20:38:44', 0, 1);
INSERT INTO `sys_user` VALUES (2, '11223344', '$2a$10$/ZVowxgJMUFcr8UuMPr5GeQTOM0jX/HdfqygK4mMZUpUmPncvB6Pi', 'ljx1231', 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png', NULL, 14, 'USER', '2025-11-21 16:55:30', '2025-11-24 15:32:03', 0, NULL);
INSERT INTO `sys_user` VALUES (3, '3207368827', '$2a$10$akdQKYkXVCgWIbZtRiaipebyleXPe9UWrWOoVBmqiOemGEzhdnQf.', 'ljx1232', 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png', NULL, 0, 'USER', '2025-11-26 14:27:41', '2025-11-26 14:27:41', 0, NULL);
INSERT INTO `sys_user` VALUES (4, '154284221', '$2a$10$akdQKYkXVCgWIbZtRiaipebyleXPe9UWrWOoVBmqiOemGEzhdnQf.', 'admin', 'https://wx3.sinaimg.cn/mw690/0086L4P5gy1hy8mzpjuzhj30sg2ddqq1.jpg', 'admin@qq.com', 200, 'ADMIN', '2025-11-26 14:27:41', '2025-11-30 16:11:44', 0, NULL);
INSERT INTO `sys_user` VALUES (5, 'zwz123456', '$2a$10$ou/oC6rasVUM/JILA4qD4e2Xm5HWOSkn.h0kUp3Q49SkEoGbSgY/K', 'zwz123456', 'https://q6.itc.cn/images01/20260208/999f471c3e5d49afa0603f0ec06582a2.png', '2017160177@qq.com', 10, 'MODERATOR', '2026-02-10 12:45:17', '2026-02-10 12:47:07', 0, 3);
INSERT INTO `sys_user` VALUES (6, '111111', '$2a$10$B4MztFqS/sVZM4Tb830ofuEwTQyd0ePbv208T1czLraqnD63btaOS', '111111', 'https://n.sinaimg.cn/sinakd10008/707/w2000h2707/20230314/6cd9-d9d5de6a2dfa4eccd66b379a4648a13d.jpg', '111111@qq.com', 16, 'MODERATOR', '2026-02-10 13:01:43', '2026-02-10 16:36:15', 0, 5);
INSERT INTO `sys_user` VALUES (7, 'admin111', '$2a$10$hwtgep7WN7lFo8/OjHy67eRcO8HBGXDIReWA7NhvcY5iWI2hwjTi2', 'admin111', 'http://localhost:8080/file/image/eb118774-149e-4f1e-9972-ea852fd33d54.jpg', 'admin111@QQ.com', 104, 'ADMIN', '2026-02-10 16:36:35', '2026-02-10 17:26:57', 0, NULL);

SET FOREIGN_KEY_CHECKS = 1;

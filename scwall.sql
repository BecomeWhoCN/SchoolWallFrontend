/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : scwall

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 11/07/2024 09:33:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sc_blocked_users
-- ----------------------------
DROP TABLE IF EXISTS `sc_blocked_users`;
CREATE TABLE `sc_blocked_users`  (
  `blocker_id` int(11) NOT NULL,
  `blocked_user_id` int(11) NOT NULL,
  `block_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`blocker_id`, `blocked_user_id`) USING BTREE,
  INDEX `blocked_user_id`(`blocked_user_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for sc_categories
-- ----------------------------
DROP TABLE IF EXISTS `sc_categories`;
CREATE TABLE `sc_categories`  (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `category_name`(`category_name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_comment_votes
-- ----------------------------
DROP TABLE IF EXISTS `sc_comment_votes`;
CREATE TABLE `sc_comment_votes`  (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `vote_type` enum('upvote','downvote') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `vote_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`vote_id`) USING BTREE,
  INDEX `comment_id`(`comment_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for sc_drift_bottle_replies
-- ----------------------------
DROP TABLE IF EXISTS `sc_drift_bottle_replies`;
CREATE TABLE `sc_drift_bottle_replies`  (
  `reply_id` int(11) NOT NULL AUTO_INCREMENT,
  `bottle_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `reply_created_at` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`reply_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_drift_bottle_replies
-- ----------------------------
INSERT INTO `sc_drift_bottle_replies` VALUES (6, 30, 1, '确实很美好', '2024-07-07 17:38:04');
INSERT INTO `sc_drift_bottle_replies` VALUES (8, 28, 1, '111', '2024-07-07 17:43:22');
INSERT INTO `sc_drift_bottle_replies` VALUES (9, 10, 1, '啦啦啦', '2024-07-07 17:47:25');
INSERT INTO `sc_drift_bottle_replies` VALUES (10, 23, 1, 'okk\n', '2024-07-07 20:23:51');
INSERT INTO `sc_drift_bottle_replies` VALUES (11, 11, 1, '111', '2024-07-07 23:04:34');
INSERT INTO `sc_drift_bottle_replies` VALUES (12, 38, 1, '太棒了，为你点赞！', '2024-07-08 08:29:39');
INSERT INTO `sc_drift_bottle_replies` VALUES (13, 38, 1, '这场经历一定令人难忘', '2024-07-08 08:29:57');
INSERT INTO `sc_drift_bottle_replies` VALUES (14, 38, 1, '太对了哥\n', '2024-07-08 08:30:02');
INSERT INTO `sc_drift_bottle_replies` VALUES (15, 39, 1, '老时间刺客了', '2024-07-08 11:02:41');
INSERT INTO `sc_drift_bottle_replies` VALUES (16, 38, 4, '太棒了。我也要勇敢一次', '2024-07-08 14:07:17');
INSERT INTO `sc_drift_bottle_replies` VALUES (17, 28, 1, '啦啦啦', '2024-07-09 16:21:05');
INSERT INTO `sc_drift_bottle_replies` VALUES (18, 22, 1, '太对了', '2024-07-09 19:45:04');
INSERT INTO `sc_drift_bottle_replies` VALUES (19, 23, 1, '我啊啊', '2024-07-10 22:08:59');

-- ----------------------------
-- Table structure for sc_drift_bottle_reports
-- ----------------------------
DROP TABLE IF EXISTS `sc_drift_bottle_reports`;
CREATE TABLE `sc_drift_bottle_reports`  (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `bottle_id` int(11) NULL DEFAULT NULL,
  `reporter_id` int(11) NULL DEFAULT NULL,
  `report_reason` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `report_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `report_status` enum('pending','resolved') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'pending',
  PRIMARY KEY (`report_id`) USING BTREE,
  INDEX `bottle_id`(`bottle_id`) USING BTREE,
  INDEX `reporter_id`(`reporter_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_drift_bottle_taken
-- ----------------------------
DROP TABLE IF EXISTS `sc_drift_bottle_taken`;
CREATE TABLE `sc_drift_bottle_taken`  (
  `take_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `bottle_id` int(11) NOT NULL,
  `taken_at` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`take_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_drift_bottle_taken
-- ----------------------------
INSERT INTO `sc_drift_bottle_taken` VALUES (1, 1, 20, '2024-07-08 17:28:32');
INSERT INTO `sc_drift_bottle_taken` VALUES (2, 1, 21, '2024-07-21 17:28:40');

-- ----------------------------
-- Table structure for sc_drift_bottles
-- ----------------------------
DROP TABLE IF EXISTS `sc_drift_bottles`;
CREATE TABLE `sc_drift_bottles`  (
  `bottle_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `user_gender` enum('male','female','secret') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `bottle_title` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `bottle_content_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `bottle_attachment_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `bottle_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `bottle_status` enum('draft','published','inactive') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`bottle_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 43 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_drift_bottles
-- ----------------------------
INSERT INTO `sc_drift_bottles` VALUES (11, 1, 'secret', '梦想的追逐', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051125bottleContent_1720149907860.md', NULL, '2024-07-05 11:25:08', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (5, 1, 'secret', '漂流瓶', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407041552bottleContent_1720079579596.md', NULL, '2024-07-04 15:53:00', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (12, 1, 'secret', '儿时的秘密基地', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051125bottleContent_1720149921152.md', NULL, '2024-07-05 11:25:21', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (13, 1, 'secret', '第一次旅行', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051125bottleContent_1720149931300.md', NULL, '2024-07-05 11:25:31', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (14, 1, 'secret', '爱的告白', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051125bottleContent_1720149941693.md', NULL, '2024-07-05 11:25:42', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (15, 1, 'secret', '最喜欢的一本书', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051125bottleContent_1720149955060.md', NULL, '2024-07-05 11:25:55', 'published');
INSERT INTO `sc_drift_bottles` VALUES (16, 1, 'secret', '心中的音乐', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051126bottleContent_1720149964668.md', NULL, '2024-07-05 11:26:05', 'published');
INSERT INTO `sc_drift_bottles` VALUES (18, 1, 'secret', '最想去的地方', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051126bottleContent_1720149980171.md', NULL, '2024-07-05 11:26:20', 'published');
INSERT INTO `sc_drift_bottles` VALUES (19, 4, 'secret', '对未来的期许', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051126bottleContent_1720149990701.md', NULL, '2024-07-05 11:26:31', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (20, 4, 'secret', '关于友情', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051126bottleContent_1720150001691.md', NULL, '2024-07-05 11:26:42', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (21, 4, 'secret', '最美的风景', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051126bottleContent_1720150009864.md', NULL, '2024-07-05 11:26:50', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (22, 4, 'secret', '一个未完成的承诺', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051126bottleContent_1720150017763.md', NULL, '2024-07-05 11:26:58', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (23, 4, 'secret', '童年的梦想职业', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051127bottleContent_1720150026628.md', NULL, '2024-07-05 11:27:07', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (24, 4, 'secret', '一封写给未来的信', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051127bottleContent_1720150035904.md', NULL, '2024-07-05 11:27:16', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (25, 1, 'secret', '一段遗憾的过往', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051127bottleContent_1720150044436.md', NULL, '2024-07-05 11:27:25', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (26, 1, 'secret', '最爱的电影', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051127bottleContent_1720150052949.md', NULL, '2024-07-05 11:27:33', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (27, 1, 'secret', '关于家乡', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051127bottleContent_1720150065379.md', NULL, '2024-07-05 11:27:45', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (28, 1, 'secret', '人生的转折点', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051127bottleContent_1720150079716.md', NULL, '2024-07-05 11:28:00', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (29, 1, 'secret', '最难忘的生日', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051128bottleContent_1720150088220.md', NULL, '2024-07-05 11:28:08', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (30, 1, 'secret', '一个美好的早晨', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051128bottleContent_1720150095548.md', NULL, '2024-07-05 11:28:16', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (31, 1, 'secret', '最喜欢的节日', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051128bottleContent_1720150103860.md', NULL, '2024-07-05 11:28:24', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (32, 1, 'secret', '一场意外的邂逅', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051128bottleContent_1720150112268.md', NULL, '2024-07-05 11:28:32', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (33, 1, 'secret', '生活的小确幸', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051128bottleContent_1720150120414.md', NULL, '2024-07-05 11:28:40', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (34, 1, 'secret', '一段温暖的话语', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051128bottleContent_1720150128084.md', NULL, '2024-07-05 11:28:48', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (35, 1, 'secret', '关于梦想的故事', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051129bottleContent_1720150147024.md', NULL, '2024-07-05 11:29:07', 'published');
INSERT INTO `sc_drift_bottles` VALUES (36, 1, 'secret', '一幅难忘的画面', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051129bottleContent_1720150155118.md', NULL, '2024-07-05 11:29:15', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (37, 1, 'secret', '一份特别的礼物', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051129bottleContent_1720150166268.md', NULL, '2024-07-05 11:29:26', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (38, 1, 'secret', '最勇敢的一次决定', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051129bottleContent_1720150178316.md', NULL, '2024-07-05 11:29:38', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (39, 1, 'secret', '时间', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051450bottleContent_1720162208322.md', NULL, '2024-07-05 14:50:09', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (40, 1, 'male', '测试2', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407091944bottleContent_1720525495547.md', NULL, '2024-07-09 19:44:56', 'inactive');
INSERT INTO `sc_drift_bottles` VALUES (41, 2, 'secret', '测试', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407100818bottleContent_1720570738979.md', NULL, '2024-07-10 08:18:59', NULL);
INSERT INTO `sc_drift_bottles` VALUES (42, 1, 'male', '测试', 'http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407102207bottleContent_1720620454161.md', NULL, '2024-07-10 22:07:35', NULL);

-- ----------------------------
-- Table structure for sc_friends
-- ----------------------------
DROP TABLE IF EXISTS `sc_friends`;
CREATE TABLE `sc_friends`  (
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `friend_nickname` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `status` enum('pending','accepted','rejected') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'pending',
  `created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`user_id`, `friend_id`) USING BTREE,
  INDEX `friend_id`(`friend_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_friends
-- ----------------------------
INSERT INTO `sc_friends` VALUES (1, 2, '这是一只鸭子', 'accepted', '2024-07-03 19:32:05');
INSERT INTO `sc_friends` VALUES (2, 1, '这是一只熊', 'accepted', '2024-07-08 17:08:58');
INSERT INTO `sc_friends` VALUES (1, 3, '这是一个熊', 'accepted', '2024-07-11 07:46:33');
INSERT INTO `sc_friends` VALUES (3, 1, '这是一个管理员', 'accepted', '2024-07-11 07:46:43');

-- ----------------------------
-- Table structure for sc_group_admins
-- ----------------------------
DROP TABLE IF EXISTS `sc_group_admins`;
CREATE TABLE `sc_group_admins`  (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `admin_role` enum('owner','admin','moderator') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'admin',
  `admin_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`group_id`, `user_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for sc_group_invitations
-- ----------------------------
DROP TABLE IF EXISTS `sc_group_invitations`;
CREATE TABLE `sc_group_invitations`  (
  `invitation_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NULL DEFAULT NULL,
  `inviter_id` int(11) NULL DEFAULT NULL,
  `invitee_id` int(11) NULL DEFAULT NULL,
  `status` enum('pending','accepted','rejected') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'pending',
  `invited_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`invitation_id`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE,
  INDEX `inviter_id`(`inviter_id`) USING BTREE,
  INDEX `invitee_id`(`invitee_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of sc_group_invitations
-- ----------------------------
INSERT INTO `sc_group_invitations` VALUES (1, 1, 1, 4, 'accepted', '2024-07-05 17:14:46');
INSERT INTO `sc_group_invitations` VALUES (2, 2, 2, 1, 'pending', '2024-07-05 17:14:46');
INSERT INTO `sc_group_invitations` VALUES (3, 3, 3, 2, 'accepted', '2024-07-05 17:14:46');
INSERT INTO `sc_group_invitations` VALUES (7, 3, 1, 1, 'pending', '2024-07-08 09:31:31');

-- ----------------------------
-- Table structure for sc_group_members
-- ----------------------------
DROP TABLE IF EXISTS `sc_group_members`;
CREATE TABLE `sc_group_members`  (
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `member_joined_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`group_id`, `user_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of sc_group_members
-- ----------------------------
INSERT INTO `sc_group_members` VALUES (1, 1, '2024-07-05 17:14:37');
INSERT INTO `sc_group_members` VALUES (1, 2, '2024-07-05 17:14:37');
INSERT INTO `sc_group_members` VALUES (2, 2, '2024-07-05 17:14:37');
INSERT INTO `sc_group_members` VALUES (2, 3, '2024-07-05 17:14:37');
INSERT INTO `sc_group_members` VALUES (2, 4, '2024-07-05 17:14:37');
INSERT INTO `sc_group_members` VALUES (3, 3, '2024-07-05 17:14:37');
INSERT INTO `sc_group_members` VALUES (3, 4, '2024-07-05 17:14:37');

-- ----------------------------
-- Table structure for sc_group_messages
-- ----------------------------
DROP TABLE IF EXISTS `sc_group_messages`;
CREATE TABLE `sc_group_messages`  (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NULL DEFAULT NULL,
  `sender_id` int(11) NULL DEFAULT NULL,
  `message_text` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `message_sent_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `message_status` enum('active','inactive') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'active',
  PRIMARY KEY (`message_id`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE,
  INDEX `sender_id`(`sender_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 33 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_group_messages
-- ----------------------------
INSERT INTO `sc_group_messages` VALUES (1, 1, 1, 'Welcome to Group A', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (2, 1, 2, 'Hello everyone!', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (3, 1, 3, 'Good morning!', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (4, 2, 2, 'Welcome to Group B', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (5, 2, 3, 'Hello!', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (6, 2, 4, 'Hi there!', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (7, 3, 3, 'Welcome to Group C', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (8, 3, 4, 'Hello all!', '2024-07-05 17:14:55', 'active');
INSERT INTO `sc_group_messages` VALUES (9, 1, 2, 'hi man\n', '2024-07-05 17:36:25', 'active');
INSERT INTO `sc_group_messages` VALUES (10, 1, 2, '沃德发 man？', '2024-07-05 17:36:45', 'active');
INSERT INTO `sc_group_messages` VALUES (11, 1, 1, '不要再互联网上bibilailai有本事现实中碰一碰', '2024-07-05 17:37:21', 'active');
INSERT INTO `sc_group_messages` VALUES (12, 1, 2, 'What the fuck are you doing\n', '2024-07-05 17:37:33', 'active');
INSERT INTO `sc_group_messages` VALUES (13, 1, 3, '我是新朋友', '2024-07-06 10:43:22', 'active');
INSERT INTO `sc_group_messages` VALUES (14, 1, 1, '你好新朋友', '2024-07-07 17:13:33', 'active');
INSERT INTO `sc_group_messages` VALUES (15, 1, 1, 'Welcome to Group A', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (16, 1, 2, 'Hello everyone!', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (17, 1, 3, 'Good morning!', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (18, 2, 2, 'Welcome to Group B', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (19, 2, 3, 'Hello!', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (20, 2, 4, 'Hi there!', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (21, 3, 3, 'Welcome to Group C', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (22, 3, 4, 'Hello all!', '2024-07-08 07:38:46', 'active');
INSERT INTO `sc_group_messages` VALUES (32, NULL, 1, '你好鸭子', '2024-07-11 08:27:03', 'active');
INSERT INTO `sc_group_messages` VALUES (31, NULL, 1, '你好鸭子', '2024-07-11 08:20:22', 'active');
INSERT INTO `sc_group_messages` VALUES (30, NULL, 1, '你好鸭子', '2024-07-11 08:19:57', 'active');

-- ----------------------------
-- Table structure for sc_groups
-- ----------------------------
DROP TABLE IF EXISTS `sc_groups`;
CREATE TABLE `sc_groups`  (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `group_description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `group_creator_id` int(11) NULL DEFAULT NULL,
  `group_admin_id` int(11) NULL DEFAULT NULL,
  `group_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `group_status` enum('active','inactive') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'active',
  PRIMARY KEY (`group_id`) USING BTREE,
  UNIQUE INDEX `group_name`(`group_name`) USING BTREE,
  INDEX `group_creator_id`(`group_creator_id`) USING BTREE,
  INDEX `group_admin_id`(`group_admin_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_groups
-- ----------------------------
INSERT INTO `sc_groups` VALUES (1, 'Group A', 'Description for Group A', 1, 1, '2024-07-05 17:14:27', 'active');
INSERT INTO `sc_groups` VALUES (2, 'Group B', 'Description for Group B', 2, 2, '2024-07-05 17:14:27', 'active');
INSERT INTO `sc_groups` VALUES (3, 'Group C', 'Description for Group C', 3, 3, '2024-07-05 17:14:27', 'active');
INSERT INTO `sc_groups` VALUES (4, 'xz的测试频道', '这是一个测试的调频频道', 1, 1, '2024-07-08 07:34:27', 'active');

-- ----------------------------
-- Table structure for sc_notifications
-- ----------------------------
DROP TABLE IF EXISTS `sc_notifications`;
CREATE TABLE `sc_notifications`  (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `notification_type` enum('message','comment','vote','group') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `notification_text` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `notification_read_status` enum('unread','read') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'unread',
  `notification_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`notification_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_post_attachments
-- ----------------------------
DROP TABLE IF EXISTS `sc_post_attachments`;
CREATE TABLE `sc_post_attachments`  (
  `attachment_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NULL DEFAULT NULL,
  `attachment_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`attachment_id`) USING BTREE,
  INDEX `post_id`(`post_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_post_categories
-- ----------------------------
DROP TABLE IF EXISTS `sc_post_categories`;
CREATE TABLE `sc_post_categories`  (
  `post_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`post_id`, `category_id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for sc_post_comments
-- ----------------------------
DROP TABLE IF EXISTS `sc_post_comments`;
CREATE TABLE `sc_post_comments`  (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `parent_comment_id` int(11) NULL DEFAULT NULL,
  `comment_content_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `comment_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `comment_status` enum('active','inactive') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'active',
  `group_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`comment_id`) USING BTREE,
  INDEX `post_id`(`post_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `parent_comment_id`(`parent_comment_id`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_post_tags
-- ----------------------------
DROP TABLE IF EXISTS `sc_post_tags`;
CREATE TABLE `sc_post_tags`  (
  `post_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`post_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for sc_post_votes
-- ----------------------------
DROP TABLE IF EXISTS `sc_post_votes`;
CREATE TABLE `sc_post_votes`  (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `vote_type` enum('upvote','downvote') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `vote_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`vote_id`) USING BTREE,
  INDEX `post_id`(`post_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for sc_posts
-- ----------------------------
DROP TABLE IF EXISTS `sc_posts`;
CREATE TABLE `sc_posts`  (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `post_title` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `post_content_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `post_header_image_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  `post_status` enum('draft','published','inactive') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'draft',
  `post_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `post_updated_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `group_id` int(11) NULL DEFAULT NULL,
  `post_summary` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`post_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_posts
-- ----------------------------
INSERT INTO `sc_posts` VALUES (2, 1, '碳中和是不是人类历史上的一个阳谋？', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/markdown/628c1610-e38b-4971-923b-7d6fa3efaee2content.md', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/picture/5644e43d-8871-49dc-b706-ca7d026bcb3fb80e8e9327bb4af0077f092f7defd0b.jpg', 'published', '2024-07-10 00:29:13', '2024-07-10 21:31:59', NULL, ' 最近翻收藏夹发现收藏的很多个人博客网站已经停更了。我发现的早的2013年断更，晚的也在2023年停更了。至今了无音讯。');
INSERT INTO `sc_posts` VALUES (3, 3, 'SSL证书涨价28倍，纯浏览web网站，有必要续费吗？', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/markdown/af468497-ffc0-465d-a2af-cc89fd6f43ebcontent.md', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/picture/fe456cba-1953-4a94-b223-5db9bccdae05d95194d386c105bfd0ba93f325030c1.jpg', 'published', '2024-07-10 00:56:09', '2024-07-10 19:32:59', NULL, '以前只要1元一年的SSL证书，现在要28元了，每多一个子域名，还要加28元。  如果网站是纯web访问，访客不能注册登陆，只能浏览这种，有必要续费吗');
INSERT INTO `sc_posts` VALUES (4, 3, '有一张巨强的显卡是什么体验？', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/markdown/dd81e9d5-f004-4823-8d5d-7d8499c813dccontent.md', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/picture/db2e6019-7edd-43f3-b55b-d9212dc96622b80e8e9327bb4af0077f092f7defd0b.jpg', 'published', '2024-07-10 00:56:51', '2024-07-10 19:32:59', NULL, '巨爽');
INSERT INTO `sc_posts` VALUES (5, 1, '朋友送我一台服务器，配置很高但是启动很慢，要五六分钟才启动，', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/markdown/9456e3c0-9b26-4baf-8e60-7df62278204ccontent.md', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/picture/9943189b-a8e6-4c18-86c5-a451affa9612d95194d386c105bfd0ba93f325030c1.jpg', 'published', '2024-07-10 01:01:12', '2024-07-11 07:42:40', NULL, '鲁大师测试炸裂了');
INSERT INTO `sc_posts` VALUES (7, 2, '程序员系统入门大模型的路径和资源，看这篇就够了', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/markdown/586be1e2-ceaf-40ad-b06e-da22b76825e1content.md', 'http://sfrsrdckw.hn-bkt.clouddn.com/scPosts/picture/bbca5feb-f8f7-4f21-88f9-8d5a196ac4de073b7f466b2de435583e38698175903.jpg', 'published', '2024-07-10 07:32:59', '2024-07-10 07:32:59', NULL, 'AI普及率越来越高吗，开发中我们应该如何掌如何掌握有关知识');

-- ----------------------------
-- Table structure for sc_private_message_attachments
-- ----------------------------
DROP TABLE IF EXISTS `sc_private_message_attachments`;
CREATE TABLE `sc_private_message_attachments`  (
  `attachment_id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) NULL DEFAULT NULL,
  `attachment_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`attachment_id`) USING BTREE,
  INDEX `message_id`(`message_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_private_message_attachments
-- ----------------------------
INSERT INTO `sc_private_message_attachments` VALUES (1, NULL, 'http://example.com/attachment1.jpg');
INSERT INTO `sc_private_message_attachments` VALUES (2, NULL, 'http://example.com/attachment2.jpg');

-- ----------------------------
-- Table structure for sc_private_messages
-- ----------------------------
DROP TABLE IF EXISTS `sc_private_messages`;
CREATE TABLE `sc_private_messages`  (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NULL DEFAULT NULL,
  `receiver_id` int(11) NULL DEFAULT NULL,
  `message_text` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `message_sent_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`message_id`) USING BTREE,
  INDEX `sender_id`(`sender_id`) USING BTREE,
  INDEX `receiver_id`(`receiver_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_private_messages
-- ----------------------------
INSERT INTO `sc_private_messages` VALUES (1, 2, 2, 'lalala\n', '2024-07-04 16:02:19');
INSERT INTO `sc_private_messages` VALUES (2, 1, 2, '哈哈哈', '2024-07-04 16:02:33');
INSERT INTO `sc_private_messages` VALUES (3, 2, 3, '123', '2024-07-04 16:03:12');
INSERT INTO `sc_private_messages` VALUES (4, 2, 1, '啦啦啦\n', '2024-07-04 16:17:11');
INSERT INTO `sc_private_messages` VALUES (5, 1, 2, '芭芭拉闪亮登场\n', '2024-07-04 16:17:22');
INSERT INTO `sc_private_messages` VALUES (6, 2, 1, '你真会啊', '2024-07-04 16:17:43');
INSERT INTO `sc_private_messages` VALUES (7, 1, 3, '你好', '2024-07-05 10:37:18');
INSERT INTO `sc_private_messages` VALUES (9, 1, NULL, '你好鸭子', '2024-07-11 08:33:33');
INSERT INTO `sc_private_messages` VALUES (10, 1, 2, '你好鸭子', '2024-07-11 08:53:12');

-- ----------------------------
-- Table structure for sc_reports
-- ----------------------------
DROP TABLE IF EXISTS `sc_reports`;
CREATE TABLE `sc_reports`  (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `reporter_id` int(11) NULL DEFAULT NULL,
  `reported_user_id` int(11) NULL DEFAULT NULL,
  `report_reason` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL,
  `report_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `report_status` enum('pending','resolved') CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT 'pending',
  PRIMARY KEY (`report_id`) USING BTREE,
  INDEX `reporter_id`(`reporter_id`) USING BTREE,
  INDEX `reported_user_id`(`reported_user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_tags
-- ----------------------------
DROP TABLE IF EXISTS `sc_tags`;
CREATE TABLE `sc_tags`  (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`tag_id`) USING BTREE,
  UNIQUE INDEX `tag_name`(`tag_name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc_user_avatars
-- ----------------------------
DROP TABLE IF EXISTS `sc_user_avatars`;
CREATE TABLE `sc_user_avatars`  (
  `avatar_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NULL DEFAULT NULL,
  `avatar_url` varchar(150) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`avatar_id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_user_avatars
-- ----------------------------
INSERT INTO `sc_user_avatars` VALUES (1, 1, 'http://sfrsrdckw.hn-bkt.clouddn.com/useravatars/202406301040userTx1.jpg');
INSERT INTO `sc_user_avatars` VALUES (2, 2, 'http://sfrsrdckw.hn-bkt.clouddn.com/useravatars/202407042015userTx2.jpg');
INSERT INTO `sc_user_avatars` VALUES (3, 3, 'http://sfrsrdckw.hn-bkt.clouddn.com/useravatars/202406301040userTx1.jpg');
INSERT INTO `sc_user_avatars` VALUES (4, 4, 'http://sfrsrdckw.hn-bkt.clouddn.com/useravatars/202406301040userTx1.jpg');

-- ----------------------------
-- Table structure for sc_users
-- ----------------------------
DROP TABLE IF EXISTS `sc_users`;
CREATE TABLE `sc_users`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_role` enum('admin','user','guest') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'user',
  `user_bio` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `user_class` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_gender` enum('male','female','secret') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'secret',
  `user_online_status` enum('online','offline','away') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'offline',
  `user_last_active` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `user_created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `user_status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'active',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `user_name`(`user_name`) USING BTREE,
  UNIQUE INDEX `user_email`(`user_email`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sc_users
-- ----------------------------
INSERT INTO `sc_users` VALUES (1, 'xzjob', 'xzjob@aliyun.com', '3d2714d16c8fb04301c05c67f8d1ba6f2a948da628e3c81f0fe35dbea81c27b0', 'admin', '如果可以的话我真想知道人们在想什么？如果可以的话我真想知道人们在想什么？', 'ClassA', '17638773858', 'male', 'offline', '2024-06-28 08:21:35', '2024-07-03 14:37:10', 'active');
INSERT INTO `sc_users` VALUES (2, 'moyu123', 'xindaier@qq.com', '3d2714d16c8fb04301c05c67f8d1ba6f2a948da628e3c81f0fe35dbea81c27b0', 'user', '摸鱼', '18', '15462315647', 'secret', 'offline', '2024-06-28 13:40:55', '2024-06-29 18:32:50', 'active');
INSERT INTO `sc_users` VALUES (3, 'testuser', 'testuser@test.com', '3d2714d16c8fb04301c05c67f8d1ba6f2a948da628e3c81f0fe35dbea81c27b0', 'user', NULL, NULL, '17638773814', 'secret', 'offline', '2024-06-28 23:47:22', '2024-06-29 11:13:40', 'active');
INSERT INTO `sc_users` VALUES (5, 'sunyabin', '145145@123.com', '3d2714d16c8fb04301c05c67f8d1ba6f2a948da628e3c81f0fe35dbea81c27b0', 'user', NULL, NULL, '17638773815', 'secret', 'online', '2024-07-11 07:39:37', '2024-07-11 07:39:37', 'active');
INSERT INTO `sc_users` VALUES (4, 'lpl2233', 'lpl@163.com', '3d2714d16c8fb04301c05c67f8d1ba6f2a948da628e3c81f0fe35dbea81c27b0', 'user', NULL, NULL, '13565652541', 'secret', 'offline', '2024-07-02 16:05:38', '2024-07-02 16:05:38', 'active');

SET FOREIGN_KEY_CHECKS = 1;

<template>
  <Headers />
  <div class="chat-window">
    <div class="chat-container">
      <Row>
        <!-- Chat Sidebar -->
        <Col span="6" class="chat-sidebar">
          <div class="user-info">
            <Avatar size="large" icon="md-contact" />
            <div class="user-name">聊天系统Beta</div>
            <div class="user-status">
              <Icon type="ios-radio-button-on" />
              测试
            </div>
          </div>
          <Tabs class="friend-tab" value="1">
            <TabPane label="好友" name="1">
              <div class="friend-list">
                <div
                  v-for="friend in friends"
                  :key="friend.friendId"
                  class="friend-item"
                  @click="handleFriendClick(friend.friendId, friend.friendNickname, friend.avatarUrl)"
                >
                  <Avatar :src="friend.avatarUrl" />
                  <span>{{ friend.friendNickname }}</span>
                </div>
              </div>
            </TabPane>
            <TabPane label="群组" name="2">
              <div class="group-list">
                <div
                  v-for="group in groups"
                  :key="group.groupId"
                  class="group-item"
                  @click="handleGroupClick(group.groupId, group.groupName)"
                >
                  <Avatar icon="md-contacts" />
                  <span>{{ group.groupName }}</span>
                </div>
              </div>
            </TabPane>
          </Tabs>
        </Col>
        <Col span="18" class="chat-main">
          <div class="chat-header">
            <Avatar :src="currentChatAvatar" size="large" icon="md-contact" />
            <div class="chat-title">{{ currentChatName }}</div>
            <MessageCall style="margin-left:380px"/>
            <FriendSetting v-if="isFriendChat" :friendId="currentChatId" @nicknameUpdated="fetchFriends" style="margin-left:10px"/>
          </div>
          <div class="chat-content" ref="chatContent">
            <div
              v-for="message in messages"
              :key="message.messageId"
              class="chat-message"
            >
              <Avatar :src="getSenderAvatar(message.senderId)" icon="md-contact" />
              <div class="message-content">
                <div class="message-user">{{ getMessageUser(message) }}</div>
                <div style="zoom: 0.7" class="message-time">
                  {{ message.messageSentAt }}
                </div>
                <div class="message-text">{{ message.messageText }}</div>
              </div>
            </div>
          </div>
          <div class="chat-footer">
            <div style="zoom: 1.5; margin-top: -5px" class="footer-icons">
              <Button @click="showEmoji" class="icon-button" style="margin-top:-10px" type="text">
                <Icon type="ios-happy" />
              </Button>
              <Button @click="linkFile" style="margin-top:-10px" class="icon-button" type="text">
                <Icon type="md-link" />
              </Button>
            </div>
            <div
              class="footer-input inputmessage"
              style="margin-top: 20px; margin-left: -60px; height: 50px; resize: none;"
            >
              <textarea
                v-model="newMessage"
                id="memo"
                style="height: 80px; width: 540px; resize: none; zoom: 1.1; padding: 5px;border-radius: 8px;"
              ></textarea>
              <Tooltip content="发送消息" placement="top">
                <Button style="zoom: 0.8" @click="sendMessage" type="primary">发 送</Button>
              </Tooltip>
            </div>
          </div>
        </Col>
      </Row>
    </div>
  </div>
  <SearchDialogVue />
  <Footers />
</template>

<script>
import axios from 'axios';
import Headers from "@/components/aresources/PageHead.vue";
import Footers from "@/components/aresources/PageFoot.vue";
import SearchDialogVue from '@/components/GroupsCom/SearchDialog.vue';
import MessageCall from "@/components/GroupsCom/MessageCall.vue";
import FriendSetting from "@/components/GroupsCom/FriendSetting.vue";

import {Row,Col,Avatar,Tabs,TabPane,Icon,Button,Tooltip} from "view-ui-plus";

export default {
  components: {SearchDialogVue,Row,Col,Avatar,Tabs,TabPane,Icon,Button,Tooltip,Footers,Headers,MessageCall,FriendSetting},
  data() {
    return {
      friends: [],
      groups: [],
      messages: [],
      newMessage: "",
      currentChatName: "未选择聊天对象",
      currentChatAvatar: "",
      currentChatId: null, // 当前聊天对象ID
      currentUserId: this.getCookie("userId"), // 当前用户ID
      isFriendChat: true, // 标识当前是否为好友聊天
      intervalId: null, // 定时器ID
    };
  },
  methods: {
    sendMessage() {
      if (this.newMessage.trim() !== "") {
        const newMessage = {
          groupId: this.isFriendChat ? null : this.currentChatId,
          senderId: this.currentUserId,
          messageText: this.newMessage,
          isGroup: !this.isFriendChat
        };
        axios.post('/api/privateMessages/send', newMessage).then(response => {
          if (response.data.success) {
            const message = {
              messageId: Date.now(), // 用当前时间戳作为临时ID
              senderId: this.currentUserId,
              senderName: '我', // 当前用户是发送者
              messageText: this.newMessage,
              messageSentAt: new Date().toLocaleString(), // 这里假设发送时间是当前时间
            };
            this.messages.push(message);
            this.newMessage = "";
            this.scrollToBottom();
          }
        });
      }
    },
    fetchMessages() {
      if (this.currentChatId === null) return; // 如果没有选择聊天对象则不请求消息
      const url = this.isFriendChat 
        ? `/api/privateMessages/getMessages?userId1=${this.currentUserId}&userId2=${this.currentChatId}` 
        : `/api/scGroupMessages/getMessages?groupId=${this.currentChatId}`;
      axios.get(url).then(response => {
        if (response.data.success) {
          this.messages = response.data.data;
          this.scrollToBottom();
        }
      });
    },
    scrollToBottom() {
      this.$nextTick(() => {
        const chatContent = this.$refs.chatContent;
        chatContent.scrollTop = chatContent.scrollHeight;
      });
    },
    showEmoji() {
      this.$Message.info("未开放的功能，请拭目以待");
    },
    linkFile() {
      this.$Message.info("未开放的功能，请拭目以待");
    },
    handleFriendClick(friendId, friendNickname, avatarUrl) {
      this.currentChatName = friendNickname;
      this.currentChatAvatar = avatarUrl;
      this.currentChatId = friendId;
      this.isFriendChat = true;
      console.log(`Friend with ID ${friendId} clicked.`);
      this.fetchMessages();
      clearInterval(this.intervalId); // 清除之前的定时器
      this.intervalId = setInterval(this.fetchMessages, 10000); // 每10秒刷新一次消息
    },
    handleGroupClick(groupId, groupName) {
      this.currentChatName = groupName;
      this.currentChatAvatar = ''; // 群组没有头像的情况下设置为空
      this.currentChatId = groupId;
      this.isFriendChat = false;
      console.log(`Group with ID ${groupId} clicked.`);
      this.fetchMessages();
      clearInterval(this.intervalId); // 清除之前的定时器
      this.intervalId = setInterval(this.fetchMessages, 10000); // 每10秒刷新一次消息
    },
    fetchFriends() {
      const userId = this.currentUserId;
      axios.get(`/api/scFriends/acceptedFriends?userId=${userId}`).then((response) => {
        if (response.data.success) {
          this.friends = response.data.data;
          if (this.friends.length > 0 && this.currentChatId === null) {
            // 默认选择第一个好友
            const firstFriend = this.friends[0];
            this.handleFriendClick(firstFriend.friendId, firstFriend.friendNickname, firstFriend.avatarUrl);
          }
        }
      });
    },
    fetchGroups() {
      const userId = this.currentUserId;
      axios.get(`/api/scGroups/userGroups?userId=${userId}`).then((response) => {
        if (response.data.success) {
          this.groups = response.data.data;
          if (this.groups.length > 0 && this.currentChatId === null) {
            // 默认选择第一个群组
            const firstGroup = this.groups[0];
            this.handleGroupClick(firstGroup.groupId, firstGroup.groupName);
          }
        }
      });
    },
    getMessageUser(message) {
      if (message.senderId === this.currentUserId) {
        return '我';
      }
      const friend = this.friends.find(f => f.friendId === message.senderId);
      return friend ? friend.friendNickname : message.senderName;
    },
    getSenderAvatar(senderId) {
      if (senderId === this.currentUserId) return this.currentChatAvatar;
      const friend = this.friends.find(f => f.friendId === senderId);
      return friend ? friend.avatarUrl : 'https://s1.imagehub.cc/images/2024/07/06/1a05e112ae8dfbd47b415c294facc655.th.png'; // 默认头像
    },
    getCookie(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2) return parts.pop().split(';').shift();
    }
  },
  mounted() {
    this.fetchFriends();
    this.fetchGroups();
  },
  beforeDestroy() {
    clearInterval(this.intervalId); // 在组件销毁前清除定时器
  },
};
</script>

<style scoped>
.chat-window {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 818px;
  background-color: #f0f2f5;
}
.chat-container {
  width: 850px;
  height: 660px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  background-color: #fff;
}
.chat-sidebar {
  background-color: #f5f5f5;
  padding: 20px;
  height: 658px;
  overflow-y: auto;
  max-height: 658px;
  margin: 0;
}
.user-info {
  text-align: center;
  margin-bottom: 20px;
}
.user-name {
  font-size: 16px;
  font-weight: bold;
}
.user-status {
  font-size: 12px;
  color: #999;
}
.friend-list,
.group-list {
  margin-top: 0px;
}
.friend-item,
.group-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
}
.friend-item span,
.group-item span {
  margin-left: 10px;
}
.chat-main {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 100%;
}
.chat-header {
  display: flex;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}
.chat-title {
  margin-left: 10px;
  font-size: 18px;
  font-weight: bold;
}
.chat-status {
  margin-left: auto;
  font-size: 14px;
  color: #999;
}
.chat-content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  max-height: 400px; /* 这里设置了最大高度 */
}
.chat-message {
  display: flex;
  align-items: flex-start;
  margin-bottom: 20px;
}
.message-content {
  margin-left: 10px;
}
.message-user {
  font-weight: bold;
}
.message-time {
  font-size: 12px;
  color: #999;
}
.message-text {
  margin-top: 5px;
}
.chat-footer {
  padding: 20px;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: space-between;
}
.footer-icons {
  display: flex;
  gap: 10px;
}
.footer-input {
  flex: 1;
  margin: 0 10px;
}
.footer-buttons {
  display: flex;
  gap: 10px;
}
.icon-button {
  padding: 0;
  background-color: transparent;
  border: none;
  outline: none;
}

.icon-button:hover,
.icon-button:focus,
.icon-button:active {
  background-color: transparent;
  border: none;
  outline: none;
}

.friend-item:hover {
  background-color: #bbbbbb;
  border-radius: 8px;
}
.group-item:hover {
  background-color: #bbbbbb;
  border-radius: 8px;
}
</style>
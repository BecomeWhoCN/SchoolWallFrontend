<template>
  <div>
    <Button type="primary" icon="ios-search" @click="showSearchDialog">搜索</Button>
    <Modal v-model="isSearchDialogVisible" title="搜索" :footer-hide="true">
      <Input v-model="searchQuery" placeholder="输入关键字进行搜索" @keyup.enter="search" />
      <Button type="primary" @click="search">搜索</Button>
      <Divider />
      <List>
        <ListItem v-for="group in groupResults" :key="group.groupId">
          <ListItemMeta
            :title="group.groupName"
            :description="group.groupDescription"
            avatar="https://s1.imagehub.cc/images/2024/07/06/1a05e112ae8dfbd47b415c294facc655.png"
          />
          <template #action>
            <li>
              <Button type="primary" @click="joinGroup(group.groupId)">申请加入</Button>
            </li>
          </template>
        </ListItem>
        <ListItem v-for="friend in friendResults" :key="friend.userId">
          <ListItemMeta
            :title="friend.userName"
            :description="friend.userDescription"
            :avatar="friend.avatarUrl"
          />
          <template #action>
            <li>
              <Button type="success" @click="addFriend(friend.userId)">添加好友</Button>
            </li>
          </template>
        </ListItem>
      </List>
    </Modal>
  </div>
</template>

<script>
import axios from 'axios';
import { Button, Modal, Input, Divider, List, ListItem, ListItemMeta, Message } from 'view-ui-plus';
import VueCookies from "js-cookie";

export default {
  components: {
    Button,
    Modal,
    Input,
    Divider,
    List,
    ListItem,
    ListItemMeta,
  },
  data() {
    return {
      isSearchDialogVisible: false,
      searchQuery: '',
      groupResults: [],
      friendResults: [],
      defaultGroupAvatar: 'https://s1.imagehub.cc/images/2024/07/06/1a05e112ae8dfbd47b415c294facc655.png',
      myUserId: null,
    };
  },
  mounted() {
    // 使用 setTimeout 确保组件完全挂载后再获取 cookie
    setTimeout(() => {
      this.myUserId = VueCookies.get('userId');
      if (!this.myUserId) {
        console.error('UserId is not defined');
        Message.error('无法获取用户ID，请确保已登录');
      }
    }, 100);
  },
  methods: {
    showSearchDialog() {
      this.isSearchDialogVisible = true;
    },
    async search() {
      try {
        const groupResponse = await axios.get(`/api/scGroups/groups`, { params: { query: this.searchQuery } });
        const friendResponse = await axios.get(`/api/scUsers/searchUsers`, { params: { query: this.searchQuery } });

        if (groupResponse.data.success) {
          this.groupResults = groupResponse.data.data;
        }

        if (friendResponse.data.success) {
          this.friendResults = friendResponse.data.data;
        }
      } catch (error) {
        console.error('搜索出错', error);
        Message.error('搜索出错');
      }
    },
    async joinGroup(groupId) {
      try {
        const response = await axios.post('/api/scGroupInvitations/inviteToGroup', { groupId });
        if (response.data.success) {
          Message.success('群组加入请求已发送');
        }
      } catch (error) {
        console.error('加入群组出错', error);
        Message.error('加入群组出错');
      }
    },
    async addFriend(userId) {
      try {
        const response = await axios.post('/api/scFriends/add', {
          friendId: userId,
          userId: this.myUserId
        }, {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        });

        if (response.data.success) {
          Message.success('好友请求已发送');
        }
      } catch (error) {
        console.error('添加好友出错', error);
        Message.error('添加好友出错');
      }
    }
  },
};
</script>

<style scoped>
/* 可根据需要添加自定义样式 */
</style>

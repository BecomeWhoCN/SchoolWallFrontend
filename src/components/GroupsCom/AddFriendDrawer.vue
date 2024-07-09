<template>
  <div>
    <Button type="primary" @click="openDrawer">添加好友</Button>
    <Drawer
      v-model:visible="visible"
      title="添加好友"
      placement="right"
      width="400"
    >
      <div>
        <Input
          v-model="searchQuery"
          placeholder="输入用户名或邮箱查找"
          style="margin-bottom: 20px;"
          @on-enter="searchUsers"
        />
        <Button type="primary" @click="searchUsers">搜索</Button>
        <div v-if="searchResults.length">
          <List>
            <ListItem v-for="user in searchResults" :key="user.userId">
              <div class="list-item-content">
                <Avatar icon="md-contact" />
                <div class="user-info">
                  <p>{{ user.username }}</p>
                  <p>{{ user.email }}</p>
                </div>
                <Button type="primary" @click="addFriend(user.userId)">添加</Button>
              </div>
            </ListItem>
          </List>
        </div>
        <div v-else>
          <p>没有找到相关用户</p>
        </div>
      </div>
    </Drawer>
  </div>
</template>

<script>
import axios from 'axios';
import { Drawer, Input, Button, List, ListItem, Avatar, Message } from 'view-ui-plus';

export default {
  components: {
    Drawer,
    Input,
    Button,
    List,
    ListItem,
    Avatar,
    Message
  },
  data() {
    return {
      visible: false,
      searchQuery: '',
      searchResults: []
    };
  },
  methods: {
    openDrawer() {
      this.visible = true;
    },
    closeDrawer() {
      this.visible = false;
    },
    searchUsers() {
      axios.get(`/api/searchUsers?query=${this.searchQuery}`).then(response => {
        if (response.data.success) {
          this.searchResults = response.data.data;
        } else {
          Message.error('搜索用户失败');
        }
      }).catch(error => {
        console.error(error);
        Message.error('搜索用户失败');
      });
    },
    addFriend(userId) {
      const currentUserId = this.getCookie('userId');
      axios.post('/api/scFriends/addFriend', new URLSearchParams({
        userId: currentUserId,
        friendId: userId
      })).then(response => {
        if (response.data.success) {
          Message.success('添加好友成功');
          this.closeDrawer();
        } else {
          Message.error('添加好友失败');
        }
      }).catch(error => {
        console.error(error);
        Message.error('添加好友失败');
      });
    },
    getCookie(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2) return parts.pop().split(';').shift();
    }
  }
};
</script>

<style scoped>
.list-item-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.user-info {
  flex-grow: 1;
  margin-left: 10px;
}
</style>
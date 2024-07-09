<template>
  <div class="event-list">
    <Poptip trigger="click" placement="bottom">
      <i-button icon="md-notifications"></i-button>
      <template v-slot:content>
        <ul class="notification-list">
          <li v-for="event in events" :key="event.friendId" class="notification-item">
            <div class="notification-content">
              <p>{{ event.friendName }} 想要添加你为好友</p>
              <small>{{ formatDate(event.createdAt) }}</small>
            </div>
            <div style="margin-left: 10px" class="notification-actions">
              <Tooltip content="同意" placement="top">
                <i-button @click="handleAccept(event.friendId)" shape="circle" icon="md-checkmark-circle-outline" type="success" size="small"></i-button>
              </Tooltip>
              <Tooltip content="屏蔽" placement="top">
                <i-button @click="handleReject(event.friendId)" shape="circle" icon="md-backspace" type="error" size="small"></i-button>
              </Tooltip>
            </div>
          </li>
        </ul>
      </template>
    </Poptip>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      events: [],
      userId: null // 假设用户ID存储在cookie中或通过其他方式获取
    };
  },
  mounted() {
    this.userId = this.getUserIdFromCookie();
    this.fetchPendingRequests();
  },
  methods: {
    getUserIdFromCookie() {
      // 获取用户ID的逻辑，例如从cookie中获取
      return document.cookie.replace(/(?:(?:^|.*;\s*)userId\s*\=\s*([^;]*).*$)|^.*$/, "$1");
    },
    fetchPendingRequests() {
      axios.get(`/api/scFriends/pendingRequests?userId=${this.userId}`)
        .then(response => {
          if (response.data.success) {
            this.events = response.data.data;
          } else {
            this.$Message.error('获取好友请求失败');
          }
        })
        .catch(error => {
          console.error(error);
          this.$Message.error('获取好友请求失败');
        });
    },
    handleAccept(friendId) {
      this.updateRequestStatus(friendId, 'accepted');
    },
    handleReject(friendId) {
      this.updateRequestStatus(friendId, 'rejected');
    },
    updateRequestStatus(friendId, status) {
      axios.post('/api/scFriends/updateRequestStatus', new URLSearchParams({
        userId: this.userId,
        friendId: friendId,
        status: status
      }))
        .then(response => {
          if (response.data.success) {
            this.$Message.success(`已${status === 'accepted' ? '同意' : '屏蔽'}  此请求`);
            this.events = this.events.filter(event => event.friendId !== friendId);
          } else {
            this.$Message.error('操作失败');
          }
        })
        .catch(error => {
          console.error(error);
          this.$Message.error('操作失败');
        });
    },
    formatDate(dateStr) {
      const date = new Date(dateStr);
      return date.toLocaleString();
    }
  }
};
</script>

<style scoped>
.notification-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.notification-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #e8e8e8;
}

.notification-content {
  flex-grow: 1;
}

.notification-actions {
  display: flex;
  gap: 10px;
}
</style>
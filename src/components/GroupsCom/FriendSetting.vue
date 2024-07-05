<template>
  <div class="event-list">
    <Poptip trigger="click" placement="bottom">
      <i-button icon="md-cog"></i-button>
      <template v-slot:content>
        <H4 style="text-align: center; margin-bottom: 5px">好友管理</H4>
        <center>
          <form @submit.prevent="handleNicknameSubmit">
            <input 
              v-model="nickname"
              class="settingUsername" 
              type="text" 
              placeholder="修改好友备注" 
              maxlength="25" 
            />
            <Tooltip content="备注应该少于25字符" placement="top">
              <button type="submit" class="settingUsernamesubmit">保存</button>
            </Tooltip>
          </form>
          <br>
          <Button @click="deleteFriend" style="margin-top: 8px" type="error" ghost>删除此好友</Button>
        </center>
      </template>
    </Poptip>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      nickname: '',
      userId: this.getCookie('userId'), // 获取当前用户ID
    };
  },
  methods: {
    getCookie(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2) return parts.pop().split(';').shift();
    },
    handleNicknameSubmit() {
      if (this.nickname.length > 25) {
        this.$Message.error('备注字符数不能超过25');
        return;
      }
      axios.post('/api/scFriends/updateNickname', new URLSearchParams({
        userId: this.userId,
        friendId: this.friendId,
        nickname: this.nickname
      })).then(response => {
        if (response.data.success) {
          this.$Message.success('好友备注修改已生效');
          location.reload();
        } else {
          this.$Message.error('备注修改失败');
        }
      }).catch(error => {
        console.error(error);
        this.$Message.error('备注修改失败');
      });
    },
    deleteFriend() {
      axios.post('/api/scFriends/deleteFriend', new URLSearchParams({
        userId: this.userId,
        friendId: this.friendId
      })).then(response => {
        if (response.data.success) {
          this.$Message.success('删除好友成功');
          location.reload();
        } else {
          this.$Message.error('删除好友失败');
        }
      }).catch(error => {
        console.error(error);
        this.$Message.error('删除好友失败');
      });
    }
  },
  props: {
    friendId: {
      type: Number,
      required: true
    }
  }
};
</script>

<style scoped>
.settingUsername {
  padding: 3px 5px;
  width: 150px;
}

.settingUsernamesubmit {
  padding: 3px 5px;
  width: 50px;
  margin-left: 5px;
  background-color: none;
}
</style>
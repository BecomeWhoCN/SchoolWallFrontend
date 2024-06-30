<template>
  <div class="header-wrapper">
    <div class="logo-container">
      <a href="/"><img src="@/assets/aresources/logo/logo_brown_bear.png" alt="Logo" class="logo" /></a>
    </div>
    <div class="user-container">
      <div v-if="!user">
        <Button type="text" @click="switchToLogin">登录</Button>
        <Button type="text" @click="switchToRegister">注册</Button>
      </div>

      <div v-else>
        <Tooltip content="打开导航抽屉">
          <Button type="text" @click="toggleDrawer">菜单</Button>
        </Tooltip>

        <Tooltip content="登出">
          <a href="/login-resource"><Button type="text" @click="logout">退出</Button></a>
        </Tooltip>
      </div>
    </div>

    <Drawer
      :width="drawerWidth"
      v-model:modelValue="drawerVisible"
      title="导航菜单"
      placement="right"
      :mask-closable="false"
    >
      <Card v-if="user" class="user-info-card" style="width:250px" bordered shadow>
        <p style="font-weight: 800; font-size: 16px">
          <Icon type="md-contact" /> 你的用户信息
        </p>
        <div class="user-info">
          <img :src="user.scUserAvatars || 'http://sfrsrdckw.hn-bkt.clouddn.com/usertximg/logo_duck_c.png'" alt="用户头像" class="user-avatar" />
          <div style="zoom:82%; margin:0px" class="user-details">
            <p><strong>用户名：</strong>{{ user.userName }}</p>
            <p><strong>邮箱：</strong>{{ user.userEmail }}</p>
            <p><strong>角色：</strong>{{ user.userRole }}</p>
            <p><strong>电话：</strong>{{ user.userPhone }}</p>
            <p><strong>性别：</strong>{{ user.userGender }}</p>
            <p><strong>在线状态：</strong>{{ user.userOnlineStatus }}</p>
          </div>
        </div>
        <Divider />
        <p style="margin-top:5px;zoom:0.82"><strong>个人留言：</strong>{{ user.userBio }}</p>
      </Card>
      <Menu mode="vertical" active-name="1-1" @on-select="handleSelect">
        <MenuItem name="1-1">
          <Icon type="md-home"></Icon>
          校园墙
        </MenuItem>
        <MenuItem name="1-2">
          <Icon type="md-people"></Icon>
          我的文章管理
        </MenuItem>
        <MenuItem name="1-3">
          <Icon type="ios-bonfire" />
          校园漂流瓶
        </MenuItem>
        <MenuItem name="1-4" style="margin-bottom: 10px">
          <Icon type="md-contacts"></Icon>
          我的群组
        </MenuItem>
        <div class="account-management-title">
          <Icon type="md-people" />&emsp;账号管理
        </div>
        <Submenu name="2" title="用户设置">
          <MenuItem name="2-1" style="margin-top: 8px">
            <Icon type="md-settings"></Icon>
            修改密码
          </MenuItem>
          <MenuItem name="2-2">
            <Icon type="md-settings"></Icon>
            修改账户信息
          </MenuItem>
          <MenuItem name="2-3">
            <Icon type="ios-sad" />
            拉黑记录
          </MenuItem>
          <MenuItem name="2-4" @click="confirmDeactivation">
            <Icon type="md-alert" />
            注销账号
          </MenuItem>
        </Submenu>
      </Menu>
    </Drawer>

    <Modal v-model="deactivationConfirmVisible" title="确认注销账号" @on-ok="showPasswordModal">
      <p>确定要注销账号吗？这将导致账号不可用。</p>
    </Modal>

    <Modal v-model="passwordModalVisible" title="输入密码" @on-ok="deactivateAccount">
      <Input v-model="password" type="password" placeholder="请输入密码" />
    </Modal>
  </div>
</template>

<script>
import {
  Button,
  Message,
  Tooltip,
  Drawer,
  Menu,
  MenuItem,
  Submenu,
  Icon,
  Card,
  Divider,
  Modal,
  Input
} from 'view-ui-plus';
import axios from 'axios';
import Cookies from 'js-cookie';

export default {
  name: 'HeaderWithSidebar',
  components: {
    Button,
    Tooltip,
    Drawer,
    Menu,
    MenuItem,
    Submenu,
    Icon,
    Card,
    Divider,
    Modal,
    Input
  },
  data() {
    return {
      user: null,
      drawerVisible: false,
      userAvatar: '/path/to/default/avatar.png', // 默认头像路径
      deactivationConfirmVisible: false,
      passwordModalVisible: false,
      password: ''
    };
  },
  computed: {
    drawerWidth() {
      return window.innerWidth < 768 ? '100%' : '300px';
    }
  },
  created() {
    this.checkUser();
    this.fetchUserData();
  },
  methods: {
    checkUser() {
      const userId = Cookies.get('userId');
      const userEmail = Cookies.get('userEmail');
      const userRole = Cookies.get('userRole');
      if (userId && userEmail && userRole) {
        this.user = {
          userId,
          userEmail,
          userRole,
        };
      }
    },
    fetchUserData() {
      const userId = Cookies.get('userId');
      if (userId) {
        axios.get(`/api/scUsers/get_scuserbyid/${userId}`)
          .then(response => {
            if (response.data.success) {
              this.user = response.data.data;
            } else {
              Message.error('无法获取用户信息');
            }
          })
          .catch(error => {
            console.error(error);
            Message.error('获取用户信息时出错');
          });
      }
    },
    switchToLogin() {
      this.$emit('switchToLogin');
      this.$router.push('/login-resource');
    },
    switchToRegister() {
      this.$emit('switchToRegister');
      this.$router.push('/login-resource');
    },
    logout() {
      Cookies.remove('userId');
      Cookies.remove('userEmail');
      Cookies.remove('userRole');
      this.user = null;
      Message.success('已退出登录');
    },
    toggleDrawer() {
      this.drawerVisible = !this.drawerVisible;
    },
    handleSelect(name) {
      if (name === '1-1') {
        this.$router.push('/');
      } else if (name === '1-2') {
        this.$router.push('/friends');
      } else if (name === '1-3') {
        this.$router.push('/drift-bottles');
      } else if (name === '1-4') {
        this.$router.push('/groups');
      } else if (name === '2-1') {
        this.$router.push('/user-settings/change-password');
      } else if (name === '2-2') {
        this.$router.push('/user-settings/update-usermessage');
      } else if (name === '2-3') {
        this.$router.push('/user-settings/account-management');
      } else if (name === '2-4') {
        this.confirmDeactivation();
      }
    },
    confirmDeactivation() {
      this.deactivationConfirmVisible = true;
    },
    showPasswordModal() {
      this.deactivationConfirmVisible = false;
      this.passwordModalVisible = true;
    },
    async deactivateAccount() {
      const userId = Cookies.get('userId');
      try {
        const formData = new FormData();
        formData.append('id', userId);
        formData.append('userPasswd', this.password);

        const response = await axios.post('/api/scUsers/update_userStatus', formData);

        if (response.data.success) {
          Message.success('正在执行删除用户操作');
          // 将cookies改为null
          Cookies.remove('userId');
          Cookies.remove('userEmail');
          Cookies.remove('userRole');
          // 删除用户信息
          this.user = null;
          // 跳转到登录页面
          this.$router.push('/login-resource');
          Message.success('用户已登出 跳转至首页');

          this.user = null;
          // 关闭侧边栏
          this.drawerVisible = false;
        } else {
          Message.error(response.data.message || '用户状态修改失败');
        }
      } catch (error) {
        console.error('修改用户状态出错:', error);
        Message.error('修改用户状态出错，请稍后再试');
      } finally {
        this.passwordModalVisible = false;
        this.password = '';
      }
    }
  }
};
</script>

<style scoped>
.header-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  background-color: #f5f3f3;
  border-bottom: 1px solid #ddd;
  color: black;
  font-weight: 600;
}

.logo-container {
  flex: 1;
}

.logo {
  height: 40px;
}

.user-container {
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.username {
  margin-right: 15px;
}

.user-info {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.user-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 15px;
}

.user-details {
  display: flex;
  flex-direction: column;
}

.user-info-card {
  margin-bottom: 20px;
}

.account-management-title {
  padding: 0px;
  font-size: 16px;
  color: #333;
  text-align: left;
  margin-bottom: -25px; /* 调整间距，确保视觉效果符合设计 */
  margin-left: 27px;
  font-size: 14px;
}

.ivu-divider {
  margin: 0px;
}
</style>
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

        <Tooltip content="退出登录状态">
          <Button type="text" @click="logout">退出</Button>
        </Tooltip>
      </div>
    </div>

    <Drawer
      :width="drawerWidth"
      v-model:modelValue="drawerVisible"
      title="用户菜单"
      placement="right"
      :mask-closable="false"
    >
      <p>你的用户信息</p>
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
          <Icon type="md-bottle"></Icon>
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
          <MenuItem name="2-4">
            <Icon type="md-alert" />
            注销账号
          </MenuItem>
        </Submenu>
      </Menu>
    </Drawer>
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
} from 'view-ui-plus';
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
  },
  data() {
    return {
      user: null,
      drawerVisible: false,
    };
  },
  computed: {
    drawerWidth() {
      return window.innerWidth < 768 ? '100%' : '300px';
    }
  },
  created() {
    this.checkUser();
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
        this.$router.push('/unfinished-pages');
      } else if (name === '1-2') {
        this.$router.push('/friends');
      } else if (name === '1-3') {
        this.$router.push('/drift-bottles');
      } else if (name === '1-4') {
        this.$router.push('/groups');
      } else if (name === '2-1') {
        this.$router.push('/change-password');
      } else if (name === '2-2') {
        this.$router.push('/update-profile');
      }
    },
  },
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

.account-management-title {
  padding: 0px;
  font-size: 16px;
  color: #333;
  text-align: left;
  margin-bottom: -25px; /* 调整间距，确保视觉效果符合设计 */
  margin-left: 27px;
  font-size: 14px;
}
</style>
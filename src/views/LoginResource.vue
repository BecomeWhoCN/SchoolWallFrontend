<template>
  <Row>
    <Col :xs="0" :md="14">
      <div class="background-image"></div>
    </Col>
    <Col :xs="24" :md="10">
      <!-- 页面切换 -->
      <div v-if="isLoginPage">
        <LoginCom @switchToRegister="switchToRegister" @switchToLostPasswd="switchToLostPasswd"/>
      </div>
      <!-- 忘记密码页面 -->
      <div v-if="isLostPassword">
        <LostPassword @switchToLogin="switchToLogin"/>
      </div>
      <!-- 注册页面 -->
      <div v-else-if="!isLoginPage && !isLostPassword">
        <ResourceCom @switchToLogin="switchToLogin" />
      </div>
    </Col>
  </Row>
</template>

<script>
import { Row, Col } from 'view-ui-plus'
import LoginCom from '@/components/LoginResource/LoginCom.vue'
import ResourceCom from '@/components/LoginResource/ResourceCom.vue'
import LostPassword from '@/components/LoginResource/LostPasswd.vue'

export default {
  components: {
    Row,
    Col,
    LoginCom,
    ResourceCom,
    LostPassword
  },
  data() {
    return {
      isLoginPage: true,
      isLostPassword: false
    }
  },
  methods: {
    switchToRegister() {
      this.isLoginPage = false;
      this.isLostPassword = false;
    },
    switchToLogin() {
      this.isLoginPage = true;
      this.isLostPassword = false;
    },
    switchToLostPasswd() {
      this.isLoginPage = false;
      this.isLostPassword = true;
    }
  }
}
</script>

<style scoped>
.background-image {
  background-image: url('@/assets/background/background_grazingland.jpg');
  background-size: cover;
  background-position: left center; /* 设置背景图片从左边开始显示 */
  height: 100vh; /* 设置高度为视口的高度 */
}
</style>

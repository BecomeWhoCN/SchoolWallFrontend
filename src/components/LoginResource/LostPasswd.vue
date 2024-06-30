<template>
  <div class="lost-password-form-wrapper">
    <a href="/"><Button class="backhome" shape="circle"><Icon type="md-home" /> 回到首页</Button></a>
    <div class="lost-password-form-container">
      <img src="@/assets/aresources/logo/logo_brown_bear.png" alt="Logo" class="logo" />
      <div>
        <h1 class="titleh1">找回密码</h1>
        <p class="titlep">请输入你的邮箱和手机号作为辅助我们识别你的手段</p>
      </div>
      <Form ref="form" :model="form" @submit.prevent="handleSubmit" class="lost-password-form">
        <FormItem prop="email">
          <Input size="large" v-model="form.email" placeholder="注册邮箱地址" />
        </FormItem>
        <FormItem prop="phone">
          <Input size="large" v-model="form.phone" placeholder="注册手机号" />
        </FormItem>
        <FormItem prop="newPasswd">
          <Input size="large" type="password" v-model="form.newPasswd" placeholder="新的密码" />
        </FormItem>
        <FormItem>
          <Button type="primary" size="large" long @click="handleSubmit">发送密码重置请求</Button>
        </FormItem>
      </Form>
      <p class="back-to-login"><a href="#" @click.prevent="switchToLogin">返回登录</a></p>
    </div>
  </div>
</template>

<script>
import { Form, FormItem, Input, Button, Message } from 'view-ui-plus';
import axios from 'axios';
import router from '@/router';

export default {
  name: 'LostPassword',
  components: {
    Form,
    FormItem,
    Input,
    Button
  },
  data() {
    return {
      form: {
        email: '',
        phone: '',
        newPasswd: ''
      }
    };
  },
  methods: {
    async handleSubmit() {
      if (!this.validateEmail(this.form.email)) {
        Message.error('请输入有效的邮箱地址');
        return;
      }
      if (!this.validatePhone(this.form.phone)) {
        Message.error('请输入有效的手机号');
        return;
      }
      if (!this.validatePassword(this.form.newPasswd)) {
        Message.error('密码必须大于6位并且至少包含一个非数字字符');
        return;
      }

      const formData = new FormData();
      formData.append('email', this.form.email);
      formData.append('phone', this.form.phone);
      formData.append('newPasswd', this.form.newPasswd);

      try {
        const response = await axios.post('/api/scUsers/update_lostPasswd', formData);
        if (response.data.success) {
          Message.success('密码更新成功');
          this.switchToLogin();
          // 跳转到首页页面
          router.push('/login-resource');
        } else {
          Message.error(response.data.message || '密码更新失败');
        }
      } catch (error) {
        Message.error('密码更新失败，请稍后再试');
      }
    },
    validateEmail(email) {
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return re.test(email);
    },
    validatePhone(phone) {
      const re = /^1[3-9]\d{9}$/;
      return re.test(phone);
    },
    validatePassword(password) {
      const re = /^(?=.*[^0-9])[A-Za-z\d!@#$%^&*()_+]{7,}$/;
      return re.test(password);
    },
    switchToLogin() {
      this.$emit('switchToLogin');
    }
  }
};
</script>

<style scoped>
.lost-password-form-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100%;
}

.lost-password-form-container {
  width: 100%;
  max-width: 500px;
  padding: 40px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.logo {
  zoom: 0.5;
  margin-bottom: 40px;
}

.lost-password-form {
  width: 100%;
}

.titleh1, .titlep {
  font-size: 1.5rem;
  margin-bottom: 10px;
  text-align: center;
}

.titlep {
  font-size: 1rem;
  margin-top: -10px;
}

.back-to-login {
  font-size: 0.9rem;
  margin-top: 15px;
  text-align: center;
}

.backhome {
  position: fixed;
  top:40px;
  left: 40px;
  border-width: 2px;
  zoom: 110%;
}
</style>

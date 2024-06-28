<template>
  <div class="login-form-wrapper">
    <div class="login-form-container">
      <img src="@/assets/aresources/logo/logo_brown_bear.png" alt="Logo" class="logo" />
      <div>
        <h1 class="titleh1">欢迎回来，登录你的校园墙</h1>
        <p class="titlep">你知道吗？校园墙其实是一个大农场</p>
      </div>
      <Form ref="form" :model="form" @submit.prevent="handleSubmit" class="login-form">
        <FormItem prop="emailOrPhone">
          <Input size="large" v-model="form.emailOrPhone" placeholder="邮箱" />
        </FormItem>
        <FormItem prop="password">
          <Input size="large" type="password" v-model="form.password" placeholder="密码" />
        </FormItem>
        <FormItem class="checkbox-item">
          <Checkbox v-model="form.rememberMe">记住登录</Checkbox>
        </FormItem>
        <FormItem>
          <Button type="primary" size="large" long @click="handleSubmit">登录</Button>
        </FormItem>
        <p class="policy">登录即同意我们的<a href="/policy">服务政策</a></p>
      </Form>
      <p class="register">没有账号？<a href="#" @click.prevent="switchToRegister">快来注册</a></p>
      <p class="register" style="margin-top: -3px">忘记密码？<a href="#" @click.prevent="switchToLostPasswd">点击找回</a></p>
    </div>
  </div>
</template>

<script>
import { Form, FormItem, Input, Checkbox, Button, Message } from 'view-ui-plus';
import axios from 'axios';
import Cookies from 'js-cookie';

export default {
  name: 'LoginCom',
  components: {
    Form,
    FormItem,
    Input,
    Checkbox,
    Button
  },
  data() {
    return {
      form: {
        emailOrPhone: '',
        password: '',
        rememberMe: false
      }
    };
  },
  methods: {
    async handleSubmit() {
      const formData = new FormData();
      formData.append('email', this.form.emailOrPhone);
      formData.append('password', this.form.password);

      try {
        const response = await axios.post('/api/scUsers/getLonginValue', formData);
        if (response.data.success) {
          Message.success('用户登录成功');
          
          const { userId, userEmail, userRole } = response.data.data;
          const cookieOptions = this.form.rememberMe
            ? { expires: 7 }
            : {};

          Cookies.set('userId', userId, cookieOptions);
          Cookies.set('userEmail', userEmail, cookieOptions);
          Cookies.set('userRole', userRole, cookieOptions);

          // 登陆成功条跳转首页
          this.$router.push('/');

        } else {
          Message.error(response.data.message || '登录失败');
        }
      } catch (error) {
        Message.error('登录失败，请稍后再试');
      }
    },
    switchToRegister() {
      this.$emit('switchToRegister');
    },
    switchToLostPasswd() {
      this.$emit('switchToLostPasswd');
    }
  }
};
</script>

<style scoped>
.login-form-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100%;
}

.login-form-container {
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

.login-form {
  width: 100%;
}

.policy {
  font-size: 0.85rem;
  margin-top: -15px;
  text-align: center;
}

.register {
  font-size: 0.9rem;
  margin-top: 15px;
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
</style>
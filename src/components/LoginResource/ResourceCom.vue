<template>
  <div class="register-form-wrapper">
    <a href="/"><Button class="backhome" shape="circle"><Icon type="md-home" /> 回到首页</Button></a>
    <div class="register-form-container">
      <img src="@/assets/aresources/logo/logo_brown_bear.png" alt="Logo" class="logo" />
      <div>
        <h1 class="titleh1">欢迎来到校园墙，注册你的账户</h1>
        <p class="titlep">校园墙是你的大农场，一起来吧！</p>
      </div>
      <Form ref="form" :model="form" @submit.prevent="handleSubmit" class="register-form">
        <FormItem prop="username">
          <Input size="large" v-model="form.username" placeholder="用户名" />
        </FormItem>
        <FormItem prop="email">
          <Input size="large" v-model="form.email" placeholder="邮箱" />
        </FormItem>
        <FormItem prop="phone">
          <Input size="large" v-model="form.phone" placeholder="手机号" />
        </FormItem>
        <FormItem prop="password">
          <Input size="large" type="password" v-model="form.password" placeholder="密码" />
        </FormItem>
        <FormItem prop="confirmPassword">
          <Input size="large" type="password" v-model="form.confirmPassword" placeholder="确认密码" />
        </FormItem>
        <FormItem class="checkbox-item">
          <Checkbox v-model="form.agreePolicy">同意服务政策</Checkbox>
        </FormItem>
        <FormItem>
          <Button type="primary" size="large" long @click="handleSubmit">注册</Button>
        </FormItem>
        <p class="policy">查看 <a href="/policy">服务政策</a></p>
      </Form>
      <p class="login">已有账号？<a href="#" @click.prevent="switchToLogin">立即登录</a></p>
    </div>
  </div>
</template>

<script>
import { Form, FormItem, Input, Checkbox, Button, Message } from 'view-ui-plus';
import axios from 'axios';
import { apiAddress } from '@/router/index.js';

export default {
  name: 'ResourceCom',
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
        username: '',
        email: '',
        phone: '',
        password: '',
        confirmPassword: '',
        agreePolicy: false
      },
      api_address: apiAddress + 'api/scUsers/create_scuser'
    };
  },
  methods: {
    async handleSubmit() {
      if (!this.validateUsername(this.form.username)) {
        Message.error('用户名必须大于4位,小于20位支持中文');
        return;
      }
      if (!this.validateEmail(this.form.email)) {
        Message.error('请输入有效的邮箱地址');
        return;
      }
      if (!this.validatePhone(this.form.phone)) {
        Message.error('请输入有效的手机号');
        return;
      }
      if (!this.validatePassword(this.form.password)) {
        Message.error('密码要大于6位小于25位 并且至少包含一个非数字字符');
        return;
      }
      if (this.form.password !== this.form.confirmPassword) {
        Message.error('密码和确认密码不一致');
        return;
      }
      if (!this.form.agreePolicy) {
        Message.error('请同意服务政策');
        return;
      }

      try {
        const response = await axios.post(this.api_address, {
          userName: this.form.username,
          userEmail: this.form.email,
          userPasswordHash: this.form.password,
          userPhone: this.form.phone
        });
        if (response.data.success) {
          Message.success('注册成功');
          this.switchToLogin();
        } else {
          Message.error(response.data.message || '注册失败');
        }
      } catch (error) {
        Message.error('注册失败，请稍后再试');
      }
    },
    validateUsername(username) {
      const re = /^[\u4e00-\u9fa5a-zA-Z0-9_-]{4,20}$/;
      return re.test(username);
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
      const re = /^(?=.*[^0-9])[A-Za-z\d!@#$%^&*()_+]{7,25}$/;
      return re.test(password);
    },
    switchToLogin() {
      this.$emit('switchToLogin');
    }
  }
};
</script>

<style scoped>
.register-form-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100%;
}

.register-form-container {
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

.register-form {
  width: 100%;
}

.policy {
  font-size: 0.85rem;
  margin-top: -15px;
  text-align: center;
}

.login {
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

.backhome {
  position: fixed;
  top:40px;
  left: 40px;
  border-width: 2px;
  zoom: 110%;
}
</style>

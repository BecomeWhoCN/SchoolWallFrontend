<template>
    <div class="register-form-wrapper">
      <div class="register-form-container">
        <img src="@/assets/aresources/logo/logo_brown_bear.png" alt="Logo" class="logo" />
        <div>
          <h1 class="titleh1">欢迎来到校园墙，注册你的账户</h1>
          <p class="titlep">校园墙是你的大农场，一起来吧！</p>
        </div>
        <Form ref="form" :model="form" @submit.prevent="handleSubmit" class="register-form">
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
          <p class="policy">注册即同意我们的<a href="/policy">服务政策</a></p>
        </Form>
        <p class="login">已有账号？<a href="#" @click.prevent="switchToLogin">立即登录</a></p>
      </div>
    </div>
  </template>

<script>
import { Form, FormItem, Input, Checkbox, Button } from 'view-ui-plus';

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
        email: '',
        phone: '',
        password: '',
        confirmPassword: '',
        agreePolicy: false
      }
    };
  },
  methods: {
    handleSubmit() {
      if (this.form.password !== this.form.confirmPassword) {
        this.$Message.error('密码和确认密码不一致');
        return;
      }
      if (!this.form.agreePolicy) {
        this.$Message.error('请同意服务政策');
        return;
      }
      // 提交注册表单逻辑
      console.log('表单提交:', this.form);
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
</style>

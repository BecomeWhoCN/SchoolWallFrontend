<template>
  <PageHead />

  <div class="change-password-wrapper">
    <a href="/"><Button class="backhome" shape="circle"><Icon type="md-home" /> 回到首页</Button></a>
    <img src="@/assets/background/background_grazingland.jpg" alt="背景图" class="background-image" />
    <Card class="form-card">
      <img class="jixiangwu" src="@/assets/aresources/logo/logo_sheep.png">
      <h2>修改密码</h2>
      <Form :model="form" :rules="rules" ref="changePasswordForm">
        <FormItem label="原密码" prop="oldPassword">
          <Input v-model="form.oldPassword" type="password" placeholder="请输入原密码" />
        </FormItem>
        <FormItem label="新密码" prop="newPassword">
          <Input v-model="form.newPassword" type="password" placeholder="请输入新密码" />
        </FormItem>
        <FormItem label="确认密码" prop="confirmPassword">
          <Input v-model="form.confirmPassword" type="password" placeholder="请确认新密码" />
        </FormItem>
        <FormItem>
          <Button style="padding:0px 123px; margin-top: 15px" type="primary" @click="handleSubmit">提交</Button>
        </FormItem>
      </Form>

      <a href="/"><p>返回上一页</p></a>
    </Card>
  </div>

  <PageFoot />
</template>

<script>
import axios from 'axios';
import Cookies from 'js-cookie';
import PageHead from '@/components/aresources/PageHead.vue'
import PageFoot from '@/components/aresources/PageFoot.vue'


export default {
  components: {
        PageHead,
        PageFoot,
    },
  data() {
    return {
      form: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: '',
      },
      rules: {
        oldPassword: [
          { required: true, message: '请输入原密码', trigger: 'blur' },
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于6位', trigger: 'blur' },
          { max: 25, message: '密码长度不能超过25位', trigger: 'blur' },
          { pattern: /^(?=.*[^0-9])[A-Za-z\d!@#$%^&*()_+]{7,25}$/, message: '密码必须包含至少一个非数字字符', trigger: 'blur' },
          { validator: this.validateNewPassword, trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认新密码', trigger: 'blur' },
          { validator: this.validateConfirmPassword, trigger: 'blur' },
        ],
      },
    };
  },
  methods: {
    handleSubmit() {
      this.$refs.changePasswordForm.validate(valid => {
        if (valid) {
          this.submitForm();
        }
      });
    },
    validateNewPassword(rule, value, callback) {
      if (value === this.form.oldPassword) {
        callback(new Error('新密码不能与旧密码相同'));
      } else {
        callback();
      }
    },
    validateConfirmPassword(rule, value, callback) {
      if (value !== this.form.newPassword) {
        callback(new Error('两次输入的密码不一致'));
      } else {
        callback();
      }
    },
    async submitForm() {
      try {
        const userId = Cookies.get('userId');
        const formData = new FormData();
        formData.append('id', userId);
        formData.append('oldPasswd', this.form.oldPassword);
        formData.append('newPasswd', this.form.newPassword);

        const response = await axios.post('/api/scUsers/update_UserPassword', formData);

        if (response.data.success) {
          this.$Message.success('密码修改成功');
          // 返回主页页面
          this.$router.push('/');
        } else {
          this.$Message.error(response.data.message || '密码修改失败');
        }
      } catch (error) {
        console.error('修改密码出错:', error);
        this.$Message.error('修改密码出错，请稍后再试');
      }
    },
  },
};
</script>

<style scoped>
.change-password-wrapper {
  position: relative;
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgba(0, 0, 0, 0.5);
}

.background-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  z-index: -1;
}

.form-card {
  width: 350px;
  padding: 20px;
  background-color: rgba(255, 255, 255, 0.9);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

h2 {
  text-align: center;
  margin-bottom: 20px;
}

.ivu-form-item {
  margin-bottom: 15px;
}

.jixiangwu {
    margin-left: 320px;
    zoom: 30%;
}

.backhome {
  position: absolute;
  top: 20px;
  left: 40px;
  border-width: 2px;
  zoom: 110%;
}
</style>

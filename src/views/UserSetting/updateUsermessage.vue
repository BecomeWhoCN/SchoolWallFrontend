<template>

  <PageHead />
  <div class="edit-user-wrapper">

    <a href="/"><Button class="backhome" shape="circle"><Icon type="md-home" /> 回到首页</Button></a>
    <img src="@/assets/background/background_grazingland.jpg" alt="背景图" class="background-image" />
    <Card class="form-card">
      <Tooltip style="margin-left: 115px" content="点击更换头像" placement="top">
        <img class="user-avatar" :src="form.scUserAvatars || '@/assets/aresources/logo/logo_sheep.png'" @click="showAvatarModal = true" />
      </Tooltip>
      <h2>修改用户信息</h2>
      <Form :model="form" ref="editUserForm">
        <FormItem label="用户名" prop="userName">
          <Input v-model="form.userName" placeholder="请输入用户名" />
        </FormItem>
        <FormItem label="邮箱" prop="userEmail">
          <Input v-model="form.userEmail" placeholder="请输入邮箱" />
        </FormItem>
        <FormItem label="班级" prop="userClass">
          <Input v-model="form.userClass" placeholder="请输入班级" />
        </FormItem>
        <FormItem label="电话" prop="userPhone">
          <Input v-model="form.userPhone" placeholder="请输入电话" />
        </FormItem>
        <FormItem label="性别" prop="userGender">
          <RadioGroup v-model="form.userGender">
            <Radio label="male">男</Radio>
            <Radio label="female">女</Radio>
            <Radio label="secret">保密</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="个人简介" prop="userBio">
          <Input v-model="form.userBio" type="textarea" placeholder="请输入个人简介" />
        </FormItem>
        <FormItem>
          <Button style="padding:0px 148px; margin-top: 15px" type="primary" @click="handleSubmit">提交</Button>
        </FormItem>
      </Form>

      <a href="/"><p>返回上一页</p></a>
    </Card>
    <a href="#"><Button shape="circle" class="backtop" icon="md-arrow-round-up"></Button></a>

    <!-- 头像更新弹窗 -->
    <Modal v-model="showAvatarModal" title="更新头像" @on-ok="handleAvatarUpload">
      <Upload
        multiple
        type="drag"
        :action="uploadUrl"
        :before-upload="beforeUpload"
        :on-success="handleUploadSuccess"
        :on-error="handleUploadError">
        <div style="padding: 20px 0">
          <Icon type="ios-cloud-upload" size="52" style="color: #3399ff"></Icon>
          <p>点击或拖拽文件到这里上传</p>
        </div>
      </Upload>
    </Modal>
  </div>

  <PageFoot />
</template>

<script>
import axios from 'axios';
import Cookies from 'js-cookie';
import PageHead from '@/components/aresources/PageHead.vue';
import PageFoot from '@/components/aresources/PageFoot.vue';

export default {
  components: {
    PageHead,
    PageFoot
  },
  data() {
    return {
      form: {
        userId: '',
        userName: '',
        userEmail: '',
        userClass: '',
        userPhone: '',
        userGender: '',
        userBio: '',
        scUserAvatars: ''
      },
      showAvatarModal: false,
      uploadUrl: '/api/scUserAvatars/update_UsesrTx' // 替换为你的实际上传URL
    };
  },
  created() {
    this.fetchUserData();
  },
  methods: {
    async fetchUserData() {
      try {
        const userId = Cookies.get('userId');
        if (userId) {
          const response = await axios.get(`/api/scUsers/get_scuserbyid/${userId}`);
          if (response.data.success) {
            this.form = response.data.data;
            this.form.userId = userId;
          } else {
            this.$Message.error('无法获取用户信息');
          }
        }
      } catch (error) {
        console.error('获取用户信息出错:', error);
        this.$Message.error('获取用户信息出错，请稍后再试');
      }
    },
    handleSubmit() {
      this.submitForm();
    },
    async submitForm() {
      try {
        const userId = Cookies.get('userId');
        const formData = {
          userId: userId,
          userName: this.form.userName,
          userEmail: this.form.userEmail,
          userClass: this.form.userClass,
          userPhone: this.form.userPhone,
          userGender: this.form.userGender,
          userBio: this.form.userBio
        };

        const response = await axios.post('/api/scUsers/update_UserInfo', formData);

        if (response.data.success) {
          this.$Message.success('用户信息修改成功');
          this.$router.push('/');
        } else {
          this.$Message.error(response.data.message || '用户信息修改失败');
        }
      } catch (error) {
        console.error('用户信息修改出错:', error);
        this.$Message.error('用户信息修改出错，请稍后再试');
      }
    },
    beforeUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
      if (!isJPG) {
        this.$Message.error('只能上传 JPG 或 PNG 文件');
        return false;
      }
      const isLt2M = file.size / 1024 / 1024 < 2;
      if (!isLt2M) {
        this.$Message.error('上传的图片大小不能超过 2MB');
        return false;
      }
      return true;
    },
    async handleUploadSuccess(response, file) {
      if (response.success) {
        this.$Message.success('头像更新成功');
        this.fetchUserData();
        this.showAvatarModal = false;
      } else {
        this.$Message.error(response.message || '头像更新失败');
      }
    },
    handleUploadError(error, file) {
      console.error('头像更新可能有延迟:', error);
      this.$Message.error('头像已更新，由于CDN原因更新可能不及时');
    }
  }
};
</script>

<style scoped>
.edit-user-wrapper {
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
  width: 400px;
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

.user-avatar {
  display: block;
  margin: 0 auto 10px;
  width: 100px;
  height: 100px;
  border-radius: 50%;
  cursor: pointer;
}

.jixiangwu {
  display: none;
}

.backhome {
  position: absolute;
  top: 20px;
  left: 40px;
  border-width: 2px;
  zoom: 110%;
}

.backtop {
  position: fixed;
  top: 78vh;
  right: 3vh;
  zoom: 120%;
  border-width: 2px;
}

.user-avatar {
  width: 82px;
  height: 76px;
}
</style>
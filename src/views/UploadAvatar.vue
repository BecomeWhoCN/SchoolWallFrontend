<template>
  <div class="upload-avatar">
    <h2>上传头像</h2>
    <input type="file" @change="onFileChange" />
    <button @click="uploadFile">上传</button>
    <div v-if="message" class="message">{{ message }}</div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      selectedFile: null,
      message: ''
    };
  },
  methods: {
    onFileChange(event) {
      this.selectedFile = event.target.files[0];
    },
    async uploadFile() {
      if (!this.selectedFile) {
        this.message = '请选择一个文件';
        return;
      }

      const formData = new FormData();
      formData.append('file', this.selectedFile);
      formData.append('id', 3); // 假设用户ID为1，实际使用时需要动态获取
      formData.append('storagePath', '/useravatars'); // 指定存储路径

      try {
        const response = await axios.post('/api/scUserAvatars/update_UsesrTx', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        });
        if (response.data.success) {
          this.message = '上传成功';
        } else {
          this.message = `上传失败: ${response.data.message}`;
        }
      } catch (error) {
        this.message = `上传失败: ${error.message}`;
      }
    }
  }
};
</script>

<style scoped>
.upload-avatar {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.message {
  margin-top: 20px;
  color: red;
}
</style>

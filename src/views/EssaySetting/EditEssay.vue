<template>
  <Header/>
  <div class="editor-container">
    <Card class="Card" title="">
      <h1>文章编辑器beta</h1>
      
      <Row :gutter="16" style="margin-top: 5px">
        <Col :md="10" :xs="24" style="text-align: center">
            <span>文章标题：</span>
            <Input v-model="title" placeholder="文章标题必填 不能大于30字" maxlength="30" show-word-limit style="width: 300px;" />
        </Col>

        <Col :md="4" :xs="24" style="text-align: center">
          <Upload :show-upload-list="false" 
                  :before-upload="handleUpload">
            <Button type="info" icon="ios-cloud-upload-outline">上传文章头图</Button>
          </Upload>
        </Col>

        <Col :md="10" :xs="24" style="text-align: center">
            <div>
                <span>文章概要：</span>
                <Input v-model="summary" placeholder="这里写文章的摘要，非必填，字数不能超过150字" maxlength="150" show-word-limit style="width: 300px;" />
            </div>
        </Col>
      </Row>

      <!-- 反向显示文章 -->
      <div style="height: 600px" ref="vditor" class="vditor"></div>
    
      <div style="margin-top: 15px">
        <Button style="margin-right: 15px" type="primary" @click="saveDraft">保存草稿</Button>
        <Button type="success" @click="releasearticle">发布文章</Button>
      </div>

      <Alert style="margin-top: 20px" type="warning">目前此编辑器页面是一个beta版本，其中已知的问题有，图片因为没
        有采用MongeDB数据库存储，而且也懒得做优化导致功能是正常的，图片强制使用bese64方式强
        制压缩导致您添加图片的时候编辑图片可能会出现压缩乱码并不影响使用但是对图片的编辑性较差，
        您可以上传图床以链接模式渲染可以解决。<br>再一个文件比较大，如果内容较多反序列化加载过程可能需要一定时间请见谅 </Alert>
    </Card>

    <Modal
        v-model="modal"
        title="你正在强行操作返回上一页"
        @on-ok="yes"
        @on-cancel="no">
        <p>你正在强行操作返回上一页，你确定要退出吗？未保存的进度将会丢失！你如果不想要发布您可以保存在草稿箱中</p>
    </Modal>

    <Tooltip style="zoom:0.8;top:100px" class="backhome" content="强制回到上一页" placement="top-start">
      <Button style="zoom:1.5" @click="modal = true" shape="circle" icon="md-backspace"></Button>
    </Tooltip>
  </div>
  <Footer/>
</template>

<script>
import Vditor from 'vditor';
import 'vditor/dist/index.css';
import Header from '@/components/aresources/PageHead.vue';
import Footer from '@/components/aresources/PageFoot.vue';
import Cookies from 'js-cookie';
import axios from 'axios';

export default {
  name: 'ArticleEditor',
  components: {
    Header,
    Footer,
  },
  data() {
    return {
      vditorInstance: null,
      modal: false,
      title: '',
      summary: '',
      imageFile: null,      // 上传的图片文件对象
      postContentUrl: '', // 文章内容的URL
      postId: 0,
      postCreatedAt: '',
      postUpdatedAt: '',
      postStatus: '',
      postHeaderImageUrl: '',
    };
  },
  mounted() {
    const { postId, postTitle, postSummary, postCreatedAt, postUpdatedAt, postStatus, postContentUrl, postHeaderImageUrl } = this.$route.params;
    if (postId) {
      this.postId = postId;
    }
    this.title = postTitle;
    this.summary = postSummary;
    this.postCreatedAt = postCreatedAt;
    this.postUpdatedAt = postUpdatedAt;
    this.postStatus = postStatus;
    this.postContentUrl = postContentUrl;
    this.postHeaderImageUrl = postHeaderImageUrl;
    
    this.vditorInstance = new Vditor(this.$refs.vditor, {
      height: 720,
      width: '100%',
      value: null,
      toolbarConfig: {
        pin: true,
      },
      cache: {
        enable: false,
      },
      counter: {
        enable: true,
      },
      hint: {
        emojiPath: 'https://cdn.jsdelivr.net/npm/vditor@3.8.11/dist/images/emoji',
      },
      tab: '\t',
      upload: {
        accept: 'image/*',
        handler: this.handleImageUpload,
      },
      after: () => {
        console.log('Vditor ready');
        if (postContentUrl) {
          this.loadPostContent(postContentUrl);
        }
      }
    });
  },
  methods: {
    handleUpload(file) {
      this.toBase64(file).then((base64) => {
        // 将选择的图片文件存储到imageFile中
        this.imageFile = file;
      }).catch((error) => {
        console.error("图片转化失败: ", error);
      });
      return false; // 阻止默认的上传行为
    },
    toBase64(file) { 
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result.split(',')[1]);
        reader.onerror = (error) => reject(error);
      });
    },
    handleImageUpload(files) {
      const file = files[0];
      this.toBase64(file).then((base64) => {
        const markdownImage = `![${file.name}](data:image/png;base64,${base64})`;
        this.vditorInstance.insertValue(markdownImage);
      }).catch((error) => {
        console.error("Base64 conversion error: ", error);
      });
    },
    yes() {
      this.$router.push('/manage-essay');
    },
    no() {
      this.modal = false;
    },
    saveDraft() {
      const userId = Cookies.get('userId');
      const title = this.title;
      const summary = this.summary;
      const editorContent = this.vditorInstance.getValue();
      const imageFile = this.imageFile;
      const postContentUrl = this.postContentUrl;
      const postHeaderImageUrl = this.postHeaderImageUrl;
      const editorContentBlob = new Blob([editorContent], { type: 'text/markdown' });
      const formData = new FormData();
      const postId = this.postId;
      formData.append('postHeaderImageUrl', postHeaderImageUrl);
      formData.append('postContentUrl', postContentUrl);
      formData.append('postId', postId);
      formData.append('userId', userId);
      formData.append('postTitle', title);
      formData.append('postSummary', summary);
      formData.append('editorContent', editorContentBlob, 'content.md');
      formData.append('imageFile', imageFile);
      axios.post('/api/scPosts/saveDraft', formData)
      .then(response => {
        if (response.data.success == true) {  
          this.$Message.success(postId ? '修改草稿保存成功' : '草稿保存成功');
          this.$router.push('/manage-essay');
        } else {
          console.log("出现问题");
        }
      })
      .catch(error => {
        console.error('操作失败:', error);
        this.$Message.error('操作失败');
      });
    },
    releasearticle() {
      const userId = Cookies.get('userId');
      const title = this.title;
      const summary = this.summary;
      const editorContent = this.vditorInstance.getValue();
      const imageFile = this.imageFile;
      const postContentUrl = this.postContentUrl;
      const postHeaderImageUrl = this.postHeaderImageUrl;
      const editorContentBlob = new Blob([editorContent], { type: 'text/markdown' });
      const formData = new FormData();
      const postId = this.postId;
      formData.append('postHeaderImageUrl', postHeaderImageUrl);
      formData.append('postContentUrl', postContentUrl);
      formData.append('postId', postId);
      formData.append('userId', userId);
      formData.append('postTitle', title);
      formData.append('postSummary', summary);
      formData.append('editorContent', editorContentBlob, 'content.md');
      formData.append('imageFile', imageFile);
      axios.post('/api/scPosts/saveArticle', formData)
      .then(response => {
        if (response.data.success == true) {  
          this.$Message.success(postId ? '修改文章发布成功' : '文章发布成功');
          this.$router.push('/manage-essay');
        } else {
          console.log("出现问题");
        }
      })
      .catch(error => {
        console.error('操作失败:', error);
        this.$Message.error('操作失败');
      });
    },
    loadPostContent(dataUrl) {
      axios.get(dataUrl)
        .then(response => {
          console.log(response.data + '看俺');
          this.vditorInstance.setValue(response.data);
        })
        .catch(error => {
          console.error('文档获取失败', error);
        });
    }
  }
};
</script>

<style scoped>
.backhome{
  position: fixed;
  left: 20px;
}
.editor-container {
  padding: 20px;
}
.Card {
  margin: 20px auto;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.vditor {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  overflow: hidden;
}
</style>
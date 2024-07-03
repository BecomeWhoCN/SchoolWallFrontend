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
          <Upload :show-upload-list="false" :before-upload="handleUpload">
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

      <div style="height: 600px" ref="vditor" class="vditor"></div>
    
      <div style="margin-top: 15px">
        <Button style="margin-right: 15px" type="primary">保存草稿</Button>
        <Button type="success">发布文章</Button>
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
    <Button style="zoom:1.5" @click="modal = true" shape="circle" icon="md-backspace"></Button></Tooltip>
  </div>
  <Footer/>
</template>

<script>
import Vditor from 'vditor';
import 'vditor/dist/index.css';
import Header from '@/components/aresources/PageHead.vue'
import Footer from '@/components/aresources/PageFoot.vue'

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
    };
  },
  mounted() {
    this.vditorInstance = new Vditor(this.$refs.vditor, {
      height: 720,
      width: '100%',
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
      },
    });
  },
  methods: {
    handleUpload(file) {
      this.toBase64(file).then((base64) => {
        const markdownImage = `![${file.name}](data:image/png;base64,${base64})`;
        this.vditorInstance.insertValue(markdownImage);
      }).catch((error) => {
        console.error("Base64 conversion error: ", error);
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
    }
  }
};
</script>

<style>
.Card {
    max-width: 1200px;
    width: 100%;
    height: 96vh;
}

.editor-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.vditor {
  max-width: 1200px;
  width: 100%;
  margin-top: 10px;
}

h1 {
    text-align: center;
    margin-bottom: 120px;
}

.backhome {
  position: absolute;
  top: 40px;
  left: 40px;
  border-width: 2px;
  zoom: 110%;
}

div>span {
    font-weight: 600;
}

Col {
    margin-bottom: 10px;
}
</style>
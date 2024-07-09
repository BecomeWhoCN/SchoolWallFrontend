<template>
  <Headers />
  <div class="drift-bottle-container">
    <Tooltip style="zoom:0.8;top:100px;left:50px" class="backhome" content="返回首页" placement="top-start">
      <Button style="zoom:1.4" @click="backhome" shape="circle" icon="md-backspace"></Button>
    </Tooltip>
    <Tooltip style="zoom:0.8;top:100px;left:110px" class="backhome" content="漂流瓶管理" placement="top-start">
      <Button style="zoom:1.4" @click="gomanage" shape="circle" icon="md-settings">管理我的漂流瓶</Button>
    </Tooltip>
    <img :src="headerImage" alt="Header Image" class="header-image" />
    <h2 style="margin-left: 40px;">{{ currentArticle.bottle_title }}</h2>
    <div style="padding: 25px;padding-left:40px" class="content-container" id="vditor"></div>
    <div class="navigation-buttons">
      <Button @click="prevArticle" type="primary" size="large" :disabled="currentIndex === 0">上一篇</Button>
      <Button @click="nextArticle" type="primary" size="large">下一篇</Button>
    </div>
    <Button @click="showReplyModal" class="reply-button" type="success" size="small">回复</Button>
  </div>
  <Modal v-model="isReplyModalVisible" title="回复漂流瓶" @on-ok="submitReply">
    <div class="reply-content">
      <h3>{{ currentArticle.bottle_title }}</h3>
      <div class="article-content" id="vditorReply"></div>
      <Input type="textarea" v-model="replyContent" placeholder="输入你的回复..." rows="4" />
    </div>
  </Modal>
  <Button @click="addbottle" class="floating-button" type="success" shape="circle" icon="md-add">添加漂流瓶</Button>
  <Footers />
</template>

<script>
import Headers from '@/components/aresources/PageHead.vue';
import Footers from '@/components/aresources/PageFoot.vue';
import { Button, Tooltip, Modal, Input } from 'view-ui-plus';
import axios from 'axios';
import Vditor from 'vditor';

export default {
  components: {
    Headers,
    Footers,
    Button,
    Tooltip,
    Modal,
    Input
  },
  data() {
    return {
      headerImage: 'https://s1.imagehub.cc/images/2024/07/03/5aff71f1b7b8e15e2101a6da16c8f771.png',
      articles: [],
      currentIndex: 0,
      isFetching: false,
      isReplyModalVisible: false,
      replyContent: ''
    };
  },
  computed: {
    currentArticle() {
      return this.articles[this.currentIndex] || { bottle_title: 'Loading...', bottle_content_url: '' };
    }
  },
  async mounted() {
    await this.fetchArticles();
  },
  methods: {
    async fetchArticles() {
      if (this.isFetching) return;
      this.isFetching = true;
      try {
        const response = await axios.get('/api/scDriftBottles/random_articles');
        this.articles = response.data;
        if (this.articles.length > 0) {
          this.loadArticleContent(this.currentArticle);
        }
      } catch (error) {
        console.error('获取漂流瓶文章失败:', error);
      } finally {
        this.isFetching = false;
      }
    },
    async loadArticleContent(article) {
      try {
        const response = await axios.get(article.bottle_content_url);
        Vditor.preview(document.getElementById('vditor'), response.data, {
          theme: 'dark'
        });
      } catch (error) {
        console.error('加载Markdown内容失败:', error);
      }
    },
    prevArticle() {
      if (this.currentIndex > 0) {
        this.currentIndex--;
        this.loadArticleContent(this.currentArticle);
      }
    },
    nextArticle() {
      if (this.currentIndex < this.articles.length - 1) {
        this.currentIndex++;
        this.loadArticleContent(this.currentArticle);
      } else {
        this.fetchArticles();
      }
    },
    backhome() {
      this.$router.push('/');
    },
    gomanage() {
      this.$router.push('/manage-bottle');
    },
    addbottle() {
      this.$router.push('/edit-bottle');
    },
    showReplyModal() {
      this.isReplyModalVisible = true;
      this.loadArticleReplyContent(this.currentArticle);
    },
    async loadArticleReplyContent(article) {
      try {
        const response = await axios.get(article.bottle_content_url);
        Vditor.preview(document.getElementById('vditorReply'), response.data, {
          theme: 'dark'
        });
      } catch (error) {
        console.error('加载Markdown内容失败:', error);
      }
    },
    getCookie(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2) return parts.pop().split(';').shift();
    },
    async submitReply() {
      const userId = this.getCookie('userId');
      const replyData = {
        bottle_id: this.currentArticle.bottle_id,
        user_id: userId, // 这里需要替换成当前用户的id
        reply_content: this.replyContent,
        reply_created_at: new Date()
      };
      console.log("------replyData-------");
      console.log(replyData);
      try {
        await axios.post('/api/scDriftBottles/reply', replyData);
        this.$Message.success('回复成功');
        this.isReplyModalVisible = false;
        this.replyContent = '';
      } catch (error) {
        console.error('提交回复失败:', error);
        this.$Message.error('提交回复失败');
      }
    }
  }
};
</script>

<style scoped>
.drift-bottle-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  position: relative;
}

.header-image {
  width: 100%;
  height: auto;
  margin-bottom: 20px;
}

.content-container {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.floating-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
}

.navigation-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.backhome, .gomanage {
  position: fixed;
  top: 80px;
  left: 20px;
}
.gomanage {
  left: 110px; /* Adjusted for proper placement */
}

.reply-button {
  margin-top: 20px;
}

.reply-content {
  margin-bottom: 20px;
}

.article-content {
  margin-bottom: 20px;
}
</style>
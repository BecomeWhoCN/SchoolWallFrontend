<template>
<Headers/>
  <div class="drift-bottle-container">

    <Tooltip style="zoom:0.8;top:100px;left:50px" class="backhome" content="返回首页" placement="top-start">
    <Button style="zoom:1.4" @click="backhome"  shape="circle" icon="md-backspace"></Button></Tooltip>

    <Tooltip style="zoom:0.8;top:100px;left:110px" class="backhome" content="漂流瓶管理" placement="top-start">
    <Button style="zoom:1.4" @click="gomanage" shape="circle" icon="md-settings">管理我的漂流瓶</Button></Tooltip>


    <img :src="headerImage" alt="Header Image" class="header-image" />
    <div class="content-container">
      <div class="article">
        <h2>{{ currentArticle.title }}</h2>
        <p>{{ currentArticle.content }}</p>
      </div>
      <div class="navigation-buttons">
        <Button @click="prevArticle" type="primary" size="large" :disabled="currentIndex === 0">上一篇</Button>
        <Button @click="nextArticle" type="primary" size="large" :disabled="currentIndex === articles.length - 1">下一篇</Button>
      </div>
    </div>
    
    <Button @click="addbottle" class="floating-button" type="success" shape="circle" icon="md-add">添加漂流瓶</Button>

  </div>
  <Footers/>
</template>

<script>
import Headers from '@/components/aresources/PageHead.vue'
import Footers from '@/components/aresources/PageFoot.vue'

export default {
    components: {
    Headers,
    Footers
  },
  data() {
    return {
      headerImage: 'https://s1.imagehub.cc/images/2024/07/03/5aff71f1b7b8e15e2101a6da16c8f771.png', // 头图占位符
      articles: [
        {
          title: '漂流瓶文章 1',
          content: '这是漂流瓶文章内容 1。'
        },
        {
          title: '漂流瓶文章 2',
          content: '这是漂流瓶文章内容 2。'
        },
        {
          title: '漂流瓶文章 3',
          content: '这是漂流瓶文章内容 3。'
        }
      ],
      currentIndex: 0,
      isModalVisible: false,
      newArticleTitle: '',
      newArticleContent: ''
    };
  },
  computed: {
    currentArticle() {
      return this.articles[this.currentIndex];
    }
  },
  methods: {
    prevArticle() {
      if (this.currentIndex > 0) {
        this.currentIndex--;
      }
    },
    nextArticle() {
      if (this.currentIndex < this.articles.length - 1) {
        this.currentIndex++;
      }
    },
    addbottle() {
      this.$router.push('/edit-bottle');
    },
    addArticle() {
      if (this.newArticleTitle && this.newArticleContent) {
        this.articles.push({
          title: this.newArticleTitle,
          content: this.newArticleContent
        });
        this.newArticleTitle = '';
        this.newArticleContent = '';
        this.isModalVisible = false;
      } else {
        this.$Message.error('标题和内容不能为空');
      }
    },
    backhome(){
      this.$router.push('/')
    },gomanage(){
        this.$router.push('/manage-bottle')
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

.article h2 {
  margin-top: 0;
}

.navigation-buttons {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.floating-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
}

.backhome{
  position: fixed;
  top: 80px;
  left: 20px;
}

.gomanage{
  position: fixed;
  top: 90px;
  left: 62px;
}
</style>
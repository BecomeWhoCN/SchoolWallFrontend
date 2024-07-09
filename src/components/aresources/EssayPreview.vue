<template>
  <div class="essay-preview" v-if="show">
    <div class="content">
      <button class="close-button" @click="closePreview">关闭</button>
      <h2>{{ essay.title }}</h2>
      <div id="vditor"></div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Vditor from 'vditor';
import 'vditor/dist/index.css';

export default {
  props: {
    id: {
      type: Number,
      required: true
    },
    show: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      essay: {}
    }
  },
  watch: {
    id(newId) {
      this.fetchEssay(newId)
    }
  },
  methods: {
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
    async fetchEssay(id) {
      try {
        // const response = await axios.get(`/api/essays/${id}`);
        // this.essay = response.data;
        this.essay = {
          "id": 1,
          "title": "文章标题",
          "bottle_content_url": "http://sfrsrdckw.hn-bkt.clouddn.com/bottleContents/202407051124bottleContent_1720149897356.md"
        };
        this.loadArticleContent(this.essay);
      } catch (error) {
        console.error('获取文章失败:', error);
      }
    },
    closePreview() {
      this.$emit('update:show', false);
    }
  },
  mounted() {
    this.fetchEssay(this.id);
  }
}
</script>

<style scoped>
.essay-preview {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 1000;
}

.content {
  position: relative;
  background: white;
  padding: 20px;
  border-radius: 10px;
  max-width: 80%;
  overflow-y: auto;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 为内容框添加阴影 */
}

.close-button {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  font-size: 18px;
  cursor: pointer;
}

h2 {
  margin-top: 0;
}
</style>

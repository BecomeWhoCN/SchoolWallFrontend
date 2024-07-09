<template>
  <Hearder />
  <div class="article-container">
    <Row :gutter="20">
      <Col :xs="24" :sm="24" :md="12" :lg="8" v-for="article in paginatedArticles" :key="article.postId">
        <Card class="article-card">
          <img :src="article.imageURL" class="article-image" />
          <h3>{{ article.title }}</h3>
          <p>{{ article.summary }}</p>
          <div class="article-info">
            <Tooltip content="发布者" placement="bottom-start">
              <span>
                <img style="zoom:80%" v-if="article.authorAvatarURL" :src="article.authorAvatarURL" class="author-avatar" />
                <Icon v-else class="pageIcon" type="md-contact" />
                <span style="margin-top: -3px">{{ article.author }}</span>
              </span>
              <Tag color="success">官方认证</Tag>
            </Tooltip>

            <Tooltip content="发布时间" placement="bottom-start">
              <span><Icon class="pageIcon" type="md-clock" /> {{ article.date }}</span>
            </Tooltip>
          </div>
          <div class="article-stats">
            <Tooltip content="评论数" placement="bottom-start">
              <span><Icon class="pageIcon" type="md-chatboxes" /> {{ article.comments }}</span>
            </Tooltip>

            <Tooltip content="获赞数" placement="bottom-start">
              <span><Icon class="pageIcon" type="ios-heart" /> {{ article.likes }}</span>
            </Tooltip>

            <Tooltip content="举报文章内容" placement="bottom-start">
              <Button type="error" style="zoom:80%" shape="circle" icon="md-help" @click="openModal(article.postId)"></Button>
            </Tooltip>
          </div>
        </Card>
      </Col>
    </Row>

    <Page :total="total" :page-size="pageSize" @on-change="handlePageChange" />

    <Modal v-model="modal" title="举报此文章" :loading="loading" @on-ok="asyncOK">
      <p>你正在举报此文章，请勿恶意举报，请在下面填写举报原因(不要超过50字)</p>
      <Input class="why" v-model="value2" maxlength="50" show-word-limit type="textarea" placeholder="举报原因" style="width: 455px" />
    </Modal>
  </div>
  <Footer />
</template>

<script>
import axios from 'axios';
import { Row, Col, Card, Button, Icon, Tooltip, Tag, Page, Modal, Input } from 'view-ui-plus';
import Cookies from "js-cookie";
import Hearder from '@/components/aresources/PageHead.vue';
import Footer from '@/components/aresources/PageFoot.vue';

export default {
  name: 'ArticlePage',
  components: {
    Row,
    Col,
    Card,
    Button,
    Icon,
    Tooltip,
    Tag,
    Page,
    Modal,
    Input,
    Hearder,
    Footer
  },
  data() {
    return {
      articles: [],
      paginatedArticles: [],
      total: 0,
      pageSize: 6,
      currentPage: 1,
      modal: false,
      loading: false,
      value2: '',
      currentPostId: null
    };
  },
  created() {
    this.fetchArticles(this.currentPage);
  },
  methods: {
    fetchArticles() {
      axios.get('/api/scPosts/queryAllArticles')
        .then(response => {
          this.articles = response.data.data.articles; // 更新为新API返回的数据结构
          this.total = response.data.data.total;
          this.paginateArticles();
        })
        .catch(error => {
          console.error('获取文章数据失败:', error);
        });
    },
    paginateArticles() {
      const startIndex = (this.currentPage - 1) * this.pageSize;
      this.paginatedArticles = this.articles.slice(startIndex, startIndex + this.pageSize);
    },
    handlePageChange(page) {
      this.currentPage = page;
      this.paginateArticles(); // 直接分页显示文章
    },
    openModal(postId) {
      this.currentPostId = postId;
      this.modal = true;
    },
    asyncOK() {
      const userId = Cookies.get('userId');
      this.loading = true;
      axios.post('/api/scReports/addReportedData', {
        userId: userId,
        postId: this.currentPostId,
        value: this.value2,
      })
      .then(response => {
        this.loading = false;
        if (response.data.success) {
          this.$Message.success('操作成功我们正在核实');
          this.modal = false;
          this.value2 = '';
        } else {
          this.$Message.error('操作失败，请重试');
        }
      })
      .catch(error => {
        this.loading = false;
        console.error('请求失败:', error);
        this.$Message.error('请求失败，请重试');
      });
    }
  }
};
</script>

<style scoped>
* {
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
}

.article-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.article-image {
  width: 100%;
  height: auto;
}

.article-card {
  margin-bottom: 20px;
}

.article-info {
  display: flex;
  justify-content: space-between;
  margin: 10px 0;
}

.article-stats {
  display: flex;
  justify-content: space-between;
  margin: 10px 0;
}

.pageIcon {
  zoom: 120%;
}

.author-avatar {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  margin-right: 5px;
}
</style>
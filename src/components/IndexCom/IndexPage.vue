<template>
  <div class="article-container">
    <div class="header">
      <h2><span style="color: #ff0000;">| </span>最新的文章</h2>

      <Tooltip content="查看所有文章" placement="bottom">
        <Button @click="goMorePage">查看更多 <Icon type="ios-arrow-dropright-circle" /></Button>
      </Tooltip>
    </div>

    <Row :gutter="20">
      <Col :xs="24" :sm="24" :md="12" :lg="12" v-for="article in articles" :key="article.postId">
        <Card class="article-card">
          <router-link :to="`/test?postId=${article.postId}`">
            <img :src="article.imageURL" class="article-image" />
            <h3>{{ article.title }}</h3>
            <p>{{ article.summary }}</p>
            <div class="article-info">
              <Tooltip content="创造者" placement="bottom-start">
                <span>
                  <img style="zoom:80%" v-if="article.authorAvatar" :src="article.authorAvatarURL" class="author-avatar" />
                  <Icon v-else class="pageIcon" type="md-contact" /> <span style="margin-top: -3px">{{ article.author }}</span>
                </span>
              </Tooltip>

              <Tooltip content="创建时间" placement="bottom-start">
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
                <Button style="zoom:80%" type="error" shape="circle" icon="md-help" @click="openModal(article.postId)"></Button>
              </Tooltip>
            </div>
          </router-link>
        </Card>
      </Col>
    </Row>

    <Modal v-model="modal" title="举报此文章" :loading="loading" @on-ok="asyncOK">
      <p>你正在举报此文章，请勿恶意举报，请在下面填写举报原因(不要超过50字)</p>
      <Input class="why" v-model="value2" maxlength="50" show-word-limit type="textarea" placeholder="举报原因" style="width: 455px" />
    </Modal>
  </div>
</template>

<script>
import axios from 'axios';
import { Row, Col, Card, Button, Icon, Tooltip, Modal, Input } from 'view-ui-plus';
import Cookies from "js-cookie";

export default {
  name: 'IndexPage',
  components: {
    Row,
    Col,
    Card,
    Button,
    Icon,
    Tooltip,
    Modal,
    Input
  },
  data() {
    return {
      articles: [],
      modal: false,
      loading: false,
      value2: '',
      currentPostId: null // 增加存储当前被举报文章的 id
    };
  },
  created() {
    this.fetchArticlesData();
  },
  methods: {
    fetchArticlesData() {
      axios.get('/api/scPosts/queryArticlesData') 
        .then(response => {
          this.articles = response.data.data.data;
          console.log(response.data.data.data);
        })
        .catch(error => {
          console.error('获取文章数据失败:', error);
        });
    },
    goMorePage() {
      this.$router.push('/more');
    },
    openModal(postId) {
      this.currentPostId = postId; // 存储当前被举报文章的 id
      this.modal = true;
    },
    asyncOK(){
      const userId = Cookies.get('userId');
      this.loading = true;
      axios.post('/api/scReports/addReportedData', {
        userId: userId,
        postId: this.currentPostId, // 使用存储的 id
        value: this.value2,
      })
      .then(response => {
        this.loading = false;
        if (response.data.success ) {
          this.$Message.success('操作成功我们正在核实');
          this.modal = false;
          this.value2 = '';
        } else {
          console.log(response.data.success)
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
  max-width: 1000px;
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

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  margin-top: 10px;
}

h2 {
  font-size: 27px;
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

a {
  color: black;
}

a:hove {
  color: black;
}
</style>
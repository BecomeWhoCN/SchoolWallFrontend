<template>
  <div class="news-container">
    <div class="header">
      <h2><span style="color: #ff0000;">| </span>最新的学校新闻</h2>

      <Tooltip content="查看所有新闻" placement="bottom">
        <Button @click="goMoreNews">查看更多 <Icon type="ios-arrow-dropright-circle" /></Button>
      </Tooltip>
    </div>

    <Row :gutter="20">
      <Col :xs="24" :sm="24" :md="12" :lg="12" v-for="news in newsList" :key="news.postId">
        <Card class="news-card">
          <img :src="news.imageURL" class="news-image" />
          <h3>{{ news.title }}</h3>
          <p>{{ news.summary }}</p>
          <div class="news-info">
            <Tooltip content="发布者" placement="bottom-start">
              <span>
                <img style="zoom:80%" v-if="news.authorAvatarURL" :src="news.authorAvatarURL" class="author-avatar" />
                <Icon v-else class="pageIcon" type="md-contact" /> 
                <span style="margin-top: -3px">{{ news.author }}</span>
              </span> 
              <Tag color="success">官方认证</Tag>
            </Tooltip>

            <Tooltip content="发布时间" placement="bottom-start">
              <span><Icon class="pageIcon" type="md-clock" /> {{ news.date }}</span>
            </Tooltip>
          </div>
          <div class="news-stats">
            <Tooltip content="评论数" placement="bottom-start">
              <span><Icon class="pageIcon" type="md-chatboxes" /> {{ news.comments }}</span>
            </Tooltip>

            <Tooltip content="获赞数" placement="bottom-start">
              <span><Icon class="pageIcon" type="ios-heart" /> {{ news.likes }}</span>
            </Tooltip>

            <Tooltip content="举报新闻内容" placement="bottom-start">
              <Button type="error" style="zoom:80%" shape="circle" icon="md-help" @click="openModal(news.postId)"></Button>
            </Tooltip>
          </div>
        </Card>
      </Col>
    </Row>
  </div>
  <Modal v-model="modal" title="举报此文章" :loading="loading" @on-ok="asyncOK">
        <p>你正在举报此文章，请勿恶意举报，请在下面填写举报原因(不要超过50字)</p>
        <Input class="why" v-model="value2" maxlength="50" show-word-limit type="textarea" placeholder="举报原因" style="width: 455px" />
    </Modal>
</template>

<script>
import axios from 'axios';
import { Row, Col, Card, Button, Icon, Tooltip, Tag } from 'view-ui-plus';
import Cookies from "js-cookie";

export default {
  name: 'SchoolNews',
  components: {
    Row,
    Col,
    Card,
    Button,
    Icon,
    Tooltip,
    Tag
  },
  data() {
    return {
      newsList: [],
      modal: false,
      loading: false,
      value2: '',
      currentPostId: null // 增加存储当前被举报新闻的 postId
    };
  },
  created() {
    this.fetchNewsData();
  },
  methods: {
    fetchNewsData() {
      axios.get('/api/scPosts/queryNewsData') 
        .then(response => {
          this.newsList = response.data.data.data;
          console.log(response.data.data.data);
        })
        .catch(error => {
          console.error('获取新闻数据失败:', error);
        });
    },
    goMoreNews() {
      this.$router.push('/news');
    },
    openModal(postId) {
      this.currentPostId = postId; // 存储当前被举报新闻的 postId
      this.modal = true;
    },
    asyncOK(){
      const userId = Cookies.get('userId');
      this.loading = true;
      axios.post('/api/scReports/addReportedData', {
        userId: userId,
        postId: this.currentPostId, // 使用存储的 postId
        value: this.value2,
      })
      .then(response => {
        this.loading = false;
        if (response.data.success ) {
          this.$Message.success('操作成功我们正在核实');
          this.modal = false;
          this.value2 = '';
        } else {
          
          this.$Message.error('操作失败，请重试');
        }
      })
      .catch(error => {
        this.loading = false;
        console.log(response.data.success)
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

.news-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
}

.news-image {
  width: 100%;
  height: auto;
}

.news-card {
  margin-bottom: 20px;
}

.news-info {
  display: flex;
  justify-content: space-between;
  margin: 10px 0;
}

.news-stats {
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

</style>
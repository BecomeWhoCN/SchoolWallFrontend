<template>
  <div class="article-container">
    <div class="header">
      <h2><span style="color: #ff0000;">| </span>最新的文章</h2>

      <Tooltip content="查看所有文章" placement="bottom">
        <Button @click="goMorePage">查看更多 <Icon type="ios-arrow-dropright-circle" /></Button>
      </Tooltip>
    </div>

    <Row :gutter="20">
      <Col :xs="24" :sm="24" :md="12" :lg="12" v-for="article in articles" :key="article.id">
        <Card class="article-card">
          <img :src="article.image" class="article-image" />
          <h3>{{ article.title }}</h3>
          <p>{{ article.content }}</p>
          <div class="article-info">
            <Tooltip content="创造者" placement="bottom-start">
              <span>
                <img style="zoom:80%" v-if="article.authorAvatar" :src="article.authorAvatar" class="author-avatar" />
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
              <Button style="zoom:80%" type="error" shape="circle" icon="md-help" @click="reportArticle(article.id)"></Button>
            </Tooltip>
          </div>
        </Card>
      </Col>
    </Row>
  </div>
</template>

<script>
import { Row, Col, Card, Button, Icon, Tooltip } from 'view-ui-plus';

export default {
  name: 'IndexPage',
  components: {
    Row,
    Col,
    Card,
    Button,
    Icon,
    Tooltip
  },
  data() {
    return {
      articles: [
        {
          id: 1,
          image: 'https://www.wetools.com/imgplaceholder/400x180',
          title: 'Article 1',
          content: 'This is the content of article 1.',
          author: 'Author 1',
          authorAvatar: '', // 假设没有头像
          date: '2024-06-30',
          comments: 5,
          likes: 20
        },
        {
          id: 2,
          image: 'https://www.wetools.com/imgplaceholder/400x180',
          title: 'Article 2',
          content: 'This is the content of article 2.',
          author: 'Author 2',
          authorAvatar: 'assets/aresources/logo/logo_brown_bear.png', // 假设有头像
          date: '2024-06-29',
          comments: 8,
          likes: 30
        }
        // Add more articles as needed
      ]
    };
  },
  methods: {
    goMorePage() {
      this.$router.push('/more');
    },
    reportArticle(id) {
      // Implement your report functionality here
      alert(`Article ${id} has been reported.`);
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

  margin-top: 40px;
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
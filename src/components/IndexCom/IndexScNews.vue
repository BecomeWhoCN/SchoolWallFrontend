<template>
  <div class="news-container">
    <div class="header">
      <h2><span style="color: #ff0000;">| </span>最新的学校新闻</h2>

      <Tooltip content="查看所有新闻" placement="bottom">
        <Button @click="goMoreNews">查看更多 <Icon type="ios-arrow-dropright-circle" /></Button>
      </Tooltip>
    </div>

    <Row :gutter="20">
      <Col :xs="24" :sm="24" :md="12" :lg="12" v-for="news in newsList" :key="news.id">
        <Card class="news-card">
          <img :src="news.image" class="news-image" />
          <h3>{{ news.title }}</h3>
          <p>{{ news.content }}</p>
          <div class="news-info">
            <Tooltip content="发布者" placement="bottom-start">
              <span>
                <img style="zoom:80%" v-if="news.authorAvatar" :src="news.authorAvatar" class="author-avatar" />
                <Icon v-else class="pageIcon" type="md-contact" /> <span style="margin-top: -3px">{{ news.author }}</span>
              </span> <Tag color="success">官方认证</Tag>
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
              <Button type="error" style="zoom:80%" shape="circle" icon="md-help" @click="reportNews(news.id)"></Button>
            </Tooltip>
          </div>
        </Card>
      </Col>
    </Row>
  </div>
</template>

<script>
import { Row, Col, Card, Button, Icon, Tooltip,Tag  } from 'view-ui-plus';

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
      newsList: [
        {
          id: 1,
          image: 'https://www.wetools.com/imgplaceholder/400x180',
          title: 'News 1',
          content: 'This is the content of news 1.',
          author: 'Author 1',
          authorAvatar: '', // 假设没有头像
          date: '2024-06-30',
          comments: 5,
          likes: 20
        },
        {
          id: 2,
          image: 'https://www.wetools.com/imgplaceholder/400x180',
          title: 'News 2',
          content: 'This is the content of news 2.',
          author: 'Author 2',
          authorAvatar: 'assets/aresources/logo/logo_school.png', // 假设有头像
          date: '2024-06-29',
          comments: 8,
          likes: 30
        }
        // Add more news as needed
      ]
    };
  },
  methods: {
    goMoreNews() {
      this.$router.push('/news');
    },
    reportNews(id) {
      // Implement your report functionality here
      alert(`News ${id} has been reported.`);
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

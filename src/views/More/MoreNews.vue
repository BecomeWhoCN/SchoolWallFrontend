<template>
    <Hearder />
    <div class="news-container">
      <Row :gutter="20">
        <Col :xs="24" :sm="24" :md="12" :lg="8" v-for="news in paginatedNews" :key="news.postId">
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
  
      <Page :total="total" :page-size="pageSize" @on-change="handlePageChange" />
  
      <Modal v-model="modal" title="举报此新闻" :loading="loading" @on-ok="asyncOK">
        <p>你正在举报此新闻，请勿恶意举报，请在下面填写举报原因(不要超过50字)</p>
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
    name: 'MoreNews',
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
        newsList: [],
        paginatedNews: [],
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
      this.fetchNews(this.currentPage);
    },
    methods: {
      fetchNews() {
        axios.get('/api/scPosts/queryAllNews')
          .then(response => {
            this.newsList = response.data.data.news; // 更新为新API返回的数据结构
            this.total = response.data.data.total;
            this.paginateNews();
          })
          .catch(error => {
            console.error('获取新闻数据失败:', error);
          });
      },
      paginateNews() {
        const startIndex = (this.currentPage - 1) * this.pageSize;
        this.paginatedNews = this.newsList.slice(startIndex, startIndex + this.pageSize);
      },
      handlePageChange(page) {
        this.currentPage = page;
        this.paginateNews(); // 直接分页显示新闻
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
  
  .news-container {
    max-width: 1200px;
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
  
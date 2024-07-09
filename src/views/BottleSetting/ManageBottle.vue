<template>
  <div class="page-container">
    <Headers />
    <div class="content">
      <h1 class="main-title">个人漂流瓶管理页面</h1>
      <Button @click="backhome" class="backhome" shape="circle" icon="md-backspace"></Button>
      <Card title="已发布的瓶子" class="table-card">
        <Table border :columns="publishedColumns" :data="publishedData" :loading="loading" stripe>
          <template #title="{ row }">
            <strong class="ellipsis">{{ row.bottleTitle }}</strong>
          </template>
          <template #author="{ row }">
            <div class="author-info">
              {{ row.authorName }}
            </div>
          </template>
          <template #action="{ row, index }">
            <Button type="primary" size="small" style="margin-right: 5px" @click="viewReplies(row.bottleId)">查看回复</Button>
            <Button type="default" size="small" style="margin-right: 5px" @click="viewDetails(row)">详情</Button>
            <Button type="error" size="small" @click="confirmDeleteArticle(row.bottleId, index)">删除</Button>
          </template>
        </Table>
        <Page class="fenye" :total="publishedTotal" :page-size="pageSize" @on-change="handlePublishedPageChange" />
      </Card>
    </div>
    <Footers />

    <Modal v-model="detailsModalVisible" title="瓶子详情">
      <p>标题: {{ currentDetails.bottleTitle }}</p>
      <p>作者: {{ currentDetails.authorName }}</p>
      <div v-html="currentDetails.bottleContent"></div>
    </Modal>

    <Modal v-model="repliesModalVisible" title="查看回复">
      <div v-if="currentReplies.length > 0">
        <div v-for="reply in currentReplies" :key="reply.reply_id" class="reply-item">
          <div class="reply-content">
            <p>
              <strong>{{ reply.user_name }}</strong> 
              <span class="reply-time">{{ formatDate(reply.reply_created_at) }}</span>
            </p>
            <p>{{ reply.reply_content }}</p>
          </div>
        </div>
      </div>
      <div v-else>
        <p>暂无回复</p>
      </div>
    </Modal>
  </div>
</template>

<script>
import axios from 'axios';
import Cookies from 'js-cookie';
import Headers from '@/components/aresources/PageHead.vue';
import Footers from '@/components/aresources/PageFoot.vue';
import { Modal, Button, Card, Table, Page } from 'view-ui-plus';

export default {
  components: {
    Headers, Footers, Modal, Button, Card, Table, Page
  },
  data() {
    return {
      userId: null,
      pageSize: 10,
      publishedTotal: 0,
      publishedData: [],
      loading: false,
      detailsModalVisible: false,
      repliesModalVisible: false,
      currentDetails: {},
      currentReplies: [],
      publishedColumns: [
        {
          title: '标题',
          slot: 'title',
          fixed: 'left',
          width: 200
        },
        {
          title: '作者',
          slot: 'author',
          width: 150
        },
        {
          title: '操作',
          slot: 'action',
          width: 400,
          align: 'center',
          fixed: 'right'
        }
      ]
    };
  },
  created() {
    this.userId = Cookies.get('userId');
    if (this.userId) {
      this.fetchPublishedData(1); // 初始加载第一页数据
    } else {
      console.error('User ID not found in cookies');
    }
  },
  methods: {
    async fetchPublishedData(page) {
      this.loading = true;
      try {
        const response = await axios.get('/api/scDriftBottles/published', {
          params: {
            userId: this.userId,
            page: page,
            pageSize: this.pageSize,
          }
        });

        if (response.data.success) {
          const bottles = response.data.data.bottles;

          // 获取每个瓶子的用户信息
          const userRequests = bottles.map(bottle => axios.get(`/api/scUsers/get_scuserbyid/${bottle.userId}`));
          const userResponses = await Promise.all(userRequests);

          // 将用户信息添加到瓶子数据中
          const bottlesWithUserInfo = bottles.map((bottle, index) => {
            const user = userResponses[index].data.data; // 假设用户信息在 data.data 中
            return {
              ...bottle,
              authorName: user.userName
            };
          });

          this.publishedData = bottlesWithUserInfo;
          this.publishedTotal = response.data.data.total;
        } else {
          console.error('Failed to fetch published bottles:', response.data.message);
        }
      } catch (error) {
        console.error('Failed to fetch published bottles:', error);
      } finally {
        this.loading = false;
      }
    },
    handlePublishedPageChange(page) {
      this.fetchPublishedData(page);
    },
    async viewReplies(bottleId) {
      try {
        const response = await axios.get(`/api/scDriftBottles/replies/${bottleId}`);
        console.log("Replies response:", response);
        if (response.data.success) {
          const replies = response.data.data; // 直接获取数据数组
          console.log("Replies:", replies);

          this.currentReplies = replies.length ? replies : [];
          this.repliesModalVisible = true;
        } else {
          console.error('Failed to fetch replies:', response.data.message);
        }
      } catch (error) {
        console.error('Failed to fetch replies:', error);
      }
    },
    async viewDetails(row) {
      if (!row || !row.bottleContentUrl) {
        console.error('Bottle content URL is missing');
        console.log("Row data:", row);
        return;
      }

      let url = row.bottleContentUrl;

      if (typeof url !== 'string') {
        console.error('Invalid URL:', url);
        return;
      }

      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'http://' + url; // 或根据需要使用 https://
      }

      console.log("Fetching details from URL:", url);

      try {
        const response = await axios.get(url);
        const content = response.data;

        this.currentDetails = {
          bottleTitle: row.bottleTitle,
          authorName: row.authorName,
          bottleContent: content
        };

        this.detailsModalVisible = true;
      } catch (error) {
        console.error('Failed to fetch article details:', error);
      }
    },
    confirmDeleteArticle(bottleId, index) {
      this.$Modal.confirm({
        title: '确认删除',
        content: '<p>你确定要删除这个漂流瓶吗？</p>',
        onOk: () => {
          this.deleteArticle(bottleId, index);
        },
        onCancel: () => {
          this.$Message.info('取消删除');
        }
      });
    },
    async deleteArticle(bottleId, index) {
      try {
        const response = await axios.delete(`/api/scDriftBottles/delete_bottle_byId/${bottleId}`);
        if (response.data.success) {
          this.publishedData.splice(index, 1);
          this.$Message.success('删除成功');
        } else {
          this.$Message.error('删除失败');
        }
      } catch (error) {
        console.error('Failed to delete article:', error);
        this.$Message.error('删除失败');
      }
    },
    backhome() {
      this.$router.push('/bottle-index');
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit' };
      return new Date(dateString).toLocaleDateString('zh-CN', options);
    }
  }
};
</script>

<style scoped>
.page-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.main-title {
  text-align: center;
  margin-bottom: 20px;
}

.table-card {
  margin-bottom: 20px;
}

.table-container {
  overflow-x: auto;
}

.backhome {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
}

.content {
  padding: 20px;
  background: #fff;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
}

.author-info {
  display: flex;
  align-items: center;
}

.ellipsis {
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 100%;
}

.reply-item {
  display: flex;
  margin-bottom: 10px;
}

.reply-content {
  flex: 1;
}

.reply-time {
  margin-left: 10px;
  color: #888;
}

@media (max-width: 768px) {
  .table-container {
    zoom: 0.7;
  }

  .backhome {
    position: fixed;
    bottom: 10px;
    right: 10px;
    z-index: 1000;
  }
}
</style>

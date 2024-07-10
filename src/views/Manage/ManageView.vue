<template>
  <div>
    <Header />
    <div class="content">
      <!-- 用户权限管理表格 -->
      <div class="table-container">
        <h2>用户权限管理</h2>
        <Table :columns="userColumns" :data="userData">
          <template #action="{ row }">
            <Button type="primary" size="small" @click="increasePermission(row.userId)" :disabled="row.userRole === 'admin'">权限提升</Button>
            <Button type="error" size="small" @click="decreasePermission(row.userId)" :disabled="row.userRole === 'user'">权限下降</Button>
          </template>
        </Table>
        <Page 
          :total="userTotal" 
          :page-size="pageSize" 
          @onChange="handleUserPageChange" 
          class="custom-page"
        />
      </div>

      <!-- 举报文章管理表格 -->
      <div class="table-container">
        <h2>举报文章管理</h2>
        <Table :columns="articleColumns" :data="articleData">
          <template #action="{ row }">
            <Button type="primary" size="small" @click="viewArticleDetail(row.postId)">详情</Button>
            <Button type="warning" size="small" @click="sendToDraft(row.postId)">打回草稿箱</Button>
            <Button type="success" size="small" @click="republishArticle(row.postId)">重新发布</Button>
            <Button type="error" size="small" @click="deleteArticle(row.postId)">删除</Button>
          </template>
        </Table>
        <Page 
          :total="articleTotal" 
          :page-size="pageSize" 
          @onChange="handleArticlePageChange" 
          class="custom-page"
        />
      </div>
      
      <!-- 被举报漂流瓶管理表格 -->
      <div class="table-container">
        <h2>被举报漂流瓶管理</h2>
        <Table :columns="messageColumns" :data="messageData">
          <template #action="{ row }">
            <Button type="primary" size="small" @click="viewDetails(row.bottleId)">详情</Button>
            <Button type="success" size="small" @click="republishMessage(row.bottleId)">重新发布</Button>
            <Button type="error" size="small" @click="deleteMessage(row.bottleId)">删除</Button>
          </template>
        </Table>
        <Page 
          :total="messageTotal" 
          :page-size="pageSize" 
          @onChange="handleMessagePageChange" 
          class="custom-page"
        />
      </div>
      
      <Modal
        v-model="detailsModalVisible"
        title="漂流瓶详情"
        @on-ok="handleModalOk"
        @on-cancel="handleModalCancel"
        :closable="false"
        :mask-closable="false"
      >
        <h3>{{ modalData.bottleTitle }}</h3>
        <div style="padding: 25px; padding-left: 40px" class="content-container" id="vditor"></div>
      </Modal>
    </div>
    <Footer />
  </div>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import Header from '@/components/aresources/PageHead.vue';
import Footer from '@/components/aresources/PageFoot.vue';
import { Table, Page, Button, Message, Modal } from 'view-ui-plus';
import axios from 'axios';
import Vditor from 'vditor';

export default defineComponent({
  components: {
    Header,
    Footer,
    Table,
    Page,
    Button,
    Modal
  },
  setup() {
    const router = useRouter();
    const pageSize = 5;

    // 表格数据和列定义
    const userColumns = [
      { title: '用户ID', key: 'userId' },
      { title: '用户名', key: 'userName' },
      { title: '用户角色', key: 'userRole' },
      {
        title: '操作',
        key: 'action',
        slot: 'action'
      }
    ];
    const userData = ref([]);
    const userTotal = ref(0);

    const articleColumns = [
      { title: '文章编号', key: 'postId' },
      { title: '作者', key: 'userName' },
      { title: '被举报文章名称', key: 'postTitle' },
      {
        title: '操作',
        key: 'action',
        slot: 'action'
      }
    ];
    const articleData = ref([]);
    const articleTotal = ref(0);

    const messageColumns = [
      { title: '漂流瓶编号', key: 'bottleId' },
      { title: '作者', key: 'userName' },
      { title: '被举报漂流瓶名称', key: 'bottleTitle' },
      {
        title: '操作',
        key: 'action',
        slot: 'action'
      }
    ];
    const messageData = ref([]);
    const messageTotal = ref(0);

    const detailsModalVisible = ref(false);
    const modalData = ref({
      bottleTitle: '',
      bottleContent: ''
    });

    // 获取用户数据
    const fetchUserData = (page) => {
      axios.post('/api/scUsers/queryAllUser', { page, pageSize })
        .then(response => {
          userData.value = response.data.data.users; // 确保数据路径正确
          userTotal.value = response.data.data.total;
        })
        .catch(error => {
          console.error('获取用户数据失败:', error);
        });
    };

    // 获取举报文章数据
    const fetchArticleData = (page) => {
      axios.post('/api/scPosts/queryAllReportedPosts', { page, pageSize })
        .then(response => {
          articleData.value = response.data.data.articles; // 确保数据路径正确
          articleTotal.value = response.data.data.total;
        })
        .catch(error => {
          console.error('获取文章数据失败:', error);
        });
    };

    // 获取被举报漂流瓶数据
    const fetchMessageData = (page) => {
      axios.post('/api/scDriftBottles/queryAllReportedDriftBottles', { page, pageSize })
        .then(response => {
          messageData.value = response.data.data.messages; // 确保数据路径正确
          messageTotal.value = response.data.data.total;
        })
        .catch(error => {
          console.error('获取漂流瓶数据失败:', error);
        });
    };

    // 页码改变事件处理
    const handleUserPageChange = (page) => fetchUserData(page);
    const handleArticlePageChange = (page) => fetchArticleData(page);
    const handleMessagePageChange = (page) => fetchMessageData(page);

    // 按钮操作
    const increasePermission = (userId) => {
      console.log('Sending userId:', userId);
      axios.post('/api/scUsers/increasePermission', { userId })
        .then(response => {
          if (response.data.success) {
            Message.success('权限提升成功');
            fetchUserData(1);
          } else {
            Message.error('权限提升失败');
          }
        })
        .catch(error => {
          console.error('权限提升请求失败:', error);
          Message.error('权限提升请求失败');
        });
    };

    const decreasePermission = (userId) => {
      axios.post('/api/scUsers/decreasePermission', { userId })
        .then(response => {
          if (response.data.success) {
            Message.success('权限下降成功');
            fetchUserData(1);
          } else {
            Message.error('权限下降失败');
          }
        })
        .catch(error => {
          console.error('权限下降请求失败:', error);
          Message.error('权限下降请求失败');
        });
    };

    const viewArticleDetail = (postId) => {
      console.log('查看文章详情', postId);
      router.push(`/test?postId=${postId}`);
    };

    const sendToDraft = (postId) => {
      axios.post('/api/scPosts/sendToDraft', { postId })
        .then(response => {
          if (response.data.success) {
            Message.success('打回草稿箱成功');
            fetchArticleData(1);
          } else {
            Message.error('打回草稿箱失败');
          }
        })
        .catch(error => {
          console.error('打回草稿箱请求失败:', error);
          Message.error('打回草稿箱请求失败');
        });
    };

    const republishArticle = (postId) => {
      axios.post('/api/scPosts/republish', { postId })
        .then(response => {
          if (response.data.success) {
            Message.success('重新发布成功');
            fetchArticleData(1);
          } else {
            Message.error('重新发布失败');
          }
        })
        .catch(error => {
          console.error('重新发布请求失败:', error);
          Message.error('重新发布请求失败');
        });
    };

    const deleteArticle = (postId) => {
      axios.post('/api/scPosts/delete', { postId })
        .then(response => {
          if (response.data.success) {
            Message.success('删除文章成功');
            fetchArticleData(1);
          } else {
            Message.error('删除文章失败');
          }
        })
        .catch(error => {
          console.error('删除文章请求失败:', error);
          Message.error('删除文章请求失败');
        });
    };

    const viewDetails = async (bottleId) => {
      try {
        const response = await axios.get(`/api/scDriftBottles/details/${bottleId}`);
        if (response.data.success) {
          modalData.value.bottleTitle = response.data.data.bottle_title;

          const contentResponse = await axios.get(response.data.data.bottle_content_url);
          modalData.value.bottleContent = contentResponse.data;

          detailsModalVisible.value = true;
          loadArticleContent(response.data.data);
        } else {
          Message.error('获取漂流瓶详情失败');
        }
      } catch (error) {
        console.error('获取漂流瓶详情请求失败:', error);
        Message.error('获取漂流瓶详情请求失败');
      }
    };

    const loadArticleContent = async (article) => {
      try {
        const response = await axios.get(article.bottle_content_url);
        Vditor.preview(document.getElementById('vditor'), response.data, {
          theme: 'dark'
        });
      } catch (error) {
        console.error('加载Markdown内容失败:', error);
      }
    };

    const republishMessage = (bottleId) => {
      axios.post('/api/scDriftBottles/republish', { bottleId })
        .then(response => {
          if (response.data.success) {
            Message.success('重新发布成功');
            fetchMessageData(1);
          } else {
            Message.error('重新发布失败');
          }
        })
        .catch(error => {
          console.error('重新发布请求失败:', error);
          Message.error('重新发布请求失败');
        });
    };

    const deleteMessage = (bottleId) => {
      axios.post('/api/scDriftBottles/delete', { bottleId })
        .then(response => {
          if (response.data.success) {
            Message.success('删除漂流瓶成功');
            fetchMessageData(1);
          } else {
            Message.error('删除漂流瓶失败');
          }
        })
        .catch(error => {
          console.error('删除漂流瓶请求失败:', error);
          Message.error('删除漂流瓶请求失败');
        });
    };

    const handleModalOk = () => {
      detailsModalVisible.value = false;
    };

    const handleModalCancel = () => {
      detailsModalVisible.value = false;
    };

    // 组件挂载时获取初始数据
    onMounted(() => {
      fetchUserData(1);
      fetchArticleData(1);
      fetchMessageData(1);
    });

    return {
      userColumns,
      userData,
      userTotal,
      pageSize,
      handleUserPageChange,
      articleColumns,
      articleData,
      articleTotal,
      handleArticlePageChange,
      messageColumns,
      messageData,
      messageTotal,
      handleMessagePageChange,
      increasePermission,
      decreasePermission,
      viewArticleDetail,
      sendToDraft,
      republishArticle,
      deleteArticle,
      viewDetails,
      republishMessage,
      deleteMessage,
      detailsModalVisible,
      modalData,
      handleModalOk,
      handleModalCancel
    };
  }
});
</script>

<style scoped>
.content {
  padding: 20px;
  background-color: #f0f0f0;
}
.table-container {
  margin-bottom: 20px;
  width: 80%;
  margin: 0 auto;
}
.custom-page {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
.custom-page .ivu-page {
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  padding: 5px 10px;
}
.custom-page .ivu-page-item {
  margin: 0 5px;
}
.custom-page .ivu-page-prev,
.custom-page .ivu-page-next {
  background-color: #f0f0f0;
  color: #000;
}
.custom-page .ivu-page-item-active {
  background-color: #5c6bc0;
  color: #fff;
}
</style>
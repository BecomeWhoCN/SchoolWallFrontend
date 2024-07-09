<template>
  <Header />
  <div class="page-container">
    <h1 class="main-title">文章管理页面</h1>
    <Card title="" class="table-card">
      <h2>已发布文章管理</h2>
      <div class="table-container">
        <Table border :columns="publishedColumns" :data="publishedData" :scroll="{ x: 1300 }">
          <template #postTitle="{ row }">
            <strong class="ellipsis">{{ row.postTitle }}</strong>
          </template>
          <template #action="{ row }">
            <Button type="primary" size="small" style="margin-right: 5px" @click="backToDraft(row.postId)">回草</Button>
            <Button type="info" size="small" style="margin-right: 5px" @click="editArticle(row)">查看/修改</Button>
            <Button type="error" size="small" @click="deleteArticle(row)">删除</Button>
          </template>
        </Table>
      </div>
      <Page class="fenye" :total="publishedTotal" :page-size="pageSize" @on-change="handlePublishedPageChange" />
    </Card>

    <Card title="" class="table-card">
      <h2>草稿箱文章管理</h2>
      <div class="table-container">
        <Table border :columns="draftColumns" :data="draftData" :scroll="{ x: 1300 }">
          <template #postTitle="{ row }">
            <strong class="ellipsis">{{ row.postTitle }}</strong>
          </template>
          <template #action="{ row }">
            <Button type="success" size="small" style="margin-right: 5px" @click="publishArticle(row.postId)">发布</Button>
            <Button type="info" size="small" style="margin-right: 5px" @click="editArticle(row)">查看/修改</Button>
            <Button type="error" size="small" @click="deleteArticle(row)">删除</Button>
          </template>
        </Table>
      </div>
      <Page class="fenye" :total="draftTotal" :page-size="pageSize" @on-change="handleDraftPageChange" />
    </Card>
    <Button @click="addEssay" class="floating-button" type="success" shape="circle" icon="md-add">添加文章</Button>
    <Tooltip style="zoom:0.8;top:100px;left:40px" class="backhome" content="返回首页" placement="top-start">
      <Button style="zoom:1.5" @click="backHome" shape="circle" icon="md-backspace"></Button>
    </Tooltip>
    <Footer />
  </div>
</template>

<script>
import Header from '@/components/aresources/PageHead.vue';
import Footer from '@/components/aresources/PageFoot.vue';
import Cookies from 'js-cookie';
import axios from 'axios';

export default {
  components: { Header, Footer },
  data() {
    return {
      pageSize: 10,
      publishedTotal: 0,
      draftTotal: 0,
      publishedData: [],
      draftData: [],
      publishedColumns: [
      { title: '标题', slot: 'postTitle', fixed: 'left', width: 200 },
        { title: '概要', key: 'postSummary', width: 150 },
        { title: '创建时间', key: 'postCreatedAt', width: 150 },
        { title: '更新时间', key: 'postUpdatedAt', width: 150 },
        { title: '状态', key: 'postStatus', width: 150 },
        { title: '操作', slot: 'action', width: 250, align: 'center', fixed: 'right' },
      ],
      draftColumns: [
        { title: '标题', slot: 'postTitle', fixed: 'left', width: 200 },
        { title: '概要', key: 'postSummary', width: 150 },
        { title: '创建时间', key: 'postCreatedAt', width: 150 },
        { title: '更新时间', key: 'postUpdatedAt', width: 150 },
        { title: '状态', key: 'postStatus', width: 150 },
        { title: '操作', slot: 'action', width: 250, align: 'center', fixed: 'right' },
      ],
    };
  },
  mounted() {
    this.fetchPublishedData(1);
    this.fetchDraftData(1);
  },
  methods: {
    fetchPublishedData(page) {
      const userId = Cookies.get('userId');
      const formData = new FormData();
      formData.append('userId', userId);
      axios.post('/api/scPosts/selectArticleAll', formData)
        .then(response => {
          console.log('查询文章成功:', response.data);
          const datas = response.data.data;
          this.publishedTotal = datas.length;
          const data = datas.slice((page - 1) * this.pageSize, page * this.pageSize).map(Article => ({
            postTitle: Article.postTitle,
            postSummary: Article.postSummary,
            postCreatedAt: Article.postCreatedAt,
            postUpdatedAt: Article.postUpdatedAt,
            postStatus: Article.postStatus,
            postId: Article.postId,
            postContentUrl:Article.postContentUrl,
            postHeaderImageUrl:Article.postHeaderImageUrl
          }));
          this.publishedData = data;
        })
        .catch(error => {
          console.error('查询文章失败:', error);
          this.$Message.error('文章查询失败');
        });
    },
    fetchDraftData(page) {
      const userId = Cookies.get('userId');
      const formData = new FormData();
      formData.append('userId', userId);
      axios.post('/api/scPosts/selectDraftAll', formData)
        .then(response => {
          console.log('查询草稿成功:', response.data);
          const drafts = response.data.data;
          this.draftTotal = drafts.length;
          const data = drafts.slice((page - 1) * this.pageSize, page * this.pageSize).map(draft => ({
            postTitle: draft.postTitle,
            postSummary: draft.postSummary,
            postCreatedAt: draft.postCreatedAt,
            postUpdatedAt: draft.postUpdatedAt,
            postStatus: draft.postStatus,
            postId: draft.postId,
            postContentUrl:draft.postContentUrl,
            postHeaderImageUrl:draft.postHeaderImageUrl
          }));
          this.draftData = data;
        })
        .catch(error => {
          console.error('查询草稿失败:', error);
          this.$Message.error('文章查询失败');
        });
    },
    handlePublishedPageChange(page) {
      this.fetchPublishedData(page);
    },
    handleDraftPageChange(page) {
      this.fetchDraftData(page);
    },
    backToDraft(postId) {
      this.$Modal.confirm({
           title: '回草',
           content: '<h2>是否确认回草<h2/>',
          onOk: () => {
          const formData = new FormData();
          formData.append('postId', postId);
          axios.post('/api/scPosts/backDraft', formData)
         .then(response => {
          if(response.data.success==true){
            window.location.reload();  // 刷新页面
            this.$Message.info('已回草');
          
          }
          else{
            this.$Message.info('回草失败');
          }
        })
        .catch(error => {
          console.error('查回草失败:', error);
          this.$Message.info('回草失败');
        });
                    },
          onCancel: () => {
         this.$Message.info('回草取消');
                    }
                });
      // this.$Modal.info({
      //   title: '操作确认',
      //   content: `已发布文章 ID: ${postId} 已回草`,
      // });
    },
    publishArticle(postId) {
      this.$Modal.confirm({
           title: '发布',
           content: '<h2>是否确认发布<h2/>',
          onOk: () => {
          const formData = new FormData();
          formData.append('postId', postId);
          axios.post('/api/scPosts/releaseArticle', formData)
         .then(response => {
          if(response.data.success==true){
            window.location.reload(); // 刷新页面
            this.$Message.info('已发布');
            
          }
          else{
            this.$Message.info('发布失败');
          }
        })
        .catch(error => {
          console.error('发布失败:', error);
          this.$Message.info('发布失败');
        });
                    },
          onCancel: () => {
         this.$Message.info('发布取消');
                    }
                });
    },
    editArticle(row) {
      const postId=row.postId;
      const postContentUrl=row.postContentUrl;
      const postHeaderImageUrl=row.postHeaderImageUrl;
      const postTitle=row.postTitle;
      const postSummary=row.postSummary;
      const postCreatedAt=row.postCreatedAt;
      const postUpdatedAt=row.postUpdatedAt;
      const postStatus=row.postStatus;
      this.$router.push({name:"edit-essay",params:{postId:postId, postContentUrl:postContentUrl,postHeaderImageUrl:postHeaderImageUrl,postTitle:postTitle,postSummary:postSummary,postCreatedAt:postCreatedAt,postUpdatedAt:postUpdatedAt,postStatus:postStatus}});
    },
    deleteArticle(row) {
      this.$Modal.confirm({
           title: '删除',
           content: `<h2>是否确认删除 标题为 ${row.postTitle}的文章<h2/>`,
          onOk: () => {
          const postId=row.postId;
          const postContentUrl=row.postContentUrl;
          const postHeaderImageUrl=row.postHeaderImageUrl;

          const formData = new FormData();

          formData.append('postId',postId);
          formData.append('postContentUrl',postContentUrl);
          formData.append('postHeaderImageUrl',postHeaderImageUrl);
          axios.post('/api/scPosts/deleteArticle',formData)
         .then(response => {
          if(response.data.success==true){
            window.location.reload();// 刷新页面
            this.$Message.info('已删除');
          }else
          {
            this.$Message.info('找不到对应的数据，数据库中已经没有了');
          }
        })
        .catch(error => {
          console.error('删除失败:', error);
          this.$Message.info('删除失败');
        });
                    },
          onCancel: () => {
         this.$Message.info('删除取消');
                    }                            
                });
    },
    // publishArticle(postId) {
    //   this.$Modal.info({
    //     title: '操作确认',
    //     content: `草稿箱文章 ID: ${postId} 已发布`,
    //   });
    // },
    addEssay() {
      this.$router.push('/edit-essay');
    },
    backHome() {
      this.$router.push('/');
    },
  },
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
.ellipsis {
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 100%;
}
.floating-button {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
}
.backhome {
  position: fixed;
  top: 80px;
  left: 20px;
}
@media (max-width: 768px) {
  .table-container {
    zoom: 0.7;
  }
  h2,
  h1 {
    zoom: 0.7;
  }
  .fenye {
    zoom: 0.7;
  }
}
@media (max-width: 450px) {
  .table-container {
    zoom: 0.5;
  }
  h2,
  h1 {
    zoom: 0.7;
  }
  .fenye {
    zoom: 0.7;
  }
}
</style>
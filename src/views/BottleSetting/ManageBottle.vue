<template>
<Headers/>
  <div class="page-container">
    <h1 class="main-title">个人漂流瓶管理页面</h1>
    <Button @click="backhome" class="backhome" shape="circle" icon="md-backspace"></Button>
    <Card title="" class="table-card">
        <h2>已发布的瓶子</h2>
      <div class="table-container">
        <Table border :columns="publishedColumns" :data="publishedData" :scroll="{ x: 1300 }">
          <template #title="{ row }">
            <strong class="ellipsis">{{ row.title }}</strong>
          </template>
          <template class="button-group" #action="{ row, index }">
            <Button type="primary" size="small" style="margin-right: 5px" @click="backToDraft(index)">回草</Button>
            <Button type="info" size="small" style="margin-right: 5px" @click="editArticle(index)">修改</Button>
            <Button type="error" size="small" @click="deleteArticle(index)">删除</Button>
          </template>
        </Table>
      </div>
      <Page class="fenye" :total="publishedTotal" :page-size="pageSize" @on-change="handlePublishedPageChange" />
    </Card>
  </div>
<Footers/>
</template>

<script>
import Headers from '@/components/aresources/PageHead.vue'
import Footers from '@/components/aresources/PageFoot.vue'

export default {
  components: {
    Headers,Footers
  },
  data() {
    return {
      pageSize: 10,
      publishedTotal: 30,
      draftTotal: 20,
      publishedData: this.getPublishedData(1),
      draftData: this.getDraftData(1),
      publishedColumns: [
        {
          title: '标题',
          slot: 'title',
          fixed: 'left',
          width: 200,
          render: (h, params) => {
            return h(
              'span',
              {
                class: 'ellipsis',
                style: { width: '100px' }
              },
              params.row.title
            );
          }
        },
        {
          title: '作者',
          key: 'author',
          width: 150
        },
        {
          title: '操作',
          slot: 'action',
          width: 250,
          align: 'center',
          fixed: 'right'
        }
      ],
      draftColumns: [
        {
          title: '标题',
          slot: 'title',
          fixed: 'left',
          width: 200,
          render: (h, params) => {
            return h(
              'span',
              {
                class: 'ellipsis',
                style: { width: '100px' }
              },
              params.row.title
            );
          }
        },
        {
          title: '作者',
          key: 'author',
          width: 150
        },
        {
          title: '操作',
          slot: 'action',
          width: 250,
          align: 'center',
          fixed: 'right'
        }
      ]
    };
  },
  methods: {
    getPublishedData(page) {
      const data = [];
      for (let i = 1; i <= this.pageSize; i++) {
        const index = (page - 1) * this.pageSize + i;
        data.push({
          title: `已发布文章 ${index}`,
          author: `作者 ${index}`
        });
      }
      return data;
    },
    getDraftData(page) {
      const data = [];
      for (let i = 1; i <= this.pageSize; i++) {
        const index = (page - 1) * this.pageSize + i;
        data.push({
          title: `草稿箱文章 ${index}`,
          author: `作者 ${index}`
        });
      }
      return data;
    },
    handlePublishedPageChange(page) {
      this.publishedData = this.getPublishedData(page);
    },
    handleDraftPageChange(page) {
      this.draftData = this.getDraftData(page);
    },
    backToDraft(index) {
      this.$Modal.info({
        title: '操作确认',
        content: `已发布文章 "${this.publishedData[index].title}" 已回草`
      });
    },
    editArticle(index) {
      this.$Modal.info({
        title: '操作确认',
        content: `修改文章 "${this.publishedData[index].title}"`
      });
    },
    deleteArticle(index) {
      this.publishedData.splice(index, 1);
      this.$Message.success('删除成功');
    },
    publishArticle(index) {
      this.$Modal.info({
        title: '操作确认',
        content: `草稿箱文章 "${this.draftData[index].title}" 已发布`
      });
    },
    backhome(){
      this.$router.push('/bottle-index')
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

.ellipsis {
  display: inline-block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  width: 100%;
}

.backhome {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
}

@media (max-width: 768px) {
  .table-container {
    zoom: 0.7;
    
  }

  h2,h1 {
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

  h2,h1 {
    zoom: 0.7;
  }

  .fenye {
    zoom: 0.7;
  }


}
</style>
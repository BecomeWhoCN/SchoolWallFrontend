<template>
    <div class="essay-preview-content">
        <img :src="essay.postHeaderImageUrl" alt="Post Header Image">
    
        <div class="Avatar">
            <Avatar class="userAvatar" icon="ios-person" size="large" :src="essay.scUserAvatars" />
            <span>创建者：{{ essay.userName }}</span><br>
            <span class="createtime">创建时间：{{ essay.postCreatedAt }}</span>
        </div>
    
        <center><h2>{{ essay.postTitle }}</h2></center>
        <p class="post_summary">文章简介：{{ essay.postSummary }}</p>
    
        <div id="vditor-preview"></div>
    </div>
</template>

<script>
import axios from 'axios';
import Vditor from 'vditor';
import 'vditor/dist/index.css';

export default {
    props: {
        id: {
            type: Number,
            required: true,
            default: 1 // 默认文章 ID
        }
    },
    data() {
        return {
            essay: {},
            postId: null,
        }
    },
    watch: {
        id(newId) {
            this.fetchEssay(newId);
        }
    },
    methods: {
        async fetchEssay(id) {
            try {
                const response = await axios.get(`/api/scPosts/selectOne?postId=${id}`);
                this.essay = response.data.data;
                this.loadArticleContent(this.essay);
            } catch (error) {
                console.error('加载文章信息失败:', error);
            }
        },
        async loadArticleContent(essay) {
            try {
                const response = await axios.get(essay.postContentUrl);
                Vditor.preview(document.getElementById('vditor-preview'), response.data, {
                    theme: 'dark',
                });
            } catch (error) {
                console.error('加载Markdown内容失败:', error);
            }
        }
    },
    mounted() {
        const postId = this.$route.query.postId;
        if (postId) {
            this.fetchEssay(postId);
        } else {
            console.error('未提供postId');
        }
    }
}
</script>

<style scoped>
* {
    margin: 0px;
    padding: 0px;
}

.essay-preview-content {
    max-width: 800px;
    padding: 20px;
    margin: 0 auto;
}

h2 {
    margin-top: 0;
}

.userAvatar {
    zoom: 1.1;
    float: left;
}

.Avatar {
    margin-top: 20px;
    margin-bottom: 25px;
}

.createtime {
    font-size: 12px;
    color: rgb(139, 139, 139);
}

.post_summary {
    padding: 10px 20px;
    margin: 10px 0;
    border-left: 4px solid #d0d0d0;
    background-color: #f9f9f9;
    font-style: italic;
    color: #555;
}
</style>
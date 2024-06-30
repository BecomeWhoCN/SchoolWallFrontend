<template>
    <div class="app-container">
        <PageHead/>

        <main class="main-content">

            <!-- 首页大图 -->
            <div class="index-banner">
                <h1>欢迎来到校园墙，今天要分享什么呢？</h1>
                <p>滴滴~ 美好生活记录一下~</p>
            </div>

        </main>
        

        <PageFoot/>
    </div>
</template>

<script>
import { Row, Col } from 'view-ui-plus'
import PageHead from '@/components/aresources/PageHead.vue'
import PageFoot from '@/components/aresources/PageFoot.vue'

export default {
    components: {
        Row,
        Col,
        PageHead,
        PageFoot
    }
}
</script>

<style>
html, body, #app {
  height: 100%;
  margin: 0;
}

.app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
}

.index-banner {
    background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('@/assets/background/indexHeadBackGround.jpg');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
    height: 400px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: white;
    font-size: 30px;
    text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.5);
}

.index-banner > h1 {
  font-size: 50px;
  font-weight: 600;
  margin: 0;
  padding: 0;
  text-align: center;
}

.index-banner > p {
    font-size: 20px;
    font-weight: 400;
    margin-top: 20px;
    text-align: center;
}
</style>

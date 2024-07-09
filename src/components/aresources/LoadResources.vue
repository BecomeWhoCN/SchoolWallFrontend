<template>
  <transition name="fade">
    <div class="loader" v-if="isLoading">
      <div class="spinner-container">
        <div class="logo-container">
          <img :src="selectedTemplate.logo" />
        </div>
        <swapping-squares-spinner
          :animation-duration="1000"
          :size="30"
          color="#483D8B"
        />
        <div class="text-container">
          <span class="text">{{ selectedTemplate.text }}</span>
          <br>
          <span class="text1">{{ selectedTemplate.text1 }}</span>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import { SwappingSquaresSpinner } from 'epic-spinners';

export default {
  name: 'LoadResources',
  components: {
    SwappingSquaresSpinner
  },
  props: {
    isLoading: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      templates: [
        { logo: require('@/assets/aresources/logo/logo_brown_bear.png'), text: '管理我的农场中…', text1: '熊先生有个农场每天都很忙' },
        { logo: require('@/assets/aresources/logo/logo_sheep.png'), text: '思考怎么越过栅栏', text1: '新鲜的草最能唤醒美好一天' },
        { logo: require('@/assets/aresources/logo/logo_duck.png'), text: '今天应该怎么捣乱', text1: '喜欢捣乱是鸭子的本职好吧' },
      ],
      selectedTemplate: {}
    };
  },
  created() {
    this.selectedTemplate = this.templates[Math.floor(Math.random() * this.templates.length)];
  }
};
</script>

<style scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
.loader {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.2);
}
.spinner-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: #eee;
  border-radius: 10px;
  width: 200px;
  height: 200px;
  overflow: auto;
}
.logo-container img {
  width: 70px;
  height: 60px;
}
.text-container {
  width: 100%;
  text-align: center;
  word-wrap: break-word;
  margin-top: 10px;
  font-size: 18px;
  font-weight: bold;
  line-height: 1.2;
}
.text1 {
  font-size: 14px;
  font-weight: bold;
  line-height: 0.8;
}
</style>

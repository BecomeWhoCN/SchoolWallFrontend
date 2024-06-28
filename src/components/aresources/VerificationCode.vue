<template>
    <div>
      <slide-verify
        ref="slideVerify"
        :l="42"
        :w="310"
        :h="155"
        :imgs="['https://yourimageurl1.jpg', 'https://yourimageurl2.jpg']"
        @success="handleSuccess"
        @fail="handleFail"
        @refresh="handleRefresh"
      ></slide-verify>
    </div>
  </template>
  
  <script>
  import SlideVerify from 'vue-monoplasty-slide-verify';
  
  export default {
    components: {
      SlideVerify
    },
    methods: {
      handleSuccess() {
        this.$emit('verified', true);
      },
      handleFail() {
        this.$emit('verified', false);
      },
      handleRefresh() {
        // 实现刷新方法
        console.log('Captcha refreshed');
      }
    }
  }
  </script>
  
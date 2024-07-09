<template>
  <div class="footer-wrapper">
    <span>备案号(xxxxxx)</span>
    <span class="separator">|</span>
    <span>© 2024 校园墙. All rights reserved.</span>
  </div>
</template>

<script>
export default {
  name: 'Footer'
};
</script>

<style scoped>
.footer-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  background-color: #f5f5f5;
  border-top: 1px solid #ddd;
  font-size: 14px;
  color: #666;
}

.separator {
  margin: 0 10px;
}
</style>

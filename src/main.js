import { createApp } from 'vue';
import ViewUIPlus from 'view-ui-plus';
import App from './App.vue';
import router from './router';
import store from './store';
import './styles/index.less';
import SlideVerify from 'vue-monoplasty-slide-verify';


const app = createApp(App);

app.use(store)
  .use(router)
  .use(ViewUIPlus)
  .use(SlideVerify)
  .mount('#app');

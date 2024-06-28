import { createRouter, createWebHistory } from 'vue-router'
import indexView from '@/views/indexView.vue'
import LoginResource from '@/views/LoginResource.vue'
import UploadAvatat from '@/views/UploadAvatar.vue'


const apiAddress = 'http://192.168.12.225:8081/';
export { apiAddress };
const routes = [
  {
    path: '/',
    name: 'indexView',
    component: indexView
  },
  {
    path: '/login-resource',
    name: 'login-resource',
    component: LoginResource
  
  },
  {
    path: '/upload-avatar',
    name: 'upload-avatar',
    component: UploadAvatat
  }
]

const router = createRouter({
  routes,
  history: createWebHistory(process.env.BASE_URL),
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router

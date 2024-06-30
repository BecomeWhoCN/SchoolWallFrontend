import { createRouter, createWebHistory } from 'vue-router'
import indexView from '@/views/indexView.vue'
import LoginResource from '@/views/LoginResource.vue'
import ChangePassword from '@/views/UserSetting/ChangePassword.vue'
import updateUsermessage from '@/views/UserSetting/updateUsermessage.vue'


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
    path: '/user-settings/change-password',
    name: 'change-password',
    component: ChangePassword
  },{
    path: '/user-settings/update-usermessage',
    name: 'update-usermessage',
    component: updateUsermessage
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

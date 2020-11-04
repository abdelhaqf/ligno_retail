import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Input',
    component: () => import('../views/PageInput')
  },
  {
    path: '/ambil',
    name: 'Ambil',
    component: () => import('../views/PageAmbil')
  },
]

const router = new VueRouter({
  routes
})

export default router

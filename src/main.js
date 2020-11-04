import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './quasar'

import Vue2Filters from 'vue2-filters'
Vue.use(Vue2Filters)

Vue.use(require('vue-moment'));

import axios from 'axios'
Vue.prototype.$http = axios.create({
  baseURL: "http://localhost/LONG/ligno_retail/api",
});

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

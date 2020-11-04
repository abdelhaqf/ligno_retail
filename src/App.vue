<template>
  <q-layout view="hHh lpR fFf" class="bg-grey-11">
    <q-page-container>
      <!-- top toolbar -->
      <q-toolbar class="bg-blue-9 text-white">
        <q-toolbar-title> <strong>Ligno</strong> Retail </q-toolbar-title>
        <q-space />
        <!-- links -->
        <q-btn stretch flat label="INPUT" to="/" />
        <q-btn stretch flat label="PENGAMBILAN" to="/ambil" />
        <q-btn stretch flat label="LAPORAN" to="/laporan" />
      </q-toolbar>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
export default {
  name: "LayoutDefault",

  data() {
    return {};
  },
};
</script>

<style></style>

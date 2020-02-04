<template>
  <div id="app">
    <DoseCommunity />
  </div>
</template>

<script>
import DoseCommunity from "./components/DoseCommunity.vue";

export default {
  name: "app",
  components: {
    DoseCommunity
  }
};
</script>

<style>
body {
  background-color: #f1eded;
}
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>

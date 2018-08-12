<template>
  <div class="title">
    {{ message }}
  </div>
</template>

<script lang="ts">
  import Vue from 'vue'

  export default Vue.extend({
    data: function (): object {
      return {
        message: 'Hello Vue with TypeScript'
      }
    },
  })
</script>

<style scoped>
  .title {
    font-size: 2rem;
    text-align: center;
  }
</style>

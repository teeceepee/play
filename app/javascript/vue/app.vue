<template>
  <div class="title">
    {{ message }}
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue"
    }
  }
}
</script>

<style scoped>
.title {
  font-size: 3rem;
  text-align: center;
}
</style>

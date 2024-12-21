<script setup lang="ts">
definePageMeta({
  colorMode: 'dark',
})

const page = {
  title: 'DAO',
  description: 'DAO',
}

useSeoMeta({
  title: page.title,
  ogTitle: page.title,
  description: page.description,
  ogDescription: page.description,
})
</script>

<template>
  <UMain>
    <DaoMintToken />
    <DaoVip class="mb-20" />
    <DaoStats />
    <DaoLead />
    <DaoTeam />
  </UMain>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'saas',
  colorMode: 'dark',
})
const { t } = $(useI18n())
const localePath = useLocalePath()

const route = useRoute()
// const { data: page } = $(await useAsyncData(route.path, () => queryContent(route.path).findOne()))
// if (!page) {
//   throw createError({ statusCode: 404, statusMessage: t('Page not found'), fatal: true })
// }

const { booking: page } = $(pageStore())


useSeoMeta({
  title: page.title,
  description: page.description,
})

const { data: posts } = await useFetch('/api/bnb3')
</script>

<template>
  <UContainer>
    <UPageHeader v-bind="page" class="py-[50px]">
      <template #links>
        <UButton 
          :to="localePath('/booking/submit')"
          icon="material-symbols:add-2"
          size="lg"
        >
          {{ $t('Submit Your B&B') }}
        </UButton>
      </template>
    </UPageHeader>
    <UPageBody>
      <div class="mx-auto max-w-2xl px-2 py-8 sm:px-0 sm:py-12 lg:max-w-7xl lg:px-0">
        <h2 class="sr-only">{{ page.description }}</h2>

        <div class="grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3">
          <NuxtLinkLocale v-for="item in posts.data" :key="item.id" :to="`/booking/${item.id}`" class="group">
            <div
              class="aspect-h-1 aspect-w-1 w-full overflow-hidden rounded-lg bg-gray-700 xl:aspect-h-8 xl:aspect-w-7">
              <img :src="item.thumbnail" :alt="item.title"
                class="h-full w-full object-cover object-center group-hover:opacity-75" />
            </div>
            <h3 class="mt-4 text-primary-600 font-bold">{{ item.label }}</h3>
            <h4 class="text-gray-500">{{ item.title }}</h4>
            <h4 class="text-gray-500">{{ item.meta }}</h4>
            <p class="mt-1 text-lg font-medium text-white">{{ item.price }} $BST</p>
          </NuxtLinkLocale>
        </div>
      </div>
    </UPageBody>
  </UContainer>
</template>
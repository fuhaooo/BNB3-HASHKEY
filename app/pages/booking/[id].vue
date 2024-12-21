<script setup lang="ts">
definePageMeta({
  colorMode: 'dark',
  layout: 'saas',
})
import { withoutTrailingSlash, joinURL } from 'ufo'
const route = useRoute()
const localePath = useLocalePath()
const thePath = computed(() => localePath(route.path))

const { data: post } = $(await useFetch(`/api/bnb3/${route.params.id}`))
if (!post) {
  throw createError({
    statusCode: 404,
    statusMessage: 'Listing not found',
    fatal: true,
  })
}

const { doSubmit, dateRange, days, reviews, setPostData, total } = $(bnb3MintCreatorTokenStore())

watchEffect(() => {
  setPostData(post)
})

// const { data: surround } = await useAsyncData(`${thePath}-surround`, () => queryContent(localePath('/booking'))
//   .where({ _extension: 'md' })
//   .without(['body', 'excerpt'])
//   .sort({ date: -1 })
//   .findSurround(withoutTrailingSlash(route.path))
//   , { default: () => [] })

const title = computed(() => post.head?.title || post.title)
const description = computed(() => post.head?.description || post.description)

useSeoMeta({
  title,
  ogTitle: title,
  description,
  ogDescription: description,
})

if (post.image?.src) {
  const site = useSiteConfig()

  useSeoMeta({
    ogImage: joinURL(site.url, post.image.src),
    twitterImage: joinURL(site.url, post.image.src),
  })
} else {
  defineOgImage({
    component: 'Saas',
    title,
    description,
    headline: 'Blog',
  })
}


</script>
<template>
  <UContainer>
    <div class="pt-6">
      <nav aria-label="Breadcrumb">
        <ol
          role="list"
          class="mx-auto flex max-w-2xl items-center space-x-2 lg:max-w-7xl"
        >
          <li>
            <div class="flex items-center">
              <NuxtLink
                :to="localePath('/booking')"
                class="mr-2 font-medium text-gray-500"
                >{{ $t('Booking') }}
              </NuxtLink>
              <svg
                width="16"
                height="20"
                viewBox="0 0 16 20"
                fill="currentColor"
                aria-hidden="true"
                class="h-5 w-4 text-gray-700"
              >
                <path d="M5.697 4.34L8.98 16.532h1.327L7.025 4.341H5.697z" />
              </svg>
            </div>
          </li>
          <li class="">
            <NuxtLink
              :to="localePath(route.path)"
              aria-current="page"
              class="font-medium text-gray-500 hover:text-gray-400"
              >{{ post.label }}</NuxtLink
            >
          </li>
        </ol>
      </nav>
      <div
        class="mx-auto mt-6 max-w-2xl lg:grid lg:max-w-7xl lg:grid-cols-3 lg:gap-x-8"
      >
        <div
          class="aspect-h-4 aspect-w-3 hidden overflow-hidden rounded-lg lg:block"
        >
          <img
            :src="post.images[0]"
            class="h-full w-full object-cover object-center"
          />
        </div>
        <div class="hidden lg:grid lg:grid-cols-1 lg:gap-y-8">
          <div class="aspect-h-2 aspect-w-3 overflow-hidden rounded-lg">
            <img
              :src="post.images[1]"
              class="h-full w-full object-cover object-center"
            />
          </div>
          <div class="aspect-h-2 aspect-w-3 overflow-hidden rounded-lg">
            <img
              :src="post.images[2]"
              class="h-full w-full object-cover object-center"
            />
          </div>
        </div>
        <div
          class="aspect-h-5 aspect-w-4 lg:aspect-h-4 lg:aspect-w-3 sm:overflow-hidden sm:rounded-lg"
        >
          <img
            :src="post.images[3]"
            class="h-full w-full object-cover object-center"
          />
        </div>
      </div>

      <UPage :ui="{ wrapper: 'lg:grid-cols-12', right: 'lg:col-span-4' }">
        <UPageBody prose>
          <div class="flex items-center justify-between">
            <h1 class="font-bold tracking-tight text-gray-500">
              {{ post.title }}
            </h1>
          </div>
          <!-- <ContentRenderer v-if="post && post.body" :value="post" /> -->
          <!-- <v-md-preview v-if="post.body" :text="post.body" :class="true ? '' : 'border rounded-md border-gray-3 shadow mt-10 p-5'" /> -->
          {{ post.body }}
        </UPageBody>
        <template #right>
          <UCard class="mt-10">
            <template #header>
              <p class="text-3xl tracking-tight text-gray-500">
                {{ post.price }} $BST
                <span class="text-gray-500 text-xl">night</span>
              </p>
            </template>
            <DateRange v-model="dateRange" />
            <div
              class="text-2xl tracking-tight text-gray-100 flex justify-between items-center pt-6"
            >
              <div>Days:</div>
              <div>
                {{ days }}
              </div>
            </div>
            <template #footer>
              <div
                class="text-2xl tracking-tight text-gray-100 flex justify-between items-center pt-6"
              >
                <div>Total:</div>
                <div>{{ total }} $BST</div>
              </div>
              <UButton class="mt-4" block color="primary" @click="doSubmit"
                >Reserve</UButton
              >
            </template>
          </UCard>
          <div class="flex items-center mt-10">
            <h3 class="sr-only">Reviews</h3>
            <div class="flex items-center">
              <div class="flex items-center">
                <UIcon
                  name="material-symbols:star"
                  v-for="rating in [0, 1, 2, 3, 4]"
                  :key="rating"
                  :class="[
                    reviews.average > rating
                      ? 'text-gray-100'
                      : 'text-gray-700',
                    'h-5 w-5 flex-shrink-0',
                  ]"
                  aria-hidden="true"
                />
              </div>
              <p class="sr-only">{{ reviews.average }} out of 5 stars</p>
              <a
                :href="reviews.href"
                class="ml-3 font-medium text-primary-600 hover:text-primary-500"
                >{{ reviews.totalCount }} reviews</a
              >
            </div>
          </div>
        </template>
      </UPage>
      <!-- <UContentSurround :surround="surround" class="my-10" /> -->
      <br />
    </div>
  </UContainer>
</template>

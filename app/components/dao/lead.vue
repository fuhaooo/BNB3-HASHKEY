
<script setup lang="ts">
const people = [
  {
    name: 'Stark',
    okr: 'https://github.com/BnB3DAO/Press-Conference/issues/created_by/HelloRWA',
    role: 'Full Stack Web3 Geek',
    imageUrl:
      'https://pbs.twimg.com/profile_images/1707609069618663424/hIL8KtSB_400x400.jpg',
  },
  {
    name: 'Alfred Fu',
    okr: 'https://github.com/BnB3DAO/Press-Conference/issues/created_by/fuhaooo',
    role: 'Web3 Beginner',
    imageUrl:
      'https://pbs.twimg.com/profile_images/1422717363611262978/O7gtcDy0_400x400.jpg',
  },
  {
    name: 'Secret',
    okr: 'https://github.com/BnB3DAO/Press-Conference/issues/created_by/Secret1007',
    role: 'Web3 Explorer',
    imageUrl:
      'https://avatars.githubusercontent.com/u/87068106?v=4',
  },
  {
    name: 'Walter',
    okr: 'https://github.com/BnB3DAO/Press-Conference/issues/created_by/bcma2333',
    role: 'Frontend Engineer',
    imageUrl:
      'https://avatars.githubusercontent.com/u/49505513?v=4',
  },
  {
    name: 'Gills',
    okr: 'https://github.com/BnB3DAO/Press-Conference/issues/created_by/gillsgills',
    role: 'Blue-Collar Researcher',
    imageUrl:
      'https://pbs.twimg.com/profile_images/1455137148345241606/bZljHsr5_400x400.jpg',
  },
]
</script>

<template>
  <div class="py-24 sm:py-32">
    <div class="mx-auto grid max-w-7xl gap-20 px-6 lg:px-8 xl:grid-cols-3">
      <div class="max-w-xl">
        <h2
          class="text-pretty text-3xl font-semibold tracking-tight text-gray-100 sm:text-4xl"
        >
          Meet our Committee Members
        </h2>
        <p class="mt-6 text-lg/8 text-gray-400">
          Our committee membership is dynamic and updated periodically based on
          contribution activity levels. Members are selected according to their
          engagement and contributions during the most recent evaluation period.
        </p>
      </div>
      <ul
        role="list"
        class="grid gap-x-8 gap-y-12 sm:grid-cols-2 sm:gap-y-16 xl:col-span-2"
      >
        <li v-for="person in people" :key="person.name">
          <a
            :href="person.okr"
            target="_blank"
            class="flex items-center gap-x-6 hover:opacity-80 hover:underline"
          >
            <img class="size-16 rounded-full" :src="person.imageUrl" alt="" />
            <div>
              <h3
                class="text-base/7 font-semibold tracking-tight text-gray-100"
              >
                {{ person.name }}
              </h3>
              <p class="text-sm/6 font-semibold text-red-400">
                {{ person.role }}
              </p>
            </div>
          </a>
        </li>
      </ul>
    </div>
  </div>
</template>

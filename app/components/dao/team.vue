<script setup lang="ts">
let people = [
  {
    name: 'Stark',
    url: 'https://x.com/StarkEVM99',
    role: 'Full Stack Web3 Geek',
    imageUrl:
      'https://pbs.twimg.com/profile_images/1707609069618663424/hIL8KtSB_400x400.jpg',
  },
  {
    name: 'Alfred Fu',
    url: 'https://x.com/Alfredfuuu',
    role: 'Web3 Beginner',
    imageUrl: 'https://pbs.twimg.com/profile_images/1422717363611262978/O7gtcDy0_400x400.jpg',
  },
  {
    name: 'Secret',
    url: 'https://x.com/secret_sun85934',
    role: 'Web3 Explorer',
    imageUrl: 'https://pbs.twimg.com/profile_images/1803639917651828741/IOqGXtAu_400x400.jpg',
  },
  {
    name: 'Walter',
    url: 'https://x.com/WalterPottery',
    role: 'A thinker about to the new world',
    imageUrl: 'https://avatars.githubusercontent.com/u/49505513?v=4',
  },
  {
    name: '狠咸蛋酶控',
    url: 'https://x.com/mianan_n',
    role: 'Explorer',
    imageUrl: 'https://pbs.twimg.com/profile_images/1858984111194730496/eHZ1t9Dd_400x400.jpg',
  },
  {
    name: '卡卡',
    url: 'https://x.com/yojil341699',
    role: 'Smart Contract Developer',
    imageUrl: 'https://pbs.twimg.com/profile_images/1833311246873202688/EKHqZP2P_400x400.jpg',
  },
  {
    name: 'Felix',
    url: 'https://x.com/felix__C__',
    role: 'Full Stack Engineer',
    imageUrl: 'https://pbs.twimg.com/profile_images/1861024516274786304/n5KZJtDE_400x400.jpg',
  },
  {
    name: 'Ben',
    url: 'https://x.com/Ben171144018061',
    role: 'Front-end developer',
    imageUrl: 'https://pbs.twimg.com/profile_images/1861021171308969984/g73Qm0WX_400x400.jpg',
  },
  {
    name: 'Gills',
    url: 'https://x.com/proto10061007',
    role: 'Blue-Collar Researcher',
    imageUrl: 'https://pbs.twimg.com/profile_images/1455137148345241606/bZljHsr5_400x400.jpg',
  },
]
people = useSortBy(people, 'name')
</script>

<template>
  <div class="py-24 sm:py-32">
    <div class="mx-auto max-w-7xl px-6 lg:px-8">
      <div class="mx-auto max-w-2xl lg:mx-0">
        <h2
          class="text-pretty text-4xl font-semibold tracking-tight text-gray-100 sm:text-5xl"
        >
          Our DAO Contributors
        </h2>
        <p class="mt-6 text-lg/8 text-gray-400">
          We're a dynamic group of individuals who are passionate about BnB3DAO.
          Our DAO Contributors brings together expertise in blockchain
          technology, DeFi, community building, and sustainable development to
          drive innovation in the Web3 space.
        </p>
      </div>
      <ul
        role="list"
        class="mx-auto mt-20 grid max-w-2xl grid-cols-2 gap-x-8 gap-y-16 text-center sm:grid-cols-3 md:grid-cols-4 lg:mx-0 lg:max-w-none lg:grid-cols-5 xl:grid-cols-6"
      >
        <li v-for="person in people" :key="person.name">
          <a
            :href="person.url"
            target="_blank"
            class="hover:opacity-80 hover:underline"
          >
            <img
              class="mx-auto size-24 rounded-full"
              :src="person.imageUrl"
              alt=""
            />
            <h3
              class="mt-6 text-base/7 font-semibold tracking-tight text-gray-100"
            >
              {{ person.name }}
            </h3>
            <p class="text-sm/6 text-gray-400">{{ person.role }}</p>
          </a>
        </li>
      </ul>
    </div>
  </div>
</template>

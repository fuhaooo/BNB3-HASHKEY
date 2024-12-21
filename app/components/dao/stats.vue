<script setup lang="ts">
const stats = [
  { id: 1, name: 'Users on the platform', value: '15,000+' },
  { id: 2, name: 'Flat platform fee', value: '1%' },
  { id: 3, name: 'Community Nodes', value: '100+' },
  { id: 4, name: 'Total Value Traded', value: '10M+ $BST' },
]
</script>
<template>
  <div class="py-24 sm:py-32">
    <div class="mx-auto max-w-7xl px-6 lg:px-8">
      <div class="mx-auto max-w-2xl lg:max-w-none">
        <div class="text-center">
          <h2
            class="text-balance text-4xl font-semibold tracking-tight text-white sm:text-5xl"
          >
            Trusted by Web3 Enthusiasts Worldwide
          </h2>
          <p class="mt-4 text-lg/8 text-gray-300">
            We provide a platform for Web3 Enthusiasts to connect, collaborate,
            and build together.
          </p>
        </div>
        <dl
          class="mt-16 grid grid-cols-1 gap-0.5 overflow-hidden rounded-2xl text-center sm:grid-cols-2 lg:grid-cols-4"
        >
          <div
            v-for="stat in stats"
            :key="stat.id"
            class="flex flex-col bg-white/5 p-8"
          >
            <dt class="text-sm/6 font-semibold text-gray-300">
              {{ stat.name }}
            </dt>
            <dd
              class="order-first text-3xl font-semibold tracking-tight text-white"
            >
              {{ stat.value }}
            </dd>
          </div>
        </dl>
      </div>
    </div>
  </div>
</template>

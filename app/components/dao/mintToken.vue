<script setup lang="ts">
const { showModal } = $(daoMintTokenStore())
</script>

<template>
  <UContainer>
    <ULandingHero>
      <template #title>
        <div v-motion-slide-top v-motion-slide-visible-top>
          Take Your Step into Future
        </div>
      </template>
      <template #description>
        <p v-motion-slide-top v-motion-slide-visible-top>
          Every Web3 Citizen should have a $BnB3 to vote on your Future Journey
        </p>
      </template>
      <template #links>
        <UButton
          v-motion-slide-bottom
          v-motion-slide-visible-bottom
          @click="showModal"
          color="white"
          class="bg-rainbow font-bold flex my-20 py-3 w-80 justify-center items-center border-none rounded-2xl text-xl hover:scale-120 animate-pulse"
        >
          <UIcon
            name="i-noto-backhand-index-pointing-right"
            class="w-5 h-5 mr-2 flex"
          />
          Start Mint
        </UButton>
      </template>
      <template #bottom>
        <DaoRewardList />
      </template>
    </ULandingHero>
  </UContainer>
</template>

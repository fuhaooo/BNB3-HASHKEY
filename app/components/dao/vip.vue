<script setup lang="ts">
const { pricing: page } = $(pageStore())
const isYearly = ref(false)
</script>

<template>
  <UContainer>
    <UPricingGrid>
      <UPricingCard
        v-for="(plan, index) in page.plans"
        :key="index"
        v-bind="plan"
        :price="isYearly ? plan.price.year : plan.price.month"
        :cycle="plan.total"
      />
    </UPricingGrid>
  </UContainer>
</template>

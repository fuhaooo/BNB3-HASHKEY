<script setup lang="ts">
const { t } = $(useI18n())
let { formData, isSubmitting, doSubmit, addImageInput, removeImageInput } = $(
  bnb3CreateTokenStore(),
)

definePageMeta({
  colorMode: 'dark',
  layout: 'saas',
})

const title = $computed(() => t('Submit Your B&B'))
useSeoMeta({
  title,
})

// Import all markdown content from booking directory
// const { data: mockDataList } = await useAsyncData('booking-mocks', () =>
//   queryContent('booking').find(),
// )

const { mock: mockData } = $(pageStore())
formData = {
  title: mockData.title || '',
  label: mockData.label || '',
  description: mockData.description.overview || '',
  body: mockData.description.space || '',
  thumbnail: mockData.thumbnail || '',
  price: mockData.price?.toString() || '',
  amenities: [],
  bedrooms: mockData.meta.bedrooms,
  bathrooms: mockData.meta.baths,
  maxGuests: mockData.meta.guests,
  address: {
    street: 'the street',
    city: mockData.label?.split(', ')?.[1] || '',
    state: 'the state',
    country: mockData.label?.split(', ')?.[2] || 'Thailand',
    zipCode: '12345',
  },
  images: mockData.images || [''],
}
</script>

<template>
  <UContainer>
    <UPageHeader :title="title" class="py-[50px]" />
    <UPageBody>
      <div class="mx-auto max-w-2xl px-4 py-8">
        <form @submit.prevent="doSubmit" class="space-y-6">
          <div class="space-y-4">
            <!-- <UButton
              type="submit"
              color="primary"
              size="lg"
              block
              :loading="isSubmitting"
            >
              {{ $t('Submit Listing') }}
            </UButton> -->
            <UFormGroup :label="$t('Property Name')" required>
              <UInput v-model="formData.title" required size="xl" />
            </UFormGroup>

            <UFormGroup :label="$t('Short Label')" required>
              <UInput v-model="formData.label" required />
            </UFormGroup>

            <UFormGroup :label="$t('Description')" required>
              <UTextarea v-model="formData.description" :rows="10" required />
            </UFormGroup>

            <UFormGroup :label="$t('Body')" required>
              <UTextarea v-model="formData.body" :rows="10" required />
            </UFormGroup>

            <UFormGroup :label="$t('Thumbnail URL')" required>
              <UInput v-model="formData.thumbnail" type="url" required />
            </UFormGroup>

            <UFormGroup :label="$t('Property Images')" required>
              <div
                v-for="(image, index) in formData.images"
                :key="index"
                class="flex gap-2 mb-2"
              >
                <UInput
                  v-model="formData.images[index]"
                  type="url"
                  :placeholder="$t('Image URL')"
                  class="flex-1"
                  required
                />
                <UButton
                  v-if="index > 0"
                  color="red"
                  @click="removeImageInput(index)"
                  icon="i-heroicons-trash"
                  square
                />
              </div>
              <UButton
                size="sm"
                color="gray"
                @click="addImageInput"
                class="mt-2"
                icon="i-heroicons-plus"
              >
                {{ $t('Add Image') }}
              </UButton>
            </UFormGroup>

            <div class="grid grid-cols-2 gap-4">
              <UFormGroup :label="$t('Price')" required>
                <UInput v-model="formData.price" type="number" required />
              </UFormGroup>
            </div>

            <UFormGroup :label="$t('Additional Information')">
              <UInput v-model="formData.meta" />
            </UFormGroup>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <UFormGroup :label="$t('Bedrooms')" required>
              <UInput
                v-model="formData.bedrooms"
                type="number"
                min="1"
                required
              />
            </UFormGroup>
            <UFormGroup :label="$t('Bathrooms')" required>
              <UInput
                v-model="formData.bathrooms"
                type="number"
                min="1"
                required
              />
            </UFormGroup>
          </div>

          <UFormGroup :label="$t('Maximum Guests')" required>
            <UInput
              v-model="formData.maxGuests"
              type="number"
              min="1"
              required
            />
          </UFormGroup>

          <div class="space-y-4">
            <UFormGroup :label="$t('Address')" required>
              <UInput
                v-model="formData.address.street"
                :placeholder="$t('Street Address')"
                required
              />
              <div class="grid grid-cols-2 gap-4 mt-4">
                <UInput
                  v-model="formData.address.city"
                  :placeholder="$t('City')"
                  required
                />
                <UInput
                  v-model="formData.address.state"
                  :placeholder="$t('State/Province')"
                  required
                />
              </div>
              <div class="grid grid-cols-2 gap-4 mt-4">
                <UInput
                  v-model="formData.address.country"
                  :placeholder="$t('Country')"
                  required
                />
                <UInput
                  v-model="formData.address.zipCode"
                  :placeholder="$t('Zip/Postal Code')"
                  required
                />
              </div>
            </UFormGroup>
          </div>

          <UButton
            type="submit"
            color="primary"
            size="lg"
            block
            :loading="isSubmitting"
          >
            {{ $t('Submit Listing') }}
          </UButton>
        </form>
      </div>
    </UPageBody>
  </UContainer>
</template>

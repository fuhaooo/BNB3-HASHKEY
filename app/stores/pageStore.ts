import index from '#shared/content/index.json'
import booking from '#shared/content/booking.json'
import mock from '#shared/content/mock.json'
import pricing from '#shared/content/pricing.json'
export const pageStore = defineStore('pageStore', () => {
  return $$({ index, booking, mock, pricing })
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(pageStore, import.meta.hot))

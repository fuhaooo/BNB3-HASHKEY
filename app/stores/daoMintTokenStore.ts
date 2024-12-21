import mintTokenModal from '@/components/dao/mintTokenModal.vue'
export const daoMintTokenStore = defineStore('daoMintTokenStore', () => {
  const { alertWithModal } = $(notificationStore())
  const showModal = () => {
    alertWithModal(mintTokenModal, 'Mint Token', 'Mint Token')
  }

  let isLoading = $ref(false)
  let items = $ref([])
  let count = $ref(0)
  const loadItems = async () => {
    if (isLoading) return
    isLoading = true
    const data = await getRequest('/api/bnb3/retweet/list')
    items = data.items
    count = data.count
    isLoading = false
  }

  return $$({ showModal, isLoading, items, count, loadItems })
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(daoMintTokenStore, import.meta.hot))

export const bnb3CreateTokenStore = defineStore('bnb3CreateTokenStore', () => {
  const localePath = useLocalePath()
  const { writeContractByName, currentAccount, network, ensureAllowance } = $(
    uniConnectorStore(),
  )
  const { t } = $(useI18n())
  const { alertError, alertSuccess } = $(notificationStore())
  // Form data structure
  let formData = $ref({
    title: '',
    label: '',
    description: '',
    body: '',
    thumbnail: '',
    price: '',
    meta: '',
    amenities: [],
    bedrooms: 1,
    bathrooms: 1,
    maxGuests: 1,
    address: {
      street: '',
      city: '',
      state: '',
      country: '',
      zipCode: '',
    },
    images: [''],
  })

  // Add function to handle dynamic image inputs
  const addImageInput = () => {
    formData.images.push('')
  }

  const removeImageInput = (index: number) => {
    formData.images.splice(index, 1)
  }

  // Form validation
  const validation = $ref({
    isValid: false,
    errors: {},
  })

  // Add loading state
  let isSubmitting = $ref(false)

  // Form submission handler
  const doSubmit = async () => {
    isSubmitting = true
    validation.isValid = true
    // Basic validation
    if (!formData.title || !formData.price) {
      validation.isValid = false
      validation.errors = {
        title: !formData.title ? t('Property name is required') : '',
        price: !formData.price ? t('Price is required') : '',
      }
      isSubmitting = false
      return
    }

    try {
      const rz = await $fetch('/api/bnb3/createToken', {
        method: 'POST',
        body: {
          ...formData,
          network,
        },
      })

      if (rz.error) {
        isSubmitting = false
        return alertError('error', rz.error)
      }

      const amount = parseEther(rz.paymentAmount)
      await ensureAllowance('BSTEntropy', 'Diamond', amount)

      const rzContract = await writeContractByName(
        'Diamond',
        'TokenCreator_create',
        [rz.paymentToken, amount, rz.nonce, rz.signature],
      )
      if (!rzContract) {
        isSubmitting = false
        return
      }

      const {
        tx: { transactionHash: hash },
      } = rzContract
      const id = rz.id

      // const hash = "0xa0ebebb5ba2c82b1e1d7f6657058ef82a607ef8941620af1290617bcf20a32ee"
      // const id = 'c469ff8d-9e6a-4ef0-9fb2-6e7b9bda2c45'
      const verifyResult = await postRequest('/api/bnb3/createToken/verifyPayment', {
        hash,
        id,
      })

      if (verifyResult.error) {
        isSubmitting = false
        return alertError(t('Error'), verifyResult.error)
      }
      alertSuccess(t('Success'), t('Your B&B has been submitted successfully'))

      // Redirect to listing page or dashboard
      navigateTo(localePath('/booking'))
    } catch (error) {
      console.error('Submission error:', error)
      alertError(t('Error'), t('Failed to submit your B&B. Please try again.'))
    } finally {
      isSubmitting = false
    }
  }

  return $$({
    formData,
    addImageInput,
    removeImageInput,
    doSubmit,
    validation,
    isSubmitting,
  })
})

if (import.meta.hot)
  import.meta.hot.accept(acceptHMRUpdate(bnb3CreateTokenStore, import.meta.hot))

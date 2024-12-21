import { add, differenceInDays } from 'date-fns'
import { chainsMap } from '#shared/chainMap'
export const bnb3MintCreatorTokenStore = defineStore(
  'bnb3MintCreatorTokenStore',
  () => {
    const localePath = useLocalePath()
    const {
      writeContractByName,
      network,
      ensureAllowance,
      forceSwitchChain,
      walletClient,
      currentAccount,
    } = $(uniConnectorStore())
    const { t } = $(useI18n())
    const { alertError, alertSuccess } = $(notificationStore())

    const reviews = { href: '#', average: 4, totalCount: 117 }

    let post = $ref({})
    const setPostData = (data: any) => {
      post = data
    }

    const total = $computed(() => {
      return days * post.price
    })


    // TODO: get the start and end date from the post data, which stored in the database
    // TODO: also, maybe not a range, but some date in furture is booked already
    // TODO: date time stand also need to setup to the hotel's timezone
    const dateRange = $ref({
      start: new Date(),
      end: add(new Date(), { days: 7 }),
    })
    const days = $computed(() =>
      differenceInDays(dateRange.end, dateRange.start),
    )

    // Form validation
    const validation = $ref({
      isValid: false,
      errors: {},
    })

    // Add loading state
    let isSubmitting = $ref(false)

    // Form submission handler
    const doSubmit = async () => {
      if (post.network !== network) {
        const rz = await forceSwitchChain(chainsMap[post.network], walletClient)

        if (!rz) {
          return alertError(t('Error'), t('Failed to switch chain.'))
        }
      }

      isSubmitting = true

      // TODO: check data validity from server
      if (false) {
        // validation.isValid = false
        // validation.errors = {
        //   title: !formData.title ? t('Property name is required') : '',
        //   price: !formData.price ? t('Price is required') : '',
        // }
        isSubmitting = false
        return
      }

      try {
        const rz = await $fetch('/api/bnb3/mintToken', {
          method: 'POST',
          body: {
            id: post.id,
            days,
            start: dateRange.start,
            end: dateRange.end,
          },
        })

        if (rz.error) {
          isSubmitting = false
          return alertError('error', rz.error)
        }

        const { tokenId, tokenAmount, paymentToken, paymentAmount, nonce, signature } = rz
        const amount = parseEther(paymentAmount)
        await ensureAllowance('BSTEntropy', 'Diamond', amount)

        const rzContract = await writeContractByName(
          'Diamond',
          'mintCreatorToken',
          [tokenId, tokenAmount, paymentToken, amount, nonce, signature],
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
        const verifyResult = await postRequest(
          '/api/bnb3/mintToken/verifyPayment',
          {
            hash,
            id,
            sender: currentAccount,
          },
        )

        if (verifyResult.error) {
          isSubmitting = false
          return alertError(t('Error'), verifyResult.error)
        }
        alertSuccess(
          t('Success'),
          t('Your room has been booked successfully, please wait for the confirmation.'),
        )

        // Redirect to listing page or dashboard
        navigateTo(localePath('/booking'))
      } catch (error) {
        console.error('Submission error:', error)
        alertError(
          t('Error'),
          t('Failed to book your room. Please try again.'),
        )
      } finally {
        isSubmitting = false
      }
    }

    return $$({
      reviews,
      dateRange,
      days,
      total,
      post,
      setPostData,
      doSubmit,
      validation,
      isSubmitting,
    })
  },
)

if (import.meta.hot)
  import.meta.hot.accept(
    acceptHMRUpdate(bnb3MintCreatorTokenStore, import.meta.hot),
  )

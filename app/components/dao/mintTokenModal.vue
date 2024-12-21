<script lang="ts" setup>
let isShowLinkInput = $ref(false)
let mintSuccess = $ref(false)
const modal = useModal()
const { t } = $(useI18n())
const { name, shareLink } = $(supabaseStore())
const { addSuccess } = $(notificationStore())
const { currentAccount, writeContractByName, network } = $(uniConnectorStore())
const mintJson = encodeURIComponent(`
{  
  "p": "#BnB3",
  "op": "mint",
  "tick": "BnB3",
  "amt": "1",
  "by": "${name}"
}`)
const text = $computed(
  () =>
    `Follow @HelloRWA, RT and LIKE via ${shareLink} to get your $BnB3${mintJson}`,
)

const shareTweetStatusLink = 'https://x.com/HelloRWA/status/1742048665827779026'

const tags = 'BnB3,RWAWallet'
const twitterShareBtnLink = $computed(() => {
  return `https://x.com/intent/tweet?text=${text}&url=${shareTweetStatusLink}&hashtags=${tags}`
})

let isLoading = $ref(false)
let link = $ref('https://x.com/HelloRWA/status/1849118874249347379')
let error = $ref('')
const doSaveRetweetLink = async () => {
  if (name !== link.split('/')[3]) {
    error = t('X Handler and Retweet status link is not the same X account!')
    return
  }
  if (isLoading) {
    return
  }
  error = ''
  isLoading = true

  try {
    const data = await postRequest('/api/bnb3/retweet/new', {
      link,
      mintType: 'retweet',
      network,
    })

    if (data.status === 'successed') {
      isLoading = false
      error = t('You already mint the reward')
      return
    }
    const {
      id,
      to,
      amount,
      nonce,
      signature,
      meta: { tokenId, paymentToken, paymentAmount },
    } = data
    const rzContract = await writeContractByName('Diamond', 'mintFT', [
      to,
      tokenId,
      amount,
      paymentToken,
      parseEther(paymentAmount),
      nonce,
      signature,
    ])
    if (!rzContract) {
      isLoading = false
      return
    }

    const {
      tx: { transactionHash: hash },
    } = rzContract

    // const hash = "0xa0ebebb5ba2c82b1e1d7f6657058ef82a607ef8941620af1290617bcf20a32ee"
    // const id = 'c469ff8d-9e6a-4ef0-9fb2-6e7b9bda2c45'
    const verifyResult = await postRequest('/api/bnb3/retweet/minted', {
      hash,
      id,
    })

    if (verifyResult.error) {
      isLoading = false
      error = verifyResult.error
      return
    }
    mintSuccess = true
  } catch (err) {
    error = err.shortMessage
  } finally {
    isLoading = false
  }
}

const { loadItems } = $(daoMintTokenStore())
const doClose = async () => {
  modal.close()
  await loadItems()
  nextTick(() => {
    mintSuccess = false
    error = ''
  })
}
</script>

<template>
  <UModal :ui="{ background: 'bg-transparent dark:bg-transparent' }">
    <div
      class="bg-indigo-600 max-w-2xl py-6 px-3 shadow-2xl relative isolate overflow-hidden sm:rounded-3xl sm:px-12 xl:py-8"
    >
      <h2
        class="font-bold mx-auto my-10 text-center text-white text-xl tracking-tight max-w-2xl sm:text-2xl"
      >
        Tweet to Mint Your First
        <br />
        <br />
        <span text-rainbow uppercase text-6xl animate-pulse> $BnB3 </span>
      </h2>
      <EnsureAuthAndAddressBind>
        <div v-if="mintSuccess" text-2xl font-bold>
          <div>Mint Successed!</div>
          <div class="mt-8 flex-cc">
            <UButton color="green" size="xl" @click="doClose">Close</UButton>
          </div>
        </div>
        <div v-else flex flex-col items-center w-full>
          <a
            target="_blank"
            :href="twitterShareBtnLink"
            @click="isShowLinkInput = true"
            class="bg-black rounded-full m-2 text-sm py-3 px-6 text-gray-100 inline-flex items-center hover:opacity-60"
            title="Click to tweet"
          >
            <span i-simple-icons-x mr-1></span>
            Click to Tweet!
          </a>
          <br />
          <div v-if="error" text-red-500>{{ error }}</div>
          <Loading v-if="isShowLinkInput" :is-loading="isLoading">
            <div
              class="rounded-xl flex flex-col space-y-3 border-1 mt-10 w-full py-8 px-6"
            >
              <input
                id="tweet-status-link"
                v-model="link"
                name="tweet-status-link"
                type="url"
                autocomplete="tweet-status-link"
                required="true"
                class="rounded-md bg-white/5 border-0 shadow-sm ring-inset text-white w-sm py-2 px-3.5 ring-1 ring-white/10 sm:text-sm sm:leading-6 focus:ring-inset focus:ring-white focus:ring-2"
                placeholder="Enter your tweet status link"
              />
              <button
                @click="doSaveRetweetLink"
                class="bg-white rounded-md flex-none font-semibold shadow-sm text-sm py-2.5 px-3.5 text-gray-900 hover:bg-gray-100 focus-visible:outline focus-visible:outline-white focus-visible:outline-2 focus-visible:outline-offset-2"
              >
                Submit
              </button>
            </div>
          </Loading>
          <div v-else text-gray-400 text-base pt-10 leading-4>
            After you send out the tweet, remember to copy the status link back
            here!
          </div>
        </div>
      </EnsureAuthAndAddressBind>
      <svg
        viewBox="0 0 1024 1024"
        class="h-[64rem] top-1/2 left-1/2 w-[64rem] -z-10 -translate-x-1/2 absolute"
        aria-hidden="true"
      >
        <circle
          cx="512"
          cy="512"
          r="512"
          fill="url(#759c1415-0410-454c-8f7c-9a820de03641)"
          fill-opacity="0.7"
        />
        <defs>
          <radialGradient
            id="759c1415-0410-454c-8f7c-9a820de03641"
            cx="0"
            cy="0"
            r="1"
            gradientUnits="userSpaceOnUse"
            gradientTransform="translate(512 512) rotate(90) scale(512)"
          >
            <stop stop-color="#7775D6" />
            <stop offset="1" stop-color="#E935C1" stop-opacity="0" />
          </radialGradient>
        </defs>
      </svg>
    </div>
  </UModal>
</template>

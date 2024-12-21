<script setup lang="ts">
const { loadItems, isLoading, count, items } = $(daoMintTokenStore())
onMounted(async () => {
  await loadItems()
})

const tokenName = '$BnB3'
const { txLink } = $(uniConnectorStore())
</script>

<template>
  <div>
    <h2
      class="flex font-semibold text-base text-white leading-7 items-center main-px"
    >
      <div class="border-b flex border-white/40 pb-3">
        <span mr-4 text-lg>Total Mint {{ tokenName }}:</span>
        <LoadingIcon v-if="isLoading" />
        <span v-else> {{ numberFormat(count) }} </span>
      </div>
    </h2>
    <Loading class="py-5" :is-loading="isLoading">
      <table class="mt-6 text-left w-full whitespace-nowrap">
        <colgroup>
          <col class="w-full sm:w-4/12" />
          <col class="lg:w-4/12" />
          <col class="lg:w-2/12" />
        </colgroup>
        <thead class="border-b border-white/10 text-sm text-white leading-6">
          <tr>
            <th
              scope="col"
              class="font-semibold py-2 pr-8 pl-4 sm:pl-6 lg:pl-8"
            >
              User
            </th>
            <th scope="col" class="font-semibold py-2 pr-8 pl-0">Reward</th>
            <th
              scope="col"
              class="font-semibold text-right py-2 pr-4 pl-0 sm:text-left sm:pr-8 lg:pr-20"
            >
              Status
            </th>
            <th
              scope="col"
              class="font-semibold text-right py-2 pr-4 pl-0 sm:pr-6 lg:pr-8"
            >
              Created at
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-white/5">
          <tr v-for="item in items" :key="item.id">
            <td class="py-4 pr-8 pl-4 sm:pl-6 lg:pl-8">
              <a
                :href="item?.meta?.link"
                target="_blank"
                class="flex gap-x-4 items-center"
              >
                <img
                  :src="item.avatar"
                  alt=""
                  class="rounded-full bg-gray-800 h-8 w-8"
                />
                <div
                  class="font-medium text-sm text-white leading-6 truncate hidden sm:block"
                >
                  {{ item.name }}
                </div>
              </a>
            </td>
            <td class="py-4 pr-4 pl-0 sm:pr-8">
              <div class="flex gap-x-2">
                <div class="font-mono text-sm text-gray-400 leading-6 truncate">
                  {{ numberFormat(item.amount) }} {{ tokenName }}
                </div>
              </div>
            </td>
            <td
              class="text-sm text-white py-4 pr-4 pl-0 leading-6 sm:pr-8 lg:pr-20"
            >
              <div v-if="item.status === 'init'">{{ item.status }}</div>
              <a
                :href="txLink(item.hash, item.network)"
                v-if="item.status === 'successed'"
                target="_blank"
                >{{ item.status }}</a
              >
            </td>
            <td
              class="text-right text-sm py-4 pr-4 pl-0 text-gray-400 leading-6 sm:pr-6 lg:pr-8"
            >
              <TimeAgo
                :time="item.created_at"
                class="text-gray-4 whitespace-nowrap"
              />
            </td>
          </tr>
        </tbody>
      </table>
    </Loading>
  </div>
</template>

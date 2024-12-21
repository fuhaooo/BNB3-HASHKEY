export default defineAppConfig({
  title: 'BnB3',
  ui: {
    primary: 'red',
    gray: 'cool',
  },
  topNav: [
    {
      label: 'Home',
      icon: 'i-heroicons-home',
      to: '/',
    },
    {
      label: 'Booking',
      icon: 'material-symbols:bedroom-parent-rounded',
      to: '/booking',
    },
    {
      label: 'DAO',
      icon: 'mdi:account-group',
      to: '/dao',
    },
  ],
})

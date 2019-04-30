import axios from 'axios'

const token: string = document.querySelector('[name=csrf-token]')!.getAttribute('content') || ''

export default axios.create({
  headers: {
    // Accept: "application/json",
    'X-CSRF-Token': token,
    'X-Requested-With': 'XMLHttpRequest',
  },
})

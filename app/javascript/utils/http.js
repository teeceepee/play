import axios from "axios"

let token = document.getElementsByName('csrf-token')[0].content

export default axios.create({
  headers: {
    // Accept: "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-Token": token,
  }
})

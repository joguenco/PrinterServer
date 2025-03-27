const server = 'http://localhost:9090'

let message = document.querySelector('#message')
let pingButton = document.querySelector('#pingButton')
let payButton = document.querySelector('#payButton')
const modalPing = document.getElementById('modalPing')
const modalTicket = document.getElementById('modalTicket')

pingButton.addEventListener('click', pingToServer)
payButton.addEventListener('click', payTicket)
document.addEventListener('keydown', (event) => {
  if (event.key === "Escape") {
    closeAllModals();
  }
})

const clickClose = function () {
  (document
    .querySelectorAll(
      '.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button'
    ) || []).forEach(($close) => {
      $close.addEventListener('click', () => {
        closeModal(modalPing)
      })
      $close.addEventListener('click', () => {
        closeModal(modalTicket)
      })
    })
}

clickClose()

function pingToServer() {
  const url = `${server}/ping`

  openModal(modalPing)

  fetch(url).then((response) => {
    return response.json()
  }).then((data) => {
    console.log(data)
    message.innerHTML = data.message
  }).catch(function (error) {
    console.log(error)
    message.innerHTML = `Cannot connect to server ${url}`
  })
}

function payTicket() {
  openModal(modalTicket)
}

function openModal($el) {
  $el.classList.add('is-active')
}

function closeModal($el) {
  $el.classList.remove('is-active')
}

function closeAllModals() {
  (document.querySelectorAll('.modal') || []).forEach(($modal) => {
    closeModal($modal)
  })
}
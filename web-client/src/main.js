const server = 'http://localhost:9090'

let message = document.querySelector('#message')
let pingButton = document.querySelector('#pingButton')
const $target = document.getElementById('modalPing')

pingButton.addEventListener('click', pingToServer)
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
        closeModal($target)
      })
    })
}

clickClose()

function pingToServer() {
  const url = `${server}/ping`

  openModal($target)

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



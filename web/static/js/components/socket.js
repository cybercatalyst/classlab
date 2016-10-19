import { Socket } from 'phoenix';

let socket = new Socket('/socket', {
  params: {
    token: document.querySelector('meta[name="session_token"]').getAttribute('content')
  }
})

socket.connect()

export default socket

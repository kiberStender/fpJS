class Sender
  constructor: (@ws) ->
  send: (msg) ->
    ws.send msg
    new Sender ws

class FpWebSocket 
  constructor: (@ws) ->
  onOpen: (fn) ->
    @ws.onopen = (evt) -> (new Promise (rs, rj) -> try rs evt catch e then rj e).then (e) -> fn e, new Sender ws 
    new FpWebSocket ws
  onClose: (fn) ->  
    @ws.onclose = (evt) -> (new Promise (rs, rj) -> try rs evt catch e then rj e).then fn
    new FpWebSocket ws
  whenMessageComes: (fn) ->
    @ws.onmessage = (evt) -> (new Promise (rs, rj) -> try rs evt.data catch e then rj e).then (msg) -> fn msg, new Sender ws
    new FpWebSocket ws
  onError: (fn) ->
    @ws.onerror = (evt) -> (new Promise (rs, rj) -> try rs evt catch e then rj e).then (msg) -> fn msg, new Sender ws
    new FpWebSocket ws
  sendMessage: (msg) ->
    @ws.send msg
    new FpWebSocket ws

webSocket = (conn, protocols) -> new FpWebSocket new WebSocket conn, protocols

export {webSocket}

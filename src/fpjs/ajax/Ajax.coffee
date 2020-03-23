import {map} from "collections/map/Map

class Ajax then constructor: (method, url = "", mData = map(), json = false) ->
  xhr = -> if window.XMLHttpRequest then new XMLHttpRequest() else new ActiveXObject("Microsoft.XMLHTTP")

  convertObjectToQueryString = (mData) -> (mData.foldLeft "") (acc) -> ([key, value]) -> acc + "&#{key}=#{value}"

  parseJson = (resp) -> if json then JSON.parse resp else resp

  @httpFetch = -> new Promise (resolve, reject) ->
    req = xhr()

    req.onreadystatechange = -> if @readyState is 4
      if @status is 200 then resolve parseJson @response
    else reject new Error @statusText

    req.onerror = -> reject new Error @statusText

    req.open method, url, true
    req.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    req.send convertObjectToQueryString mData

get = (url, json = false) -> (new Ajax "GET", url, map(), json).httpFetch()
post = (url, mData = map(), json = false) -> (new Ajax "POST", url, mData, json).httpFetch()
del = (url, mData = map(), json = false) -> (new Ajax "DELETE", url, mData, json).httpFetch()
put = (url, mData = map(), json = false) -> (new Ajax "PUT", url, mData, json).httpFetch()


export {get, post, del, put}

import "../draft/styles.scss"

import React from "react"
import ReactDOM from "react-dom"
import { createStore, applyMiddleware } from "redux"
import { Provider } from "react-redux"
import thunkMiddleware from "redux-thunk"
import loggerMiddleware from "redux-logger"

import { HeaderCont } from "../draft/containers/header"
import { MainCont } from "../draft/containers/main"
import { rootReducer } from "../draft/reducers/root"

let store = createStore(
  rootReducer,
  applyMiddleware(
    thunkMiddleware,
    loggerMiddleware
  )
)

const App = () => (
  <div>
    <HeaderCont />
    <MainCont />
  </div>
)

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.querySelector("#root")
)


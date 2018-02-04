require("pages/index_page/style.scss")

import React from "react"
import ReactDOM from "react-dom"

import { name } from "consts"

const Index = props => (
  <h1>
    Welcome to&nbsp;
    <a href="http://www.xiumaijia.com/">{props.name}</a>
  </h1>
)

Index.defaultProps = {
  name: "name"
}

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <Index name={name()} />,
    document.querySelector("#root"),
  )
})

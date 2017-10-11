require("pages/index_page/style.scss")

import React from "react"
import ReactDOM from "react-dom"
import CSSTransitionGroup from 'react-transition-group/CSSTransitionGroup'

import { name } from "consts"

const Index = props => (
  <CSSTransitionGroup
    transitionName="index-title"
    transitionAppear={true}
    transitionAppearTimeout={1000}
    transitionEnter={false}
    transitionLeave={false}
  >
    <h1>
      Welcome to&nbsp;
      <a href="http://www.xiumaijia.com/">{props.name}</a>
    </h1>
  </CSSTransitionGroup>
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

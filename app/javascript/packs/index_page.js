import React from 'react'
import ReactDOM from 'react-dom'

const Index = props => (
  <h1>{props.name}</h1>
)

Index.defaultProps = {
  name: "Welcome"
}

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <Index name="Welcome" />,
    document.querySelector("#root")
  )
})

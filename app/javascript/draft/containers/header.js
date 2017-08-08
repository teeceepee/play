import React from "react"
import { connect } from "react-redux"

const Header = ({ title }) => (
  <h1>{title.toUpperCase()}</h1>
)

function mapStateToProps(state) {
  return {
    title: state.currentTitle,
  }
}

function mapDispatchToProps(dispatch) {
  return {}
}

export const HeaderCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(Header)

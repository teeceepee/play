import React from "react"
import { connect } from "react-redux"

const ArticleNew = ({}) => (
  <div>
    <h2>Article New</h2>


  </div>
)

function mapStateToProps(state) {
  return {

  }
}

function mapDispatchToProps(dispatch) {
  return {

  }
}

export const ArticleNewCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleNew)

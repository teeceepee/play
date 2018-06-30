import './styles.scss'

import React from "react"
import { connect } from "react-redux"

class LandingPage extends React.Component {

  render() {
    return (
      <div className="index-page">
        <div className="banner">
          <h1 className="title">Explore, play and enjoy.</h1>
        </div>

        <div className="libraries m-auto p-3">
          <p>Thanks to these libraries:</p>
          <ul>
            <li>Axios</li>
            <li>Bootstrap</li>
            <li>Draft.js</li>
            <li>Moment</li>
            <li>React</li>
            <li>Redux</li>
            <li>Redux Form</li>
            <li>React</li>
            <li>...</li>
          </ul>
        </div>

        <div className="footer">
          <div className="created-by">Created by teeceepee</div>
        </div>
      </div>
    )
  }
}

function mapStateToProps(state) {
  return {
  }
}

function mapDispatchToProps(dispatch) {
  return {}
}

export const LandingPagePage = connect(
  mapStateToProps,
  mapDispatchToProps,
)(LandingPage)

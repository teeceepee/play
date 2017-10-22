// import 'custom_antd.less'
import './styles.scss'

import React from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'

class LandingPage extends React.Component {

  render() {
    return (
      <div className="index-page">
        <div className="banner">
          <h1 className="title">Why Y</h1>
        </div>

        <div className="blocks">
          <div className="block">
            <Link to="/articles">
              <span>Articles </span>
            </Link>
          </div>
          <div className="block">
            <Link to="/articles">Articles</Link>
          </div>
          <div className="block">
            <Link to="/articles">Articles</Link>
          </div>
        </div>

        <div className="footer">
          <div className="powered-by">Powered by React</div>
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

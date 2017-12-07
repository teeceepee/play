import React from "react"
import { connect } from "react-redux"
import { Switch, Route, Link, withRouter } from 'react-router-dom'
import { ArticleIndexCont } from "./article_index"
import { ArticleNewCont } from "./article_new"
import { ArticleEditCont } from "./article_edit"
import { LandingPagePage } from 'landing_page/index'
import { CalendarPage } from '../../calendar/index'

class Main extends React.Component {

  render() {
    return (
      <Switch>
        <Route path="/articles/edit/:id" component={ArticleEditCont} />
        <Route path="/articles" exact component={ArticleIndexCont} />
        <Route path="/articles/new" component={ArticleNewCont} />
        <Route path="/calendar" exact component={CalendarPage} />
        <Route component={LandingPagePage} />
      </Switch>
    )
  }
}

function mapStateToProps(state) {
  return {
    path: state.path,
    paths: state.paths,
  }
}

function mapDispatchToProps(dispatch) {
  return {
  }
}

export const MainCont = withRouter(connect(
  mapStateToProps,
  mapDispatchToProps,
)(Main))

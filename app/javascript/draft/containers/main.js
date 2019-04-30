import React from "react"
import { connect } from "react-redux"
import { Switch, Route, Link, withRouter } from 'react-router-dom'
import { ArticleIndexCont } from "./article_index"
import { ArticleNewCont } from "./article_new"
import { ArticleEditCont } from "./article_edit"
import { LandingPagePage } from 'LandingPage'
import { CalendarPage } from '../../calendar/index'
import { EditorPage } from '../../editor'
import { DashboardPage } from 'Dashboard'
import { PlayerPage } from 'PlayerPage/index'
import { MachineLearningPage } from 'MachineLearning/index'
import { MinerPage } from 'Miner/index'

class Main extends React.Component {

  render() {
    return (
      <Switch>
        <Route path="/articles/edit/:id" component={ArticleEditCont} />
        <Route path="/articles" exact component={ArticleIndexCont} />
        <Route path="/articles/new" component={ArticleNewCont} />
        <Route path="/calendar" exact component={CalendarPage} />
        <Route path="/editor" exact component={EditorPage}/>
        <Route path="/dashboard" exact component={DashboardPage}/>
        <Route path="/player" exact component={PlayerPage}/>
        <Route path="/machine" exact component={MachineLearningPage}/>
        <Route path="/miner" exact component={MinerPage}/>
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

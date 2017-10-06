import React from "react"
import { connect } from "react-redux"
import { Switch, Route, Link, withRouter } from 'react-router-dom'
import { ArticleIndexCont } from "./article_index"
import { ArticleNewCont } from "./article_new"
import { ArticleEditCont } from "./article_edit"

class Main extends React.Component {

  render() {
    return (
      <div>
        <Switch>
          <Route path="/draft/articles/edit/:id" component={ArticleEditCont} />
          <Route path="/draft/articles" component={ArticleIndexCont} />
          <Route path="/draft" render={() => <Link to="/draft/articles">Articles</Link>} />
        </Switch>
      </div>
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

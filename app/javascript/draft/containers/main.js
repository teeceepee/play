import React from "react"
import { connect } from "react-redux"
import { changePath, updateTitle } from "../reducers/root"
import { ArticleIndexCont } from "./article_index"
import { ArticleNewCont } from "./article_new"
import { ArticleEditCont } from "./article_edit"

class Main extends React.Component {

  currentTab() {
    const path = this.props.path

    switch (path) {
      case 'new':
        return <ArticleNewCont/>
      case 'edit':
        return <ArticleEditCont/>
      default:
        return <ArticleIndexCont/>
    }
  }

  render() {
    const { path, paths, clickPath } = this.props

    return (
      <div>
        <h2>{path}</h2>
        <ul className="nav nav-tabs">
          {paths.map(p => (
            <li className="nav-item" key={p} onClick={() => { clickPath(p) }}>
              <a className={path === p ? "nav-link active" : "nav-link"} href="#">{p}</a>
            </li>
          ))}
          <li className="nav-item"><a className="nav-link disabled" href="#">Disabled</a></li>
        </ul>

        {this.currentTab()}
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
    clickPath: function (path) {
      dispatch(changePath(path))
      dispatch(updateTitle(path))
    }
  }
}

export const MainCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(Main)

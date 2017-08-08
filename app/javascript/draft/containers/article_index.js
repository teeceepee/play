import React from "react"
import { connect } from "react-redux"
import { editArticle } from "../reducers/root"

class ArticleIndex extends React.Component {

  articleItems() {
    const { articles, editArticle } = this.props
    return articles.map(article => (
      <li onClick={() => { editArticle(article.id) }} className="list-group-item" key={article.id}>
        <h4>{article.title}</h4>
        <div>{article.content}</div>
      </li>
    ))
  }

  render() {
    return (
      <div>
        <h3>Article Index</h3>

        <ul className="list-group">
          {this.articleItems()}
        </ul>
      </div>
    )
  }
}


function mapStateToProps(state) {
  return {
    articles: state.articles
  }
}

function mapDispatchToProps(dispatch) {
  return {
    editArticle: (id) => {
      dispatch(editArticle(id))
    }
  }
}

export const ArticleIndexCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleIndex)

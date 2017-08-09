import React from "react"
import { connect } from "react-redux"
import { editArticle } from "../reducers/root"

class ArticleIndex extends React.Component {

  articleItems() {
    const { articles, editArticle } = this.props
    return articles.map(article => (
      <div onClick={() => { editArticle(article.id) }} className="list-group-item list-group-item-action flex-column align-items-start" key={article.id}>
        <h4>{article.title}</h4>
        <pre>{article.content}</pre>
      </div>
    ))
  }

  render() {
    return (
      <div>
        <h3 className="mt-2">Article Index</h3>

        <div className="list-group">
          {this.articleItems()}
        </div>
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

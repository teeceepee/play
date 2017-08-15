import React from "react"
import { connect } from "react-redux"
import { fetchArticles, editArticle } from "../reducers/root"

class ArticleIndex extends React.Component {

  componentDidMount() {
    this.props.fetchArticles()
  }

  articleItems() {
    const { articles, editArticle } = this.props
    return articles.map(article => (
      <div onClick={() => { editArticle(article) }} className="list-group-item list-group-item-action flex-column align-items-start" key={article.id}>
        <h4>{article.title}</h4>
        <div>{article.content}</div>
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
    fetchArticles: () => {
      dispatch(fetchArticles())
    },
    editArticle: (article) => {
      dispatch(editArticle(article))
    }
  }
}

export const ArticleIndexCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleIndex)

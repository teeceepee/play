import React from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'
import { updateTitle, fetchArticles } from "../reducers/root"

class ArticleIndex extends React.Component {

  componentDidMount() {
    this.props.updateTitle('article index')
    this.props.fetchArticles()
  }

  articleItems() {
    const { articles } = this.props
    return articles.map(article => (
      <div className="list-group-item list-group-item-action flex-column align-items-start" key={article.id}>
        <h4>{article.title}</h4>
        <div>{article.content}</div>
        <Link to={'/draft/articles/edit/' + article.id} >Edit</Link>
      </div>
    ))
  }

  render() {
    return (
      <div>
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
    updateTitle: (title) => {
      dispatch(updateTitle(title))
    },
    fetchArticles: () => {
      dispatch(fetchArticles())
    }
  }
}

export const ArticleIndexCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleIndex)

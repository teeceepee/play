import React, { Component } from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'
import { Dropdown } from '../../common/dropdown'
import { ArticleForm } from './article_form'
import {
  updateTitle,
  fetchArticles,
  updateArticle,
  toggleArticleForm,
  toggleArticleDropdown,
} from "../reducers/root"

class ArticleDropdown extends Component {
  handleToggle = () => {
    this.props.toggleArticleDropdown(this.props.article)
  }

  render() {
    const article = this.props.article
    return (
      <Dropdown
        trigger=""
        isOpen={this.props.isOpen}
        open={this.handleToggle}
        close={this.handleToggle}
      >
        <Link to={`/articles/edit/${article.id}`} className="dropdown-item">Edit in new page</Link>
      </Dropdown>
    )
  }
}

class ArticleIndex extends Component {

  componentDidMount() {
    this.props.updateTitle('article index')
    this.props.fetchArticles()
  }

  updateArticle = (article) => {
    this.props.updateArticle(article)
  }

  articleItems() {
    const { articles } = this.props
    return articles.map(article => (
      <div className="list-group-item  flex-column align-items-start" key={article.id}>
        <h4>
          {article.title}
          <div className="float-right">
            <ArticleDropdown
              article={article}
              isOpen={this.props.articleDropdownVisible[article.id]}
              toggleArticleDropdown={this.props.toggleArticleDropdown}
            />
          </div>
        </h4>
        <div style={{whiteSpace: 'pre-wrap'}}>{article.content}</div>
        <div onClick={() => this.props.toggleArticleForm(article)} className="btn btn-outline-primary btn-sm">Edit</div>
        <div className={this.props.articleFormVisible[article.id] ? '' : 'd-none'}>
          <ArticleForm form={`article-${article.id}`} initialValues={article} onSubmit={this.updateArticle} />
        </div>
      </div>
    ))
  }

  render() {
    return (
      <div className="container mt-3">
        <Link to="/articles/new">New</Link>
        <div className="list-group">
          {this.articleItems()}
        </div>
        <hr/>
        <Link to="/">Back to index</Link>
      </div>
    )
  }
}


function mapStateToProps(state) {
  return {
    articles: state.articles,
    articleFormVisible: state.articleFormVisible,
    articleDropdownVisible: state.articleDropdownVisible,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    updateTitle: (title) => {
      dispatch(updateTitle(title))
    },
    fetchArticles: () => {
      dispatch(fetchArticles())
    },
    updateArticle: (article) => {
      dispatch(updateArticle(article))
    },
    toggleArticleForm: (article) => {
      dispatch(toggleArticleForm(article))
    },
    toggleArticleDropdown: (article) => {
      dispatch(toggleArticleDropdown(article))
    }
  }
}

export const ArticleIndexCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleIndex)

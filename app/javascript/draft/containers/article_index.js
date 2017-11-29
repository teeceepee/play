import React, { Component } from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'
import { Dropdown } from '../../common/dropdown'
import { Modal } from "../../common/modal"
import { ArticleForm } from './article_form'
import {
  updateTitle,
  fetchArticles,
  updateArticle,
  toggleArticleForm,
  toggleArticleDropdown,
  showModal,
  hideModal,
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
      <div className="card mb-3" key={article.id}>
        <div className="card-body">
          <h4 className="card-title">
            {article.title}
            <div className="float-right">
              <ArticleDropdown
                article={article}
                isOpen={this.props.articleDropdownVisible[article.id]}
                toggleArticleDropdown={this.props.toggleArticleDropdown}
              />
            </div>
          </h4>
          <p className="card-text" style={{whiteSpace: 'pre-wrap'}}>{article.content}</p>
          <div onClick={() => this.props.toggleArticleForm(article)} className="btn btn-outline-primary btn-sm">Edit</div>
          <div className={this.props.articleFormVisible[article.id] ? '' : 'd-none'}>
            <ArticleForm form={`article-${article.id}`} initialValues={article} onSubmit={this.updateArticle} />
          </div>
        </div>
      </div>
    ))
  }

  render() {
    return (
      <div className="container mt-3">
        <Link to="/articles/new">New</Link>
        <div className="mb-1">
          <button onClick={this.props.openArticlesModal} className="btn btn-primary">Open modal</button>
          <Modal
            isOpen={this.props.articlesModalIsOpen}
            onClose={this.props.closeArticlesModal}
          >
            <h1>An Open Modal</h1>
            <p>modal content...</p>
            <p>modal content...</p>
          </Modal>
        </div>
        <div>
          {this.articleItems()}
        </div>
        <hr/>
        <Link to="/">Back to index</Link>
      </div>
    )
  }
}

const modalIdentity = 'articles-modal'

function mapStateToProps(state) {
  return {
    articles: state.articles,
    articleFormVisible: state.articleFormVisible,
    articleDropdownVisible: state.articleDropdownVisible,
    articlesModalIsOpen: state.modals[modalIdentity] || false,
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
    },
    openArticlesModal: () => {
      dispatch(showModal(modalIdentity))
    },
    closeArticlesModal: () => {
      dispatch(hideModal(modalIdentity))
    },
  }
}

export const ArticleIndexCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleIndex)

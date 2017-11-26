import React from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'

import { updateTitle, fetchArticle, updateArticleForm, updateArticle } from "../reducers/root"

class ArticleEdit extends React.Component {

  constructor(props) {
    super(props)

    this.onChange = this.onChange.bind(this)
    this.onSubmit = this.onSubmit.bind(this)
  }

  componentDidMount() {
    const id = this.props.match.params.id;
    this.props.updateTitle(`article edit #${id}`)
    this.props.fetchArticle(id)
  }

  onChange(e) {
    const { article, updateArticleForm } = this.props

    const edited = Object.assign({}, article, {
      [e.target.name]: e.target.value
    })

    updateArticleForm(edited)
  }

  onSubmit(e) {
    e.preventDefault()
    const { article, updateArticle } = this.props
    updateArticle(article)
  }

  render() {
    const { article } = this.props
    return (
      <div className="container mt-3">
        <form action="" onSubmit={this.onSubmit}>
          <div className="form-group">
            <input type="text" name="title" value={article.title} className="form-control" onChange={this.onChange} />
          </div>

          <div className="form-group">
            <textarea name="content" value={article.content} className="form-control" onChange={this.onChange} rows="6"></textarea>
          </div>

          <button className="btn btn-outline-primary">Save</button>
        </form>
        <hr/>
        <Link to="/articles">Back</Link>
      </div>
    )
  }
}


function mapStateToProps(state) {
  return {
    article: state.forms.articleForm
  }
}

function mapDispatchToProps(dispatch) {
  return {
    updateTitle: (title) => {
      dispatch(updateTitle(title))
    },
    fetchArticle: (id) => {
      dispatch(fetchArticle(id))
    },
    updateArticleForm: (article) => {
      dispatch(updateArticleForm(article))
    },
    updateArticle: (article) => {
      dispatch(updateArticle(article))
    },
  }
}

export const ArticleEditCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleEdit)

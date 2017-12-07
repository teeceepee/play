import React from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'

import { ArticleForm } from './article_form'
import { updateTitle, createArticle } from '../reducers/root'


const initialValues = {
  title: 'title...',
  content: 'content...',
}

class ArticleNew extends React.Component {
  constructor(props) {
    super(props)

    this.props.updateTitle('article new')
  }


  render() {
    return (
      <div className="container mt-4">
        <ArticleForm form="article-new" initialValues={initialValues} onSubmit={this.props.createArticle}/>
        <hr/>
        <Link to="/articles">Back</Link>
      </div>
    )
  }
}

function mapStateToProps(state) {
  return {

  }
}

function mapDispatchToProps(dispatch) {
  return {
    updateTitle: (title) => {
      dispatch(updateTitle(title))
    },
    createArticle: (article) => {
      dispatch(createArticle(article))
    }
  }
}

export const ArticleNewCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleNew)

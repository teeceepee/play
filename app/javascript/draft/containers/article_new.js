import React from "react"
import { connect } from "react-redux"
import { Link } from 'react-router-dom'
import { Field, reduxForm } from 'redux-form'

import { InputFormGroup, TextareaFormGroup, SelectFormGroup } from './form_groups'
import { updateTitle, createArticle } from '../reducers/root'

const statusOptions = [
  ['Draft', 'draft'],
  ['Published', 'published'],
]

const validate = values => {
  const errors = {}
  if (!values.title) {
    errors.title = 'Required'
  }

  if (!values.content) {
    errors.content = 'Required'
  }

  if (!values.status) {
    errors.status = 'Required'
  }

  return errors
}

let ArticleForm = ({handleSubmit, pristine}) => (
  <form onSubmit={handleSubmit}>
    <Field name="title" component={InputFormGroup} type="text" label="Title" />
    <Field name="content" component={TextareaFormGroup} label="Content" rows="10" />
    <Field name="status" component={SelectFormGroup} label="Status" options={statusOptions} includeBlank={true} />
    <button className="btn btn-outline-primary" disabled={pristine}>Save</button>
  </form>
)

ArticleForm = reduxForm({
  form: 'article',
  validate,
})(ArticleForm)

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
      <div>
        <ArticleForm initialValues={initialValues} onSubmit={this.props.createArticle}/>
        <hr/>
        <Link to="/draft/articles">Back</Link>
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

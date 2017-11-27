import React from 'react'
import { reduxForm, Field } from 'redux-form'

import { InputFormGroup, TextareaFormGroup, SelectFormGroup } from './form_groups'

const statusOptions = JSON.parse(document.querySelector('meta[name=global-options]').content)['article.status']

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
  validate,
})(ArticleForm)

export { ArticleForm }

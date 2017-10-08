import React from 'react'

class BaseFormGroup extends React.Component {

  identity() {
    return this.props.input.name
  }

  render() {
    throw 'Cannot use `BaseFormGroup`'
  }
}

export class InputFormGroup extends BaseFormGroup {

  render() {
    const {input, meta: { touched, error }, label, type } = this.props
    const cls = 'form-control' + (touched && error ? ' is-invalid' : '')

    return (
      <div className="form-group">
        <label htmlFor={this.identity()}>{label}</label>
        <input {...input} type={type} id={this.identity()} className={cls} />
        {touched && error && <div className="invalid-feedback">{error}</div>}
      </div>
    )
  }
}

export class TextareaFormGroup extends BaseFormGroup {

  render() {
    const {input, meta: { touched, error }, label, rows } = this.props
    const cls = 'form-control' + (touched && error ? ' is-invalid' : '')

    return (
      <div className="form-group">
        <label htmlFor={this.identity()}>{label}</label>
        <textarea {...input} id={this.identity()} className={cls} rows={rows} />
        {touched && error && <div className="invalid-feedback">{error}</div>}
      </div>
    )
  }
}

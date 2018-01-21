import './react-select-bootstrap.scss'
import React, { Component } from 'react'
import Select from 'react-select'

class BaseFormGroup extends Component {

  identity() {
    return this.props.input.name
  }

  render() {
    throw 'Cannot use `BaseFormGroup`'
  }
}

export class InputFormGroup extends BaseFormGroup {

  render() {
    const { input, meta: { touched, error }, label, type } = this.props
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
    const { input, meta: { touched, error }, label, rows } = this.props
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

const textParams = {
  placeholder: 'Select ...', // default: 'Select ...'
  noResultsText: 'No results found', // default: 'No results found'
  clearValueText: '', // default: 'Clear value'
}

export class SelectFormGroup extends BaseFormGroup {

  handleFocus = () => {
    this.select && this.select.focus()
  }

  handleBlur = () => {
    this.props.input.onBlur(this.props.input.value)
  }

  render() {
    const { input, meta: { touched, error }, label } = this.props

    return (
        <div className="form-group">
          <label onClick={this.handleFocus}>{label}</label>
          <Select
            options={this.selectOptions()}
            value={input.value}
            onChange={input.onChange} simpleValue={true}
            onFocus={input.onFocus}
            onBlur={this.handleBlur}
            openOnFocus={true}
            ref={(el) => this.select = el}
            {...textParams}
          />
          {touched && error && <div className="invalid-feedback" style={{display: 'block'}}>{error}</div>}
      </div>
    )
  }

  selectOptions() {
    const {options} = this.props
    return options.map(o => ({label: o[0], value: o[1]}))
  }
}

export class NSelectFormGroup extends BaseFormGroup {

  options() {
    const { options, includeBlank } = this.props
    let opts
    if (includeBlank) {
      opts = [['', '']].concat(options)
    } else {
      opts = options
    }

    return (
      opts.map(option => <option value={option[1]} key={option[0]}>{option[0]}</option>)
    )
  }

  render() {
    const { input, meta: { touched, error }, label } = this.props
    const cls = 'form-control' + (touched && error ? ' is-invalid' : '')

    return (
      <div className="form-group">
        <label htmlFor={this.identity()}>{label}</label>
        <select {...input} id={this.identity()} className={cls}>
          {this.options()}
        </select>
        {touched && error && <div className="invalid-feedback">{error}</div>}
      </div>
    )
  }
}

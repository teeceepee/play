import React, { Component } from 'react'
import ReactDOM from 'react-dom'

const MENU_CLASS = 'dropdown-menu'

export class Dropdown extends Component {
  constructor(props) {
    super(props)
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
  }

  componentDidMount() {
    document.addEventListener('click', this.handleDocumentClick)
  }

  componentWillUnmount() {
    document.removeEventListener('click', this.handleDocumentClick)
  }

  handleDocumentClick (event) {
    if (this.props.isOpen) {
      const triggerEl = ReactDOM.findDOMNode(this).children[0]
      const isInner = triggerEl.contains(event.target)

      if (!isInner) {
        setTimeout(() => { this.props.close() })
      }
    }
  }

  handleClick = () => {
    if (this.props.isOpen) {
      this.props.close()
    } else {
      this.props.open()
    }
  }

  triggerButton() {
    const trigger = this.props.trigger
    let el

    if (typeof trigger === 'string') {
      el = <div className="btn btn-primary dropdown-toggle">{trigger}</div>
    } else {
      el = trigger
    }

    return (
      <div onClick={this.handleClick} style={{display: 'inline-block'}}>{el}</div>
    )
  }

  render() {
    const menuCls = MENU_CLASS + (this.props.isOpen ? ' show' : '')

    return (
      <div className="dropdown">
        {this.triggerButton()}
        <div className={menuCls}>
          {this.props.children}
        </div>
      </div>
    )
  }
}


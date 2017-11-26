import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const MODAL_OPEN = 'modal-open'
const MODAL_DIALOG = 'modal-dialog'

const ClassName = {
  SCROLLBAR_MEASURER : 'modal-scrollbar-measure',
}

// inspired by Bootstrap modal.js
class ScrollbarChecker {

  checkScrollbar() {
    this.isBodyOverflowing = document.body.clientWidth < window.innerWidth
    this.scrollbarWidth = this._getScrollbarWidth()
  }

  setScrollbar() {
    if (this.isBodyOverflowing) {
      // Adjust body padding
      const actualPadding = document.body.style.paddingRight
      const calculatedPadding = getComputedStyle(document.body).paddingRight

      document.body.dataset.paddingRight = actualPadding
      document.body.style.paddingRight = `${parseFloat(calculatedPadding) + this.scrollbarWidth}px`
    }
  }

  resetScrollbar() {
    // Restore body padding
    const padding = document.body.dataset.paddingRight
    if (typeof padding !== 'undefined') {
      document.body.style.paddingRight = padding
      delete document.body.dataset.paddingRight
    }
  }

  _getScrollbarWidth() {
    const scrollDiv = document.createElement('div')
    scrollDiv.className = ClassName.SCROLLBAR_MEASURER
    document.body.appendChild(scrollDiv)
    const scrollbarWidth = scrollDiv.getBoundingClientRect().width - scrollDiv.clientWidth
    document.body.removeChild(scrollDiv)
    return scrollbarWidth
  }
}

export class Modal extends Component {

  constructor(props) {
    super(props)

    this.scrollbarChecker = new ScrollbarChecker()
  }

  componentWillReceiveProps(nextProps) {
    if (!this.props.isOpen && nextProps.isOpen) {
      this.beforeOpen()
    }
  }

  beforeOpen = () => {
    this.scrollbarChecker.checkScrollbar()
    this.scrollbarChecker.setScrollbar()
    document.querySelector('body').classList.add(MODAL_OPEN)
  }

  handleClose = () => {
    document.querySelector('body').classList.remove(MODAL_OPEN)
    this.scrollbarChecker.resetScrollbar()

    this.props.onClose()
  }

  handleBackdropClick = (event) => {
    const dialog = ReactDOM.findDOMNode(this).querySelector('.' + MODAL_DIALOG)

    if (!dialog.contains(event.target)) {
      this.handleClose()
    }
  }

  render() {
    if (this.props.isOpen) {
      return (
        <div>
          <div onClick={this.handleBackdropClick} style={{display: 'block'}} className={"modal show"} tabIndex="-1">
            <div className={MODAL_DIALOG}>
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">{this.props.title}</h5>
                  <button onClick={this.handleClose} type="button" className="close">
                    <span>&times;</span>
                  </button>
                </div>
                <div className="modal-body">
                  {this.props.children}
                </div>
              </div>
            </div>
          </div>

          {this.props.isOpen && <div className="modal-backdrop show"/>}
        </div>
      )
    } else {
      return null
    }
  }
}

Modal.defaultProps = {
  title: '',
}

Modal.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  title: PropTypes.string,
}

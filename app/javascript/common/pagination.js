import React, { Component } from 'react'
import PropTypes from 'prop-types'

export class Pagination extends Component {

  handleClick = (e) => {
    e.preventDefault()
    const pageNumber = parseInt(e.target.dataset.page)
    this.props.onPageChange(pageNumber)
  }

  render() {
    return (
      <ul className="pagination">
        {this.prevTag()}
        {this.pages()}
        {this.nextTag()}
      </ul>
    )
  }

  prevTag() {
    const cls = this.props.currentPage === 1 ? ' disabled' : ''
    return (
      <li className={"page-item" + cls}>
        <a onClick={this.handleClick} data-page={this.props.currentPage - 1} className="page-link" href="#">Prev</a>
      </li>
    )
  }

  nextTag() {
    const cls = this.props.currentPage === this.props.totalPages ? ' disabled' : ''
    return (
      <li className={"page-item" + cls}>
        <a onClick={this.handleClick} data-page={this.props.currentPage + 1} className="page-link" href="#">Next</a>
      </li>
    )
  }

  pageTag(n) {
    const cls = n === this.props.currentPage ? ' active' : ''
    return (
      <li className={"page-item" + cls} key={n}>
        <a onClick={this.handleClick} data-page={n} className="page-link" href="#">{n}</a>
      </li>
    )
  }

  pages() {
    let pageArray = []

    for (let n = 1; n <= this.props.totalPages; n++) {
      pageArray.push(this.pageTag(n))
    }

    return pageArray
  }
}

Pagination.propTypes = {
  onPageChange: PropTypes.func.isRequired,
  currentPage: PropTypes.number.isRequired,
  totalPages: PropTypes.number.isRequired,
}

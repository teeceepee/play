import React, { Component } from 'react'
import { NavLink } from 'react-router-dom'

export class Navbar extends Component {

  render() {
    return (
      <nav className="navbar navbar-expand-sm navbar-dark bg-primary">
        <div className="container justify-content-start">
          <a className="navbar-brand" href="#">Y</a>
          <ul className="navbar-nav">
            <NavLink exact to="/" className="nav-item nav-link">Home</NavLink>
            <NavLink to="/articles" className="nav-item nav-link">Articles</NavLink>
          </ul>
        </div>
      </nav>
    )
  }
}


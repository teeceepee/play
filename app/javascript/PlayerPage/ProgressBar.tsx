import './styles.scss'

import React, { PureComponent } from 'react'
import ReactDOM from 'react-dom'

interface BarProps {
  initial: number,
  max: number,
  left: number,
  onChange: (newLeft: number) => void,
  onNumberChange: (n: number) => void,
}

class ProgressBar extends PureComponent<BarProps> {
  static defaultProps = {
    left: 0,
  }

  startLeft: number | null = null
  startPageX: number | null = null
  maxLeft: number = 0
  trackEl: HTMLElement | null = null
  cursorEl: HTMLElement | null = null

  componentDidMount () {
    const el = ReactDOM.findDOMNode(this) as Element
    this.trackEl = el.querySelector<HTMLElement>('.progress-bar-track')
    this.cursorEl = el.querySelector<HTMLElement>('.progress-bar-cursor')

    if (this.trackEl && this.cursorEl) {
      this.maxLeft = this.trackEl.scrollWidth

      // Initialize cursor position
      const initialLeft = this.maxLeft * this.props.initial / this.props.max
      this.change(initialLeft)

      this.cursorEl.addEventListener('mousedown', this.mouseDownCallback)

      document.addEventListener('mouseup', this.mouseUpCallback)
      document.addEventListener('mousemove', this.mouseMoveCallback)

      window.addEventListener('resize', this.resizeCallback)
    }
  }

  componentWillUnmount () {
    if (this.cursorEl) {
      this.cursorEl.removeEventListener('mousedown', this.mouseDownCallback)
      this.cursorEl = null
    }

    document.removeEventListener('mouseup', this.mouseUpCallback)
    document.removeEventListener('mousemove', this.mouseMoveCallback)

    window.removeEventListener('resize', this.resizeCallback)
  }

  private mouseDownCallback = (e: MouseEvent) => {
    this.startLeft = (e.currentTarget as HTMLElement).offsetLeft
    this.startPageX = e.pageX
  }

  private mouseUpCallback = () => {
    this.startLeft = null
    this.startPageX = null
  }

  private mouseMoveCallback = (e: MouseEvent) => {
    if (this.startLeft != null && this.startPageX) {
      const newLeft = this.startLeft + e.pageX - this.startPageX

      const normalized: number = newLeft < 0 ? 0 : Math.min(newLeft, this.maxLeft)
      this.change(normalized)
    }
  }

  private resizeCallback = () => {
    if (this.trackEl && this.maxLeft != this.trackEl.scrollWidth) {
      const width = this.trackEl.scrollWidth
      const factor = width / this.maxLeft
      const scaledLeft = this.props.left * factor
      this.maxLeft = width

      this.change(scaledLeft, false)
    }
  }

  private change (newLeft: number, changeNumber: boolean = true) {
    this.props.onChange(newLeft)

    if (changeNumber) {
      this.props.onNumberChange(Math.floor(newLeft / this.maxLeft * this.props.max))
    }
  }

  render () {
    return (
      <div className="progress-bar-container">
        <div className="progress-bar-wrapper">
          <div className="progress-bar-track"/>
          <div className="progress-bar-cursor" style={{left: this.leftStyle()}}/>
        </div>
      </div>
    )
  }

  private leftStyle () {
    return `${this.props.left}px`
  }
}

interface BarContProps {
  current: number,
  max: number,
  onNumberChange: (n: number) => void,
}

interface BarContStates {
  left: number,
}

export class ProgressBarCont extends PureComponent<BarContProps, BarContStates> {
  static defaultProps = {
    current: 0,
    max: 100,
  }

  state = {
    left: 0
  }

  handleChange = (newLeft: number) => {
    this.setState({
      left: newLeft,
    })
  }

  render () {
    const initial = Math.min(this.props.current, this.props.max)

    return (
      <ProgressBar
        initial={initial}
        max={this.props.max}
        onNumberChange={this.props.onNumberChange}
        left={this.state.left}
        onChange={this.handleChange}
      />
    )
  }
}

interface ExampleStates {
  current: number,
}

export class ProgressBarExample extends PureComponent<any, ExampleStates> {

  state = {
    current: 1000,
  }

  handleNumberChange = (n: number) => {
    this.setState({
      current: n,
    })
  }

  render () {
    return (
      <div>
        <ProgressBarCont
          current={this.state.current}
          max={100}
          onNumberChange={this.handleNumberChange}
        />
        <div style={{fontSize: this.fontSize()}}>{this.state.current}</div>
      </div>
    )
  }

  private fontSize () {
    const size = Math.max(this.state.current, 16)
    return `${size}px`;
  }
}

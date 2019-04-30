import './styles.scss'

import React, { Component } from 'react'
import { Board, GameStatus, Pos, Square, SquareState } from './board'
import { Instructions } from './instructions'

const COUNT = 3

interface CellProps {
  square: Square
  onClick: (pos: Pos) => void
  onContextMenu: (pos: Pos) => void
}

class Cell extends Component<CellProps> {

  public handleClick = () => {
    this.props.onClick({
      row: this.props.square.row,
      col: this.props.square.col,
    })
  }

  public handleContextMenu: React.MouseEventHandler = (e) => {
    e.preventDefault()

    this.props.onContextMenu({
      row: this.props.square.row,
      col: this.props.square.col,
    })
  }

  public render () {
    const { state } = this.props.square

    const exposedClass = state === SquareState.EXPOSED ? 'exposed' : ''
    return (
      <div className={'miner-cell ' + exposedClass} onClick={this.handleClick} onContextMenu={this.handleContextMenu}>
        <div>{this.displayText()}</div>
      </div>
    )
  }

  private displayText (): string {
    const { isBomb, num, state } = this.props.square

    if (state === SquareState.UNKNOWN) {
      return ''
    } else if (state === SquareState.MARKED) {
      return 'F'
    } else {
      if (!isBomb) {
        return num > 0 ? String(num) : ''
      } else {
        // 显示地雷的话游戏已结束
        return 'B'
      }
    }
  }
}

interface MinerProps {
  rows: number
  cols: number
}

interface MinerState {
  gameState: GameStatus
  squares: Square[][]
}

class Miner extends Component<MinerProps, MinerState> {
  public static defaultProps = {
    rows: 10,
    cols: 20,
  }

  private readonly board: Board

  constructor (props: MinerProps) {
    super(props)

    this.board = new Board(this.props.rows, this.props.cols, COUNT)

    const { gameState, squares } = this.board.getState()

    this.state = {
      gameState,
      squares,
    }
  }

  public handleCellClick = (pos: Pos): void => {
    this.board.sweep(pos)

    this.setBoardState()
  }

  public handleCellContextMenu = (pos: Pos): void => {
    this.board.mark(pos)

    this.setBoardState()
  }

  public render () {
    const rows = Array.from({length: this.state.squares.length}).map((_, i: number) => {
      const column: Square[] = this.state.squares[i]

      const cols = Array.from({length: column.length}).map((_, j: number) => {
        const square = column[j]

        return (
          <Cell
            key={j}
            square={square}
            onClick={this.handleCellClick}
            onContextMenu={this.handleCellContextMenu}
          />
        )
      })

      return <div className="miner-row" key={i}>{cols}</div>
    })

    return (
      <div className="miner-page p-5">
        <div>{this.state.gameState}</div>
        <div className="miner-grid-wrapper">
          <div className="miner-grid m-auto">
            {rows}
          </div>
        </div>

        <Instructions/>
      </div>
    )
  }

  private setBoardState () {
    const { gameState, squares } = this.board.getState()

    this.setState({
      gameState,
      squares,
    })
  }
}

export const MinerPage = Miner

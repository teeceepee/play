import { randomNumbers } from './utils'

export enum SquareState {
  UNKNOWN = 'UNKNOWN',
  MARKED = 'MARKED',
  EXPOSED = 'EXPOSED',
}

export class Square {
  public readonly row: number
  public readonly col: number
  public isBomb: boolean = false
  public num: number = 0
  public state: SquareState = SquareState.UNKNOWN

  constructor (row: number, col: number) {
    this.row = row
    this.col = col
  }
}

export interface Pos {
  row: number
  col: number
}

export enum GameStatus {
  NOT_STARTED = 'NOT_STARTED',
  STARTED = 'STARTED',
  WON = 'WON',
  LOST = 'LOST',
}

export class Board {
  private readonly rows: number
  private readonly cols: number
  private readonly bombs: number
  private readonly rowArray: Square[][]
  private status: GameStatus

  constructor (rows: number, cols: number, bombs: number) {
    this.rows = rows
    this.cols = cols
    this.bombs = bombs

    this.rowArray = new Array(this.rows)
    for (let r = 0; r < rows; r++) {
      const squares = new Array(this.cols)

      for (let c = 0; c < cols; c++) {
        squares[c] = new Square(r + 1, c + 1)
      }

      this.rowArray[r] = squares
    }

    this.status = GameStatus.NOT_STARTED
  }

  // 挖开一个方格
  public sweep (pos: Pos): void {
    if (this.status === GameStatus.NOT_STARTED) {
      this.init(pos)
    } else if (this.status === GameStatus.WON || this.status === GameStatus.LOST) {
      return
    }

    const square = this.getSquare(pos)
    if (square.state === SquareState.MARKED) {
      return
    }

    square.state = SquareState.EXPOSED

    if (!square.isBomb) {
      this.exposeExtraSquares(pos)
    }

    this.judge()
  }

  // 标记一个方格
  // 未知状态和标记状态可以互相转换
  public mark (pos: Pos): void {
    if (this.status !== GameStatus.STARTED) {
      return
    }

    const square = this.getSquare(pos)
    if (square.state === SquareState.UNKNOWN) {
      square.state = SquareState.MARKED
    } else if (square.state === SquareState.MARKED) {
      square.state = SquareState.UNKNOWN
    }

    this.judge()
  }

  public getState () {
    return {
      gameState: this.status,
      squares: this.rowArray,
    }
  }

  private getSquare (pos: Pos): Square {
    return this.rowArray[pos.row - 1][pos.col - 1]
  }

  // 失败条件：挖到雷
  // 胜利条件：
  // 1. 所有雷都被正确标记
  // 2. 没有错误标记
  // 3. 所有不是雷的格子都挖开了
  private judge (): void {
    if (this.status !== GameStatus.STARTED) {
      return
    }

    let exposedCount: number = 0
    let correctMarks: number = 0
    let wrongMarks: number = 0

    const maxIdx = this.rows * this.cols
    for (let idx = 0; idx < maxIdx; idx++) {
      const pos = this.indexToPos(idx)
      const square = this.getSquare(pos)

      if (square.state === SquareState.MARKED) {
        if (square.isBomb) {
          // 正确标记的数量加一
          correctMarks += 1
        } else {
          // 错误标记的数量加一
          wrongMarks += 1
        }
      } else if (square.state === SquareState.EXPOSED) {
        // 挖到雷了，失败
        if (square.isBomb) {
          this.status = GameStatus.LOST
          return
        }

        exposedCount += 1
      }
    }

    const allExposed: boolean = exposedCount + this.bombs === maxIdx

    if (allExposed && correctMarks === this.bombs) {
      this.status = GameStatus.WON
    }
  }

  // 初始化
  // 1. 埋雷
  // 2. 计算数字
  private init (pos: Pos): void {
    if (this.status !== GameStatus.NOT_STARTED) {
      return
    }

    this.status = GameStatus.STARTED

    // 初始点的 index
    const initIndex = this.posToIndex(pos)

    const indices = randomNumbers(this.rows * this.cols - 1, this.bombs)

    // 埋雷
    indices.forEach((i: number) => {
      // 跳过初始点
      const index = i < initIndex ? i : i + 1

      const bombPos = this.indexToPos(index)

      this.getSquare(bombPos).isBomb = true
    })

    // 计算数字
    const maxIdx = this.rows * this.cols
    for (let idx = 0; idx < maxIdx; idx++) {
      const position = this.indexToPos(idx)

      const adj = this.getAdjacentPositions(position)

      const bombAdj = adj.filter((adjPos: Pos) => {
        return this.getSquare(adjPos).isBomb
      })

      this.getSquare(position).num = bombAdj.length
    }
  }

  // 0 -> (1, 1)
  // 1 -> (1, 2)
  // 10 -> (2, 1)
  private indexToPos (index: number): Pos {
    const r = Math.floor(index / this.cols)
    const c = index % this.cols

    return {
      row: r + 1,
      col: c + 1,
    }
  }

  // (row, col) index = (row - 1) * this.cols + (col - 1)
  private posToIndex (pos: Pos): number {
    return (pos.row - 1) * this.cols + pos.col - 1
  }

  private getAdjacentPositions (pos: Pos): Pos[] {
    const { row, col } = pos

    const positions = [
      {row: row - 1, col: col - 1}, // top left
      {row: row - 1, col}, // top
      {row: row - 1, col: col + 1}, // top right
      {row, col: col + 1}, // right
      {row: row + 1, col: col + 1}, // bottom right
      {row: row + 1, col}, // bottom
      {row: row + 1, col: col - 1}, // bottom left
      {row, col: col - 1}, // left
    ]

    return positions.filter((position: Pos): boolean => this.isPosInBoard(position))
  }

  // row range: [1, this.rows]
  // col range: [1, this.cols]
  private isPosInBoard (pos: Pos): boolean {
    const falseCondition = pos.row < 1 || pos.row > this.rows || pos.col < 1 || pos.col > this.cols
    return !falseCondition
  }

  // 展开相关的方块
  private exposeExtraSquares (pos: Pos): void {
    this.getConnectedSafePositions(pos).forEach((safePos: Pos) => {
      const square = this.getSquare(safePos)
      square.state = SquareState.EXPOSED

      const adj = this.getAdjacentPositions(safePos)

      adj.forEach((position: Pos) => {
        const sq = this.getSquare(position)

        if (sq.state === SquareState.UNKNOWN && !sq.isBomb && sq.num > 0) {
          sq.state = SquareState.EXPOSED
        }
      })
    })
  }

  // 查找相邻的安全方块的位置
  private getAdjacentSafePositions (pos: Pos): Pos[] {
    const adj = this.getAdjacentPositions(pos)

    return adj.filter((adjPos: Pos): boolean => {
      const square = this.getSquare(adjPos)

      return square.state === SquareState.UNKNOWN && !square.isBomb && square.num === 0
    })
  }

  // 查找连续的安全区域，递归
  private getConnectedSafePositionsRecur (pos: Pos, indexSet: Set<number>): void {
    this.getAdjacentSafePositions(pos).forEach((adjPos: Pos): void => {
      const idx = this.posToIndex(adjPos)

      if (!indexSet.has(idx)) {
        indexSet.add(this.posToIndex(adjPos))
        this.getConnectedSafePositionsRecur(adjPos, indexSet)
      }
    })
  }

  // 查找连续的安全区域
  private getConnectedSafePositions (pos: Pos): Pos[] {
    const indexSet = new Set<number>()

    this.getConnectedSafePositionsRecur(pos, indexSet)

    const positions: Pos[] = []
    indexSet.forEach((idx: number) => {
      positions.push(this.indexToPos(idx))
    })
    return positions
  }
}

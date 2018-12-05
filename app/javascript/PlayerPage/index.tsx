import React, { PureComponent } from 'react'
import { ProgressBarExample } from './ProgressBar'

class Player extends PureComponent {

  render() {
    return (
      <div className="container mt-4">
        <h1>Player</h1>

        <ProgressBarExample/>
      </div>
    )
  }
}

export const PlayerPage = Player

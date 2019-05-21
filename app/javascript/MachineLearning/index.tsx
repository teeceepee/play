import React, { PureComponent } from 'react'
import * as $script from 'scriptjs'

interface State {
  component: React.ComponentType | null
}

class MachineLearning extends PureComponent<{}, State> {

  public state: State = {
    component: null,
  }

  public componentDidMount () {
    $script('https://unpkg.com/ml5@0.1.1/dist/ml5.min.js', async () => {
      const module = await import('./ImageClassifier')

      this.setState({
        component: module.ImageClassifier,
      })
    })
  }

  public render () {
    return (
      <div className="container mt-4">
        {this.inner()}
      </div>
    )
  }

  private inner () {
    if (this.state.component != null) {
      return React.createElement(this.state.component)
    } else {
      return <div>Loading...</div>
    }
  }
}

export const MachineLearningPage = MachineLearning

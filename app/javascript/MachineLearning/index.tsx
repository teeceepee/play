import React, { PureComponent } from 'react'
import { ImageClassifier } from './ImageClassifier'

class MachineLearning extends PureComponent {

  render() {
    return (
      <div className="container mt-4">
        <ImageClassifier/>
      </div>
    )
  }
}

export const MachineLearningPage = MachineLearning

import React, { PureComponent } from 'react'

declare var ml5: any

interface PredictResult {
  className: string
  probability: number
}

export class ImageClassifier extends PureComponent {

  state = {
    input: '',
    imageSrc: '',
    results: [],
    predicting: false,
  }

  handleChange = (e: any) => {
    this.setState({input: e.target.value})
  }

  handleLoad = () => {
    this.setState({imageSrc: this.state.input})
  }

  handleImageLoad = (e: any) => {
    const img = e.target
    this.predict(img)
  }

  predict = (img: any) => {
    this.setState({predicting: true})
    const classifier = ml5.imageClassifier('MobileNet', () => {
      classifier.predict(img, (err: any, results: any) => {
        if (err) {
          alert(err)
        }

        this.setState({
          results: results || [],
          predicting: false,
        })
      })
    })
  }


  render () {
    return (
      <div>
        <h2>Image Classifier</h2>

        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <input
                type="text"
                value={this.state.input}
                onChange={this.handleChange}
                className="form-control"
              />
            </div>
            <div className="form-group">
              <button onClick={this.handleLoad} className="btn btn-outline-primary">Load</button>
            </div>
          </div>
        </div>


        <div className="row">
          <div className="col-sm-6">
            <img
              src={this.state.imageSrc}
              crossOrigin="anonymous"
              onLoad={this.handleImageLoad}
              className="img-fluid"
            />
          </div>
          <div className="col-sm-6">
            {this.results()}
          </div>
        </div>


      </div>
    )
  }

  results () {
    if (this.state.predicting) {
      return <span>predicting...</span>
    }

    if (this.state.results.length > 0) {
      const rows = this.state.results.map((result: PredictResult) => {
        return (
          <tr key={`${result.className}-${result.probability}`}>
            <td>{result.className}</td>
            <td>{result.probability}</td>
          </tr>
        )
      })

      return (
        <table className="results table">
          <thead>
            <tr>
              <th>Class name</th>
              <th>Probability</th>
            </tr>
          </thead>
          <tbody>
            {rows}
          </tbody>
        </table>
      )
    }
  }
}

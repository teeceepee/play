class BilibiliRandom extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      gifState: 'initialized',
      gif: {}
    }
  }

  componentDidMount() {
    setTimeout(() => {
      this.setState(Object.assign({}, this.state, {
        gifState: 'fetching'
      }))
      $.get({
        url: '/d/bilibili_gifs/random',
      }).done((data) => {
        setTimeout(() => {
          let img = new Image()

          img.addEventListener("load", () => {
            this.setState({
              gifState: 'fetched',
              gif: data
            })
          })

          img.src = data.icon
        }, 2000)
      })
    }, 2000)
  }

  componentWillUnmount() {
    console.log('Unmount')
  }

  gif() {
    return this.state.gif
  }

  stateString() {
    return JSON.stringify(this.state, undefined, 2)
  }

  container() {
    if (this.state.gifState == 'fetched') {
      return (
        <div className="gif-container">
          <img
            src={this.gif().icon}
            alt={this.gif().title}
            className="gif-img img-thumbnail"
          />
          <div className="gif-title help-block">
            {this.gif().title}
          </div>
        </div>
      )
    } else if (this.state.gifState == 'fetching') {
      return (
        <div>
          <i className="fa fa-spinner fa-spin"></i>
        </div>
      )
    } else {
      return (
        <div></div>
      )
    }
  }

  render() {
    return (
      <div>
        <div className="gif-container">
          {this.container()}
        </div>
        <pre>
          {this.stateString()}
        </pre>
      </div>

    )
  }
}

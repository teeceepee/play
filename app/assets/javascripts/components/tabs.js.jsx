
class TabBar extends React.Component {

  constructor(props) {
    super(props)

    this.state = {
      selected: 1,
      tabs: [
        {
          text: 'first'
        },
        {
          text: 'second'
        }
      ]
    }
  }

  handleSelect(index) {
    let newState = {
      selected: index,
      tabs: this.state.tabs
    }
    this.setState(newState)
  }


  items() {
    return this.state.tabs.map((tab, i) => {
      return (
        <TabItem
          key={i}
          tab={tab}
          index={i}
          active={this.state.selected == i}
          onSelect={this.handleSelect.bind(this)}
        >
        </TabItem>
      )
    })
  }

  render() {
    return (
      <ul
        className="tabs"
      >
        {this.items()}
      </ul>
    )
  }
}

class TabItem extends React.Component {

  handleClick() {
    this.props.onSelect(this.props.index);
  }

  render() {
    let classes = this.props.active ? 'tab active' : 'tab'
    return (
      <li
        className={classes}
        onClick={this.handleClick.bind(this)}
      >
        {this.props.tab.text}
      </li>
    )
  }
}


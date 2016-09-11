//= require react

var Gif = React.createClass({
  displayName: 'Gif',

  getInitialState: function () {
    return {
      selected: false
    };
  },

  handleClick: function () {
    this.setState({
      selected: true
    });

    setTimeout(function () {
      this.setState({
        selected: false
      })
    }.bind(this), 1500);
  },

  handleMouseEnter: function () {
    this.setState({
      selected: true
    });
  },

  handleMouseLeave: function () {
    this.setState({
      selected: false
    });
  },

  href: function() {
    return this.props.gif.links[0];
  },

  isNew: function() {
    var now = Math.floor(Date.now() / 1000);
    var postTime = Number.parseInt(this.props.gif.posttime);
    return now - postTime < (3 * 24 * 3600);
  },

  isSelected: function () {
    return this.state.selected;
  },

  img: function() {
    return React.createElement('img', {
      src: this.props.gif.icon,
      title: this.props.gif.title,
      alt: this.props.gif.title,
      onClick: this.handleClick,
      onMouseEnter: this.handleMouseEnter,
      onMouseLeave: this.handleMouseLeave,
    });
  },

  title: function() {
    return React.createElement(
      'div',
      null,
      React.createElement(
        'span',
        null,
        this.props.gif.id + ' '
      ),
      React.createElement(
        'a',
        {
          className: 'search-link',
          href: this.href(),
          target: '_blank'
        },
        this.props.gif.title
      )
    );
  },

  a: function() {
    return React.createElement('a', {title: this.props.gif.title, target: '_blank'}, this.img());
  },

  render: function() {
    var classes = ['gif'];
    if (this.isNew()) {
      classes.push('new');
    }
    if (this.isSelected()) {
      classes.push('selected')
    }

    return React.createElement(
      'div',
      {className: classes.join(' ')},
      this.title(),
      this.a());
  }
});

var GifList = React.createClass({
  displayName: 'GifList',

  gifs: function(gifs) {
    return gifs.map(function(gif) {
      return React.createElement(Gif, {gif: gif})
    });
  },
  render: function() {
    nodes = this.gifs(this.props.gifs);
    return React.createElement('div', {className: 'gif-list'}, nodes);
  }
});

var renderAll = function(gifs) {
  ReactDOM.render(
    React.createElement(GifList, {gifs: gifs}),
    document.getElementById('gifs-container')
  );
};


var url = '/d/bilibili_gifs';
var xhr = $.ajax({
  url: url,
  method: 'get',
  dateType: 'json'
}).done(function(data) {
  var gifs = data.fix;
  renderAll(gifs);
});

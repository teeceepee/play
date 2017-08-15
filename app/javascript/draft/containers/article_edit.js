import React from "react"
import { connect } from "react-redux"
import { updateArticle } from "../reducers/root"

class ArticleEdit extends React.Component {

  constructor(props) {
    super(props)

    this.onChange = this.onChange.bind(this)
  }

  onChange(e) {
    const { article, updateArticle } = this.props

    const edited = Object.assign({}, article, {
      [e.target.name]: e.target.value
    })

    updateArticle(edited)
  }

  render() {
    const { article } = this.props
    return (
      <div>
        <h2>Article Edit #{article.id} {article.title}</h2>

        <form action="">
          <div className="form-group">
            <input type="text" name="title" value={article.title} className="form-control" onChange={this.onChange} />
          </div>

          <div className="form-group">
            <textarea name="content" value={article.content} className="form-control" onChange={this.onChange}></textarea>
          </div>
        </form>
      </div>
    )
  }
}


function mapStateToProps(state) {
  return {
    article: state.forms.articleForm
  }
}

function mapDispatchToProps(dispatch) {
  return {
    updateArticle: (article) => {
      dispatch(updateArticle(article))

    }
  }
}

export const ArticleEditCont = connect(
  mapStateToProps,
  mapDispatchToProps,
)(ArticleEdit)

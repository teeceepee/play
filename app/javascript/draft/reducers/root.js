import { combineReducers } from 'redux'
import { push } from 'react-router-redux'
import { reducer as formReducer, stopSubmit } from 'redux-form'
import { createAction, handleActions } from 'redux-actions'
import http from 'utils/http'

export const updateTitle = createAction('UPDATE_TITLE')

const currentTitle = handleActions({
  [updateTitle]: (state, action) => action.payload,
}, 'draft')

const requestArticles = createAction('REQUEST_ARTICLES')
const receiveArticles = createAction('RECEIVE_ARTICLES')

export function fetchArticles() {
  return function(dispatch) {
    dispatch(requestArticles())

    http.get("/articles")
      .then(resp => {
        dispatch(receiveArticles(resp.data))
      })

  }
}

const submitArticle = createAction('SUBMIT_ARTICLE')
const savedArticle = createAction('SAVED_ARTICLE', article => article)

export function updateArticle(article) {
  return function(dispatch) {
    dispatch(submitArticle())

    http.patch(`/articles/${article.id}`, article)
      .then(_ => {
        dispatch(savedArticle(article))
        dispatch(toggleArticleForm(article))
        dispatch(push('/articles'))
      })
  }
}

const articles = handleActions({
  [receiveArticles]: (state, action) => action.payload,
  [savedArticle]: (state, action) => (
    state.map(article => (article.id === action.payload.id ? action.payload : article))
  ),
}, [])


function selectedArticleId(state = null, action) {
  switch (action.type) {
    case EDIT_ARTICLE:
      return action.article.id
    default:
      return state
  }
}

const RECEIVE_ARTICLE = "RECEIVE_ARTICLE"
function receiveArticle(article) {
  return {
    type: RECEIVE_ARTICLE,
    article: article
  }
}

export function fetchArticle(id) {
  return function (dispatch) {
    http.get(`/articles/${id}`)
      .then(resp => {
        dispatch(receiveArticle(resp.data))
      })
  }
}


export const EDIT_ARTICLE = "EDIT_ARTICLE"

export function editArticle(article) {
  return {
    type: EDIT_ARTICLE,
    article: article,
  }
}

export const UPDATE_ARTICLE_FORM = "UPDATE_ARTICLE_FORM"

export function updateArticleForm(editedArticle) {
  return {
    type: UPDATE_ARTICLE_FORM,
    article: editedArticle
  }
}



export function createArticle(article) {
  return function(dispatch) {
    dispatch(submitArticle())

    http.post('/articles', {article: article})
      .then(_ => {
        dispatch(push('/articles'))
      })
      .catch(error => {
        const errors = error.response.data.errors
        const fields = Object.keys(errors)
        let submitErrors = {}

        fields.forEach(field => {
          if (errors[field] && errors[field].length > 0) {
            submitErrors[field] = errors[field].join(' ')
          }
        })

        dispatch(stopSubmit('article-new', submitErrors))
      })
  }
}

function articleForm(state = {title: '', content: ''}, action) {
  switch (action.type) {
    case EDIT_ARTICLE:
      return action.article
    case UPDATE_ARTICLE_FORM:
      return action.article
    case RECEIVE_ARTICLE:
      return action.article
    default:
      return state
  }
}

export const toggleArticleForm = createAction('TOGGLE_ARTICLE_FORM', article => article)

const articleFormVisible = handleActions({
  [toggleArticleForm]: (state, action) => {
    const articleId = action.payload.id
    return {
      [articleId]: !state[articleId],
    }
  }
}, {})

export const toggleArticleDropdown = createAction('TOGGLE_ARTICLE_DROPDOWN', article => article)

const articleDropdownVisible = handleActions({
  [toggleArticleDropdown]: (state, action) => {
    const articleId = action.payload.id
    return {
      [articleId]: !state[articleId],
    }
  }
}, {})

export const showModal = createAction('SHOW_MODAL', identity => identity)
export const hideModal = createAction('HIDE_MODAL', identity => identity)

const modals = handleActions({
  [showModal]: (state, action) => ({[action.payload]: true}),
  [hideModal]: (state, action) => ({[action.payload]: false})
}, {})

const forms = combineReducers({
  articleForm
})

export const rootReducerObject = {
  currentTitle,
  articles,
  selectedArticleId,
  articleFormVisible,
  articleDropdownVisible,
  modals,
  forms,
  form: formReducer,
}

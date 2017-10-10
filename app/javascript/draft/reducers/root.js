import { combineReducers } from 'redux'
import { push } from 'react-router-redux'
import { reducer as formReducer } from 'redux-form'
import http from 'utils/http'

const UPDATE_TITLE = "UPDATE_TITLE"

export function updateTitle(title) {
  return {
    type: UPDATE_TITLE,
    title: title,
  }
}

function currentTitle(state = "draft", action) {
  switch (action.type) {
    case UPDATE_TITLE:
      return action.title
    default:
      return state
  }
}

function articles(state = [], action) {
  switch (action.type) {
    case RECEIVE_ARTICLES:
      return action.articles
    default:
      return state
  }

}

function selectedArticleId(state = null, action) {
  switch (action.type) {
    case EDIT_ARTICLE:
      return action.article.id
    default:
      return state
  }
}

export const REQUEST_ARTICLES = "REQUEST_ARTICLES"
export const RECEIVE_ARTICLES = "RECEIVE_ARTICLES"
export const RECEIVE_ARTICLE = "RECEIVE_ARTICLE"

function requestArticles() {
  return {
    type: REQUEST_ARTICLES,
  }
}

function receiveArticles(articles) {
  return {
    type: RECEIVE_ARTICLES,
    articles: articles
  }
}

function receiveArticle(article) {
  return {
    type: RECEIVE_ARTICLE,
    article: article
  }
}


export function fetchArticles() {
  return function(dispatch) {
    dispatch(requestArticles())

    http.get("/articles")
      .then(resp => {
        dispatch(receiveArticles(resp.data))
      })

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

export const SUBMIT_ARTICLE = "SUBMIT_ARTICLE"
export const SAVED_ARTICLE = "SAVED_ARTICLE"

function submitArticle() {
  return {
    type: SUBMIT_ARTICLE,
  }
}

function savedArticle(article) {
  return {
    type: SAVED_ARTICLE,
    article: article,
  }
}

export function updateArticle(article) {
  return function(dispatch) {
    dispatch(submitArticle())

    http.patch(`/articles/${article.id}`, article)
      .then(_ => {
        dispatch(savedArticle(article))
        dispatch(push('/articles'))
      })
  }
}

export function createArticle(article) {
  return function(dispatch) {
    dispatch(submitArticle())

    http.post('/articles', {article: article})
      .then(_ => {
        dispatch(push('/articles'))
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

const forms = combineReducers({
  articleForm
})

export const rootReducerObject = {
  currentTitle,
  articles,
  selectedArticleId,
  forms,
  form: formReducer,
}

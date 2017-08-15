import { combineReducers } from "redux"
import axios from "axios"

let token = document.getElementsByName('csrf-token')[0].content
axios.defaults.headers.common["X-CSRF-Token"] = token

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

export const CHANGE_PATH = "CHANGE_PATH"

export function changePath(path) {
  return {
    type: CHANGE_PATH,
    path: path,
  }
}


let initialPaths = [
  'index',
  'new',
  'edit',
]

function path(state = "index", action) {
  switch (action.type) {
    case CHANGE_PATH:
      return action.path
    case EDIT_ARTICLE:
      return 'edit'
    default:
      return state
  }
}


function paths(state = initialPaths) {
  return state
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

export function fetchArticles() {
  return function(dispatch) {
    dispatch(requestArticles())

    axios.get("/articles.json")
      .then(resp => {
        dispatch(receiveArticles(resp.data))
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

    axios.patch(`/articles/${article.id}.json`, article)
      .then(_ => {
        dispatch(savedArticle(article))
        dispatch(changePath("index"))
      })
  }

}

function articleForm(state = {}, action, s) {
  switch (action.type) {
    case EDIT_ARTICLE:
      return action.article
    case UPDATE_ARTICLE_FORM:
      return action.article
    default:
      return state
  }
}

const forms = combineReducers({
  articleForm
})

export const rootReducer = combineReducers({
  currentTitle,
  path,
  paths,
  articles,
  selectedArticleId,
  forms,
})

import { combineReducers } from "redux"

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

let initialArticles = [
  {
    id: 1,
    title: 'First',
    content: 'First content.',
  },
  {
    id: 2,
    title: 'Second',
    content: 'Second content.',
  }
]

function articles(state = initialArticles, action) {
  switch (action.type) {
    // case UPDATE_ARTICLE:
    //   return state.map((article) => {
    //     if (article.id === action.article.id) {
    //       return action.article
    //     } else {
    //       return article
    //     }
    //   })
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

export const EDIT_ARTICLE = "EDIT_ARTICLE"

export function editArticle(article) {
  return {
    type: EDIT_ARTICLE,
    article: article,
  }
}

export const UPDATE_ARTICLE = "UPDATE_ARTICLE"

export function updateArticle(editedArticle) {
  return {
    type: UPDATE_ARTICLE,
    article: editedArticle
  }
}

function articleForm(state = {}, action, s) {
  switch (action.type) {
    case EDIT_ARTICLE:
      return action.article
    case UPDATE_ARTICLE:
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

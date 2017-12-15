import { createAction } from 'redux-actions'

export const showModal = createAction('SHOW_MODAL', identity => identity)
export const hideModal = createAction('HIDE_MODAL', identity => identity)


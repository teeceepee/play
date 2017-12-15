import { handleActions } from 'redux-actions'
import { showModal, hideModal } from './actions'

export const modal = handleActions({
  [showModal]: (state, action) => ({[action.payload]: true}),
  [hideModal]: (state, action) => ({[action.payload]: false})
}, {})

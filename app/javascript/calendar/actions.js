import { createAction } from 'redux-actions'

export const selectPrevMonth = createAction('SELECT_PREV_MONTH')
export const selectNextMonth = createAction('SELECT_NEXT_MONTH')
export const selectCurrentMonth = createAction('SELECT_CURRENT_MONTH')

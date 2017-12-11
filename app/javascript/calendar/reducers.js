import moment from 'moment'
import { handleActions } from 'redux-actions'
import {
  selectNextMonth,
  selectPrevMonth,
  selectCurrentMonth,
  fetchNbaGamesSuccess,
} from './actions'

const today = moment()

const initialState = {
  year: today.year(),
  month: today.month(),
  today: today.format('YYYY-MM-DD'),
  utcOffset: '+08:00',
}

export const calendar = handleActions({
  [selectPrevMonth]: (state) => {
    let newDate
    if (state.month === 0) {
      newDate = {
        ...state,
        year: state.year - 1,
        month: 11,
      }
    } else {
      newDate = {
        ...state,
        year: state.year,
        month: state.month - 1,
      }
    }
    return newDate
  },
  [selectNextMonth]: (state) => {
    let newDate
    if (state.month === 11) {
      newDate = {
        ...state,
        year: state.year + 1,
        month: 0,
      }
    } else {
      newDate = {
        ...state,
        year: state.year,
        month: state.month + 1,
      }
    }
    return newDate
  },
  [selectCurrentMonth]: (state) => {
    const today = moment(state.today)
    return {
      ...state,
      year: today.year(),
      month: today.month(),
    }
  },
}, initialState)

export const nbaGames = handleActions({
  [fetchNbaGamesSuccess]: (state, action) => {
    const newGames = action.payload
    const newIds = newGames.map(game => game.id)
    const filteredGames = state.filter(game => !newIds.includes(game.id))

    return [...filteredGames, ...action.payload]
  },
}, [])

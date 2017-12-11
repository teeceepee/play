import { createAction } from 'redux-actions'
import moment from 'moment'
import http from 'utils/http'

export const selectPrevMonth = createAction('SELECT_PREV_MONTH')
export const selectNextMonth = createAction('SELECT_NEXT_MONTH')
export const selectCurrentMonth = createAction('SELECT_CURRENT_MONTH')

export const fetchNbaGamesSuccess = createAction('FETCH_NBA_GAMES_SUCCESS', games => games)

export function fetchNbaGames() {
  return function(dispatch, getState) {
    const { calendar } = getState()

    http.get("/d/nba_games", {
      params: {
        year: calendar.year,
        month: calendar.month + 1,
        utc_offset: calendar.utcOffset,
      }
    }).then(resp => {
      const games = resp.data.data.map(game => {
        const startTime = moment(game.start_time)
        startTime.utcOffset(calendar.utcOffset)
        return {...game, startTime}
      })
      dispatch(fetchNbaGamesSuccess(games))
    })
  }
}

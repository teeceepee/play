import { createAction } from 'redux-actions'
import moment from 'moment'
import http from 'utils/http'

export const selectPrevMonth = createAction('SELECT_PREV_MONTH')
export const selectNextMonth = createAction('SELECT_NEXT_MONTH')
export const selectCurrentMonth = createAction('SELECT_CURRENT_MONTH')

export const fetchNbaGamesSuccess = createAction('FETCH_NBA_GAMES_SUCCESS', games => games)

export function fetchNbaGames(year, month, utcOffset) {
  return function(dispatch) {
    http.get("/d/nba_games", {
      params: {
        year: year,
        month: month + 1,
        utc_offset: utcOffset,
      }
    }).then(resp => {
      const games = resp.data.data.map(game => ({...game, startTime: moment(game.start_time)}))
      dispatch(fetchNbaGamesSuccess(games))
    })
  }
}

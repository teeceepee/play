import './styles.scss'
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import moment from 'moment'

import { Modal, showModal } from '../common/modal'

import {
  selectPrevMonth,
  selectNextMonth,
  selectCurrentMonth,
  fetchNbaGames,
} from './actions'

class DayCell extends Component {

  handleGamesClick = () => {
    this.props.showModal(this.cellId())
  }

  render() {
    let cellCls = ''
    if (this.isWeekend()) {
      cellCls = cellCls + ' weekend'
    }
    if (this.isCurrentMonth()) {
      cellCls = cellCls + ' current-month'
    }

    const cls = this.isToday() ? ' text-white bg-primary' : ''
    return (
      <td className={"day-cell" + cellCls}>
        <div className="text-right">
          <div className={"day-number d-inline-block rounded-circle text-center" + cls}>{this.dayNumber()}</div>
        </div>
        <div>
          <div className="games-wrapper">
            {this.brief()}

            <Modal identity={this.cellId()} title={this.cellId()}>
              {this.games()}
            </Modal>
          </div>
        </div>
      </td>
    )
  }

  isWeekend() {
    const day = this.props.date.day()
    return day === 0 || day === 6
  }

  isCurrentMonth() {
    const { year, month } = this.props.calendar
    return this.props.date.year() === year && this.props.date.month() === month
  }

  isToday() {
    return this.props.date.isSame(this.props.calendar.today, 'day')
  }

  dayNumber() {
    return this.props.date.format('D')
  }

  cellId() {
    return this.props.date.format('YYYY-MM-DD')
  }

  brief() {
    if (this.props.games.length > 0) {
      const firstGame = this.props.games[0]
      return (
        <div onClick={this.handleGamesClick} className="games">
          <div className="game">{firstGame.road.toUpperCase()} vs {firstGame.home.toUpperCase()}</div>
          <div className="game">and {this.props.games.length - 1} other games</div>
        </div>
      )
    }
  }

  games() {
    return this.props.games.map(game => (
      <div key={game.id}>
        <h3 className="text-center">
          {game.road.toUpperCase()} vs {game.home.toUpperCase()}
        </h3>
        <p className="text-center">{game.startTime.utcOffset(this.props.calendar.utcOffset).format('HH:mm Z')}</p>
      </div>
    ))
  }
}

DayCell.proptypes = {
  date: PropTypes.any.isRequired,
  calendar: PropTypes.object.isRequired,
  games: PropTypes.array.isRequired,
}


function mapStateToPropsCell(state, ownProps) {
  return {
    games: state.nbaGames.filter(nbaGame => {
      return nbaGame.startTime.isSame(ownProps.date, 'day')
    })
  }
}

const DayCellCont = connect(mapStateToPropsCell, {showModal})(DayCell)

class Calendar extends Component {

  componentDidMount() {
    this.props.fetchNbaGames()
  }

  handleSelectPrev = () => {
    this.props.selectPrevMonth()
    this.props.fetchNbaGames()
  }

  handleSelectCurrent = () => {
    this.props.selectCurrentMonth()
    this.props.fetchNbaGames()
  }

  handleSelectNext = () => {
    this.props.selectNextMonth()
    this.props.fetchNbaGames()
  }

  render() {
    return (
      <div className="container-fluid mt-4">
        <div className="d-flex justify-content-between mb-4">
          <h2 className="current-month mb-0">{this.monthText()}</h2>
          <div className="btn-group">
            <div onClick={this.handleSelectPrev} className="btn btn-outline-secondary">&lt;</div>
            <div onClick={this.handleSelectCurrent} className="btn btn-outline-secondary">Today</div>
            <div onClick={this.handleSelectNext} className="btn btn-outline-secondary">&gt;</div>
          </div>
        </div>
        <table className="calendar-table table table-bordered">
          <thead>
            <tr className="text-right">
              <th className="weekend">Sun</th>
              <th>Mon</th>
              <th>Tue</th>
              <th>Wed</th>
              <th>Thu</th>
              <th>Fri</th>
              <th className="weekend">Sat</th>
            </tr>
          </thead>
          {this.body()}
        </table>
      </div>
    )
  }

  monthText() {
    const { year, month } = this.props.calendar
    return moment([year, month]).format('YYYY-MM')
  }

  weekRow(startOfWeek) {
    const days = [
      startOfWeek,
      startOfWeek.clone().add(1, 'day'),
      startOfWeek.clone().add(2, 'day'),
      startOfWeek.clone().add(3, 'day'),
      startOfWeek.clone().add(4, 'day'),
      startOfWeek.clone().add(5, 'day'),
      startOfWeek.clone().add(6, 'day'),
    ]

    return (
      <tr key={startOfWeek.unix()}>
        {days.map(day => <DayCellCont date={day} calendar={this.props.calendar} key={day.unix()}/>)}
      </tr>
    )
  }

  body() {
    const { year, month, utcOffset } = this.props.calendar
    const startOfMonth = moment([year, month])
    startOfMonth.utcOffset(utcOffset)
    const firstDay = startOfMonth.startOf('week')

    const startOfWeeks = [
      firstDay,
      firstDay.clone().add(1, 'week'),
      firstDay.clone().add(2, 'week'),
      firstDay.clone().add(3, 'week'),
      firstDay.clone().add(4, 'week'),
      firstDay.clone().add(5, 'week'),
    ]
    return (
      <tbody>
        {startOfWeeks.map(startOfWeek => this.weekRow(startOfWeek))}
      </tbody>
    )
  }
}

function mapStateToProps(state) {
  return {
    calendar: state.calendar,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    selectPrevMonth: () => dispatch(selectPrevMonth()),
    selectNextMonth: () => dispatch(selectNextMonth()),
    selectCurrentMonth: () => dispatch(selectCurrentMonth()),
    fetchNbaGames: () => dispatch(fetchNbaGames()),
  }
}

export const CalendarPage = connect(
  mapStateToProps,
  mapDispatchToProps,
)(Calendar)
import React from 'react'
import { connect } from 'react-redux'
import { hillSelected } from '../actions'

const Hill = ({hill, onClick}) => (
  <a href='#' onClick={onClick}>{hill.name} ({hill.hillnumber})</a>
)

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onClick: () => { dispatch(hillSelected(parseInt(ownProps.hill.hillnumber))) }
  }
}

export default connect(null, mapDispatchToProps)(Hill)

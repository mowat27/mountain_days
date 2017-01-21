import React from 'react'
import { connect } from 'react-redux'
import { distanceInMilesFilterChanged } from '../actions'

const Filters = ({distanceInMilesFilterChanged}) => (
  <div className='filters'>
    <label>Within <input onInput={(evt) => {distanceInMilesFilterChanged(evt.target.value)}} /> miles of G12 8DJ</label>
  </div>
)

const mapDispatchToProps = (dispatch) => (
  {
    distanceInMilesFilterChanged: (miles) => {
      dispatch(distanceInMilesFilterChanged(miles))
    }
  }
)

export default connect(null, mapDispatchToProps)(Filters)

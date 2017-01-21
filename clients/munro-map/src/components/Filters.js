import React from 'react'
import { connect } from 'react-redux'

const Filters = () => (
  <div className='filters'>
    <label>Within <input /> miles of G12 8DJ</label>
  </div>
)

const mapStateToProps = () => (
  {}
)

export default connect(mapStateToProps)(Filters)

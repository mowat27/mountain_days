import React from 'react'
import { connect } from 'react-redux'
import Hill from './Hill'

const Filters = ({hills}) => (
  <div className='filters'>
    <ul>
      { hills.map( hill => <li key={hill.hillnumber}><Hill hill={hill} /></li>) }
    </ul>
  </div>
)

const mapStateToProps = ({hills}) => (
  {
    hills: hills.slice(0,5)
  }
)

export default connect(mapStateToProps)(Filters)

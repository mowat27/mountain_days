import React from 'react'
import { connect } from 'react-redux'
import Hill from './Hill'

const HillList = ({hills}) => (
  <div className='hill-list'>
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

export default connect(mapStateToProps)(HillList)

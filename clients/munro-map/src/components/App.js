import React, { Component } from 'react'
import MunroMap  from './MunroMap'
import Filters  from './Filters'
import HillList  from './HillList'

class App extends Component {
  render() {
    return (
      <div>
        <Filters />
        <HillList />
        <MunroMap />
      </div>
    )
  }
}

export default App

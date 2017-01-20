import React, { Component } from 'react'
import MunroMap  from './MunroMap'
import Filters  from './Filters'

class App extends Component {
  render() {
    return (
      <div>
        <Filters />
        <MunroMap />
      </div>
    )
  }
}

export default App

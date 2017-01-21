import 'babel-polyfill'
import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import thunkMiddleware from 'redux-thunk'
import { createStore, applyMiddleware, combineReducers, compose } from 'redux'

import App  from './components/App'
import { fetchHills } from './actions'
import { hills, selections, filters } from './reducers'

const rootReducer = combineReducers({hills, selections, filters})
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose

const store = createStore(rootReducer, {}, composeEnhancers(
   applyMiddleware(thunkMiddleware)
 ))

store.dispatch(fetchHills())

render(
  <Provider store={store}>
    <App />
  </Provider>,

  document.getElementById('root')
)

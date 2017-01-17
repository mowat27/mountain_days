import 'babel-polyfill'
import createLogger from 'redux-logger'
import thunkMiddleware from 'redux-thunk'
import { createStore, applyMiddleware, combineReducers, compose } from 'redux'

import { addHill, fetchHills } from './actions'
import { hills } from './reducers'

const rootReducer = combineReducers({hills})

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
const store = createStore(rootReducer, {}, composeEnhancers(
   applyMiddleware(thunkMiddleware)
 ));

store.dispatch(fetchHills())

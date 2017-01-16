import { createStore, combineReducers } from 'redux'
import { addHill } from './actions'
import { hills } from './reducers'

const store = createStore(combineReducers({hills}), window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__())

store.dispatch(addHill({name: "First"}))
store.dispatch(addHill({name: "Second"}))
store.dispatch(addHill({name: "Third"}))

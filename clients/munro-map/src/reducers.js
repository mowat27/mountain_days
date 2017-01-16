import { ADD_HILL } from '../src/actions'

export function hills(state = [], action) {
  if(!action) return state

  switch(action.type) {
    case ADD_HILL:
      return [...state, action.hill]
    default:
      return state
  }
}

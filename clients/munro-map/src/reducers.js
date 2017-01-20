import { ADD_HILL, HILL_SELECTED } from '../src/actions'

export function hills(state = [], action) {
  if(!action) return state

  switch(action.type) {
    case ADD_HILL:
      return [...state, action.hill]
    default:
      return state
  }
}

export function selections(state = {}, action) {
  if(!action) return state

  switch(action.type) {
    case HILL_SELECTED:
      return {
        ...state,
        selectedHill: action.hillnumber
      }
    default:
      return state
  }
}

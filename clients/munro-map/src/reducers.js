import { ADD_HILL, HILL_SELECTED, DISTANCE_IN_MILES_FILTER_CHANGED } from '../src/actions'

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

export function setFilter(state, newFilter) {
  let existingElementIndex = state.findIndex(({ name, units }) => (
    name === newFilter.name && units === newFilter.units)
  )

  return [
    ...state.slice(0, existingElementIndex),
    newFilter,
    ...state.slice(existingElementIndex + 1, state.length)
  ]
}

export function filters(state = [], action) {
  if(!action) return state

  switch(action.type) {
    case DISTANCE_IN_MILES_FILTER_CHANGED:
      return setFilter(state, {
        name: "distance",
        units: "miles",
        value: action.miles
      })
    default:
      return state
  }
}

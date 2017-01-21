import fetch from 'isomorphic-fetch'

// Hill Actions and Action Creators
export const ADD_HILL = 'ADD_HILL'
export const REQUEST_HILLS = 'REQUEST_HILLS'
export const FETCH_HILLS = 'FETCH_HILLS'

export function addHill(hill) {
  return {type: ADD_HILL, hill}
}

function requestHills() {
  return {type: REQUEST_HILLS}
}

export function fetchHills() {
  return dispatch => {
    dispatch(requestHills())

    return fetch('http://localhost:9292/read-model.json')
      .then(response => response.json())
      .then(hills => {
        for (var hill of hills) {
          dispatch(addHill(hill))
        }
      })
  }
}

// Hill - user actions
export const HILL_SELECTED = 'HILL_SELECTED'
export function hillSelected(hillnumber) {
  return {
    type: HILL_SELECTED,
    hillnumber: hillnumber
  }
}

export const DISTANCE_IN_MILES_FILTER_CHANGED = 'DISTANCE_IN_MILES_FILTER_CHANGED'
export function distanceInMilesFilterChanged(miles) {
  return {
    type: DISTANCE_IN_MILES_FILTER_CHANGED,
    miles: parseInt(miles)
  }
}

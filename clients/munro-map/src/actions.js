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

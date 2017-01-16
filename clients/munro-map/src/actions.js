// Hill Actions and Action Creators
export const ADD_HILL = 'ADD_HILL'

export function addHill(hill) {
  return {type: ADD_HILL, hill}
}

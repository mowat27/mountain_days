import deepFreeze from 'deep-freeze'
import { addHill, ADD_HILL } from '../src/actions'
import { hillSelected, HILL_SELECTED } from '../src/actions'
import { distanceInMilesFilterChanged, DISTANCE_IN_MILES_FILTER_CHANGED } from '../src/actions'
import { expect } from 'chai'

describe("addHill() action creator", () => {
  it("returns an ADD_HILL action", () => {
    let hill = {name: "Some Hill"}
    let expected = {type: ADD_HILL, hill}

    deepFreeze(hill)

    expect(addHill(hill)).to.deep.equal(expected)
  })
})

describe("hillSelected() action creator", () => {
  it("returns a HILL_SELECTED action", () => {
    let hillnumber = "999"
    let expected = {type: HILL_SELECTED, hillnumber: "999"}

    deepFreeze(hillnumber)

    expect(hillSelected(hillnumber)).to.deep.equal(expected)
  })
})

describe("distanceInMilesFilterChanged() action creator", () => {
  it("returns a DISTANCE_IN_MILES_FILTER_CHANGED action", () => {
    let miles = "200"
    let expected = {type: DISTANCE_IN_MILES_FILTER_CHANGED, miles: 200}

    deepFreeze(miles)

    expect(distanceInMilesFilterChanged(miles)).to.deep.equal(expected)
  })
})

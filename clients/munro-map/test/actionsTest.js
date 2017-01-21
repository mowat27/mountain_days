import deepFreeze from 'deep-freeze'
import { addHill, ADD_HILL } from '../src/actions'
import { hillSelected, HILL_SELECTED } from '../src/actions'
import { expect } from 'chai'

describe("addHill", () => {
  it("returns an ADD_HILL action", () => {
    let hill = {name: "Some Hill"}
    let expected = {type: ADD_HILL, hill}

    deepFreeze(hill)

    expect(addHill(hill)).to.deep.equal(expected)
  })
})

describe("hillSelected", () => {
  it("returns a HILL_SELECTED action", () => {
    let hillnumber = "999"
    let expected = {type: HILL_SELECTED, hillnumber: "999"}

    deepFreeze(hillnumber)

    expect(hillSelected(hillnumber)).to.deep.equal(expected)
  })
})

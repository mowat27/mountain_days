import deepFreeze from 'deep-freeze'
import { addHill, ADD_HILL } from '../src/actions'

describe("addHill", () => {
  it("returns an ADD_HILL action", () => {
    let hill = {name: "Some Hill"}
    let expected = {type: ADD_HILL, hill}

    deepFreeze(hill)

    expect(addHill(hill)).to.deep.equal(expected)
  })
})

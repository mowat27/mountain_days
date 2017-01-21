import deepFreeze from 'deep-freeze'
import { ADD_HILL, HILL_SELECTED, DISTANCE_IN_MILES_FILTER_CHANGED } from '../src/actions'
import { hills, selections, filters } from '../src/reducers'
import { expect } from 'chai'

describe("hills reducer", () => {
  it("returns input state when the action is unknown", () => {
    let action = { type: 'FOO' }
    let initialState = []

    deepFreeze(action)
    deepFreeze(initialState)

    expect(hills(initialState, action)).to.deep.equal(initialState)
  })

  it("returns an empty array when no action is passed", () => {
    expect(hills()).to.deep.equal([])
  })

  it("adds a hill", () => {
    let action = { type: ADD_HILL, hill: { name: "Some Mountain" } }
    let initialState = []
    let expectedState = [{ name: "Some Mountain" }]

    deepFreeze(action)
    deepFreeze(initialState)

    expect(hills(initialState, action)).to.deep.equal(expectedState)
  })
})

describe("selections reducer", () => {
  it("returns input state when the action is unknown", () => {
    let action = { type: 'FOO' }
    let initialState = {}

    deepFreeze(action)
    deepFreeze(initialState)

    expect(selections(initialState, action)).to.deep.equal(initialState)
  })

  it("returns an empty object when no action is passed", () => {
    expect(selections()).to.deep.equal({})
  })

  it("sets the selected hill", () => {
    let action = { type: HILL_SELECTED, hillnumber: "123" }
    let initialState = { selectedHill: "987" }
    let expectedState = { selectedHill: "123" }

    deepFreeze(action)
    deepFreeze(initialState)

    expect(selections(initialState, action)).to.deep.equal(expectedState)
  })
})

describe("filters reducer", () => {
  it("returns input state when the action is unknown", () => {
    let action = { type: 'FOO' }
    let initialState = []

    deepFreeze(action)
    deepFreeze(initialState)

    expect(filters(initialState, action)).to.deep.equal(initialState)
  })

  it("returns an empty object when no action is passed", () => {
    expect(filters()).to.deep.equal([])
  })

  describe("DISTANCE_IN_MILES_FILTER_CHANGED events", () => {
    it("adds a new filter when none found", () => {
      let action = { type: DISTANCE_IN_MILES_FILTER_CHANGED, miles: 123 }
      let initialState = []
      let expectedState = [{ name: "distance", value: 123, units: "miles" }]

      deepFreeze(action)
      deepFreeze(initialState)

      expect(filters(initialState, action)).to.deep.equal(expectedState)
    })

    it("changes a pre-existing filter", () => {
      let action = { type: DISTANCE_IN_MILES_FILTER_CHANGED, miles: 123 }
      let initialState = [
        { name: "foo", value: 1, units: "bar" },
        { name: "distance", value: 999, units: "miles" },
        { name: "bop", value: 2, units: "baz" }
      ]
      
      let expectedState = [
        { name: "foo", value: 1, units: "bar" },
        { name: "distance", value: 123, units: "miles" },
        { name: "bop", value: 2, units: "baz" }
      ]

      deepFreeze(action)
      deepFreeze(initialState)

      expect(filters(initialState, action)).to.deep.equal(expectedState)
    })
  })
})

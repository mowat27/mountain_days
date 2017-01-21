import deepFreeze from 'deep-freeze'
import { ADD_HILL, HILL_SELECTED } from '../src/actions'
import { hills } from '../src/reducers'
import { selections } from '../src/reducers'
import { expect } from 'chai'

describe("hills", () => {
  it("returns input state when the action is unknown", () => {
    let action = {type: 'FOO'}
    let initialState = []

    deepFreeze(action)
    deepFreeze(initialState)

    expect(hills(initialState, action)).to.deep.equal(initialState)
  })

  it("returns an empty array when no action is passed", () => {
    expect(hills()).to.deep.equal([])
  })

  it("adds a hill", () => {
    let action = {type: ADD_HILL, hill: {name: "Some Mountain"}}
    let initialState = []
    let expectedState = [{name: "Some Mountain"}]

    deepFreeze(action)
    deepFreeze(initialState)

    expect(hills(initialState, action)).to.deep.equal(expectedState)
  })
})

describe("selections", () => {
  it("returns input state when the action is unknown", () => {
    let action = {type: 'FOO'}
    let initialState = {}

    deepFreeze(action)
    deepFreeze(initialState)

    expect(selections(initialState, action)).to.deep.equal(initialState)
  })

  it("returns an empty object when no action is passed", () => {
    expect(selections()).to.deep.equal({})
  })

  it("sets the selected hill", () => {
    let action = {type: HILL_SELECTED, hillnumber: "123"}
    let initialState = {selectedHill: "987"}
    let expectedState = {selectedHill: "123"}

    deepFreeze(action)
    deepFreeze(initialState)

    expect(selections(initialState, action)).to.deep.equal(expectedState)
  })
})

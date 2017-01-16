import deepFreeze from 'deep-freeze'
import { ADD_HILL } from '../src/actions'
import { hills } from '../src/reducers'

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

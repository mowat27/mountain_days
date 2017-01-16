import { foo } from '../src'

describe("foo", () => {
  it("is null", () => {
    expect(foo("bar")).to.be.null
  })
})

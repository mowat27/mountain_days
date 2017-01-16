import { foo } from '../src/app'

describe("foo", () => {
  it("is null", () => {
    expect(foo("bar")).to.be.null
  })
})

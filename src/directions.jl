abstract type AbstractDirection end

struct Up <: AbstractDirection end
const UP = Up()

struct Down <: AbstractDirection end
const DOWN = Down()

struct Left <: AbstractDirection end
const LEFT = Left()

struct Right <: AbstractDirection end
const RIGHT = Right()

const DIRECTIONS = (UP, DOWN, LEFT, RIGHT)

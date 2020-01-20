export Style, NoStyle, nostyle

abstract type Style end

struct NoStyle <: Style end

const nostyle = NoStyle()


struct StyledShape <: Shape
    shape::Shape
    style::Style
end

struct BasicStyle <: Style
   stroke::Color
   fill::Color
end

Style(;stroke::Color, fill::Color) = BasicStyle(stroke, fill)
Shape(shape::Shape, style::Style) = StyledShape(shape, style)

boundingbox(styled::StyledShape) = boundingbox(styled.shape)

##### xml ##########

function xml(style::BasicStyle)
    [AttributeNode(:stroke, string(style.stroke)), AttributeNode(:fill, string(style.fill))]
end

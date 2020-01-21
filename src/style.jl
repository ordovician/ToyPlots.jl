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
   stroke_width::Int # width of stroke
end

Style(;stroke::Color = Color("silver"), fill::Color = Color("gray"), stroke_width::Integer = 2) = BasicStyle(stroke, fill, stroke_width)
Shape(shape::Shape, style::Style = Style()) = StyledShape(shape, style)

boundingbox(styled::StyledShape) = boundingbox(styled.shape)

##### xml ##########

function xml(style::BasicStyle)
    [AttributeNode(:stroke, string(style.stroke)),
     AttributeNode(:fill, string(style.fill)),
     AttributeNode(Symbol("stroke-width"), string(style.stroke_width))]
end

export Svg, Style, Group, StyledShape, NoStyle, nostyle, xml

abstract type Style end

struct NoStyle <: Style
    
end

const nostyle = NoStyle()

struct Group <: Shape
    id::Union{Nothing, String}
    shapes::Vector{Shape}
end

struct StyledShape <: Shape
    shape::Shape
    style::Style
end

mutable struct Svg
    canvas::Rect{Float64}
    viewbox::Rect{Float64}
    shapes::Vector{Shape}
end

function Svg(width::Number, height::Number)
    r = Rect(0, 0, width, height)
    Svg(r, r)
end

function xml(svg::Svg)
    node = ElementNode("svg", [:version => "1.1", 
                               :baseProfile => "full",
                               :xmlns   => "http://www.w3.org/2000/svg"])

    if !iszero(topleft(svg.canvas))
        push!(node.attributes, AttributeNode(:x, x(svg.canvas)))
        push!(node.attributes, AttributeNode(:y, y(svg.canvas)))
    end
    if !iszero(size(canvas))
        push!(node.attributes, AttributeNode(:width, width(svg.canvas)))
        push!(node.attributes, AttributeNode(:height, height(svg.canvas)))
    end
    
    viewbox = Float64[]
    
    if !iszero(topleft(svg.viewbox))
        push!(viewbox, x(svg.viewbox))
        push!(viewbox, y(svg.viewbox))
    end
    if !iszero(size(svg.viewbox))
        push!(viewbox, size(svg.viewbox).x)
        push!(viewbox, size(svg.viewbox).y)
    end        

    push!(node.attributes, AttributeNode(:viewbox, join(viewbox, ' ')))
    
    node.children =  Node[xml(shape) for shape in svg.shapes]
    node
end

function xml(group::Group)
    node = ElementNode("g")
    if group.id != nothing
       push!(node.attributes, AttributeNode(:id, id))
    end
    node.children =  Node[xml(shape) for shape in svg.shapes]
    node
end

function xml(r::Rect)
    ElementNode("rect", [:x => x(r), :y => y(r)
                            :width  => width(r),
                            :height => height(r)])    
end

function xml(c::Circle)
    ElementNode("circle", [ :cx => x(c), 
                            :cy => y(c),
                            :r => radius(c)])    
end
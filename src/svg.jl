export Svg, Group, xml
import Base: push!

struct Group <: Shape
    id::Union{Nothing, String}
    shapes::Vector{Shape}
end

mutable struct Svg{T <: Number}
    canvas::Rect{T}
    viewbox::Rect{T}
    shapes::Vector{Shape}
end

"""
    Svg(width, height)
Construct a SVG top node, which you can add shapes and groups to
"""
function Svg(width::Number, height::Number)
    r = Rect(width, height)
    Svg(r, r, Shape[])
end

function push!(group::Union{Svg, Group}, shape::Shape...)
   push!(group.shapes, shape...) 
end

######### XML #####################
function xml(svg::Svg)
    node = ElementNode(:svg, [:version => "1.1", 
                               :baseProfile => "full",
                               :xmlns   => "http://www.w3.org/2000/svg"])

    if !iszero(topleft(svg.canvas))
        push!(node.attributes, AttributeNode(:x, x(svg.canvas)))
        push!(node.attributes, AttributeNode(:y, y(svg.canvas)))
    end
    if !iszero(size(svg.canvas))
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
    node = ElementNode(:g)
    if group.id != nothing
       push!(node.attributes, AttributeNode(:id, id))
    end
    node.children =  Node[xml(shape) for shape in svg.shapes]
    node
end

function xml(r::Rect)
    ElementNode(:rect, [:x => x(r), :y => y(r),
                            :width  => width(r),
                            :height => height(r)])    
end

function xml(c::Circle)
    ElementNode(:circle, [ :cx => x(c), 
                           :cy => y(c),
                           :r => radius(c)])    
end


function xml(styled::StyledShape)
    node = xml(styled.shape)
    append!(node.attributes, xml(styled.style))
    node
end
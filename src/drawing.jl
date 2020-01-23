export Drawing, draw
import Base: show

struct Drawing{T<:Number}
    viewport::Vector2D{T}     # Size of box you see in screen coordinates
    viewbox::Rect{T}          # Part of scene you see in scene coordinates
    shapes::Vector{Shape}
end

"""
    draw(shapes)
Create a drawing containing shapes
"""
function draw(shapes::Vector{Shape})
    boxes = boundingbox.(shapes)
    viewbox = reduce(surround, boxes)
    viewport = size(viewbox) + 30 # add some padding
    Drawing(viewport, viewbox, shapes)
end

draw(shapes::Shape...) = draw(collect(Shape, shapes))

function draw(io::IO, rect::Rect, depth::Integer)
    x, y = x(rect), y(rect)
    w, h = width(rect), height(rect)
    println(io, "  "^depth, """<rect x="$x" y="$y" width="$w" height="$h" stroke="silver" fill="gray" stroke-width="2"/>""")
end

function draw(io::IO, circle::Circle, depth::Integer)
    x, y = x(circle), y(circle)
    r = radius(circle)
    println(io, "  "^depth, """<circle r="$r" cx="$x" cy="$y" fill="yellow" />""")
end


function show(io::IO, ::MIME"image/svg+xml", drawing::Drawing)
    w = drawing.viewport.x
    h = drawing.viewport.y
    viewbox = drawing.viewbox
    vbstr = if iszero(min(viewbox))
        string(width(viewbox), " ", height(viewbox))
    else
        string(x(viewbox), " ", y(viewbox), " ", width(viewbox), " ", heigh(viewbox))
    end

    header = """
    <svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg" width="$w" height="$h" viewbox="$vbstr">
    """
    println(io, header)

    for shape in drawing.shapes
        draw(io, shape, 1)
    end

    println(io, "</svg>")
end

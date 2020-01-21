export Plot, plot

import Base: show

struct Plot
    svg::Svg
end

"""
    plot(width, height)
Create an SVG plot
"""
function plot(shapes...)
    boxes = boundingbox.(shapes)
    box = reduce(surround, boxes)
    viewport = Rect(zero(min(box)), size(box) + 30)
    svg = Svg(viewport, box, collect(Shape, shapes))
    Plot(svg)
end


function show(io::IO, ::MIME"image/svg+xml", plt::Plot)
    print(io, xml(plt.svg))
end

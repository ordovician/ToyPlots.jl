import Base: show
export ScatterPlot

struct ScatterPlot{T <: Number}
    polygon::Polygon2D{T}
end

function plot(xs::Vector{<:Number}, ys::Vector{<:Number})
    
end
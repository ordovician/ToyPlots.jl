import Base: show
export ScatterPlot

type ScatterPlot{T <: Number}
    polygon::Polygon2D{T}
end

function plot(xs::Vector{<:Number}, ys::Vector{<:Number})
    
end
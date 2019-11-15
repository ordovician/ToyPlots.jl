import Base: show
export PolyLayer

type PolyLayer{T <: Number}
    polygon::Polygon2D{T}
end

function plot(polygon::Polygon2D)
    
end
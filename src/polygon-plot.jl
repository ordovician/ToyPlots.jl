import Base: show
export PolyLayer

struct PolyLayer{T <: Number}
    polygon::Polygon2D{T}
end

function plot(polygon::Polygon2D)
    
end
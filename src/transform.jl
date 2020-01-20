export Transform, Translate, Rotate

import Base: show

"A transform for use with SVG. Tranforms are used to move and rotate shapes."
abstract type Transform end

struct Translate{T <: Number} <: Transform
   Δx::T
   Δy::T
end

struct Rotate{T <: Number} <: Transform
   degrees::T 
end

struct RotateOrigin{T <: Number} <: Transform
   degrees::T
   x::T
   y::T 
end

Rotate(degrees, x, y) = RotateOrigin(degrees, x, y)




show(io::IO, t::Translate) = print(io, "translate(", t.Δx, " ", t.Δy, ")")
show(io::IO, r::Rotate) = print(io, "rotate(", r.degrees, ")")
show(io::IO, r::RotateOrigin) = print(io, "rotate($(r.degrees), $(r.x), $(r.y))")
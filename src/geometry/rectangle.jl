import  Base: zero, min, max
export  Rect, isinside, isintersecting, transform, boundingbox,
        center, size, halfsize, x, y, width, height,
        translate

struct Rect{T} <: Shape
	origin::Point2D{T}
	size::Vector2D{T}
end

zero(t::Type{Rect{T}}) where T <: Number = Rect{T}(zero(Point2D{T}), zero(Point2D{T}))
zero(v::Rect{<:Number}) = zero(typeof(v))

Rect(x::Number, y::Number, width::Number, height::Number) = Rect(Point2D(x, y), Vector2D(width, height))

function Rect(size::Vector2D{T}) where {T <: Number}
    origin = zero(Point2D{T})
    Rect(origin, size)
end

min(r::Rect) = r.origin
max(r::Rect) = r.origin + size(r)

Rect(width::Number, height::Number) = Rect(Vector2D(width, height))

center(r::Rect) = Point2D(r.origin.x + r.size.x / 2, r.origin.y + r.size.y / 2)
size(r::Rect) = r.size
halfsize(r::Rect) = size(r) / 2
width(r::Rect) = size(r).x
height(r::Rect) = size(r).y
x(r::Rect) = r.origin.x
y(r::Rect) = r.origin.y

isinside(r::Rect, p::Point2D) = min(r) <= p <= max(r)


function isintersecting(r::Rect, s::Rect)
	d = abs(center(s) - center(r))
	h1 = halfsize(r)
	h2 = halfsize(s)

	d.x <= h1.x + h2.x &&
	d.y <= h1.y + h2.y
end


transform(r::Rect, m::Matrix2D) = Rect(m * r.min, m * r.max)

function surround(p::Point2D, q::Point2D)
	origin = mincomp(p, q)
	Rect(origin, maxcomp(p, q) - origin)
end

function surround(r::Rect, p::Point2D)
	origin = mincomp(min(r), p)
	Rect(origin, maxcomp(max(r), p) - origin)
end

function surround(r::Rect, s::Rect)
	origin = mincomp(min(r), min(s))
	Rect(origin, maxcomp(max(r), max(s)) - origin)
end

boundingbox(r::Rect) = r

translate(r::Rect, Δ::Vector2D) = Rect(r.min + Δ, r.max + Δ)

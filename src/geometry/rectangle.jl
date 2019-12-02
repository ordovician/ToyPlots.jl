import  Base: zero
export  Rect, isinside, isintersecting, transform, boundingbox,
        center, size, halfsize, topleft, bottomright, topright, x, y, width, height,
        surround, translate

struct Rect{T} <: Shape
	min::Point2D{T}
	max::Point2D{T}
end

zero(t::Type{Rect{T}}) where T <: Number = Rect{T}(zero(Point2D{T}), zero(Point2D{T}))
zero(v::Rect{<:Number}) = zero(typeof(v))

Rect(minx::Number, miny::Number, maxx::Number, maxy::Number) = Rect(Point2D(minx, miny), Point2D(maxx, maxy))
Rect(origin::Point2D{<:Number}, size::Vector2D{<:Number}) = Rect(origin, origin + size)

function Rect(size::Vector2D{T}) where {T <: Number}
    origin = zero(Point2D{T})
    Rect(origin, origin + size)
end

Rect(width, height) = Rect(Vector2D(width, height))

center(r::Rect) = Point2D((r.max.x + r.min.x) * 0.5, (r.max.y + r.min.y) * 0.5)
size(r::Rect) = r.max - r.min
halfsize(r::Rect) = 0.5 * size(r)
width(r::Rect) = r.max.x - r.min.y
height(r::Rect) = r.max.y - r.min.y
x(r::Rect) = r.min.x
y(r::Rect) = r.min.y

function isinside(r::Rect, p::Point2D)
	ismin(r.min, p) && ismax(r.max, p) ||
		pos == r.min || pos == r.max 
end

function isintersecting(r::Rect, s::Rect)
	d = abs(center(s) - center(r))
	h1 = halfsize(r)
	h2 = halfsize(s)
	
	d.x <= h1.x + h2.x &&
	d.y <= h1.y + h2.y
end

topleft(r::Rect)     = Vector2D(r.min.x, r.max.y)
bottomright(r::Rect) = Vector2D(r.max.x, r.min.y)
topright(r::Rect)    = r.max
bottomleft(r::Rect)  = r.min

transform(r::Rect, m::Matrix2D) = Rect(m * r.min, m * r.max)

surround(r::Rect, p::Point2D) = Rect(mincomp(r.min, p), maxcomp(r.max, p))
surround(r::Rect, s::Rect) = Rect(mincomp(r.min, s.min), maxcomp(r.max, s.max))
boundingbox(r::Rect) = r

translate(r::Rect, Δ::Vector2D) = Rect(r.min + Δ, r.max + Δ)

export Color

abstract type Color end

struct NoColor <: Color end

const nocolor = NoColor()

struct NamedColor <: Color
    name::String
end

Color(name::AbstractString) = NamedColor(name)

show(io::IO, color::NoColor)    = print(io, "none")
show(io::IO, color::NamedColor) = print(io, color.name)
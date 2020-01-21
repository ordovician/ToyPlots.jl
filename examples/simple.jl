# Simple example of two geometric figures with one of them
# in a group allowing rotation. All SVG shapes support
# rotation but for simplicity we have only made it possible on groups
using ToyPlots

rect = Shape(Rect(0, 0, 50, 20))
poly = Shape(Polyline2D(Point2D(20, 20), Point2D(100, 30), Point2D(50, 50)))
plot(Group(Shape[rect], Rotate(10)),  poly)

# This code will produce the following SVG
# <svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg" width="130" height="80" viewbox="100.0 50.0">
#  <g transform="rotate(10)">
#    <rect x="0" y="0" width="50" height="20" stroke="silver" fill="gray" stroke-width="2"/>
#  </g>
#  <polyline points="20,20 100,30 50,50" stroke="silver" fill="gray" stroke-width="2"/>
# </svg>

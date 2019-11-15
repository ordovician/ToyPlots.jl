# ToyPlots
Work in progress... this is intended as a tiny package for plotting using SVG. The idea is to utilze the `show` and `display` system in Julia so you can easily produce SVG graphics in Juno, Jupyter and Nextjournal.

It is not intended to be a serious plotting tool. It is mainly as intended as educational code to show how plotting and drawing works in Julia using the `display` system and MIME types.

## Concept
The idea is to have a simple representation of XML DOM nodes and use those to compose the SVG markup and serve that up to display different objects. Above these XML nodes there is a higher level representation.
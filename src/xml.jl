import Base: setindex!, getindex, show, haskey, findfirst

export  Node, Document, ElementNode, TextNode, AttributeNode,
        nodename, iselement, istext, isattribute, hasroot, hasnode,
        nodecontent,
        countnodes, countattributes,
        nodes, elements, textnodes, attributes, eachattribute,
        root, setroot!,
        addchild!, addchildren!, addelement!

"All nodes in XML DOM is some type of Node."
abstract type Node end

"Top level of an XML DOM"
mutable struct Document
    rootnode::Union{Node, Nothing}
end

"Top level of an XML DOM"
function Document()
    Document(nothing)
end

"""
Represents an attribute inside a tag.

# Example
Here `class` and `name` are examples of attributs belonging to parent node
`widget`.

    <widget class="QCheckBox" name="checkBox">
"""
mutable struct AttributeNode <: Node
    # parent::Node
    name::Symbol
    value::String
end

"XML Node which can contain attributes and child nodes"
mutable struct ElementNode <: Node
    # parent::Node
    name::Symbol
    attributes::Vector{AttributeNode}
    children::Vector{Node}
end

function ElementNode(name::AbstractString)
    ElementNode(name, AttributeNode[], Node[])
end

"Represents the text found between two tags. E.g. in `<foo>bar</foo>` bar is the `TextNode`"
mutable struct TextNode <: Node
    # parent::Node
    content::String
end

"Creates an element node named `name` with a text node containing text `value`"
function ElementNode(name::Symbol, value::AbstractString)
    ElementNode(name, AttributeNode[], Node[TextNode(value)])
end

"Element node with children `nodes`"
function ElementNode(name::Symbol, nodes::Array{T}) where T <: Node
    ElementNode(name, AttributeNode[], nodes)
end

"""Element node with attributes given like `ElementNode("widget", ["class"=>class, "name"=>name])`"""
function ElementNode(name::Symbol, attributes::Vector)
    ElementNode(name, [AttributeNode(name, value) for (name, value) in attributes], Node[])
end

AttributeNode(name::Symbol, value) = AttributeNode(name, string(value))

###### Public API #############

function getindex(n::ElementNode, key::Symbol)
    for m in n.attributes
        if m.name == key
            return m.value
        end
    end
    error("No attribute with key $key exist")
end

function setindex!(n::ElementNode, value::String, key::Symbol)
    ii = findall(m->m.name == key, n.attributes)
    if isempty(ii)
        push!(n.attributes, AttributeNode(key, value))
    else
        n.attributes[ii[1]] = AttributeNode(key, value)
    end
end

"Get all child nodes under node `n`"
nodes(n::Node) = Node[]
nodes(n::ElementNode) = n.children

"Get all elements under node `n`"
elements(n::Node) = ElementNode[]
elements(n::ElementNode) = filter(iselement, nodes(n))

textnodes(n::Node) = TextNode[]
textnodes(n::ElementNode) = filter(istext, nodes(n))

"Get an array of attributes under node `n`"
attributes(n::Node) = AttributeNode[]
attributes(n::ElementNode) = n.attributes

"Gets a dictionary of attributes meant to use in a for loop for iteration"
eachattribute(n::Node) = AttributeNode[]
eachattribute(n::ElementNode) = n.attributes

"For an XML tag looking like `<foo>bar</foo>` the `nodename` would be foo"
nodename(n::Node) = ""
nodename(n::TextNode) = "text"
nodename(n::ElementNode) = n.name

"Check if node is an element node. Element nodes can contain child nodes"
iselement(n::Node) = false
iselement(n::ElementNode) = true

"Check if node is a text node. Text nodes represents the text you find between XML tags."
istext(n::Node) = false
istext(n::TextNode) = true

"Check if node is an attribute node. Attributes are on the form `name = \"value\"`"
isattribute(n::Node) = false
isattribute(n::AttributeNode) = true

"Number of child nodes"
countnodes(n::Node) = 0
countnodes(n::ElementNode) = length(n.children)

"Number of attributes. Typically onlye element nodes have attributes"
countattributes(n::Node) = 0
countattributes(n::ElementNode) = length(n.attributes)

"Check if a root node has been set of XML document"
hasroot(doc::Document) = doc.rootnode != nothing

"Get root node. Make sure you check if it exists first with `hasroot(n)`"
root(n::Document) = n.rootnode
setroot!(n::Document) = n.rootnode = n

"Get content of all text nodes under `n`"
nodecontent(n::TextNode) = n.content
nodecontent(n::Node) = join(map(nodecontent, nodes(n)))

"""
    hasnode(node)
Return if `node` has a child node.
"""
hasnode(n::Node) = false
hasnode(n::ElementNode) = !isempty(n.children)

function addelement!(parent::Node, name::AbstractString)
    child = ElementNode(name)
    addchild!(parent, child)
    child
end

"Add `child` node to `parent` node"
function addchild!(parent::Node, child::Node)
    error("Can't add children to nodes of type $(typeof(p))")
end

addchild!(parent::ElementNode, child::Node) = push!(parent.children, child)

function addchildren!(p::Node, children)
    error("Can't add children to nodes of type $(typeof(p))")    
end

"""
    addchildren!(parent, children::Vector{Pair{String, String}})

A convenience function for easily adding child elements to a parent node `p`.

# Examples

    addchildren!(node, ["x" => "10", "y" => "20"])
"""
function addchildren!(p::ElementNode, children::Vector{Pair{String, String}})
    for child in children
        addchild!(p, ElementNode(first(child), last(child)))
    end
end

"""
    addchildren!(parent, children::Vector{Node})

For easily adding multiple children to a parent node.

# Examples

    addchildren!(node, [ElementNode("foo"), ElementNode("bar")])
"""
function addchildren!(p::ElementNode, children::Vector{T}) where T <: Node
    append!(p.children, children)
end

####### Show ###########

function show(io::IO, doc::Document)
  if hasroot(doc)
    show(io, root(doc), 1)
  else
    print(io, "Document()")
  end
end

function show(io::IO, n::TextNode)
    print(io, n.content)
end

function show(io::IO, n::Node, depth::Integer = 0)
    print(io, "Unknown node type")
end

function show(io::IO, n::AttributeNode)
   print(io, string(n.name), "=\"", n.value,"\"")
end

function show(io::IO, n::TextNode, depth::Integer)
    print(io, "  "^depth)
    println(io, n.content)
end

function show(io::IO, parent::ElementNode, depth::Integer = 0)
    print(io, "  "^depth)

    tag = nodename(parent)
    print(io, "<$tag")
    attrs = map(x ->  "$(x.name)=\"$(x.value)\"", attributes(parent))
    attr_str = join(attrs, " ")

    if !isempty(attr_str)
        print(io, " ", attr_str)
    end

    children = nodes(parent)
    len = length(children)

    if len == 0
        println(io, "/>")
    elseif len == 1 && istext(first(children))
        print(io, ">")
        for n in children show(io, n) end
    else
        println(io, ">")
        for n in children
            show(io, n, depth + 1)
        end
        print(io, "  "^depth)
    end
    
    if len != 0
        println(io, "</$tag>")
    end
end

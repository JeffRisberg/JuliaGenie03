#=
Main:
- Julia version: 1.5.3
- Author: jeff
- Date: 2021-03-17
=#
using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

include("Model.jl")
using .Model

include("Mapper.jl")
using .Mapper

include("Service.jl")
using .Service


Base.convert(::Type{Int64}, v::SubString{String}) = parse(Int64, v)

route("/books/:id::Int64", method = GET, named = :getBooksWithParam) do
  id = payload(:id)
  book = Mapper.get(id)
  if (book != nothing)
      return json([book])
  else
      return json([])
  end
end

route("/books", method = GET, named = :getBooksNoParam) do
  json(Mapper.getAll())
end

route("/books", method = POST) do
  @show jsonpayload()
  @show rawpayload()

  title = jsonpayload()["title"]
  author = jsonpayload()["author"]
  pages = jsonpayload()["pages"]
  book = Book(title, author, pages)
  Mapper.create!(book)

  json("New Book $(title) $(author) $(pages)")
end

route("/books", method = PUT) do
  @show jsonpayload()
  @show rawpayload()

  id = jsonpayload()["id"]
  title = jsonpayload()["title"]
  author = jsonpayload()["author"]
  pages = jsonpayload()["pages"]
  book = Book(title, author, pages)
  Mapper.update(book)

  json("Updated Book $(title) $(author) $(pages)")
end

route("/books/:id::Int64", method = DELETE, named = :deleteBook) do
  id = payload(:id)
  Mapper.delete(id)
  "acknowledged"
end

up(8000, async = false)


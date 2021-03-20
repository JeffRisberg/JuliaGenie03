#=
Main:
- Julia version: 1.5.3
- Author: jeff
- Date: 2021-03-17
=#
using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

Base.convert(::Type{Int64}, v::SubString{String}) = parse(Int64, v)

route("/books/:id::Int64", method = GET, named = :withParam) do
  id = payload(:id)
  book = Mapper.get(id)
  if (book != null)
      return json([book])
  else
      return json([])
end

route("/books", method = GET, named = :booksNoParam) do
  json(Mapper.getAll())
end

route("/books", method = POST) do
  @show jsonpayload()
  @show rawpayload()

  title = jsonpayload()["title"]
  author = jsonpayload()["author"]
  pages = jsonpayload()["pages"]
  book = Book(nextId, title, author, pages)
  Mapper.create!(book)

  json("New Book $(nextId) $(title) $(author) $(pages)")
end

up(8000, async = false)


#=
Main:
- Julia version: 1.5.3
- Author: jeff
- Date: 2021-03-17
=#
using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

struct Book
  id::Int
  title::String
  author::String
  pages::Int
end

book1 = Book(1, "Harry Potter", "J. K. Rowling", 423)
book2 = Book(2, "Tom Swift", "Victor Appleton II", 216)

books = Book[]
append!(books, [book1])
append!(books, [book2])


Base.convert(::Type{Int}, v::SubString{String}) = parse(Int, v)

route("/books/:id::Int", method = GET, named = :withParam) do
  id = payload(:id)
  for book in books
    if book.id == id
        return json([book])
    end
  end
  json([])
end

route("/books", method = GET, named = :noParam) do
  json(books)
end

up(8000, async = false)


#=
Main:
- Julia version: 1.5.3
- Author: jeff
- Date: 2021-03-17
=#
using Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json

import Base: ==

using StructTypes

mutable struct Book
  id::Int64
  title::String
  author::String
  pages::Int64
end


==(x::Book, y::Book) = x.id == y.id
Book() = Book(0, "", "", 0)
Bool(title, author, pages) = Book(0, title, author, pages)
StructTypes.StructType(::Type{Book}) = StructTypes.Mutable()

book1 = Book(1, "Harry Potter and the Sorcers Stone", "J. K. Rowling", 423)
book2 = Book(2, "Tom Swift and his Flying Lab", "Victor Appleton II", 216)
book3 = Book(3, "Tom Swift and his Jetmarine", "Victor Appleton II", 221)


books = Book[]
append!(books, [book1, book2])
append!(books, [book3])

Base.convert(::Type{Int64}, v::SubString{String}) = parse(Int64, v)

route("/books/:id::Int64", method = GET, named = :withParam) do
  id = payload(:id)
  for book in books
    if book.id == id
        return json([book])
    end
  end
  json([])
end

route("/books", method = GET, named = :booksNoParam) do
  json(books)
end

route("/books", method = POST) do
  @show jsonpayload()
  @show rawpayload()

  title = jsonpayload()["title"]
  author = jsonpayload()["author"]
  pages = jsonpayload()["pages"]

  nextId = size(books, 1) + 1
  book = Book(nextId, title, author, pages)
  append!(books, [book])

  json("New Book $(nextId) $(title) $(author) $(pages)")
end

up(8000, async = false)


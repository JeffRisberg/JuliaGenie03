module Model

using StructTypes

import Base: ==

export Book

mutable struct Book
  id::Int64 # service-managed
  title::String
  author::String
  pages::Int64
  timespicked::Int64 # service-managed
end

==(x::Book, y::Book) = x.id == y.id
Book() = Book(0, "", "", 0, 0)
Bool(title, author, pages) = Book(0, title, author, pages, 0)
StructTypes.StructType(::Type{Book}) = StructTypes.Mutable()

end # module

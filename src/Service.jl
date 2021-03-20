module Service

# in OctoberSky, these are called Controllers.

using ..Model
using ..Mapper

function createBook(obj)
    @assert haskey(obj, :title) && !isempty(obj.title)
    @assert haskey(obj, :author) && !isempty(obj.author)
    @assert haskey(obj, :pages) && !isempty(obj.pages)
    book = Book(obj.title, obj.author, obj.pages)
    Mapper.create!(book)
    return book
end

function getBook(id::Int64)::Book
    Mapper.get(id)
end

function updateBook(id::Int64, updated)
    book = Mapper.get(id)
    book.title = updated.title
    book.author = updated.author
    book.pages = updated.pages
    book.timespicked = updated.timespicked
    Mapper.update(book)
    return book
end

function deleteBook(id::Int64)
    Mapper.delete(id)
    return
end

function pickBookToRead()::Book
    books = Mapper.getAllBooks()
    leastTimesPicked = minimum(x->x.timespicked, books)
    leastPickedBooks = filter(x->x.timespicked == leastTimesPicked, books)
    pickedBook = rand(leastPickedBooks)
    pickedBook.timespicked += 1
    Mapper.update(pickedBook)
    @info "picked book = $(pickedBook.name) on thread = $(Threads.threadid())"
    return pickedBook
end

end # module

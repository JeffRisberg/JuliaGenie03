module Mapper

# In OctoberSky, these are called DAOs

using ..Model

book1 = Book(1, "Harry Potter and the Sorcerer's Stone", "J. K. Rowling", 423, 0)
book2 = Book(2, "Tom Swift and his Flying Lab", "Victor Appleton II", 216, 0)
book3 = Book(3, "Tom Swift and his Jetmarine", "Victor Appleton II", 221, 0)

books = Book[]
append!(books, [book1, book2])
append!(books, [book3])

function get(id::Int64)
    for book in books
        if book.id == id
            return book
        end
    end
    return nothing
end

function getAll()
    return books
end

function create!(book)
    nextId = size(books, 1) + 1
    book.id = nextId
    append!(books, [book])
end

function update(book)
end

function delete(id)
    deleteat!(books, findall(x->x.id==id, books))
end

end # module

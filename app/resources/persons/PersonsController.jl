module PersonsController

using Genie.Renderer
using Genie.Renderer.Html
using MySQL
using DataFrames

struct Person
  id::Integer
  first::String
  last::String
end

function mysql_connect(db_config)
  conn = DBInterface.connect(MySQL.Connection, db_config.host, db_config.user, db_config.password)
  DBInterface.execute(conn, "use JuliaGenie01")
  return conn
end

function query_people(conn)
  people_result = DBInterface.execute(conn, "SELECT id, first, last FROM persons;") |> DataFrame
  return people_result
end

function html_display(my_people_list)
    html(:persons, :peoplelist, people = my_people_list)
end

function peoplelist(db_config)
  conn = mysql_connect(db_config)

  people_result = query_people(conn)

  my_people_list = []
  num_people = size(people_result,1)
  @info "number of people " num_people

  for i = 1:size(people_result,1)
    id = people_result[i, 1]
    first_name = people_result[i, 2]
    last_name = people_result[i, 3]
    person = Person(id, first_name, last_name)
    @info "person: " person

    push!(my_people_list, person)
  end

  html_display(my_people_list)

end

end

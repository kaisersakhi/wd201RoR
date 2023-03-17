require_relative  "./connect_db.rb"
require_relative  "./todo.rb"

connect_db!
Todo.show_list

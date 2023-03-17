require "active_record"

class Todo < ActiveRecord::Base
  def self.show_list
    puts "My Todo-list"
    puts "Overdue"
    puts get_all_tasks(:overdue)

    puts "Due Today"
    puts get_all_tasks(:due_today)

    puts "Due Later"
    puts get_all_tasks(:due_later)
  end

  def self.get_all_tasks(type)
    comp = if type == :overdue
        "<"
      elsif type == :due_today
        "="
      else
        ">"
      end

    todos = self.where("due_date #{comp} ?", Date.today)
    # todos
    str = ""
    todos.each do |todo|
      str = str.concat todo.to_displayable_string, "\n"
    end
    str
  end

  def self.mark_as_complete(id)
    todo = Todo.find(id)
    if todo
      todo.completed = true
      todo.save!
    end
    todo
  end

  def self.add_task(new_task)
    p new_task
    # p self.superclass
    if new_task
      self.create!(todo_text: new_task[:todo_text], due_date: Date.today + new_task[:due_in_days], completed: false)
    end
  end

  def to_displayable_string
    status = self.completed ? "[x]" : "[ ]"
    "#{self.id}. #{status} #{self.todo_text} #{self.due_date}"
  end
end

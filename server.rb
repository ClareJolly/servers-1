require 'socket'

server = TCPServer.new(2345)

socket = server.accept

class Notebook
  attr_reader :title
  attr_accessor :all_notes

  def initialize(title = "Notebook")
    @title = title
    @all_notes = []
  end

  def note_titles(array = @all_notes)
    array.map { |x| x.title }.join("\n")
  end

  def note_body(title, array = @all_notes)
    array.each do |x|
      return x.body if x.title == title
    end
  end
end

class Note
  attr_reader :title, :body, :notebook
  def initialize(notebook, title, body)
    @notebook = notebook
    @title = title
    @body = body
    @notebook.all_notes << self
  end

end

socket.puts "WELCOME TO THE JOLLY NOTES APP"
socket.puts "==============================\n"
socket.puts "What do you want to do? (add, view, view body)"
do_next = socket.gets.chomp
notebook = Notebook.new

while do_next != "quit"
  if do_next.downcase == "add"
    socket.puts "Enter note title"
    notetitle = socket.gets.chomp
    socket.puts "Enter note body"
    notebody = socket.gets.chomp
    note = Note.new(notebook, notetitle, notebody)
    socket.puts "Note added"
    socket.puts "\nWhat do you want to do?\n"
    do_next = socket.gets.chomp
  elsif do_next.downcase == "view"
    socket.puts "HERE ARE THE NOTES"
    socket.puts "==================\n"
    socket.puts notebook.note_titles
    socket.puts "\nWhat do you want to do?\n"
    do_next = socket.gets.chomp
  elsif do_next.downcase == "view body"
    socket.puts "which note?"
    notetitle = socket.gets.chomp
    socket.puts "HERE IS THE BODY OF #{notetitle.upcase}"
    socket.puts "====================================\n"
    socket.puts notebook.note_body(notetitle)
    socket.puts "\nWhat do you want to do?\n"
    do_next = socket.gets.chomp
  else
    socket.puts "Sorry, what? What do you want to do?"
    do_next = socket.gets.chomp
  end
end
socket.puts "You said: . Goodbye!!"
socket.close

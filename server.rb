require 'socket'

server = TCPServer.new(2345)

socket = server.accept

# socket.puts "What do you say??"
#
# they_said = socket.gets.chomp

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

socket.puts "What do you want to do?"
do_next = socket.gets.chomp
notebook = Notebook.new
while do_next != "quit"

if do_next.downcase == "add note"

socket.puts "Enter note title"
notetitle = socket.gets.chomp
socket.puts "Enter note body"
notebody = socket.gets.chomp


# socket.puts "You said: #{they_said}."
# they_said = socket.gets.chomp


note = Note.new(notebook, notetitle, notebody)
socket.puts note
socket.puts "What do you want to do?"
do_next = socket.gets.chomp
# socket.puts "Enter note"
# notetitle = socket.gets.chomp


elsif do_next.downcase == "view notes"
  socket.puts notebook.note_titles
  socket.puts "What do you want to do?"
  do_next = socket.gets.chomp
elsif do_next.downcase == "view body"
  socket.puts "which note?"
  notetitle = socket.gets.chomp
  socket.puts notebook.note_body(notetitle)
  socket.puts "What do you want to do?"
  do_next = socket.gets.chomp
end
end
socket.puts "You said: . Goodbye!!"
socket.close

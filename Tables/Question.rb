require './questionsdatabase.rb'
class Question

  def self.create_question(title, body, author_id)
    QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
    INSERT INTO
      questions(title, body, author_id)
    VALUES
      (?,?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
    Question.new({'id' => @id, 'title' => title, 'body' => body, 'author_id' => author_id})
  end

  attr_accessor :id, :title, :body, :author_id

  def initialize(options = {})
    @id, @title, @body, @author_id = options.values_at('id', 'title', 'body', 'author_id')
  end

  def self.find_by_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL
    results.map{|result| Question.new(result)}
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    results.map{|result| Question.new(result)}
  end

  def author
    self.author_id
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end


end

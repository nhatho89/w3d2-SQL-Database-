require './questionsdatabase.rb'
class Reply

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL

    results.map{|result| Reply.new(result)}
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL

    results.map{|result| Reply.new(result)}
  end

  attr_accessor :id, :question_id, :parent_id, :user_id, :body

  def initialize(options = {})
    @id, @question_id, @parent_id, @user_id, @body =
      options.values_at('id', 'question_id', 'parent_id', 'user_id', 'body')
  end

  def find_by_user_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL

    results.map{|result| Reply.new(result)}
  end

  def author
    self.user_id
  end

  def question
    self.question_id
  end

  def parent_reply
    self.parent_id
  end

  def child_replies
    results = QuestionsDataabase.instance.execute(<<-SQL, self)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL

    results.map{|result| Reply.new(result)}
  end

  
end

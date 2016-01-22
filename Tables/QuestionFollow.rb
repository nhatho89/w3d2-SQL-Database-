require './questionsdatabase.rb'
class QuestionFollow
  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id, @user_id, @question_id = options.values_at('id', 'user_id', 'question_id')
  end

  def find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      id = ?
    SQL

    results.map{|result| QuestionFollow.new(result)}
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_follows ON users.id = question_follows.user_id
    WHERE
      question_id = ?
    SQL

    results.map{|result| User.new(result)}
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      questions
    JOIN
      question_follows ON question_follows.question_id = questions.id
    WHERE
      question_follows.user_id = ?
    SQL
    results.map{|result| Question.new(result)}
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      (SELECT
        question_id, COUNT(*)
      FROM
        question_follows
      GROUP BY
        question_id
      ORDER BY
        COUNT(*) DESC) AS 'follow_count'
    JOIN
      questions ON questions.id = follow_count.question_id
    LIMIT ?
    SQL
  end


end

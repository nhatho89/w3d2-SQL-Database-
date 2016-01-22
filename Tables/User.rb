require './questionsdatabase.rb'
class User

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def self.create_user(fname, lname)
    # raise 'already saved!' unless self.id.nil?

    QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    INSERT INTO
      users(fname, lname)
    VALUES
      (?,?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
    User.new({'id' => @id, 'fname' => fname, 'lname' => lname})
  end

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.find_by_name(fname, lname = "")
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? or lname = ?
    SQL
    results.map { |result| User.new(result) }
  end

  def authored_questions
    Question::find_by_author_id(self.id)
  end

  def authored_replies
    Reply::find_by_user_id(self.id)
  end

  def followed_questions
    #self = user
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

end

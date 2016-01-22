require './questionsdatabase.rb'
class QuestionLike
  attr_accessor :id, :user_id, :question_id
  def initialize(option={})
    @id, @user_id, @question_id =
      options.values_at('id', 'user_id', 'question_id')
  end

  def find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
    SQL

    results.map{|result| QuestionLike.new(result)}
  end
end

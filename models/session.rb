require_relative('../db/sql_runner.rb')

class Session

  attr_accessor :type, :start_time, :duration, :capacity
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @type = options['type']
    @start_time = options['start_time']
    @duration = options['duration']
    @capacity = options['capacity']
  end

  def save()
    sql = "INSERT INTO sessions
    (
      type,
      start_time,
      duration,
      capacity
      )
      VALUES ($1, $2, $3, $4)
      RETURNING id"
      values = [@type, @start_time, @duration, @capacity]
      @id = SqlRunner.run(sql, values).first['id'].to_i
  end

  def update()
    sql = "UPDATE sessions SET
    (
      type,
      start_time,
      duration,
      capacity
      ) = ($1, $2, $3, $4)
      WHERE id = $5"
    values = [@type, @start_time, @duration, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete(id)
    sql = "DELETE FROM sessions
    WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM sessions
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    return Session.new(result)
  end

  def self.all()
    sql = "SELECT * FROM sessions"
    results = SqlRunner.run(sql)
    return results.map { |session| Session.new(session) }
  end

  def self.delete_all()
    sql = "DELETE FROM sessions"
    SqlRunner.run(sql)
  end

  def attendance()
    sql = "SELECT members.* FROM members
    INNER JOIN schedule
    ON schedule.member_id = members.id
    WHERE schedule.session_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map { |member| Member.new(member) }
  end

  def self.find_by_type(type)
    sql = "SELECT * FROM sessions
    WHERE name = $1"
    values = [type]
    result = SqlRunner.run(sql, values).first
    return Session.new(result)
  end




end

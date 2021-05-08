# frozen_string_literal: true

class Memo
  def initialize
    @db_connection = PG.connect(dbname: 'memo')
  end

  def all
    @db_connection.exec('SELECT * FROM Memos ORDER BY id ASC')
  end

  def find(id)
    @db_connection.exec('SELECT * FROM Memos WHERE id = $1', [id]).first
  end

  def create(title, body)
    @db_connection.exec('INSERT INTO Memos(id, title, body) VALUES(DEFAULT, $1, $2)', [title, body])
  end

  def update(title, body, id)
    @db_connection.exec('UPDATE Memos SET title = $1, body = $2 WHERE id = $3', [title, body, id])
  end

  def delete(id)
    @db_connection.exec('DELETE FROM Memos WHERE id = $1', [id])
  end
end

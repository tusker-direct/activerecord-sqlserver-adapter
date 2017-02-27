require 'cases/helper_sqlserver'

class IndexTestSQLServer < ActiveRecord::TestCase

  before do
    connection.create_table(:testings) do |t|
      t.column :foo, :string, limit: 100
      t.column :bar, :string, limit: 100
      t.string :first_name
      t.string :last_name,    limit: 100
      t.string :key,          limit: 100
      t.boolean :administrator
    end
  end

  after do
    connection.drop_table :testings rescue nil
  end

  it 'add index with order' do
    assert_sql(/CREATE.*INDEX.*\(\[last_name\] DESC\)/i) do
      connection.add_index 'testings', ['last_name'], order: { last_name: :desc }
      connection.remove_index 'testings', ['last_name']
    end
    assert_sql(/CREATE.*INDEX.*\(\[last_name\] DESC, \[first_name\]\)/i) do
      connection.add_index 'testings', ['last_name', 'first_name'], order: { last_name: :desc }
      connection.remove_index 'testings', ['last_name', 'first_name']
    end
    assert_sql(/CREATE.*INDEX.*\(\[last_name\] DESC, \[first_name\] ASC\)/i) do
      connection.add_index 'testings', ['last_name', 'first_name'], order: { last_name: :desc, first_name: :asc }
      connection.remove_index 'testings', ['last_name', 'first_name']
    end
  end

end
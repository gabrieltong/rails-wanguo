class AddQuestionKindToImport < ActiveRecord::Migration
  def change
    add_column :imports, :question_kind, :string
  end
end

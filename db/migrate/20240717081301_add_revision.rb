class AddRevision < ActiveRecord::Migration[7.1]
  def change
    add_column :id_generations, :revision, :integer, default: 0
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end

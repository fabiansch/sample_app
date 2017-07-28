class AddPasswordResetSentAtToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_sent_at, :datetime
  end
end

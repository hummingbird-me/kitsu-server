class CreateFunctionGenerateSnowflake < ActiveRecord::Migration[6.1]
  def change
    # We have 22 bits for our unsigned sequence ID.
    create_sequence :snowflake_id_seq, min: 0, max: (2**23) - 1, cycle: true
    create_function :generate_snowflake
  end
end
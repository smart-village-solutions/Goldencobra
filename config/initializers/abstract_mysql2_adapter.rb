# Columns in a PRIMARY KEY must be NOT NULL, but if declared explicitly as NULL
# produced no error. Now an error occurs. For example, a statement such as
# CREATE TABLE t (i INT NULL PRIMARY KEY) is rejected. The same occurs for
# similar ALTER TABLE statements.
# (Bug #13995622, Bug #66987, Bug #15967545, Bug #16545198)
#
# https://github.com/rails/rails/pull/13247#issuecomment-32425844
class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
end

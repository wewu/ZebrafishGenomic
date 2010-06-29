class Dbxref < ActiveRecord::Base
  belongs_to :biodatabase, :class_name => "Biodatabase"
end

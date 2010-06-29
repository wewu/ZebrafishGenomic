class Term < ActiveRecord::Base
  belongs_to :ontology 
  has_many :goassignments
end

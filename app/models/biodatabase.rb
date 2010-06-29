class Biodatabase < ActiveRecord::Base
  has_many :bioentries
  has_many :dbxrefs
end

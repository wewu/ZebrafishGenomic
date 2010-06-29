class PeptideGenomedbResult < ActiveRecord::Base
   belongs_to :bioentries
   has_many :spectrum_results
end

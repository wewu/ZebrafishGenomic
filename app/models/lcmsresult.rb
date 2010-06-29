class Lcmsresult < ActiveRecord::Base
   belongs_to :bioentry
   has_many   :peptide_ipidb_results
end

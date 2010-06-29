class PeptideIpidbResult < ActiveRecord::Base
   belongs_to :lcmsresult
   has_many   :spectrum_results #, :as => :peptide
end

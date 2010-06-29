class SpectrumResult < ActiveRecord::Base
   belongs_to :peptide_ipidb_result #, :polymorphic => true
   belongs_to :peptide_genomedb_result #, :polymorphic => true
end

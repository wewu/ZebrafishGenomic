class CreateSpectrumResults < ActiveRecord::Migration
  def self.up
    create_table :spectrum_results do |t|
       t.column :peptide_ipidb_result_id,    :integer, :null => false
       t.column :peptide_genomedb_result_id, :integer, :null => false
       t.column :spectrum,                   :string, :null => false
       t.column :prob,                       :float
    end
    add_index :spectrum_results, :peptide_ipidb_result_id
    add_index :spectrum_results, :peptide_genomedb_result_id
  end

  def self.down
    drop_table :spectrum_results
  end
end

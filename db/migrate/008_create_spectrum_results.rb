class CreateSpectrumResults < ActiveRecord::Migration
  def self.up
    create_table :spectrum_results do |t|
       t.column :spectrum_link, :string, :null => false
       t.column :peptide_type,  :string, :null => false 
       t.column :peptide_id,    :integer, :null => false
    end
    add_index :spectrum_results, :peptide_type
    add_index :spectrum_results, :peptide_id
  end

  def self.down
    drop_table :spectrum_results
  end
end

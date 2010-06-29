class AddPvalueToSpectrumResults < ActiveRecord::Migration
  def self.up
     add_column(:spectrum_results, :prob, :float)
  end

  def self.down
    drop_column :spectrum_results, :prob
  end
end

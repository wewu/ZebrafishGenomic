class Bioentry < ActiveRecord::Base
  belongs_to :biodatabase
  has_one :bioentry_record
  has_many :dbxrefs
  has_many :lcmsresults
  has_many :goassignments
  has_many :peptide_genomedb_results

  def self.lcms_page(cond, includetables, page)
     basecond = "bioentries.biodatabase_id = 2 and bioentries.accession like 'IPI%%'"
     paginate :per_page => 10, 
              :page => page,
              :include => includetables,
              :conditions => [basecond + " and " + cond],
              :order => "accession, hpf, search_method"

  end

  def self.peptide_page(cond, includetable, orderby, page)
        paginate :per_page => 20, 
                 :page => page,
                 :conditions => ["bioentries.biodatabase_id = 36 and " + cond],
                 :order => orderby,
                 :include => includetable
  end
  
  def self.query_page(cond, includetables, page)
     paginate :per_page => 10, 
              :page => page,
              :include => includetables,
              :conditions => [cond],
              :order => "accession"

  end
  
end
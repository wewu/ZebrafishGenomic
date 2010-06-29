# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "abc", :force => true do |t|
    t.integer "peptide_ipidb_result_id",                    :null => false
    t.integer "peptide_genomedb_result_id",                 :null => false
    t.string  "spectrum",                   :default => "", :null => false
    t.float   "prob"
  end

  add_index "abc", ["peptide_ipidb_result_id"], :name => "index_abc_on_peptide_ipidb_result_id"
  add_index "abc", ["peptide_genomedb_result_id"], :name => "index_abc_on_peptide_genomedb_result_id"

  create_table "biodatabases", :force => true do |t|
    t.string "name",        :default => "", :null => false
    t.string "authority"
    t.text   "description"
  end

  add_index "biodatabases", ["name"], :name => "db_name", :unique => true
  add_index "biodatabases", ["authority"], :name => "db_auth"

  create_table "bioentries", :force => true do |t|
    t.integer "biodatabase_id", :limit => 10,                 :null => false
    t.integer "taxon_id",       :limit => 10
    t.string  "name",           :limit => 40, :default => "", :null => false
    t.string  "accession",      :limit => 40, :default => "", :null => false
    t.string  "identifier",     :limit => 40
    t.string  "division",       :limit => 6
    t.text    "description"
    t.integer "version",        :limit => 5,                  :null => false
  end

  add_index "bioentries", ["accession", "biodatabase_id", "version"], :name => "accession", :unique => true
  add_index "bioentries", ["identifier", "biodatabase_id"], :name => "identifier", :unique => true
  add_index "bioentries", ["name"], :name => "bioentry_name"
  add_index "bioentries", ["biodatabase_id"], :name => "bioentry_db"
  add_index "bioentries", ["taxon_id"], :name => "bioentry_tax"

  create_table "bioentry_records", :id => false, :force => true do |t|
    t.integer "bioentry_id", :limit => 10,                 :null => false
    t.text    "record",                    :default => "", :null => false
    t.string  "ipi",         :limit => 30
  end

  add_index "bioentry_records", ["bioentry_id"], :name => "bioentry_id"
  add_index "bioentry_records", ["record"], :name => "kw"

  create_table "bioentry_relationships", :force => true do |t|
    t.integer "object_bioentry_id",  :limit => 10, :null => false
    t.integer "subject_bioentry_id", :limit => 10, :null => false
    t.integer "term_id",             :limit => 10, :null => false
    t.integer "rank",                :limit => 5
  end

  add_index "bioentry_relationships", ["object_bioentry_id", "subject_bioentry_id", "term_id"], :name => "object_bioentry_id", :unique => true
  add_index "bioentry_relationships", ["term_id"], :name => "bioentryrel_trm"
  add_index "bioentry_relationships", ["subject_bioentry_id"], :name => "bioentryrel_child"
  add_index "bioentry_relationships", ["object_bioentry_id"], :name => "bioentryrel_parent"

  create_table "dbxrefs", :force => true do |t|
    t.integer "bioentry_id",    :limit => 10
    t.integer "biodatabase_id", :limit => 10
    t.string  "dbname",         :limit => 100, :default => "", :null => false
    t.string  "accession",                     :default => "", :null => false
    t.integer "version",        :limit => 5,                   :null => false
    t.integer "rank",           :limit => 6,   :default => 0
  end

  add_index "dbxrefs", ["bioentry_id", "dbname", "accession", "version"], :name => "dbxrefs_acc", :unique => true
  add_index "dbxrefs", ["dbname"], :name => "dbxref_db"
  add_index "dbxrefs", ["biodatabase_id"], :name => "biodatabase_id"

  create_table "digeresults", :force => true do |t|
    t.integer "bioentry_id",     :limit => 10
    t.integer "match_num",       :limit => 10,                 :null => false
    t.integer "spot_num",        :limit => 10,                 :null => false
    t.integer "hpf",                                           :null => false
    t.string  "ipi",             :limit => 50, :default => "", :null => false
    t.float   "protein_score",                                 :null => false
    t.float   "protein_score_c",                               :null => false
    t.float   "protein_mw",                                    :null => false
    t.float   "protein_pi",                                    :null => false
    t.integer "pep_count",       :limit => 5,                  :null => false
    t.integer "fold_change",     :limit => 2,                  :null => false
    t.integer "xcoor"
    t.integer "ycoor"
    t.float   "circ"
    t.float   "radius"
  end

  add_index "digeresults", ["bioentry_id"], :name => "bioentry_id"

  create_table "entries", :id => false, :force => true do |t|
    t.string "acc"
  end

  create_table "goassignments", :force => true do |t|
    t.integer "term_id",       :limit => 10, :null => false
    t.integer "bioentry_id",   :limit => 10, :null => false
    t.string  "evidence_code", :limit => 10
  end

  add_index "goassignments", ["term_id"], :name => "fk_goa_term"
  add_index "goassignments", ["bioentry_id"], :name => "fk_goa_bioentry"

  create_table "goenrichments", :force => true do |t|
    t.integer "term_id",              :limit => 10
    t.string  "goterm_acc",           :limit => 15, :default => "", :null => false
    t.integer "assignment_count",     :limit => 5,                  :null => false
    t.integer "total_assignments",    :limit => 5,                  :null => false
    t.float   "probability",                                        :null => false
    t.string  "condensed_goterm_acc", :limit => 15, :default => "", :null => false
    t.string  "go_namespace",         :limit => 25, :default => "", :null => false
    t.integer "hpf",                  :limit => 3,                  :null => false
  end

  add_index "goenrichments", ["term_id"], :name => "term_id"

  create_table "ingenuityresults", :force => true do |t|
    t.integer "bioentry_id", :limit => 10
    t.string  "ipi",         :limit => 15, :default => "", :null => false
    t.string  "gene_name",   :limit => 30
    t.string  "description"
    t.string  "identifier",  :limit => 30
    t.string  "location",    :limit => 50
    t.string  "family",      :limit => 50
    t.string  "pathway",     :limit => 50
    t.integer "hpf",         :limit => 3,                  :null => false
    t.string  "signal_type", :limit => 15
  end

  add_index "ingenuityresults", ["bioentry_id"], :name => "bioentry_id"

  create_table "lcmsresults", :force => true do |t|
    t.integer "bioentry_id",         :limit => 10
    t.integer "entry_num",           :limit => 10,                 :null => false
    t.integer "entry_subgroup",      :limit => 2,                  :null => false
    t.integer "hpf",                                               :null => false
    t.string  "ipi",                 :limit => 50, :default => "", :null => false
    t.float   "protein_group_prob",                                :null => false
    t.float   "protein_prob",                                      :null => false
    t.integer "percent_coverage",                                  :null => false
    t.integer "num_unique_peptides",                               :null => false
    t.integer "total_num_peptides",                                :null => false
    t.string  "search_method",       :limit => 10, :default => "", :null => false
    t.string  "qinteract_project",   :limit => 50, :default => "", :null => false
  end

  add_index "lcmsresults", ["bioentry_id"], :name => "bioentry_id"

  create_table "ontologies", :force => true do |t|
    t.string "name",       :limit => 32, :default => "", :null => false
    t.text   "definition"
  end

  add_index "ontologies", ["name"], :name => "name", :unique => true

  create_table "peptide_genomedb_results", :force => true do |t|
    t.integer "bioentry_id",                                      :null => false
    t.integer "hpf",                                              :null => false
    t.float   "prob",                                             :null => false
    t.string  "sequence",          :limit => 100, :default => "", :null => false
    t.string  "incross_intron",    :limit => 10,  :default => "", :null => false
    t.float   "xcorr"
    t.float   "deltacn"
    t.integer "sprank"
    t.string  "ions",              :limit => 20
    t.string  "chromosome",        :limit => 2,   :default => "", :null => false
    t.integer "start_position",                                   :null => false
    t.integer "end_position",                                     :null => false
    t.integer "frame",                                            :null => false
    t.string  "related_gene_name", :limit => 50
    t.string  "spectrum",          :limit => 50,  :default => "", :null => false
    t.string  "spectrum_link",     :limit => 300
    t.string  "gbrowser_link",     :limit => 300
  end

  add_index "peptide_genomedb_results", ["bioentry_id"], :name => "bioentry_id"

  create_table "peptide_ipidb_results", :force => true do |t|
    t.integer "lcmsresult_id",                                       :null => false
    t.integer "hpf",                                                 :null => false
    t.float   "prob",                                                :null => false
    t.string  "sequence",             :limit => 100, :default => "", :null => false
    t.float   "weight",                                              :null => false
    t.integer "precursor_ion_charge",                                :null => false
    t.integer "total_termini",                                       :null => false
    t.integer "num_sibling_peptides",                                :null => false
    t.integer "num_instances",                                       :null => false
  end

  add_index "peptide_ipidb_results", ["lcmsresult_id"], :name => "lcmsresult_id"

  create_table "spectrum_results", :force => true do |t|
    t.integer "peptide_ipidb_result_id",                    :null => false
    t.integer "peptide_genomedb_result_id",                 :null => false
    t.string  "spectrum_link",              :default => "", :null => false
    t.float   "prob"
  end

  create_table "taxon_names", :id => false, :force => true do |t|
    t.integer "taxon_id",   :limit => 10,                 :null => false
    t.string  "name",                     :default => "", :null => false
    t.string  "name_class", :limit => 32, :default => "", :null => false
  end

  add_index "taxon_names", ["taxon_id", "name", "name_class"], :name => "taxon_id", :unique => true
  add_index "taxon_names", ["taxon_id"], :name => "taxnametaxonid"
  add_index "taxon_names", ["name"], :name => "taxnamename"
  add_index "taxon_names", ["name_class"], :name => "taxnamenameclass"

  create_table "taxons", :force => true do |t|
    t.integer "ncbi_taxon_id",     :limit => 10
    t.integer "parent_id",         :limit => 10
    t.string  "node_rank",         :limit => 32
    t.integer "genetic_code",      :limit => 3
    t.integer "mito_genetic_code", :limit => 3
    t.integer "left_value",        :limit => 10
    t.integer "right_value",       :limit => 10
  end

  add_index "taxons", ["ncbi_taxon_id"], :name => "ncbi_taxon_id", :unique => true
  add_index "taxons", ["left_value"], :name => "left_value", :unique => true
  add_index "taxons", ["right_value"], :name => "right_value", :unique => true
  add_index "taxons", ["parent_id"], :name => "taxparent"

  create_table "term_paths", :force => true do |t|
    t.integer "subject_term_id",   :limit => 10, :null => false
    t.integer "predicate_term_id", :limit => 10, :null => false
    t.integer "object_term_id",    :limit => 10, :null => false
    t.integer "ontology_id",       :limit => 10, :null => false
    t.integer "distance",          :limit => 10
  end

  add_index "term_paths", ["subject_term_id", "predicate_term_id", "object_term_id", "ontology_id", "distance"], :name => "subject_term_id", :unique => true
  add_index "term_paths", ["predicate_term_id"], :name => "trmpath_predicateid"
  add_index "term_paths", ["object_term_id"], :name => "trmpath_objectid"
  add_index "term_paths", ["ontology_id"], :name => "trmpath_ontid"
  add_index "term_paths", ["subject_term_id"], :name => "trmpath_subjectid"

  create_table "term_relationships", :force => true do |t|
    t.integer "subject_term_id",   :limit => 10, :null => false
    t.integer "predicate_term_id", :limit => 10, :null => false
    t.integer "object_term_id",    :limit => 10, :null => false
    t.integer "ontology_id",       :limit => 10, :null => false
  end

  add_index "term_relationships", ["subject_term_id", "predicate_term_id", "object_term_id", "ontology_id"], :name => "subject_term_id", :unique => true
  add_index "term_relationships", ["predicate_term_id"], :name => "trmrel_predicateid"
  add_index "term_relationships", ["object_term_id"], :name => "trmrel_objectid"
  add_index "term_relationships", ["ontology_id"], :name => "trmrel_ontid"
  add_index "term_relationships", ["subject_term_id"], :name => "ontrel_subjectid"

  create_table "terms", :force => true do |t|
    t.integer "ontology_id", :limit => 10,                 :null => false
    t.string  "name",                      :default => "", :null => false
    t.string  "identifier",  :limit => 40
    t.string  "is_obsolete", :limit => 1
    t.text    "definition"
  end

  add_index "terms", ["identifier", "ontology_id", "is_obsolete"], :name => "identifier", :unique => true
  add_index "terms", ["ontology_id"], :name => "term_ont"

  create_table "tmp_rec", :force => true do |t|
    t.string  "spectrum_link", :default => "", :null => false
    t.string  "peptide_type",  :default => "", :null => false
    t.integer "peptide_id",                    :null => false
    t.float   "prob"
  end

  add_index "tmp_rec", ["peptide_type"], :name => "index_spectrum_results_on_peptide_type"
  add_index "tmp_rec", ["peptide_id"], :name => "index_spectrum_results_on_peptide_id"

end

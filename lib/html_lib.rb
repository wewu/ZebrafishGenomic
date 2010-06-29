class HtmlLib

## LCMS tables
def lcms_head
   s = ""
   s = s + textb_col("Show <br/> Peptides")
   s = s + textb_col("Accession")
   s = s + textb_col("Hours <br/> Post <br/> Fertilization")
   s = s + textb_col("Search <br/> Method")
   s = s + textb_col(" ")
   s = s + textb_col("Protein Group <br/> p-value")
   s = s + textb_col("Protein <br/> p-value")
   s = s + textb_col("Coverage")
   s = s + textb_col("Unique <br/> Peptides")
   s = s + textb_col("Total <br/> Peptides")
   s = s + textb_col(" ")
   s = s + textb_col("<a href='http://www.ebi.ac.uk/GOA/' target='_new'>GO</a> <br/>Term Name")
   s = s + textb_col(" ")
   s = s + textb_col("Description")
   sr = make_row(s, -1)
   sr
end

def lcms_row(i, id, accession, t1, t2, t3, t4, t5, t6, t7, go, desc)
   s = ""
   if (accession != "")
      s = s + cbox_col("cbox_" + id.to_s)
   else
      s = s + text_col(" ")
   end
   if (ENV['RAILS_ENV'].eql?("development"))
      s = s + http_alignleft_col("/bioentries/ipidetails/" + id.to_s, accession)
   else
      s = s + http_alignleft_col("/zebrafish/bioentries/ipidetails/" + id.to_s, accession)
   end
   s = s + text_col(t1)
   s = s + text_col(t2)
   s = s + text_col("")
   s = s + text_col(t3)
   s = s + text_col(t4)
   s = s + text_col(t5)
   s = s + text_col(t6)
   s = s + text_col(t7)
   s = s + text_col("")
   s = s + text_alignleft_col(go)
   s = s + text_col(" ")
   if (is_nil(desc))
      desc = ""
   end
   s = s + text_alignleft_col(desc) 

   sr = make_row(s, i%2)
   sr
end



def lcms_table(bioentries, ipiarr, keywords)
   s = ""
   i = 0 
   
   s = s + lcms_head()
   
   for bioentry in bioentries 
      showpeptide = search_array_numitem(bioentry.id, ipiarr)
      lcmsresults = bioentry.lcmsresults
      goresults = bioentry.goassignments
   
      firstentry = true
      for row in lcmsresults
         accession = ""
         desc = ""
         gostr = ""
         if (firstentry)
            accession = bioentry.accession
            desc = bioentry.description
            if (keywords != "")
               desc = desc.gsub(keywords, "<b>" + keywords + "</b>")
            end
            for go in goresults
               gostr = gostr + "<a href='http://www.ebi.ac.uk/ego/DisplayGoTerm?id=" + go.term.identifier + "' target = '_new'>" + go.term.name + "</a>,  "
            end 
         end
       
         s = s + lcms_row(i,
                          bioentry.id,
                          accession,
                          row.hpf,
                          row.search_method,
                          row.protein_group_prob,
                          row.protein_prob, 
                          row.percent_coverage,
                          row.num_unique_peptides,
                          row.total_num_peptides,
                          gostr,
                          desc)
         if (showpeptide >= 0)
            peprows = peptide_ipidb_table(row, row.peptide_ipidb_results)
            s = s + peprows
         end
         firstentry = false
         i = i + 1 
      end
   end
   s
end

   



## == Peptide_IPIDB ====
def peptide_ipidb_head
   s = ""
   s = s + textb_col("")
   s = s + textb_col("")
   s = s + textb_col("")
   s = s + textb_col("Peptide <br/> Index")
   s = s + textb_col("")
   s = s + textb_col("Peptide <br/> Probability")
   s = s + textb_col("Weight")
   s = s + textb_col("Precursor <br/>Ion Charge")
   s = s + textb_col("Total Termini")
   s = s + textb_col("Num <br/>Sibling<br/>Peptides")
   s = s + textb_col("")
   s = s + textb_col("Peptide Sequence")
   s = s + textb_col("Spectra")
   s
end

def peptide_ipidb_cols(t1, t2, t3, t4, t5, t6, t7, t8)
   s = ""
   s = s + textb_col("")
   s = s + textb_col("")
   s = s + textb_col("")
   s = s + text_col(t1)
   s = s + text_col("")
   s = s + text_col(t2)
   s = s + text_col(t3)
   s = s + text_col(t4)
   s = s + text_col(t5)
   s = s + text_col(t6)
   s = s + text_col("")
   s = s + text_alignleft_col(t7)
   s = s + text_col(t8)
   s
end

def form_spectrum_link(search_method, qproj, seq, spectrum_results)
   httpprefix = "http://bioinf.itmat.upenn.edu/tpp/cgi-bin/plot-msms.cgi?MassType=1&NumAxis=1&ShowA=1&ShowB=1&ShowY=1&ShowY2=1"
   modval = 0
   modvalint = 0
   if (search_method.eql?("sequest"))
      modval = 160.030684
      modvalint = 160
   else
     if (search_method.eql?("mascot"))
             modval = 147.035404
             modvalint = 147
           end
         end

         pos = 0
         mod = ""
   pep = ""

         begin
            pattern = /(.)\[/
      matched = pattern.match(seq)
      if (matched)
         pos = matched[1].length
      end
   rescue
   end
   
   if (pos > 0)
      mod = "&Mod" + pos.to_s + "=" + modval.to_s
      seq.gsub!("[" + modvalint.to_s + "]", "")
   end
   pep = "&Pep=" + seq

         specstr = ""
   for specrec in spectrum_results
      spectrum = specrec.spectrum
      specshort = ""
      arr = spectrum.split(/\./)
      if (arr.length > 0)
         specshort = arr[0]
      end
      dtaprefix = "&Dta=/data/www/htdocs/qInteract/data2/"
      dta = dtaprefix + qproj + "/" + specshort + "/" + spectrum + ".dta"
      
      http = httpprefix + mod + pep + dta
      prob = specrec.prob
      
      if (specstr.length == 0)
         specstr = "<a href='" + http + "' target = '_new'>" + prob.to_s + "</a>"
      else
         specstr = specstr + ", <a href='" + http + "' target = '_new'>" + prob.to_s + "</a>"
      end
   end
   specstr
end

def peptide_ipidb_table(lcmsresult, pepipidbresults)
   s = ""
   if (pepipidbresults.length > 0)
      s = s + make_row(peptide_ipidb_head(), 2)
      i = 0
      
      for row in pepipidbresults
         spectrumlink = form_spectrum_link(lcmsresult.search_method, lcmsresult.qinteract_project, row.sequence, row.spectrum_results)      
         sc = peptide_ipidb_cols((i+1).to_s,
                                 row.prob,
                                 row.weight,
                                 row.precursor_ion_charge,
                                 row.total_termini,
                                 row.num_sibling_peptides,
                                 row.sequence,
                                 spectrumlink)
         sr = make_row(sc, 2)
         s = s + sr
         i = i + 1
      end
   end
   s
end


## == Peptide_genomedb_table ====
def peptide_genomedb_head
   s = ""
   s = s + textb_col("Index")
   s = s + textb_col("Inside or Cross <br/> Intron")
   s = s + textb_col("Hours <br/> Post <br/> Fertilization")
   s = s + textb_col("Probabilities")
   s = s + textb_col("Peptide Sequence")
   s = s + textb_col("")
   s = s + textb_col("Chromosome")
   s = s + textb_col("Start <br/> Position")
   s = s + textb_col("End <br/> Position")
   s = s + textb_col("Frame")
   s = s + textb_col("")
   s = s + textb_col("Xcorr")
   s = s + textb_col("Deltacn")
   s = s + textb_col("Sprank")
   s = s + textb_col("Ions")
   sr = make_row(s, -1)
   sr
end


def peptide_genomedb_row(i, id, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, gblink, spectrumlink)
   s = ""
   s = s + text_col(id)
   s = s + http_col_new_window(gblink, t1)
   s = s + text_col(t2)
   s = s + text_col(spectrumlink)
   s = s + text_alignleft_col(t3)
   s = s + text_col("")
   s = s + text_col(t4)
   s = s + text_col(t5)
   s = s + text_col(t6)
   s = s + text_col(t7)
   s = s + text_alignright_col(t8)
   s = s + text_col("")
   s = s + text_alignright_col(t9)
   s = s + text_col(t10)
   s = s + text_alignright_col(t11)

   sr = make_row(s, i%2)
   sr
end


def peptide_genomedb_table(bioentries)
   s = ""
   i = 0
   s = s + peptide_genomedb_head()
   
   for bioentry in bioentries
      pep_results = bioentry.peptide_genomedb_results

      
      for row in pep_results
         spectrumlink = form_spectrum_link("sequest", row.qinteract_project, row.sequence, row.spectrum_results)      
         s = s + peptide_genomedb_row(i,
                                    row.id.to_s,
                                    row.related_gene_name,
                                    row.hpf.to_s,
                                    row.sequence,
                                    row.chromosome.to_s,
                                    row.start_position.to_s,
                                    row.end_position.to_s,
                                    row.frame.to_s,
                                    row.xcorr.to_s,
                                    row.deltacn.to_s,
                                    row.sprank.to_s,
                                    row.ions.to_s,	
                                    row.gbrowser_link,
                                    spectrumlink)
         i = i + 1
      end
   end
   s
end


## == Peptide Summary ====
def peptidesummary_table
   s = "<b>Summary of Peptide Results</b><br><br>\n"
   s = s + "<table border=1>\n"
   s = s + peptidesummary_head_row()
   s = s + peptidesummary_rec_row("24 HPF", 183, 302)
   s = s + peptidesummary_rec_row("72 HPF", 1, 28)
   s = s + peptidesummary_rec_row("120 HPF", 5, 48)
   s = s + "</table>"
   s
end

def peptidesummary_head_row
   s = textb_col("Data Set")
   s = s + textb_col("Number of new peptides <br/>that are cross Intron <br/> and Exon boundaries")
   s = s + textb_col("Number of new peptides <br/>that are inside introns")
   sr = make_row(s, -1)
   sr
end

def peptidesummary_rec_row(t1, t2, t3)
   s = text_alignleft_col(t1)
   s = s + text_col(t2)
   s = s + text_col(t3)
   sr = make_row(s, 0)
   sr
end

      
## == XREF ====
def xref_head
   s = textb_col("Database Name")
   s = s + textb_col("Accession")
   s
end

def xref_cols(t1, accession, authority)
   s = text_alignleft_col(t1)
   if (authority)
      s = s + http_col(authority + accession, accession )
   else
      s = s + text_alignleft_col(accession)
   end
   s
end

def xref_table(xrefresults)
   s = ""
   if (xrefresults.length > 0)
      s = "<h2 > External Database References</h2>\n"
      s = s + "<table border=1>\n"
      s = s + make_row(xref_head(), -1)
      i = 0
      for row in xrefresults
         sc=  xref_cols(row.dbname,
                        row.accession,
                        row.biodatabase.authority)
         sr = make_row(sc, i%2)
         s = s + sr
         i = i + 1
      end
      s = s + "</table>\n"
   end
   s
end

## == uniprot ====
def uniprot_table(record)
   s = ""
   if (record.length > 0)
      s = "<h2 > IPI UniProt Record</h2>\n"
      s = s + "<table border=1>\n"
      s = s + "<pre>" + record + "</pre>\n"
      s = s + "</table>\n"
   end
   s
end


## ================ form function ================================
def text_col(txt)
   str = "<td nowrap>" + txt.to_s + "</td>\n"
end

def text_row(txt)
   s = make_row(text_col(txt), 0)
end

def text_alignleft_col(txt)
   str = "<td align=left>" + txt + "</td>\n"
end

def text_alignright_col(txt)
   str = "<td nowrap align=right>" + txt + "</td>\n"
end

def text_color_col(txt, color)
   str = "<td nowrap><font color='" + color + "'>" + txt + "</font></td>\n"
end

def yesno_col(txt)
   s = ""
   if (txt.length > 0)
      s = text_color_col("Y", "green")
   else
      s = text_color_col("N", "red")
   end
   s
end

def http_col(http, txt)
   str = "<td nowrap><a href='" + http + "'>" + txt.to_s + "</a></td>\n"
end

def http_alignleft_col(http, txt)
   str = "<td align=left nowrap><a href='" + http + "'>" + txt.to_s + "</a></td>\n"
end

def http_col_new_window(http, txt)
   str = "<td nowrap><a href='" + http + "' target='_new'>" + txt.to_s + "</a></td>\n"
end

def http_alignleft_col_new_window(http, txt)
   str = "<td align=left nowrap><a href='" + http + "' target='_new'>" + txt.to_s + "</a></td>\n"
end

##textb
def textb_col(txt)
   str = "<td nowrap><b>" + txt + "</b></td>\n"
end

def textb_row(txt)
   s = make_row(textb_col(txt), 0)
end

def make_row(txt, rownum)
   bgclr = get_bgcolor(rownum)
   row = "<tr align='center' bgcolor=" + bgclr + ">" + txt + "</tr>\n"
   row
end

def cbox_col(name)
   str = "<td nowrap><input type=checkbox name='" + name + "' value = 1></td>"
end

def cboxchked_col(name)
   str = "<td nowrap><input type=checkbox name='" + name + "' value = 1 checked='yes'></td>"
end


## ================ basic function ================================
def submit_button(txt)
   str = "<input type=submit value='" + txt + "'>"
end

def get_bgcolor(rownum)
   if (rownum == 0)
      bgclr = "white"
   elsif (rownum == 1)
      bgclr = "lightgray"
   elsif (rownum == 2)       #peptide table
      bgclr = "lightblue"
   elsif (rownum == -1)      #headline
      bgclr = "lightgreen"
   end
   bgclr
end

def is_nil(str)
   empty = false
   if ((str == nil) || (str == ""))   
      empty = true
   else
      empty = false
   end
   empty
end

def search_array_numitem(item, arr)
    idx = -1
    j = 0
    for it in arr
       if (it == item)
           idx  = j
           break
       end      
       j = j + 1
    end
    idx
end
   
def search_array_stritem(item, arr)
   idx = -1
   begin
      j = 0
      for a in arr
         if (a.casecmp(item) == 0)
            idx  = j
            break
         end      
         j = j + 1
      end
   rescue
   end
   idx
end

end   #class end

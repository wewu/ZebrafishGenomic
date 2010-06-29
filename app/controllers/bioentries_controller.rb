class BioentriesController < ApplicationController

  def goto_content
     @idval = params[:id]
     @keywords = ""

     if (params[:curpage].to_i > 0)
        @curpage = params[:curpage]
     else
        @curpage = params[:page]
     end
     
     if (@idval.eql?("intro"))        then render :action => "intro" 
     elsif (@idval.eql?("search"))    then render :action => "search"
     elsif (@idval.eql?("protiden"))  then render :action => "protiden"
     elsif (@idval.eql?("proteinintro"))  then render :action => "proteinintro"
     elsif (@idval.eql?("peptideintro"))  then render :action => "peptideintro"

     elsif (@idval.eql?("lcms"))    
        @bioentries = Bioentry.lcms_page("lcmsresults.bioentry_id = bioentries.id", "lcmsresults", @curpage)
        @ipiarr = selected_ipiarr(@bioentries)
        render :action => "list"

     elsif (@idval.eql?("peptide"))  
        @bioentries = Bioentry.peptide_page("peptide_genomedb_results.bioentry_id = bioentries.id", "peptide_genomedb_results", "peptide_genomedb_results.id", @curpage)
        render :action => "list"

     elsif (@idval.eql?("query"))     
        @keywords = params[:keywords].upcase
        @bioentries = Bioentry.query_page("match (bioentry_records.record) against ('" + @keywords + "' IN BOOLEAN MODE)", "bioentry_record", @curpage)
        @ipiarr = selected_ipiarr(@bioentries)
        render :action => "list"

     elsif (@idval.eql?("download"))
        @local_download_index_file = get_download_path() + "index.html"
        render :action => "download"
     end
  end

  def selected_ipiarr(bioentries)
     ipiarr = Array.new
     i = 0
     for bioentry in bioentries
        begin
           if (params["cbox_" + bioentry.id.to_s] == "1")
              ipiarr[i] = bioentry.id
              i = i + 1
           end
        rescue
        end
     end
     ipiarr
  end

## render to detail pages
  def peptidegbrowser
     @tall = params[:id]
     render :action => "peptidebrowser"
  end

  def ipidetails
    @bioentry = Bioentry.find(params[:id])
    render :action => "ipidetails"
  end

## navigation
  def goto_logo
     render :action => "logo"
  end

  def goto_navbar
     render :action => "navbar"
  end

  def goto_contact
     render :action => "contact"
  end

## functions
  def get_download_path()
     path = File.dirname(__FILE__) + "/../../public/downloads/"
     path
  end

end

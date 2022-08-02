require "net/http"
require "uri"
require 'nokogiri'

class CustomRestSearchController < ApplicationController

  unloadable

  #  before_action :find_project, :authorize
  before_action :find_custom_field, :find_project

  def search
   if User.current.allowed_to?(:add_issues, @project)
     logger.info 'Prijavljen uporabnik '+User.current.name+' na SVN tags endpoint' 
    issue_id = params['issue_id']
    project_id = params['project_id']
    svn_field=@custom_field.svn.to_s
    svn_usr=@custom_field.svnusr.to_s
    svn_pwd=@custom_field.svnpwd.to_s
    customfield_id=CustomField.find_by_name(svn_field).id;
    svn = @project.custom_field_value(customfield_id)   
    restapi=@custom_field.rest.to_s
#    restapi.concat("?svn=")
#    restapi.concat(svn)
    logger.info "Username:"+svn_usr+"  geslo:"+svn_pwd+"  Url:"+restapi
#    url = URI(restapi)
#    request = Net::HTTP.Get.new(url.host, url.port)
#    #request = Net::HTTP::Get.new(url)
#    request.use_ssl = (url.scheme == 'https')
#    request["Authorization"] =  "Basic " + Base64::strict_encode64(svn_usr+":"+svn_pwd)
#    result = https.request(request)
#    puts result.read_body

#      encoded_url = CGI.escape_html(restapi)
#      uri = URI.parse(encoded_url)
#      http = Net::HTTP.new(uri.host, uri.port)
#      #http.basic_auth svn_usr, svn_pwd
#      if uri.scheme == "https"
#       http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#       http.use_ssl = true
#       #http.use_ssl = true if uri.instance_of? URI::HTTPS
#      else
#       http.use_ssl = false 
#      end
#      request = Net::HTTP::Get.new(uri.request_uri)
#      request["Authorization"] =  "Basic " + Base64::strict_encode64(svn_usr+":"+svn_pwd)
#      result = http.request(request)

#    uri = URI(restapi)
#    req = Net::HTTP::Get.new(uri)
#    req.basic_auth svn_usr, svn_pwd
#      if uri.scheme == "https"
#       req.verify_mode = OpenSSL::SSL::VERIFY_NONE
#       req.use_ssl = true
       #http.use_ssl = true if uri.instance_of? URI::HTTPS
#      end

 #   Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
 #    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
 #    request = Net::HTTP::Get.new uri
 #    response = http.request req
 #   end
 #   
 #   puts http.body
 #   output=http.body
 #   if res.is_a?(Net::HTTPSuccess)
#
#      #    result = Net::HTTP.get_response(URI.parse(URI.encode(restapi)))



#http.basic_auth svn_usr,svn_pwd
#request["Authorization"] =  "Basic " + Base64::strict_encode64(svn_usr+":"+svn_pwd)

uri = URI(restapi)
req = Net::HTTP::Get.new(uri)
req.basic_auth svn_usr,svn_pwd
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")
res = http.request(req)

#res = Net::HTTP.start(uri.hostname, uri.port) do |http|
#  http.request(req)
#end
logger.info 'GET metoda uspesno koncana';

  case res
    when Net::HTTPSuccess
     #tags=doc.xpath("//name").collect(&:text)
     document = Nokogiri::HTML(res.body)
     link = document.at('ul').css('a').map(&:text)
     links = parse_links(link.drop(1).reverse())
#links = []

     #div = document.at('ul')

     #div.at('li').xpath(a[contains(.,'..').remove

     #links.push(diviv.at('li').xpath('a))

#document.at("ul").css('a').each do |node|
#if node.text != '..'
# links.push(node.text)
#end
     
     #document.css('li').each do |links|
     #  puts links.at['a'].text if not text.include? ".."
     #end
     @dataset = links;
     #   document.at('ul').search('li').each do |row|
      #    cells = row.search('a').text
      #    logger.info cells;    


     #@dataset = eval()
     logger.info 'Podatki uspesno preparsani';
    when Net::HTTPUnauthorized
      @dataset = []
      logger.warn  "Napaka #{response.message}: z avtentifikacijo! Http code:"+res.code+" Url:"+restapi
    when Net::HTTPServerError
      @dataset = []
      logger.warn "Napaka #{response.message}: Http code:"+res.code+" Url:"+restapi
    else
      logger.warn "Napaka "+response.message+" Http code:"+res.code+" Url:"+restapi
      @dataset = []
  end


   else
      logger.info 'Uporabnik '+User.current.name+' nima pravic na SVN tags endpoint'
      @dataset = []
   end
    render :layout => false
  end

def parse_links(links)
     povezave = []
     links.each do |url|
       povezave.push(url.chop)
     end
return povezave
end  


  private
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_custom_field
    @custom_field = CustomField.find(params[:custom_field_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  helper_method :search
end

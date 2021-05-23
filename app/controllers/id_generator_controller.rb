
class IdGeneratorController < ApplicationController
  require "const/vfs_const"
  require "const/stat_const"
  require "const/acl_const"
  require "const/ssl_const"
  require "const/spin_types"
  require "openssl"
  require "base64"
  require "tasks/security"
  require "uri"
  require "pg"
  require "pp"
  require "time"
  require "const/page_audio_mappings"
  require "json"

  include Vfs
  include Acl
  include Ssl
  include Stat
  include Types

  protect_from_forgery with: :exception
  protect_from_forgery except: :reject_proc

  # frozen_string_literal: true

  layout "id_generator"

  require 'tasks/security'

  def index
    id_generator_props = {name: "ID Generator"}

    server_name = "http://www.audiokyoto.com"
    proc_path = "/id_generator/"
    idpass = ""
    lang = params["lang"]
    ns = params["ns"].to_i
    ne = params["ne"].to_i
    nd = 0
    Random.new_seed
    rmin = 0
    rmax = 10000000000
    for nr in ns..ne do
      numhash = Security::hash_key nr, ns, ne, nd
      pwdhash = Security::hash_key_s numhash
      altid = Random.rand(rmin...rmax).to_s
      self.register_new_id_rec(numhash, pwdhash, altid)
    end
    # File.open("num0.txt") do |f|
    #   f.each_line do |l|
    #     numhash = Security::hash_key_s(f.gets)
    #     lstr = lang + numhash
    #     pp lstr
    #   end
    # end
  end

    # add user properties to spin_sessions
  def register_new_id_rec(newid, passwd, altid)
    log_message = "#{__method__} : id record = (id:#{newid}, passwd:#{passwd}, altid:#{altid}"
    Rails.logger.warn(log_message)

    retry_save = ACTIVE_RECORD_RETRY_COUNT
    catch(:id_generation_again) {
      IdGeneration.transaction do
        begin
          ssrec = IdGeneration.find_or_create_by(uid_base: newid) do |cs|
          end
          if ssrec.present?
            IdGeneration.where(uid_base: newid).update_all(uid_base: newid, password_base: passwd, altid_base: altid, withdrawn: false)
          end
        rescue ActiveRecord::StaleObjectError
          if retry_save > 0
            retry_save -= 1
            sleep(AR_RETRY_WAIT_MSEC)
            throw :id_generation_again
          end
        end
      end # => end of transaction
    }
  end

  #
  def accesslog(req, ses, spinses, msg = "")
    eolmsg = ""
    if msg.empty?
      eolmsg = '\n'
    else
      eolmsg = " #{msg}\n"
    end
    logmsg = "#{req.env["REMOTE_ADDR"]} - - [#{Time.now.iso8601}] \"#{req.env["REQUEST_METHOD"]} #{req.env["REQUEST_URI"]} #{req.env["SERVER_PROTOCOL"]} \" 200 - \"#{req.env["HTTP_REFERER"]}\" #{ses} #{spinses} \"#{req.env["HTTP_USER_AGENT"]}\"#{eolmsg}"
    $access_logger.info(logmsg)

    return logmsg
  end

end

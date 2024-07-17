class IdGeneratorController < ApplicationController
  require 'const/vfs_const'
  require 'const/stat_const'
  require 'const/acl_const'
  require 'const/ssl_const'
  require 'const/spin_types'
  require 'openssl'
  require 'base64'
  require 'tasks/security'
  require 'utilities/database_utilities'
  require 'uri'
  require 'pg'
  require 'time'
  require 'const/page_audio_mappings'
  require 'json'

  include Vfs
  include Acl
  include Ssl
  include Stat
  include Types

  protect_from_forgery with: :exception
  protect_from_forgery except: :reject_proc

  # frozen_string_literal: true

  layout 'id_generator'

  require 'tasks/security'

  def index
    id_generator_props = { name: 'ID Generator' }

    @page_title = id_generator_props[:name]

    server_name = 'https://society-foundation.securedomainjapan.com'
    proc_path = '/id_generator/'
    idpass = ''
    lang = params['lang']
    rmin = 0
    rmax = 200_000_000
    ns = params['ns'].present? ? params['ns'].to_i : rmin
    ne = params['ne'].present? ? params['ne'].to_i : rmax
    nd = 0
    Random.new_seed
    (ns..ne).each do |nr|
      numhash = Security.hash_key nr, ns, ne, nd
      pwdhash = Security.hash_key_s numhash
      altid = Random.rand(rmin...rmax).to_s
      DatabaseUtility.update_or_create_record(IdGeneration, { uid_base: numhash },
                                              Vfs::ACTIVE_RECORD_RETRY_COUNT) do |idrec|
        idrec[:uid_base] = numhash
        idrec[:password_base] = pwdhash
        idrec[:altid_base] = altid
      rescue StandardError => e
        S5fLib.print_exception(e, true)
        raise "Failed to register new id record in #{__method__}"
      end
      log_message = "#{__method__} : id record = (id:#{numhash}, passwd:#{pwdhash}, altid:#{altid}"
      Rails.logger.warn(log_message)
      # register_new_id_rec(numhash, pwdhash, altid)
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
    catch(:id_generation_again) do
      IdGeneration.transaction do
        ssrec = IdGeneration.find_or_create_by(uid_base: newid) do |cs|
        end
        if ssrec.present?
          IdGeneration.where(uid_base: newid).update_all(uid_base: newid, password_base: passwd, altid_base: altid,
                                                         withdrawn: false)
        end
      rescue ActiveRecord::StaleObjectError
        if retry_save > 0
          retry_save -= 1
          sleep(AR_RETRY_WAIT_MSEC)
          throw :id_generation_again
        end
      end # => end of transaction
    end
  end

  def accesslog(req, ses, spinses, msg = '')
    eolmsg = ''
    eolmsg = if msg.empty?
               '\n'
             else
               " #{msg}\n"
             end
    logmsg = "#{req.env['REMOTE_ADDR']} - - [#{Time.now.iso8601}] \"#{req.env['REQUEST_METHOD']} #{req.env['REQUEST_URI']} #{req.env['SERVER_PROTOCOL']} \" 200 - \"#{req.env['HTTP_REFERER']}\" #{ses} #{spinses} \"#{req.env['HTTP_USER_AGENT']}\"#{eolmsg}"
    $access_logger.info(logmsg) # rubocop:disable Style/GlobalVars

    logmsg
  end
end

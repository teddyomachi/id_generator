require 'const/vfs_const'

require 'const/acl_const'

require 'const/stat_const'

require 'tasks/session_management'

require 'tasks/security'

require 'utilities/set_utilities'

require 'exceptions/s5f_exception'

require 'pg'

module DatabaseUtility
  class StateUtility < ActiveRecord::Base
    include Vfs

    include Acl

    include Stat

    def self.updated_after?(tdata, qtime, cond = 'all')
      # initialize variables

      qt = Time.new

      Spinapp::SpinDomain.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        case tdata

        when 'SpinDomain'

          if cond == 'all'

            qt = Spinapp::SpinDomain.maximum(:updated_at).to_time

          else

            qto = Spinapp::SpinDomain.readonly.select(:updated_at).where(['id > 0'])

            qt = nil

            qto.each do |q|
              if qt.nil?

                qt = q[:updated_at]

              elsif qt < q[:updated_at]

                qt = q[:updated_at]

              end
            end

          end # => end of 'SpinDomain' case

        end # => end of case
      end

      qt > qtime
    end # => end of self.updated_after? tdata, qtime, cond = 'all'
  end

  class SessionUtility < ActiveRecord::Base
    include Vfs

    include Acl

    # set session infomation to spin_sessions

    # params :

    # sid : session_id

    # type : type of request that call this

    # pharray : hash of parameters which are specific with each request

    def self.set_session_info(sid, type, hkey, location)
      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        sr = Spinapp::SpinSession.find_by(spin_session_id: sid)

        # initialize

        return false if sr.blank?

        contl = 'folder_a'

        return false unless sr # => no record?

        # do specific process for each request type

        case type

          # change_domain request

        when 'change_domain'

          # folder in concern is folder_a or folder_b

          cl = location

          case cl

          when 'folder_a'

            # sr.spin_domaindata_A_id = hkey

            # sr.spin_domaindata_B_id = nil

            sr.cont_location_domain = 'folder_a'

            sr[:selected_domain_a] = hkey

            sr[:spin_current_domain] = hkey

            sr.save

          when 'folder_b'

            # sr.spin_domaindata_B_id = hkey

            # sr.spin_domaindata_B_id = nil

            sr.cont_location_domain = 'folder_b'

            sr[:selected_domain_b] = hkey

            sr[:spin_current_domain] = hkey

            sr.save

          when 'folder_a'

            # sr.spin_domaindata_A_id = hkey

            # sr.spin_domaindata_B_id = nil

            sr.cont_location_domain = 'folder_a'

            sr[:selected_domain_a] = hkey

            sr[:spin_current_domain] = hkey

            sr.save

          when 'folder_b'

            # sr.spin_domaindata_B_id = hkey

            # sr.spin_domaindata_B_id = nil

            sr.cont_location_domain = 'folder_b'

            sr[:selected_domain_b] = hkey

            sr[:spin_current_domain] = hkey

            sr.save

          end

          # change_foldwer request

        when 'change_folder'

          # folder in concern is folder_a or folder_b

          cl = location

          # current_domain = String.new

          case cl # => check content location

          when 'folder_a'

            sr.cont_location_folder = 'folder_a'

            sr[:selected_folder_a] = hkey

            sr[:spin_current_directory] = hkey

            # current_domain = sr[:selected_folder_a]

            # sr.spin_folderdata_B_id = nil

            sr.save

          when 'folder_b'

            sr.cont_location_folder = 'folder_b'

            sr[:selected_folder_b] = hkey

            sr[:spin_current_directory] = hkey

            # current_domain = sr[:selected_folder_b]

            # sr.spin_folderdata_A_id = nil

            sr.save # => update spin_sessions table

          end

        end # => end of case
      end # => end of transaction

      true
    end

    # => end of self.set_session_info( sid, type, pharray )

    def self.get_current_directory(sid, location = LOCATION_ANY)
      # if sid == ADMIN_SESSION_ID

      # return "/"

      # else

      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ss = Spinapp::SpinSession.readonly.find_by(spin_session_id: sid)

        return nil if ss.blank?

        return nil unless ss

        case location

        when 'folder_a'

          return ss[:selected_folder_a]

        when 'folder_b'

          return ss[:selected_folder_b]

        when 'folder_at'

          return ss[:selected_folder_at]

        when 'folder_bt'

          return ss[:selected_folder_bt]

        when 'folder_atfi'

          return ss[:selected_folder_atfi]

        when 'folder_btfi'

          return ss[:selected_folder_btfi]

        else

          return ss[:spin_current_directory]

        end

        # end
      end
    end

    # => end of get_current_directory sid

    def self.get_selected_domain(sid, location = LOCATION_ANY)
      # if sid == ADMIN_SESSION_ID

      # return "/"

      # else

      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ss = Spinapp::SpinSession.readonly.find_by(spin_session_id: sid)

        return nil unless ss.present?

        case location

        when 'folder_a', 'domain_a'

          return ss[:selected_domain_a]

        when 'folder_b', 'domain_b'

          return ss[:selected_domain_b]

        when 'folder_at'

          return ss[:selected_domain_a]

        when 'folder_bt'

          return ss[:selected_domain_b]

        when 'folder_atfi'

          return ss[:selected_domain_a]

        when 'folder_btfi'

          return ss[:selected_domain_b]

        else

          return ss[:selected_domain_a]

        end

        # end
      end
    end

    # => end of get_current_directory sid

    def self.get_location_current_directory(sid, location)
      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ss = Spinapp::SpinSession.readonly.select('selected_folder_a,selected_folder_b,selected_folder_at,selected_folder_bt,selected_folder_atfi,selected_folder_btfi,spin_current_directory').find_by(spin_session_id: sid)

        if ss.present?

          case location

          when 'folder_a'

            return ss[:selected_folder_a]

          when 'folder_b'

            return ss[:selected_folder_b]

          when 'folder_at'

            return ss[:selected_folder_at]

          when 'folder_bt'

            return ss[:selected_folder_bt]

          when 'folder_atfi'

            return ss[:selected_folder_atfi]

          when 'folder_btfi'

            return ss[:selected_folder_btfi]

          else

            return ss[:spin_current_directory]

          end

        end
      end

      nil
    end

    # => end of get_location_current_directory sid

    def self.get_current_directory_path(sid, location = LOCATION_ANY)
      # if sid == ADMIN_SESSION_ID

      # return "/"

      # else

      ss = ''

      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ss = Spinapp::SpinSession.readonly.find_by(spin_session_id: sid)
      end

      if ss.present?

        case location

        when 'folder_a'

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_a]

        when 'folder_b'

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_b]

        when 'folder_at'

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_at]

        when 'folder_bt'

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_bt]

        when 'folder_atfi'

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_atfi]

        when 'folder_btfi'

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_btfi]

        else

          VirtualFileSystemUtility.key_to_path ss[:selected_folder_a]

        end

      else

        nil

        # end

      end
    end

    # => end of get_current_directory_path

    # set current directory in db spin_sessions

    def self.set_current_directory(sid, vpath, location = LOCATION_ANY)
      path_is_relative = false

      current_path = vpath

      path_is_relative = true if vpath[0, 1] != '/' || vpath[0, 2] == './'

      if path_is_relative

        cd = get_current_directory sid

        current_path = cd + (vpath[0, 2] == './' ? vpath[1..-1] : ('/' + vpath))

      else

        current_path = vpath

      end

      ss = ''

      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ss = Spinapp::SpinSession.readonly.find_by(spin_session_id: sid)
      end

      retry_set_current_director = Vfs::ACTIVE_RECORD_RETRY_COUNT

      cp = nil

      catch(:set_current_directory_again) do
        Spinapp::SpinSession.transaction do
          if ss.present? # => check session

            cp = VirtualFileSystemUtility.path_to_key current_path

            # ss[:spin_current_directory] = VirtualFileSystemUtility.path_to_key current_path

            # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

            ss[:updated_at] = Time.now

            ss[:spin_current_location] = location

            ss[:cont_location_folder] = location

            ss[:spin_current_directory] = cp

            case location

            when 'folder_a'

              ss[:selected_folder_a] = cp

            when 'folder_b'

              ss[:selected_folder_b] = cp

            when 'folder_at'

              ss[:selected_folder_at] = cp

            when 'folder_bt'

              ss[:selected_folder_bt] = cp

            when 'folder_atfi'

              ss[:selected_folder_atfi] = cp

            when 'folder_btfi'

              ss[:selected_folder_btfi] = cp

            else

              ss[:selected_folder_a] = cp

            end

            ss.save

          elsif sid == ADMIN_SESSION_ID # => no session is found and sid is ADMIN_SESSION_ID. special case!

            cp = VirtualFileSystemUtility.path_to_key current_path

            # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

            new_session = Spinapp::SpinSession.new

            new_session[:spin_session_id] = sid

            new_session[:spin_current_directory] = if %w[folder_a folder_b].include?(location)

                                                     cp

                                                   else

                                                     ''

                                                   end

            new_session.created_at = Time.now

            new_session.updated_at = Time.now

            case location

            when 'folder_a'

              new_session[:selected_folder_a] = cp

            when 'folder_b'

              new_session[:selected_folder_b] = cp

            when 'folder_at'

              new_session[:selected_folder_at] = cp

            when 'folder_bt'

              new_session[:selected_folder_bt] = cp

            when 'folder_atfi'

              new_session[:selected_folder_atfi] = cp

            when 'folder_btfi'

              new_session[:selected_folder_btfi] = cp

            else

              new_session[:selected_folder_a] = cp

            end

            new_session.save

          else # => simply session is not found

            return nil

          end # => end of check session
        rescue ActiveRecord::StaleObjectError
          retry_set_current_director -= 1

          return nil unless retry_set_current_director > 0

          sleep(AR_RETRY_WAIT_MSEC)

          throw :set_current_directory_again
        end # => end of transaction
      end

      cp
    end

    # => end of set_current_directory

    def self.set_current_location(sid, location)
      if location == LOCATION_ANY

        return false # => accept valid location only!

      end

      ss = Spinapp::SpinSession.find_by(spin_session_id: sid)

      return false if ss.blank?

      retry_set_current_location = Vfs::ACTIVE_RECORD_RETRY_COUNT

      catch(:set_current_location_again) do
        Spinapp::SpinSession.transaction do
          ss[:spin_current_location] = location

          ss.save
        rescue ActiveRecord::StaleObjectError
          retry_set_current_location -= 1

          return false unless retry_set_current_location > 0

          sleep(AR_RETRY_WAIT_MSEC)

          throw :set_current_location_again
        end
      end

      true
    end

    def self.set_current_folder_location(sid, location)
      if location == LOCATION_ANY

        return false # => accept valid location only!

      end

      ss = Spinapp::SpinSession.find_by(spin_session_id: sid)

      return false if ss.blank?

      retry_set_current_folder_location = Vfs::ACTIVE_RECORD_RETRY_COUNT

      catch(:set_current_folder_location_again) do
        Spinapp::SpinSession.transaction do
          ss[:spin_current_location] = location

          ss[:cont_location_folder] = location

          ss.save
        rescue ActiveRecord::StaleObjectError
          retry_set_current_folder_location -= 1

          if retry_set_current_folder_location > 0

            sleep(AR_RETRY_WAIT_MSEC)

            throw :set_current_folder_location_again

          end
        end
      end

      true
    end

    def self.get_current_location(sid)
      ss = Spinapp::SpinSession.find_by(spin_session_id: sid)

      return nil if ss.blank?

      ss[:spin_current_location]
    end

    def self.get_current_folder_location(sid)
      ss = Spinapp::SpinSession.find_by(spin_session_id: sid)

      return nil if ss.blank?

      ss[:cont_location_folder]
    end

    # set current directory in db spin_sessions

    def self.set_current_folder(sid, folder_hashkey, location = LOCATION_ANY, domain_hashkey = nil)
      domain_hashkey = SessionManager.get_selected_domain(sid, location) if domain_hashkey.blank?

      retry_set_current_folder = Vfs::ACTIVE_RECORD_RETRY_COUNT

      resh = DatabaseUtility.update_or_create_record(Spinapp::SpinSession,{spin_session_id: sid}, retry_set_current_folder) do |ssrec|
        ssrec[:spin_current_directory] = folder_hashkey
        ssrec[:selected_folder_a] = folder_hashkey
        ssrec[:spin_current_domain] = domain_hashkey
        ssrec[:selected_domain_a] = domain_hashkey
        ssrec[:updated_at] = Time.now
        ssrec[:spin_current_location] = location
        ssrec[:cont_location_folder] = location

      rescue StandardError => e
        S5fLib.print_exception(e,true)
        raise "Update record failed in #{self.class.name}.#{__method__}"
      end
      resh
    end

    # => end of set_current_directory

    # set current directory in db spin_sessions

    def self.set_current_directory_path(sid, vpath, location = LOCATION_ANY)
      path_is_relative = false

      current_path = vpath

      path_is_relative = true if vpath[0, 1] != '/' || vpath[0, 2] == './'

      if path_is_relative

        cd = get_current_directory_path sid, location

        current_path = cd + (vpath[0, 2] == './' ? vpath[1..-1] : ('/' + vpath))

      else

        current_path = vpath

      end

      ss = Spinapp::SpinSession.find_by(spin_session_id: sid)

      if ss.present? # => check session

        cp = VirtualFileSystemUtility.path_to_key current_path

        return nil if Spinapp::SpinAccessControl.accessible_node?(sid, cp, NODE_DIRECTORY) == false

        Spinapp::SpinSession.transaction do
          # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

          ss[:spin_current_directory] = cp

          ss.updated_at = Time.now

          case location

          when 'folder_a'

            ss[:selected_folder_a] = cp

          when 'folder_b'

            ss[:selected_folder_b] = cp

          when 'folder_at'

            ss[:selected_folder_at] = cp

          when 'folder_bt'

            ss[:selected_folder_bt] = cp

          when 'folder_atfi'

            ss[:selected_folder_atfi] = cp

          when 'folder_btfi'

            ss[:selected_folder_btfi] = cp

          else

            ss[:selected_folder_a] = cp

          end

          return '/' unless ss.save

          set_current_folder(sid, cp, 'folder_b')

          return current_path
        end

      elsif sid == ADMIN_SESSION_ID # => no session is found and sid is ADMIN_SESSION_ID. special case!

        cp = VirtualFileSystemUtility.path_to_key current_path

        return nil if Spinapp::SpinAccessControl.accessible_node?(sid, cp, NODE_DIRECTORY) == false

        Spinapp::SpinSession.transaction do
          # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

          new_session = Spinapp::SpinSession.new

          new_session[:spin_session_id] = sid

          new_session[:spin_current_directory] = if %w[folder_a folder_b].include?(location)

                                                   cp

                                                 else

                                                   ''

                                                 end

          new_session.created_at = Time.now

          new_session.updated_at = Time.now

          case location

          when 'folder_a'

            ss[:selected_folder_a] = cp

          when 'folder_b'

            ss[:selected_folder_b] = cp

          when 'folder_at'

            ss[:selected_folder_at] = cp

          when 'folder_bt'

            ss[:selected_folder_bt] = cp

          when 'folder_atfi'

            ss[:selected_folder_atfi] = cp

          when 'folder_btfi'

            ss[:selected_folder_btfi] = cp

          else

            ss[:selected_folder_a] = cp

          end

          return '/' unless ss.save

          set_current_folder(sid, cp, 'folder_b')

          return current_path
        end

      end # => end of check session
    end

    # => end of set_current_directory_path

    # set current directory in db spin_sessions

    def self.set_current_domain(sid, domain_hashkey, location = 'folder_a', _partial_root_node = nil)
      selected_folder = ''

      # get selected folder
      # begin
      #   selected_folder = Spinapp::FolderDatum.find_by(session_id: sid, cont_location: location,domain_hash_key: domain_hashkey,selected: true)
      # rescue ActiveRecord::RecordNotFound
      #   selected_folder = Spinapp::DomainDatum.get_selected_folder_of_domain_data(sid, domain_hashkey, location)
      # rescue StandardError => e
      #   S5fLib.print_exception(e,true)
      #   raise "Failed to set current domain by no selected folder in #{__method__}"
      # end

      # Spinapp::FolderDatum.fill_folders(sid, location, domain_hashkey, partial_root_node) unless cand_folders.count.positive?

      # selected_folder = Spinapp::DomainDatum.get_selected_folder_of_domain_data(sid, domain_hashkey, location)

      # if selected_folder.blank?

      #   selected_folder = Spinapp::FolderDatum.get_first_folder_of_domain(sid, domain_hashkey, location)

      #   # if selected_folder.blank?

      #   #   return domain_hashkey

      #   # end

      # end

      retry_set_current_domain = Vfs::ACTIVE_RECORD_RETRY_COUNT

      begin
        DatabaseUtility.update_records(Spinapp::SpinSession,{spin_session_id: sid}, retry_set_current_domain) do |ses|
          ses[:cont_location_domain] = location
          ses[:spin_current_domain] = domain_hashkey
          ses[:selected_domain_a] = domain_hashkey
          # ses[:selected_folder_a] = selected_folder
        end
      rescue StandardError => e
        S5fLib.print_exception(e,true)
        raise "Failed to set current domain in #{__method__}"
      end
      # catch(:set_current_domain_again) do
      #   Spinapp::SpinSession.transaction do
      #     Spinapp::SpinSession.where(spin_session_id: sid).update_all(
      #       cont_location_domain: location,

      #       spin_current_domain: domain_hashkey,

      #       selected_domain_a: domain_hashkey,

      #       selected_folder_a: selected_folder
      #     )
      #   rescue ActiveRecord::StaleObjectError
      #     return nil unless retry_set_current_domain > 0

      #     retry_set_current_domain -= 1

      #     throw :set_current_domain_again

      #     # end of begin-rescue block
      #   rescue StandardError => e
      #     S5fLib.print_exception(e, true)
      #     raise "Failed to update #{model_class.name} in #{__method__}"
      #   end
      #   # end of transaction
      # end

      domain_hashkey
    end

    # => end of set_current_domain

    def self.get_current_domain(sid, location)
      # get current domain and returns its hash_key

      ss = nil

      Spinapp::SpinSession.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ss = Spinapp::SpinSession.readonly.find_by(spin_session_id: sid)
      end

      return unless ss.present?

      case location

      when 'folder_a', 'folder_at', 'folder_atbi'

        ss[:spin_current_domain]

      when 'folder_b', 'folder_bt', 'folder_btbi'

        ss[:selected_domain_b]

      else

        ss[:spin_current_domain]

      end
    end

    # => end of get_current_domain

    def self.get_default_domain(sid)
      raise "Failed to get default domain in #{self.class.name}.#{__method__}" if sid.blank?

      # get current domain and returns its hash_key

      ur = nil

      ids = SessionManager.get_uid_gid(sid, false)

      return Spinapp::SpinDomain.get_system_default_domain if ids.blank? # => sid may be null

      Spinapp::SpinUser.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        #        u = Spinapp::SpinSession.readonly.find_by_spin_session_id sid

        ur = Spinapp::SpinUser.readonly.find_by(spin_uid: ids[:uid])
      end

      if ur.present?

        ur[:spin_default_domain]

      else

        dds = Spinapp::SpinDomain.search_accessible_domains(sid, ids[:gids])

        dds[0][:hash_key] if dds.length > 0

      end # => end of if ur
    end # => end of get_current_domain
  end

  # => end of class SessionUtility

  class VirtualFileSystemUtility < ActiveRecord::Base
    include Vfs

    include Acl

    include Stat

    def self.open_meta_db_connection
      # conn = nil

      # return PG::Connection.open( :dbname => ApplicationController.get_appl_env("dbname"),

      # :user => ApplicationController.get_appl_env("user"),

      # :spin_password => ApplicationController.get_appl_env("password") )

      case ENV.fetch('RAILS_ENV', nil)

      when 'development'

        #        logger.debug 'development env'

        PG::Connection.new(dbname: 'spin_development', user: 'spinadmin', password: 'postgres')

      when 'test'

        #        logger.debujg 'testr env'

        PG::Connection.new(dbname: 'test', user: 'spinadmin', password: 'postgres')

      when 'production'

        #        logger.debug 'production env'

        PG::Connection.new(dbname: 'spin', user: 'spinadmin', password: 'postgres')

      else

        #        logger.debug 'production env'

        PG::Connection.new(dbname: 'spin', user: 'spinadmin', password: 'postgres')

      end
    end

    def self.close_meta_db_connection(dbcon)
      dbcon.close
    end

    def self.virtual_file_system_query(query_string)
      reta = { status: false, result: nil }

      printf "ssid = %s\n", query_string

      # conn = PG::Connection.open( :dbname => "spin_development", :user => "spinadmin", :spin_password => "postgres")

      conn = open_meta_db_connection

      # do exec query

      reta[:result] = conn.exec(query_string)

      # conn.close

      close_meta_db_connection conn

      # return reta["status"] = nil if result is nil

      # else return status and result in reta

      reta
    end

    def self.virtual_file_system_query2(conn, query_string)
      reta = { status: false, result: nil }

      printf "ssid = %s\n", query_string

      # conn = PG::Connection.open( :dbname => "spin_development", :user => "spinadmin", :spin_password => "postgres")

      # conn = self.open_meta_db_connection

      # do exec query

      reta[:result] = conn.exec(query_string)

      # conn.close

      # self.close_meta_db_connection conn

      # return reta["status"] = nil if result is nil

      # else return status and result in reta

      reta
    end

    def self.existing_directory?(vp, depth, parent_x)
      # use spin_nodes table

      ret_a = []

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ret_a = find_directory_node vp, depth, parent_x, true

        return [-1, -1, -1, -1] if ret_a.blank?
      end

      return [-1, -1, -1, -1] if ret_a == [-1, -1, -1, -1] # not found

      ret_a # => returns [ x, y, prx, v, hashkey ]
    end

    # => end of is_existing_directory

    def self.existing_node?(vp, depth, parent_x, get_latest = true)
      # use spin_nodes table

      ret_a = []

      SpnNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        ret_a = readonly.find_node vp, depth, parent_x, true, get_latest

        return [-1, -1, -1, -1] if ret_a.blank?
      end

      return [-1, -1, -1, -1] if ret_a == [-1, -1, -1, -1] # not found

      ret_a # => returns [ x, y, prx, v, hashkey ]
    end

    # => end of is_existing_directory

    def self.create_virtual_directory_path(sid, location, vdir, _flag_make_path = false, owner_uid = NO_USER, owner_gid = NO_GROUP, acls = nil)
      # create virtual directory path which is specifierd by vdir

      # vdir = /x/y/z/.../dirname

      vpath = vdir

      # status var.

      if vdir[0, 1] != '/' || vdir[0, 2] == './'

        cd = SessionUtility.get_current_directory_path sid, location

        vpath = cd + (vdir[0, 1] == '/' ? vdir[2, -1] : vdir[1, -1])

      end

      path_array = vpath.scan(%r{[^/]+}) # => ex. [ "usr", "local", "spin path" ]

      n = 1

      prx = 0

      vn = NoXYPV

      path_array.each do |dirname|
        printf 'dirname = %s', dirname

        # create directory 'dirname' in the current directory

        vn = create_virtual_directory_node sid, dirname, n, prx, owner_uid, owner_gid, acls

        return NoXYPV if vn[X..V] == NoXYPV # => failed to create directory

        vn[V] *= -1 if vn[V] < 0

        #        end

        # check next

        n += 1

        prx = vn[X]
      end

      # conn.close

      # self.close_meta_db_connection conn

      vn
    end

    def self.create_virtual_directory_node(sid, dirname, depth, prx, owner_uid = NO_USER, owner_gid = NO_GROUP, acls = nil)
      # get new node location

      # is there specified layer ( depth )?

      # create new directory node at the layer if there isn't

      #      new_layer = Spinapp::SpinNodeKeeper.test_and_set_layer_info depth

      request_loc = [REQUEST_COORD_VALUE, depth, prx, REQUEST_VERSION_NUMBER]

      new_dir_loc = nil

      new_dir_loc = Spinapp::SpinNodeKeeper.test_and_set_xy(sid, request_loc, dirname,
                                                            NODE_DIRECTORY) while new_dir_loc.blank?

      return NoXYPV if new_dir_loc[X..V] == NoXYPV

      # create new node

      # new_node = self.create_virtual_node new_layer.last_x, depth, prx, 0, dirname, NODE_DIRECTORY, 0, 0 # => root and root group

      s_ids = SessionManager.get_uid_gid sid

      if new_dir_loc[V] < 0

        new_node = Spinapp::SpinNode.create_spin_node sid, new_dir_loc[X], new_dir_loc[Y], new_dir_loc[PRX], new_dir_loc[V] * -1, dirname, NODE_DIRECTORY, (owner_uid == NO_USER ? s_ids[:uid] : owner_uid), (owner_gid == NO_USER ? s_ids[:gid] : owner_gid), acls # => root and root group

        #        new_node = self.create_virtual_node sid, new_dir_loc[X], new_dir_loc[Y],  new_dir_loc[PRX], new_dir_loc[V], dirname, NODE_DIRECTORY, (owner_uid == NO_USER ? s_ids[:uid] : owner_uid), (owner_gid == NO_USER ? s_ids[:gid] : owner_gid), acls # => root and root group

        # new_node = self.create_virtual_node 0, depth, prx, 0, NODE_DIRECTORY, get_uid, get_gid

        Spinapp::SpinAccessControl.copy_parent_acls sid, new_node, NODE_DIRECTORY # => new_node = [x,y,prx,v,hashkey]

        new_node[X..K]

      elsif new_dir_loc[V] == 1

        new_nd = Spinapp::SpinNode.find_by(spin_tree_type: 0, node_x_coord: new_dir_loc[X], node_y_coord: new_dir_loc[Y],

                                           node_type: NODE_DIRECTORY)

        if new_nd.present?

          new_dir_loc[K] = new_nd[:spin_node_hashkey]

        else

          log_msg = ':create_virtual_directory_node => Spinapp::SpinNode.find returned nil {new_dir_loc[X],new_dir_loc[Y]} = {' + new_dir_loc[X].to_s + ',' + new_dir_loc[Y].to_s + '}'

          FileManager.logger(sid, log_msg, 'LOCAL', LOG_ERROR)

          raise log_msg

        end

        new_dir_loc[V] *= -1

        new_dir_loc

      else

        new_dir_loc[V] *= -1

        new_dir_loc[X..K]

      end
    end

    def self.move_virtual_file(move_sid, move_file_key, target_folder_key, target_cont_location)
      # Does the user have any right to delete or trash file?

      Spinapp::SpinAccessControl.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        acls = Spinapp::SpinAccessControl.acl_values? move_sid, move_file_key

        target_acls = Spinapp::SpinAccessControl.acl_values? move_sid, target_folder_key, NODE_DIRECTORY

        has_right_to_delete = false

        target_has_right_to_delete = false

        acls.each do |_key, value|
          next unless (value && ACL_NODE_WRITE) || (value && ACL_NODE_DELETE) # => has right to delete

          has_right_to_delete = true

          break
        end

        target_acls.each do |_key, value|
          next unless (value && ACL_NODE_WRITE) || (value && ACL_NODE_DELETE) # => has right to delete

          target_has_right_to_delete = true

          break
        end

        # return false unless it has right to delete file

        return false if has_right_to_delete == false || target_has_right_to_delete == false

        # delete or trash file node

        ret = Spinapp::SpinNode.move_node move_sid, move_file_key, target_folder_key, target_cont_location
      end
    end

    # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    def self.move_virtual_files_in_clipboard_org(operation_id, move_sid, source_folder_key, target_folder_key, target_cont_location)
      # Does the user have any right to delete or trash file?

      ret_key = ''

      # Are source and target the same?

      return false if source_folder_key == target_folder_key

      # get vpath of the source folder

      svloc = SpinLocationManager.key_to_location(source_folder_key, NODE_DIRECTORY)

      vps = SpinLocationManager.get_location_vpath(svloc)

      # get vpath of the target folder

      tvloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

      vpt = SpinLocationManager.get_location_vpath(tvloc)

      # get 1 node from clipboard and process it

      # unitl all data that has same opr_id are proccessed

      while true

        # get 1

        get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT

        mvf = get_node_hash[:node_hash_key]

        break if mvf.nil? # => end of proccess

        # Does it have ACL to do move operation?

        has_right_to_delete = Spinapp::SpinAccessControl.writable?(move_sid, mvf, ANY_TYPE)

        #        has_right_to_delete = Spinapp::SpinAccessControl.deletable?(move_sid, mvf, ANY_TYPE)

        return false if has_right_to_delete != true

        # get vpath of the node to be moved

        xvloc = SpinLocationManager.key_to_location(mvf, ANY_TYPE)

        vpx = SpinLocationManager.get_location_vpath(xvloc)

        # vpath mapping!

        vvps = vps

        vvpt = vpt

        FileManager.rails_logger('(vps,vpt) = (' + vps + ',' + vpt + ')')

        fvpx = SpinLocationManager.vpath_mapping_locations(vpx, vvps, vvpt)

        # get location

        fpvpx = SpinLocationManager.vpath_mapping_parent_vpath(fvpx)

        node_type = ANY_TYPE

        if Spinapp::SpinNode.directory?(mvf) == true

          node_type = NODE_DIRECTORY

          # make new vpath

          vfile_name = fvpx.split(%r{/})[-1]

          new_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fvpx, true)

          new_dir_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fpvpx, true)

          if new_location[0..3] != [-1, -1, -1, -1]

            ret_key = if new_location[V] > 0 # => There isn't

                        Spinapp::SpinNode.move_node_location(move_sid, mvf, vfile_name, new_dir_location, false,
                                                             target_cont_location, NODE_DIRECTORY)

                      else # => There already is!

                        Spinapp::SpinNode.move_node_location(move_sid, mvf, vfile_name, new_dir_location, true,
                                                             target_cont_location, NODE_DIRECTORY)

                      end

          end

        else # => file

          node_type = NODE_FILE

          # get location

          new_dir_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fpvpx, true)

          if tvloc != [-1, -1, -1, -1]

            vfile_name = fvpx.split(%r{/})[-1]

            ret_key = Spinapp::SpinNode.move_node_location(move_sid, mvf, vfile_name, new_dir_location, false,
                                                           target_cont_location, NODE_FILE, new_dir_location[K])

          end

          # delete or trash file node

          #          ret = Spinapp::SpinNode.copy_node cpf, target_folder_key, target_cont_location

        end # => end of if Spinapp::SpinNode.directory?(cpf) == true

        break if ret_key.blank?

        Spinapp::ClipBoard.get_set_operation_processed operation_id, move_sid, OPERATION_CUT, mvf

      end # => end of while loop

      if ret_key.blank?

        FileManager.rails_logger 'ret_key is empty'

        while true

          # get 1

          get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT,
                                                      (GET_MARKER_PROCESSED | GET_MARKER_SET)

          mvfrb = get_node_hash[:node_hash_key]

          #          mvfrb = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT, (GET_MARKER_PROCESSED|GET_MARKER_SET)

          break if mvfrb.nil? # => end of proccess

          Spinapp::ClipBoard.get_rollback_operation operation_id, move_sid, OPERATION_CUT, mvfrb

        end # => end of while true do

      else

        FileManager.rails_logger('ret_key is ' + ret_key)

        while true

          # get 1

          get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT, GET_MARKER_PROCESSED

          mvfcmt = get_node_hash[:node_hash_key]

          break if mvfcmt.nil? # => end of proccess

          FileManager.rails_logger('mvfcmt = ' + mvfcmt)

          # get vpath of the node to be moved

          xvloc = SpinLocationManager.key_to_location(mvfcmt, ANY_TYPE)

          vpx = SpinLocationManager.get_location_vpath(xvloc)

          # vpath mapping!

          fvpx = SpinLocationManager.vpath_mapping_locations(vpx, vps, vpt)

          # get location

          fpvpx = SpinLocationManager.vpath_mapping_parent_vpath(fvpx)

          Spinapp::ClipBoard.get_set_operation_completed operation_id, move_sid, OPERATION_CUT, mvfcmt, ret_key

          FileManager.rails_logger('after set_operation_completed = ' + ret_key)

          node_type = ANY_TYPE

          if Spinapp::SpinNode.directory?(mvf) == true

            node_type = NODE_DIRECTORY

            # make new vpath

            vfile_name = fvpx.split(%r{/})[-1]

            new_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fvpx, true)

            new_key = SpinLocationManager.location_to_key(new_location, NODE_DIRECTORY)

            new_dir_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fpvpx, true)

            cont_location = if /folder_a/ =~ target_cont_location

                              'folder_a'

                            elsif /folder_b/ =~ target_cont_location

                              'folder_b'

                            else

                              'folder_a'

                            end

            domain_key = SessionManager.get_selected_domain(move_sid, cont_location)

            Spinapp::FolderDatum.remove_folder_rec(move_sid, cont_location, mvfcmt)

            Spinapp::FolderDatum.load_folder_recs(move_sid, new_dir_location, domain_key, nil, nil, cont_location, DEPTH_TO_TRAVERSE,
                                                  SessionManager.get_last_session(move_sid))

            locations = CONT_LOCATIONS_LIST - [cont_location]

            locations.each do |location|
              Spinapp::FolderDatum.copy_folder_data_from_location_to_location(move_sid, cont_location, location,
                                                                              domain_key)
            end

          else # => file

            node_type = NODE_FILE

            # get location

            new_dir_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fpvpx, true)

            new_key = SpinLocationManager.location_to_key(new_dir_location, NODE_FILE)

            cont_location = if /folder_a/ =~ target_cont_location

                              'folder_a'

                            elsif /folder_b/ =~ target_cont_location

                              'folder_b'

                            else

                              'folder_a'

                            end

            Spinapp::FileDatum.load_file_list_rec(move_sid, cont_location, ret_key, new_key)

            Spinapp::FileDatum.fill_file_list(move_sid, cont_location, new_key)

            # delete or trash file node

            #          ret = Spinapp::SpinNode.copy_node cpf, target_folder_key, target_cont_location

          end # => end of if Spinapp::SpinNode.directory?(cpf) == true

        end # => end of while true do

      end # => end of if ret_key.blank?

      !(ret_key.blank? == true)
    end

    # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    def self.move_virtual_files_in_clipboard(operation_id, move_sid, source_folder_key, target_folder_key, target_cont_location)
      # Does the user have any right to delete or trash file?

      ret_key = ''

      ret_keys = []

      ret_folder_keys = []

      # Are source and target the same?

      return false if source_folder_key == target_folder_key

      # get vpath of the source folder

      svloc = SpinLocationManager.key_to_location(source_folder_key, NODE_DIRECTORY)

      vps = SpinLocationManager.get_location_vpath(svloc)

      # get vpath of the target folder

      tvloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

      vpt = SpinLocationManager.get_location_vpath(tvloc)

      # get 1 node from clipboard and process it

      # unitl all data that has same opr_id are proccessed

      while true

        # get 1

        get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT

        mvf = get_node_hash[:node_hash_key]

        break if mvf.nil? # => end of proccess

        # Does it have ACL to do move operation?

        has_right_to_delete = Spinapp::SpinAccessControl.writable?(move_sid, mvf, ANY_TYPE)

        #        has_right_to_delete = Spinapp::SpinAccessControl.deletable?(move_sid, mvf, ANY_TYPE)

        return false if has_right_to_delete != true

        # get vpath of the node to be moved

        xvloc = SpinLocationManager.key_to_location(mvf, ANY_TYPE)

        vpx = SpinLocationManager.get_location_vpath(xvloc)

        # vpath mapping!

        vvps = vps

        vvpt = vpt

        FileManager.rails_logger('(vps,vpt) = (' + vps + ',' + vpt + ')')

        fvpx = SpinLocationManager.vpath_mapping_locations(vpx, vvps, vvpt)

        # get location

        fpvpx = SpinLocationManager.vpath_mapping_parent_vpath(fvpx)

        if Spinapp::SpinNode.directory?(mvf) == true

          # make new vpath

          vfile_name = fvpx.split(%r{/})[-1]

          new_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fvpx, true)

          new_dir_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fpvpx, true)

          # 追加 移動元親ディレクトリを取得 ↓

          source_node = Spinapp::SpinNode.find_by(spin_node_hashkey: mvf)

          return false if source_node.blank?

          # spin_nodesから親ノードのhash_keyを取得

          source_parent_node = SpinLocationManager.get_parent_node(source_node)

          return false if source_parent_node.blank?

          # 追加 移動元親ディレクトリを取得 ↑

          if new_location[0..3] != [-1, -1, -1, -1]

            ret_key = if new_location[V] > 0 # => There isn't

                        Spinapp::SpinNode.move_node_location(move_sid, mvf, vfile_name, new_dir_location, false,
                                                             target_cont_location, NODE_DIRECTORY)

                      else # => There already is!

                        Spinapp::SpinNode.move_node_location(move_sid, mvf, vfile_name, new_dir_location, true,
                                                             target_cont_location, NODE_DIRECTORY)

                      end

            if ret_key.present?

              domain_key = SessionManager.get_selected_domain(move_sid, target_cont_location)

              Spinapp::FolderDatum.remove_folder_rec(move_sid, target_cont_location, mvf)

              # 追加 移動元親ディレクトリのchildを更新 ↓

              if source_node != source_parent_node

                Spinapp::FolderDatum.remove_child_from_parent(source_node[:spin_node_hashkey],
                                                              source_parent_node[:spin_node_hashkey], move_sid)

              end

              # 追加 移動元親ディレクトリのchildを更新 ↑

              ret_folder_keys.push ret_key

            end

          end

        else # => file

          # get location

          new_dir_location = SpinLocationManager.get_location_coordinates(move_sid, target_cont_location, fpvpx, true)

          if tvloc != [-1, -1, -1, -1]

            vfile_name = fvpx.split(%r{/})[-1]

            ret_key = Spinapp::SpinNode.move_node_location(move_sid, mvf, vfile_name, new_dir_location, false,
                                                           target_cont_location, NODE_FILE, new_dir_location[K])

            puts ret_key

          end

          # delete or trash file node

          #          ret = Spinapp::SpinNode.copy_node cpf, target_folder_key, target_cont_location

        end # => end of if Spinapp::SpinNode.directory?(cpf) == true

        puts 'test'

        break if ret_key.blank?

        ret_keys.push ret_key

        Spinapp::ClipBoard.get_set_operation_processed operation_id, move_sid, OPERATION_CUT, mvf

      end # => end of while loop

      if ret_key.blank?

        FileManager.rails_logger 'ret_key is empty'

        while true

          # get 1

          get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT,
                                                      (GET_MARKER_PROCESSED | GET_MARKER_SET)

          mvfrb = get_node_hash[:node_hash_key]

          break if mvfrb.nil? # => end of proccess

          Spinapp::ClipBoard.get_rollback_operation operation_id, move_sid, OPERATION_CUT, mvfrb

        end # => end of while true do

      else

        idx = 0

        while true

          # get 1

          get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid, OPERATION_CUT,
                                                      (GET_MARKER_PROCESSED | GET_MARKER_SET)

          mvfrb = get_node_hash[:node_hash_key]

          break if mvfrb.nil?

          Spinapp::ClipBoard.get_set_operation_completed operation_id, move_sid, OPERATION_COPY, mvfrb, ret_keys[idx]

          if get_node_hash[:node_type] == NODE_DIRECTORY

            Spinapp::FolderDatum.load_folder_recs(move_sid, ret_keys[idx], domain_key, nil, nil, target_cont_location, DEPTH_TO_TRAVERSE,
                                                  SessionManager.get_last_session(move_sid))

            # 追加 移動先親ディレクトリのchildを更新 ↓

            # spin_nodesから親ノードのhash_keyを取得

            move_node = Spinapp::SpinNode.find_by(spin_node_hashkey: ret_keys[idx])

            return false if move_node.blank?

            move_parent_node = SpinLocationManager.get_parent_node(move_node)

            return false if move_parent_node.blank?

            Spinapp::FolderDatum.add_child_to_parent(ret_keys[idx], move_parent_node[:spin_node_hashkey], move_sid) if move_node != move_parent_node

            # 追加 移動先親ディレクトリのchildを更新 ↑

          end

          idx += 1

        end

      end # => end of if ret_key.blank?

      !(ret_key.blank? == true)
    end

    # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    def self.copy_virtual_files_in_clipboard(operation_id, copy_sid, source_folder_key, target_folder_key, target_cont_location)
      # Does the user have any right to delete or trash file?

      ret_key = ''

      new_location = []

      # Are source and target the same?

      return false if source_folder_key == target_folder_key

      # get vpath of the source folder

      svloc = SpinLocationManager.key_to_location(source_folder_key, NODE_DIRECTORY)

      vps = SpinLocationManager.get_location_vpath(svloc)

      # get vpath of the target folder

      tvloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

      vpt = SpinLocationManager.get_location_vpath(tvloc)

      # get 1 node from clipboard and process it

      # unitl all data that has same opr_id are proccessed

      while true

        # get 1

        get_node_hash = Spinapp::ClipBoard.get_node operation_id, copy_sid, OPERATION_COPY

        cpf = get_node_hash[:node_hash_key]

        break if cpf.nil? # => end of proccess

        # get vpath of the node to be copied

        xvloc = SpinLocationManager.key_to_location(cpf, ANY_TYPE)

        vpx = SpinLocationManager.get_location_vpath(xvloc)

        # vpath mapping!

        vvps = vps

        vvpt = vpt

        fvpx = SpinLocationManager.vpath_mapping_locations(vpx, vvps, vvpt)

        # get location

        fpvpx = SpinLocationManager.vpath_mapping_parent_vpath(fvpx)

        node_type = ANY_TYPE

        if Spinapp::SpinNode.directory?(cpf) == true

          node_type = NODE_DIRECTORY

          # make new vpath

          new_dir_location = SpinLocationManager.get_location_coordinates(copy_sid, target_cont_location, fpvpx, true)

          next unless new_dir_location[0..3] != [-1, -1, -1, -1]

          #            if new_dir_location[V] > 0 # => There isn't

          #              ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, false, target_cont_location, NODE_DIRECTORY)

          #            else # => There already is!

          #              ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, true, target_cont_location, NODE_DIRECTORY)

          #            end

          vfile_name = fvpx.split(%r{/})[-1]

          ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, false,
                                                         target_cont_location, NODE_DIRECTORY)

        else # => file

          node_type = NODE_FILE

          # get location

          new_dir_location = SpinLocationManager.get_location_coordinates(copy_sid, target_cont_location, fpvpx, true)

          if tvloc != [-1, -1, -1, -1]

            vfile_name = fvpx.split(%r{/})[-1]

            ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, false,
                                                           target_cont_location, NODE_FILE, new_dir_location[K])

          end

          # delete or trash file node

          #          ret = Spinapp::SpinNode.copy_node cpf, target_folder_key, target_cont_location

        end # => end of if Spinapp::SpinNode.directory?(cpf) == true

        if ret_key.blank?

          FileManager.rails_logger('>> copy_virtual_file_in_clipboard : failed to copy ' + vfile_name + '(' + cpf + ')')

          #          return false

        else

          Spinapp::ClipBoard.get_set_operation_completed operation_id, copy_sid, OPERATION_COPY, cpf, ret_key

          if node_type == NODE_DIRECTORY

            new_key = ret_key

            cont_location = if /folder_a/ =~ target_cont_location

                              'folder_a'

                            elsif /folder_b/ =~ target_cont_location

                              'folder_b'

                            else

                              'folder_a'

                            end

            domain_key = SessionManager.get_selected_domain(copy_sid, cont_location)

            #            Spinapp::FolderDatum.recopy_folder_rec(copy_sid, cont_location, cpf)

            if get_node_hash[:node_type] == NODE_DIRECTORY

              Spinapp::FolderDatum.load_folder_recs(copy_sid, new_key, domain_key, nil, nil, cont_location, DEPTH_TO_TRAVERSE,
                                                    SessionManager.get_last_session(copy_sid))

              # 追加 コピー先親ディレクトリのchildを更新 ↓

              # spin_nodesから親ノードのhash_keyを取得

              new_node = Spinapp::SpinNode.find_by(spin_node_hashkey: new_key)

              return false if new_node.blank?

              parent_node = nil

              if new_node.present?

                parent_node = SpinLocationManager.get_parent_node(new_node)

                return false if parent_node.blank?

                Spinapp::FolderDatum.add_child_to_parent(new_key, parent_node[:spin_node_hashkey], copy_sid) if new_node != parent_node

              end

              # 追加 コピー先親ディレクトリのchildを更新 ↑

            end

            #            locations = CONT_LOCATIONS_LIST - [ cont_location ]

            #            locations.each {|location|

            #              Spinapp::FolderDatum.copy_folder_data_from_location_to_location(copy_sid, cont_location, location, domain_key)

            #            }

          else

            new_key = SpinLocationManager.location_to_key(new_location, NODE_FILE)

            cont_location = if /folder_a/ =~ target_cont_location

                              'folder_a'

                            elsif /folder_b/ =~ target_cont_location

                              'folder_b'

                            else

                              'folder_a'

                            end

            Spinapp::FileDatum.load_file_list_rec(copy_sid, cont_location, ret_key, new_key)

            Spinapp::FileDatum.fill_file_list(copy_sid, cont_location, new_key)

          end

        end

      end # => end of while loop

      pp 'ret_key is empty' if ret_key.blank?

      !(ret_key.blank? == true)
    end

    # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    def self.symbolic_link_virtual_files_in_clipboard(operation_id, copy_sid, source_folder_key, target_folder_key, target_cont_location)
      # Does the user have any right to delete or trash file?

      ret_key = ''

      new_location = []

      # Are source and target the same?

      return false if source_folder_key == target_folder_key

      # get vpath of the source folder

      svloc = SpinLocationManager.key_to_location(source_folder_key, NODE_DIRECTORY)

      vps = SpinLocationManager.get_location_vpath(svloc)

      # get vpath of the target folder

      tvloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

      vpt = SpinLocationManager.get_location_vpath(tvloc)

      # get 1 node from clipboard and process it

      # unitl all data that has same opr_id are proccessed

      while true

        # get 1

        get_node_hash = Spinapp::ClipBoard.get_node operation_id, copy_sid, OPERATION_COPY

        cpf = get_node_hash[:node_hash_key]

        break if cpf.nil? # => end of proccess

        # get vpath of the node to be copied

        xvloc = SpinLocationManager.key_to_location(cpf, ANY_TYPE)

        vpx = SpinLocationManager.get_location_vpath(xvloc)

        # vpath mapping!

        vvps = vps

        vvpt = vpt

        fvpx = SpinLocationManager.vpath_mapping_locations(vpx, vvps, vvpt)

        # get location

        fpvpx = SpinLocationManager.vpath_mapping_parent_vpath(fvpx)

        node_type = ANY_TYPE

        if Spinapp::SpinNode.directory?(cpf) == true

          node_type = NODE_DIRECTORY

          # make new vpath

          vfile_name = fvpx.split(%r{/})[-1]

          new_location = SpinLocationManager.get_location_coordinates(copy_sid, target_cont_location, fvpx, true)

          new_dir_location = SpinLocationManager.get_location_coordinates(copy_sid, target_cont_location, fpvpx, true)

          if new_location[0..3] != [-1, -1, -1, -1]

            return false unless new_location[V] > 0 # => There isn't

            ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, false,
                                                           target_cont_location, NODE_DIRECTORY)

            # => There already is!

            #              ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, true, target_cont_location, NODE_DIRECTORY)

          end

        elsif new_location[V] > 0 # => file

          node_type = NODE_FILE

          # get location

          new_dir_location = SpinLocationManager.get_location_coordinates(copy_sid, target_cont_location, fpvpx, true)

          if tvloc != [-1, -1, -1, -1]

            vfile_name = fvpx.split(%r{/})[-1]

            ret_key = Spinapp::SpinNode.copy_node_location(copy_sid, cpf, vfile_name, new_dir_location, false,
                                                           target_cont_location, NODE_FILE, new_dir_location[K])

          end # => There isn't

        # delete or trash file node

        #          ret = Spinapp::SpinNode.copy_node cpf, target_folder_key, target_cont_location

        else

          return false

        end # => end of if Spinapp::SpinNode.directory?(cpf) == true

        if ret_key.blank?

          FileManager.rails_logger('>> copy_virtual_file_in_clipboard : failed to copy ' + vfile_name + '(' + cpf + ')')

          #          return false

        else

          Spinapp::ClipBoard.get_set_operation_completed operation_id, copy_sid, OPERATION_COPY, cpf, ret_key

          if node_type == NODE_DIRECTORY

            new_key = ret_key

            cont_location = if /folder_a/ =~ target_cont_location

                              'folder_a'

                            elsif /folder_b/ =~ target_cont_location

                              'folder_b'

                            else

                              'folder_a'

                            end

            domain_key = SessionManager.get_selected_domain(copy_sid, cont_location)

            #            Spinapp::FolderDatum.recopy_folder_rec(copy_sid, cont_location, cpf)

            if get_node_hash[:node_type] == NODE_DIRECTORY

              Spinapp::FolderDatum.load_folder_recs(copy_sid, new_key, domain_key, nil, nil, cont_location, DEPTH_TO_TRAVERSE,
                                                    SessionManager.get_last_session(copy_sid))

            end

            #            locations = CONT_LOCATIONS_LIST - [ cont_location ]

            #            locations.each {|location|

            #              Spinapp::FolderDatum.copy_folder_data_from_location_to_location(copy_sid, cont_location, location, domain_key)

            #            }

          else

            new_key = SpinLocationManager.location_to_key(new_location, NODE_FILE)

            cont_location = if /folder_a/ =~ target_cont_location

                              'folder_a'

                            elsif /folder_b/ =~ target_cont_location

                              'folder_b'

                            else

                              'folder_a'

                            end

            Spinapp::FileDatum.load_file_list_rec(copy_sid, cont_location, ret_key, new_key)

            Spinapp::FileDatum.fill_file_list(copy_sid, cont_location, new_key)

          end

        end

      end # => end of while loop

      pp 'ret_key is empty' if ret_key.blank?

      !(ret_key.blank? == true)
    end

    # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    def self.move_virtual_files(operation_id, move_sid, move_file_keys, target_folder_key, target_cont_location)
      # Does the user have any right to delete or trash file?

      ret_key = ''

      # get location of the target folder

      # get 1 node from clipboard and process it

      # unitl all data that has same opr_id are proccessed

      while true

        # get 1

        get_node_hash = Spinapp::ClipBoard.get_node operation_id, move_sid

        mvf = get_node_hash[:node_hash_key]

        break if mvf.nil? # => end of proccess

        # Does it have ACL to do move operation?

        acls = Spinapp::SpinAccessControl.acl_values? move_sid, mvf, ANY_TYPE

        target_acls = Spinapp::SpinAccessControl.acl_values? move_sid, target_folder_key, NODE_DIRECTORY

        has_right_to_delete = false

        target_has_right_to_delete = false

        acls.values.each do |av|
          next unless (av && ACL_NODE_WRITE) || (av && ACL_NODE_DELETE) # => has right to delete

          has_right_to_delete = true

          break # => break from 'each' iterator
        end

        target_acls.values.each do |tav|
          next unless (tav && ACL_NODE_WRITE) || (tav && ACL_NODE_DELETE) # => has right to delete

          target_has_right_to_delete = true

          break # => break from 'each' iterator
        end

        if has_right_to_delete == false || target_has_right_to_delete == false

          next # => skip this and get next

        end

        # get location of the current target

        tloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

        if Spinapp::SpinNode.directory?(mvf) == true

          # get location

          my_loc = SpinLocationManager.key_to_location(mvf, NODE_DIRECTORY)

          my_move_file_keys = Spinapp::ClipBoard.get_keys_in_folder_loc move_sid, my_loc

          vfile_name = Spinapp::SpinNode.get_node_name mvf

          my_loc[X] = REQUEST_COORD_VALUE

          my_loc[Y] = tloc[Y] + 1

          my_loc[PRX] = tloc[X]

          #          my_loc[V] = REQUEST_VERSION_NUMBER

          new_location = nil

          new_location = Spinapp::SpinNodeKeeper.test_and_set_xy(move_sid, my_loc, vfile_name, NODE_DIRECTORY) while new_location.blank?

          ret_key = Spinapp::SpinNode.move_node_location(move_sid, mvf, new_location, target_cont_location,
                                                         NODE_DIRECTORY)

          ret_key = move_virtual_files move_sid, my_move_file_keys, mvf, target_cont_location if my_move_file_keys.length > 0

        else # => file

          # get location

          my_loc = SpinLocationManager.key_to_location(mvf, NODE_FILE)

          vfile_name = Spinapp::SpinNode.get_node_name mvf

          my_loc[X] = ANY_VALUE

          my_loc[Y] = tloc[Y] + 1

          my_loc[PRX] = tloc[X]

          #          my_loc[V] = REQUEST_VERSION_NUMBER

          new_location = nil

          new_location = Spinapp::SpinNodeKeeper.test_and_set_xy(move_sid, my_loc, vfile_name, NODE_FILE) while new_location.blank?

          new_location[V] *= -1 if new_location[V] < 0

          ret_key = Spinapp::SpinNode.move_node_location(move_sid, mvf, new_location, target_cont_location, NODE_FILE)

          # delete or trash file node

          #          ret = Spinapp::SpinNode.move_node mvf, target_folder_key, target_cont_location

        end

      end

      current_move_file_keys = []

      tloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

      current_move_file_keys = if move_file_keys.nil?

                                 Spinapp::ClipBoard.get_keys_in_folder_loc move_sid, tloc

                               else

                                 move_file_keys

                               end

      current_move_file_keys.each do |mvf|
        acls = Spinapp::SpinAccessControl.acl_values? move_sid, mvf, ANY_TYPE

        target_acls = Spinapp::SpinAccessControl.acl_values? move_sid, target_folder_key, NODE_DIRECTORY

        has_right_to_delete = false

        target_has_right_to_delete = false

        acls.values.each do |av|
          next unless (av && ACL_NODE_WRITE) || (av && ACL_NODE_DELETE) # => has right to delete

          has_right_to_delete = true

          break
        end

        target_acls.values.each do |tav|
          next unless (tav && ACL_NODE_WRITE) || (tav && ACL_NODE_DELETE) # => has right to delete

          target_has_right_to_delete = true

          break
        end

        # return false unless it has right to delete file

        return ret_key if has_right_to_delete == false || target_has_right_to_delete == false

        if Spinapp::SpinNode.directory?(mvf) == true

          # get location

          my_loc = SpinLocationManager.key_to_location(mvf, NODE_DIRECTORY)

          my_move_file_keys = Spinapp::ClipBoard.get_keys_in_folder_loc move_sid, my_loc

          vfile_name = Spinapp::SpinNode.get_node_name mvf

          my_loc[X] = REQUEST_COORD_VALUE

          my_loc[Y] = tloc[Y] + 1

          my_loc[PRX] = tloc[X]

          new_location = nil

          new_location = Spinapp::SpinNodeKeeper.test_and_set_xy(move_sid, my_loc, vfile_name, NODE_DIRECTORY) while new_location.blank?

          ret = Spinapp::SpinNode.move_node_location(move_sid, mvf, new_location, target_cont_location, NODE_DIRECTORY)

          ret_key = move_virtual_files move_sid, my_move_file_keys, mvf, target_cont_location if my_move_file_keys.length > 0

        else

          # get location

          my_loc = SpinLocationManager.key_to_location(mvf, NODE_FILE)

          vfile_name = Spinapp::SpinNode.get_node_name mvf

          my_loc[X] = ANY_VALUE

          my_loc[Y] = tloc[Y] + 1

          my_loc[PRX] = tloc[X]

          new_location = nil

          new_location = Spinapp::SpinNodeKeeper.test_and_set_xy(move_sid, my_loc, vfile_name, NODE_FILE) while new_location.blank?

          new_location[V] *= -1 if new_location[V] < 0

          ret = Spinapp::SpinNode.move_node_location(move_sid, mvf, new_location, target_cont_location, NODE_FILE)

          # delete or trash file node

          #          ret = Spinapp::SpinNode.move_node mvf, target_folder_key, target_cont_location

        end

        break if ret_key.blank?

        Spinapp::ClipBoard.get_set_operation_completed operation_id, move_sid, OPERATION_CUT, mvf, ret_key
      end

      # tidy up!

      ret_key
    end

    # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    #    def self.copy_virtual_files copy_sid, copy_file_keys, target_folder_key, target_cont_location

    #      # Does the user have any right to delete or trash file?

    #      ret = false

    #      ret_key = ''

    #      # get location of the target folder

    #      current_copy_file_keys = []

    #      tloc = SpinLocationManager.key_to_location(target_folder_key, NODE_DIRECTORY)

    #      if copy_file_keys == nil

    #        current_copy_file_keys = Spinapp::ClipBoard.get_keys_in_folder_loc copy_sid, tloc

    #      else

    #        current_copy_file_keys = copy_file_keys

    #      end

    #      current_copy_file_keys.each {|mvf|

    #        acls = Spinapp::SpinAccessControl.has_acl_values copy_sid, mvf, ANY_TYPE

    #        target_acls = Spinapp::SpinAccessControl.has_acl_values copy_sid, target_folder_key, NODE_DIRECTORY

    #        has_right_to_delete = false

    #        target_has_right_to_delete = false

    #        acls.values.each {|av|

    #          if av && ACL_NODE_WRITE or av && ACL_NODE_DELETE # => has right to delete

    #            has_right_to_delete = true

    #            break

    #          end

    #        }

    #        target_acls.values.each {|tav|

    #          if tav && ACL_NODE_WRITE or tav && ACL_NODE_DELETE # => has right to delete

    #            target_has_right_to_delete = true

    #            break

    #          end

    #        }

    #        # return false unless it has right to delete file

    #        if has_right_to_delete == false or target_has_right_to_delete == false

    #          return false

    #        end

    #        ret = false

    #        if Spinapp::SpinNode.directory?(mvf) == true

    #          # get location

    #          my_loc = SpinLocationManager.key_to_location(mvf, NODE_DIRECTORY)

    #          my_copy_file_keys = Spinapp::ClipBoard.get_keys_in_folder_loc copy_sid, my_loc

    #          vfile_name = Spinapp::SpinNode.get_node_name mvf

    #          my_loc[X] = ANY_VALUE

    #          my_loc[Y] = tloc[Y] + 1

    #          my_loc[PRX] = tloc[X]

    #          new_location = Spinapp::SpinNodeKeeper.test_and_set_xy(copy_sid, my_loc, vfile_name, NODE_DIRECTORY)

    #          if new_location != [ -1, -1, -1, -1 ]

    #            ret = Spinapp::SpinNode.copy_node_location(copy_sid, mvf, tloc, new_location, (new_location[V] > 0 ? false : true), target_cont_location, NODE_DIRECTORY)

    #          end

    #          if my_copy_file_keys.length > 0

    #            ret_key = self.copy_virtual_files copy_sid, my_copy_file_keys, mvf, target_cont_location

    #          else

    #            ret = true

    #          end

    #        else

    #          # get location

    #          my_loc = SpinLocationManager.key_to_location(mvf, NODE_FILE)

    #          vfile_name = Spinapp::SpinNode.get_node_name mvf

    #          my_loc[X] = ANY_VALUE

    #          my_loc[Y] = tloc[Y] + 1

    #          my_loc[PRX] = tloc[X]

    #          new_location = Spinapp::SpinNodeKeeper.test_and_set_xy(copy_sid, my_loc, vfile_name, NODE_FILE)

    #          ret = Spinapp::SpinNode.copy_node_location(copy_sid, mvf, tloc, new_location, false, target_cont_location, NODE_FILE)

    #          # delete or trash file node

    #          #          ret = Spinapp::SpinNode.copy_node mvf, target_folder_key, target_cont_location

    #        end

    #        unless ret_key.emtpty?

    #          Spinapp::ClipBoard.get_set_operation_completed operation_id, copy_sid, OPERATIONS_COPY, mvf, ret_key

    #        else

    #          ret = false

    #          break

    #        end

    #      }

    #      # tidy up!

    #      if ret == true

    #      end

    #      return ret

    #    end # => end of delete_virtual_file delete_sid, delete_file_key, true # => the last argument is trash_it flag

    def self.change_virtual_file_properties(sid, hash_key, properties)
      if Spinapp::SpinAccessControl.writable?(sid, hash_key, ANY_TYPE)

        retb = false

        node_attributes = {}

        target_node = Spinapp::SpinNode.find_by(spin_node_hashkey: hash_key)

        return false if target_node.blank?

        vloc = []

        px = vloc[X] = target_node[:node_x_coord]

        py = vloc[Y] = target_node[:node_y_coord]

        vloc[PRX] = target_node[:node_x_pr_coord]

        vloc[V] = target_node[:node_version]

        ploc = Spinapp::SpinNode.get_parent_location(vloc)

        same_name_files = Spinapp::SpinNode.where([

                                                    'spin_tree_type = 0 AND node_x_pr_coord = ? AND node_x_coord <> ? AND node_y_coord = ? AND node_name = ? AND is_void = false', ploc[X], px, py, properties[:file_name]

                                                  ])

        return false if same_name_files.present?

        if /{.+}/ =~ target_node[:node_attributes] # => json text

          node_attributes = JSON.parse target_node[:node_attributes]

        end # => end of if /{.+}/ =~ target_node[:node_attributes] # => json text

        Spinapp::SpinNode.transaction do
          # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

          if properties[:file_name].present?

            target_node[:node_name] = properties[:file_name]

            vp = target_node[:virtual_path]

            fnindex = vp.rindex('/')

            newvp = vp[0..fnindex] + properties[:file_name]

            target_node[:virtual_path] = newvp

            subq = "virtual_path LIKE '#{vp}/%'"

            subnodes = Spinapp::SpinNode.where("#{subq}")

            spos = vp.length

            subnodes.each do |sn|
              vptmp = sn[:virtual_path]

              sn[:virtual_path] = newvp + vptmp[spos..-1]

              sn.save
            end

          end

          if properties[:description].present?

            target_node[:node_description] = properties[:description]

            node_attributes[:description] = properties[:description]

          end

          node_attributes[:title] = properties[:title] if properties[:title].present?

          node_attributes[:subtitle] = properties[:subtitle] if properties[:subtitle].present?

          if properties[:keyword].present?

            node_attributes[:keyword] = properties[:keyword]

            target_node[:node_attributes] = node_attributes.to_json if node_attributes != {}

          end

          #          Spinapp::SpinNode.has_updated(sid, hash_key)

          #          ctime = Time.now

          #          target_node[:spin_updated_at] = ctime

          #          target_node[:ctime] = ctime

          if target_node.save

            Spinapp::SpinNodeKeeper.modify_node_keeper_node_name(px, py, properties[:file_name])

            Spinapp::SpinNode.has_updated(sid, hash_key)

            retb = true

            if target_node[:node_type] == NODE_DIRECTORY

              pn = SpinLocationManager.get_parent_node(target_node)

              parent_node = pn[:spin_node_hashkey]

              #              parent_node = SpinLocationManager.get_parent_key(hash_key, NODE_FILE)

              Spinapp::FolderDatum.has_updated(sid, parent_node, UPDATE_PROPERTY, true)

            end

          else

            retb = false

          end
        end # => end of transaction

        retb

      else

        false

      end
    end

    # => end of change_virtual_file_properties

    def self.change_virtual_file_extension(sid, hash_key, properties)
      if Spinapp::SpinAccessControl.writable?(sid, hash_key, ANY_TYPE)

        retb = false

        # target_node = Spinapp::SpinNode.find_by_spin_node_hashkey hash_key

        node_attributes = {}

        target_node = Spinapp::SpinNode.find_by(spin_node_hashkey: hash_key)

        return false if target_node.blank?

        if /{.+}/ =~ target_node[:node_attributes] # => json text

          target_node_node_attributes = target_node[:node_attributes]

          node_attributes = JSON.parse(target_node_node_attributes)

          # node_attributes = JSON.parse target_node[:node_attributes]

        end # => end of node_attributesif /{.+}/ =~ target_node[:node_attributes] # => json text

        Spinapp::SpinNode.transaction do
          # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

          #          properties.each {|key,value|

          #            node_attributes[key] = value

          #          }

          # cast = properties[:cast]

          node_attributes['cast'] = properties['cast']

          node_attributes['client'] = properties['client']

          node_attributes['copyright'] = properties['copyright']

          node_attributes['duration'] = properties['duration']

          node_attributes['location'] = properties['location']

          node_attributes['music'] = properties['music']

          node_attributes['producer'] = properties['producer']

          node_attributes['produced_date'] = properties['produced_date']

          if node_attributes != {}

            target_node[:node_attributes] = node_attributes.to_json

            target_node[:memo1] = properties['duration'] # Add memo By Imai 2015/1/14

            target_node[:memo2] = properties['producer'] # Add memo By Imai 2015/1/14

            target_node[:memo3] = properties['produced_date'] # Add memo By Imai 2015/1/14

            target_node[:memo4] = properties['location'] # Add memo By Imai 2015/1/14

            target_node[:memo5] = properties['cast'] # Add memo By Imai 2015/1/14

          end

          # ADD IMAI at 2015/12/26

          ctime = Time.now

          target_node[:spin_updated_at] = ctime

          retb = if target_node.save

                   true

                 #            parent_node = SpinLocationManager.get_parent_key(target_node, NODE_FILE)

                 #            Spinapp::FolderDatum.has_updated(sid, parent_node, UPDATE_PROPERTY, true)

                 else

                   false

                 end
        end # => end of transaction

        retb

      else

        false

      end
    end

    # => end of change_virtual_file_properties

    def self.change_virtual_file_details(sid, hash_key, properties)
      if Spinapp::SpinAccessControl.writable?(sid, hash_key, ANY_TYPE)

        retb = false

        target_node = Spinapp::SpinNode.find_by(spin_node_hashkey: hash_key)

        return false if target_node.blank?

        Spinapp::SpinNode.transaction do
          # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

          target_node[:details] = properties[:details]

          target_node[:details] = properties[:details]

          target_node[:details] = properties[:details]

          target_node[:details] = properties[:details]

          target_node[:details] = properties[:details]

          # ADD IMAI at 2015/12/26

          ctime = Time.now

          target_node[:spin_updated_at] = ctime

          retb = if target_node.save

                   true

                 else

                   false

                 end
        end # => end of transaction

        #        parent_node = SpinLocationManager.get_parent_key(hash_key, NODE_FILE)

        #        Spinapp::FolderDatum.has_updated(sid, parent_node, UPDATE_PROPERTY, true)

        retb

      else

        false

      end
    end

    # => end of change_virtual_file_properties

    def self.change_virtual_file_name(sid, _location, hash_key, new_name)
      raise "Failed to change virtual file name, no access right in #{__method__}" unless Spinapp::SpinAccessControl.writable?(sid, hash_key, ANY_TYPE)

      begin
        n = Spinapp::SpinNode.find_by!(spin_node_hashkey: hash_key)
      rescue ActiveRecord::RecordNotFound => e
        S5fLib.print_exception(e, true)
        raise "Failed to change virtual file name in#{__method__}"
      end

      vloc = []
      px = vloc[X] = n[:node_x_coord]
      py = vloc[Y] = n[:node_y_coord]
      vloc[PRX] = n[:node_x_pr_coord]
      vloc[V] = n[:node_version]
      ploc = Spinapp::SpinNode.get_parent_location(vloc)

      retry_change_virtual_file_name = Vfs::ACTIVE_RECORD_RETRY_COUNT

      n[:node_name] = new_name
      vp = n[:virtual_path]
      fnindex = vp.rindex('/')
      newvp = vp[0..fnindex] + new_name
      n[:virtual_path] = newvp
      #          ctime = Time.now
      #          n[:spin_updated_at] = ctime
      #          n[:ctime] = ctime
      recs = Spinapp::SpinNode.where(['spin_node_hashkey = ?', hash_key]).update_all(node_name: new_name,

                                                                                     virtual_path: newvp)
      return false unless recs == 1

      subq = "virtual_path LIKE '#{vp}/%'"
      subnodes = Spinapp::SpinNode.where("#{subq}")
      spos = vp.length
      subnodes.each do |sn|
        vptmp = sn[:virtual_path]
        sn[:virtual_path] = newvp + vptmp[spos..-1]
        recs = Spinapp::SpinNode.where(['spin_node_hashkey = ?',
                                        hash_key]).update_all(virtual_path: newvp + vptmp[spos..-1])
        return false if recs != 1
      end
      Spinapp::SpinNodeKeeper.modify_node_keeper_node_name(px, py, new_name)
      Spinapp::SpinNode.has_updated(sid, hash_key)
      frecs = Spinapp::FolderDatum.where(['session_id = ? AND spin_node_hashkey = ?', sid, hash_key]).update_all(
        text: new_name, folder_name: new_name
      )
      return false if frecs != 1

      flrecs = Spinapp::FileDatum.where(['session_id = ? AND spin_node_hashkey = ?', sid,
                                         hash_key]).update_all(file_name: new_name)
      return false if flrecs != 1

      parent_node = SpinLocationManager.get_parent_key(hash_key, NODE_FILE)
      Spinapp::FolderDatum.has_updated(sid, parent_node, UPDATE_PROPERTY, true)
    rescue ActiveRecord::StaleObjectError
      return false unless retry_change_virtual_file_name > 0

      retry_change_virtual_file_name -= 1
      throw :change_virtual_file_name_again
    end
    # end of change_virtual_file_name

    # => self.change_virtual_file_name sid, location, hash_key, new_name, is_in_list = false

    def self.change_virtual_domain_name(sid, hash_key, new_name)
      # => find spin domain

      spin_domain_rec = nil

      retry_count = Vfs::ACTIVE_RECORD_RETRY_COUNT

      catch(:change_virtual_domain_name_again) do
        Spinapp::SpinDomain.transaction do
          spin_domain_rec = Spinapp::SpinDomain.find_by(hash_key:)

          return false unless spin_domain_rec.present?

          return false unless Spinapp::SpinAccessControl.writable?(sid, spin_domain_rec[:domain_root_node_hashkey], NODE_DOMAIN)

          # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

          #          n = Spinapp::SpinDomain.find_by_hash_key hash_key

          spin_domain_rec[:spin_domain_disp_name] = new_name

          return false unless spin_domain_rec.save

          #            SessionManager.set_location_dirty(sid, location, is_in_list)

          Spinapp::SpinDomain.set_domain_has_updated(hash_key)

          return true
        rescue ActiveRecord::StaleObjectError
          retry_count -= 1

          return false unless retry_count > 0

          sleep(AR_RETRY_WAIT_MSEC)

          throw :change_virtual_domain_name_again
        end # => end of transaction
      end
    end

    # => end of self.change_virtual_domain_name sid, location, hash_key, new_name, is_in_list = false

    #    # Should be called in a transaction!

    #    def Spinapp::SpinNode.get_access_rights uid, gid, x, y

    #      # get node(x,y)

    #      if x < 0

    #        x = 0

    #      end

    #      if y < 0

    #        y = 0

    #      end

    #      acl = Hash.new

    #      n = Spinapp::SpinNode.readonly.find_by_node_x_coord_and_node_y_coord x, y

    #      if n

    #        acl[:spin_uid_access_right] = ( n[:spin_uid] == uid ? n[:spin_uid_access_right] : ACL_NODE_NO_ACCESS )

    #        acl[:spin_gid_access_right] = ( n[:spin_gid] == gid ? n[:spin_gid_access_right] : ACL_NODE_NO_ACCESS )

    #        acl[:spin_world_access_right] = n[:spin_world_access_right]

    #      else

    #        return nil

    #      end

    #      # pp "n = ",n

    #      # retreive access rights fr4om spinapp_spin_access_controls

    #      u_acls = Spinapp::SpinAccessControl.readonly.where :managed_node_hashkey => n[:spin_node_hashkey], :spin_uid => uid

    #      g_acls = Spinapp::SpinAccessControl.readonly.where :managed_node_hashkey => n[:spin_node_hashkey], :spin_gid => gid

    #      if u_acls.length > 0

    #        u_acls.each {|ua|

    #          acl[:spin_uid_access_right] |= ua[:spin_uid_access_right]

    #        }

    #      end

    #      if g_acls.length > 0

    #        g_acls.each {|ga|

    #          acl[:spin_gid_access_right] |= ga[:spin_gid_access_right]

    #        }

    #      end

    #      # return access rights

    #      return acl

    #    end

    #    # Sould be called in a transaction!

    #    def self.get_spin_vfs_id x, y

    #      # get node(x,y)

    #      n = nil

    #      if x < 0

    #        x = 0

    #      end

    #      if y < 0

    #        y = 0

    #      end

    #      acl = Hash.new

    #      n = Spinapp::SpinNode.readonly.find(["node_x_coord = ? AND node_y_coord = ?", x, y]).order("node_version DESC")

    #      # pp "n = ",n

    #      # return access rights

    #      return n[:spin_vfs_id]

    #    end

    #    # Sould be called in a transaction!

    #    def self.get_spin_storage_id x, y

    #      # get node(x,y)

    #      n = nil

    #      if x < 0

    #        x = 0

    #      end

    #      if y < 0

    #        y = 0

    #      end

    #      acl = Hash.new

    #      #      n = Spinapp::SpinNode.readonly.find_by_node_x_coord_and_node_y_coord x, y

    #      n = Spinapp::SpinNode.readonly.find(["node_x_coord = ? AND node_y_coord = ?", x, y]).order("node_version DESC")

    #      # pp "n = ",n

    #      # return access rights

    #      return n[:spin_storage_id]

    #    end

    #    # Sould be called in a transaction!

    #    def self.get_spin_node_tree x, y

    #      # get node(x,y)

    #      n = nil

    #      if x < 0

    #        x = 0

    #      end

    #      if y < 0

    #        y = 0

    #      end

    #      n = Spinapp::SpinNode.readonly.find(["node_x_coord = ? AND node_y_coord = ?", x, y]).order("node_version DESC")

    #      #      n = Spinapp::SpinNode.readonly.find_by_node_x_coord_and_node_y_coord x, y

    #      # pp "n = ",n

    #      # return access rights

    #      return n[:spin_node_tree]

    #    end

    #    # Sould be called in a transaction!

    #    def self.get_max_versions x, y

    #      # get node(x,y)

    #      n = nil

    #      if x < 0

    #        x = 0

    #      end

    #      if y < 0

    #        y = 0

    #      end

    #      n = Spinapp::SpinNode.readonly.find(["node_x_coord = ? AND node_y_coord = ? ORDER BY node_version DESC LIMIT 1;", x, y])

    #      #      n = Spinapp::SpinNode.readonly.find_by_node_x_coord_and_node_y_coord x, y

    #      # pp "n = ",n

    #      # return access rights

    #      return n[:max_versions]

    #    end

    #    def self.create_folder_at sid, folder_hash_key, virtual_folder_name

    #      # analyze virtual_path path

    #      virtual_path = virtual_folder_name

    #      # => ex. /clients/a_coorporation/orginization/.../

    #      vloc = [ 0, 0, 0, 0 ]  # => means ROOT

    #      not_exists = [-1,-1,-1,-1,nil]

    #      loc = [ -1, -1, -1, -1 ]

    #      # search directory path which has the folder_hash_key

    #      self.transaction do

    #        cloc_obj = Spinapp::SpinNode.readonly.find_by_spin_node_hashkey(folder_hash_key)

    #        if cloc_obj == nil

    #          return not_exists

    #        end

    #        cloc = cloc_obj.select("node_x_coord,node_y_coord,node_x_pr_coord,node_version")

    #        # get virtual path which is at the loc[x,y,prx,v]

    #        loc[X] = cloc[:node_x_coord]

    #        loc[Y] = cloc[:node_y_coord]

    #        loc[PRX] = cloc[:node_x_pr_coord]

    #        loc[V] = cloc[:node_version]

    #      end

    #      cpath = SpinLocationManager.get_location_vpath loc

    #      # Is it a relative path?

    #      if virtual_path[0,2] == "./" # => relative path

    #        # resolve it and make absolute path

    #        cpath << virtual_path[1..-1]    # => from '/' to the end of string

    #      elsif virtual_path[0,1] != "/" # => relative path

    #        # resolve it and make absolute path

    #        cpath << virtual_path        # => from '/' to the end of string

    #      else

    #        cpath << '/' << virtual_path

    #      end

    #      virtual_path = cpath

    #      # ret_path = DatabaseUtility::SessionUtility.set_current_directory ADMIN_SESSION_ID, cpath

    #      vloc = self.create_virtual_directory_path sid, virtual_path, true

    #      if vloc[X..V] == [ -1, -1, -1, -1 ] # => error!

    #        return [ -1, -1, -1, -1 ]

    #      end

    #      return vloc

    #    end   # => end of create_folder_at

    def self.create_virtual_file_dbu(sid, vfile_name, dir_key, acls = nil, is_under_maintenance = true, set_pending = false)
      # create virtual file in the directory specified by dir_key

      # acls : acl hash for the new file if it isn't nil

      # => default : use acls of the parent directory

      # get uid and gid { :uid => id, :gid => id }

      uidgid = SessionManager.get_uid_gid sid

      # get location [x,y,prx,v] from dir_key

      ploc = SpinLocationManager.key_to_location dir_key, NODE_DIRECTORY

      # Are there nodes in the target directory?

      #      existing_nodes = Spinapp::SpinNode.where(["spin_tree_type = 0 AND node_x_pr_coord = ? AND node_y_coord = ? AND is_void = false",ploc[X],ploc[Y] + 1])

      #      max_number = REQUEST_COORD_VALUE

      #      existing_nodes.each {|n|

      #        if n[:node_x_coord] > max_number

      #          max_number = n[:node_x_coord]

      #        end

      #      }

      # get full location [X,Y,P,V,K]

      loc = [REQUEST_COORD_VALUE, ploc[Y] + 1, ploc[X], REQUEST_VERSION_NUMBER]

      vfile_loc = nil

      while vfile_loc.blank?

        vfile_loc = Spinapp::SpinNodeKeeper.test_and_set_xy sid, loc, vfile_name # parent node loc and new file name

      end

      vfile_loc[V] *= -1 if vfile_loc[V] < 0

      # Is there a file that has the same name?

      same_locs = Spinapp::SpinNode.where(['spin_tree_type = 0 AND node_x_coord = ? AND node_y_coord = ?', vfile_loc[X],

                                           vfile_loc[Y]])

      same_locs.each do |sl|
        if sl[:node_name] != vfile_name

          Spinapp::SpinNode.delete_node(sid, sl[:spin_node_hashkey], true)

        elsif sl[:node_version] < vfile_loc[V]

          sl[:latest] = false

          sl.save

        end
      end

      log_msg = ":create_virtual_file_dbu => test_and_set_xy returned = #{vfile_loc}"

      FileManager.logger(sid, log_msg, 'LOCAL', LOG_ERROR)

      return vfile_loc if vfile_loc[X..V] == [-1, -1, -1, -1]

      vfile_loc = Spinapp::SpinNode.create_spin_node sid, vfile_loc[X], vfile_loc[Y], vfile_loc[PRX], vfile_loc[V], vfile_name,
                                                     NODE_FILE, uidgid[:uid], uidgid[:gid], acls, is_under_maintenance, set_pending

      if acls.nil?

        # vfile_loc = self.create_virtual_node 0, depth, prx, 0, NODE_DIRECTORY, get_uid, get_gid

        Spinapp::SpinAccessControl.copy_parent_acls sid, vfile_loc, NODE_FILE.dir_key, uidgid[:uid] # => vfile_loc = [x,y,prx,v,hashkey]

      end

      vfile_loc[X..K] # => return location array

      #      return vfile_loc[K] # => return hash key
    end

    # => self.create_virtual_file sid, vfile_name, dir_key

    #    def self.create_virtual_new_version sid, vfile_name, dir_key, acls = nil, is_under_maintenance = false, set_pending = false

    #      # create virtual file in the directory specified by dir_key

    #      # acls : acl hash for the new file if it isn't nil

    #      # => default : use acls of the parent directory

    #      # get uid and gid { :uid => id, :gid => id }

    #      uidgid = SessionManager.get_uid_gid sid

    #      # get location [x,y,prx,v] from vfile_key

    #      older_nodes = []

    #      ploc = SpinLocationManager.key_to_location dir_key, NODE_DIRECTORY

    #      self.transaction do

    #        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

    #        older_nodes = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => ploc[X],:node_y_coord => ploc[Y]+1,:node_name => vfile_name).order("node_version DESC")

    #        older_nodes.each {|n|

    #          n[:latest] = false

    #          n.save

    #        }

    #        vfile_key = older_nodes[0][:spin_node_hashkey]

    #      end # => end of transaction

    #      # get version info of vfile_key

    #      #       n = Spinapp::SpinNode.find_by_spin_node_hashkey vfile_key

    #      vfile_loc = [ -1, -1, -1, -1 ]

    #      self.transaction do

    #        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

    #        version_info = Spinapp::SpinNode.get_version_info older_nodes[0][:node_x_coord],older_nodes[0][:node_y_coord]

    #        vfile_loc = Spinapp::SpinNode.create_spin_node sid, older_nodes[0][:node_x_coord], older_nodes[0][:node_y_coord], older_nodes[0][:node_x_pr_coord], version_info[:latest_version]+1, version_info[:name], NODE_FILE, uidgid[:uid], uidgid[:gid], acls, is_under_maintenance, set_pending

    #      end # => end of transaction

    #      if vfile_loc[X..V] != [ -1, -1, -1, -1 ]

    #        if acls == nil

    #          # vfile_loc = self.create_virtual_node 0, depth, prx, 0, NODE_DIRECTORY, get_uid, get_gid

    #          Spinapp::SpinAccessControl.copy_parent_acls sid, vfile_loc, NODE_FILE, dir_key, uidgid[:uid] # => vfile_loc = [x,y,prx,v,hashkey]

    #        end

    #        return SpinLocationManager.location_to_key vfile_loc, NODE_FILE

    #      else

    #        return nil

    #      end

    #    end # => self.create_virtual_file sid, vfile_name, dir_key

    def self.get_latest_version(vfile_key)
      # get version info of vfile_key

      loc = SpinLocationManager.key_to_location vfile_key

      latest_node_key = Spinapp::SpinNode.get_latest_node loc[X], loc[Y]
    end

    # => end of get_latest_version open_file_key

    def self.get_prior_version(vfile_key)
      # get version info of vfile_key

      loc = SpinLocationManager.key_to_location vfile_key

      prior_node_key = Spinapp::SpinNode.get_prior_node loc[X], loc[Y]
    end

    # => end of get_latest_version open_file_key

    def self.search_virtual_file(_sid, file_name, dir_key, dir_x = ANY_VALUE, dir_y = ANY_VALUE, search_file_status = SEARCH_ACTIVE_VFILE)
      # get location of the dir

      fs = []

      dir_loc = []

      if dir_x == ANY_VALUE || dir_y == ANY_VALUE

        dir_loc = SpinLocationManager.key_to_location dir_key

      else

        dir_loc[X] = dir_x

        dir_loc[Y] = dir_y

      end

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        fs = if dir_loc[Y] > 0

               case search_file_status

               when SEARCH_ACTIVE_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_void = false AND is_pending = false AND in_trash_flag = false', SPIN_NODE_VTREE, dir_loc[X], dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               when SEARCH_EXISTING_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_void = false', SPIN_NODE_VTREE, dir_loc[X], dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => dir_loc[X], :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false).order("node_version DESC")

               when SEARCH_IN_TRASH_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND in_trash_flag = true', SPIN_NODE_VTREE, dir_loc[X], dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => dir_loc[X], :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :in_trash_flag => true).order("node_version DESC")

               when SEARCH_PENDING_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_pending = true', SPIN_NODE_VTREE, dir_loc[X], dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => dir_loc[X], :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_pending => true).order("node_version DESC")

               else # => same as SEARCH_ACTIVE_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_void = false AND is_pending = false AND in_trash_flag = false', SPIN_NODE_VTREE, dir_loc[X], dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

                 #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => dir_loc[X], :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false, :is_pending => false, :in_trash_flag => false).order("node_version DESC")

               end

             #          if active_file_only

             #            fs = Spinapp::SpinNode.where(:node_x_pr_coord => dir_loc[X], :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false, :is_pending => false, :in_trash_flag => false).order("node_version DESC")

             #          else

             #            fs = Spinapp::SpinNode.where(:node_x_pr_coord => dir_loc[X], :node_y_coord => dir_loc[Y]+1, :node_name => file_name).order("node_version DESC")

             #          end

             else

               case search_file_status

               when SEARCH_ACTIVE_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_void = false AND is_pending = false AND in_trash_flag = false', SPIN_NODE_VTREE, 0, dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false, :is_pending => false, :in_trash_flag => false).order("node_version DESC")

               when SEARCH_EXISTING_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_void = false', SPIN_NODE_VTREE, 0, dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false).order("node_version DESC")

               when SEARCH_IN_TRASH_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND in_trash_flag = true', SPIN_NODE_VTREE, 0, dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :in_trash_flag => true).order("node_version DESC")

               when SEARCH_PENDING_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_pending = true', SPIN_NODE_VTREE, 0, dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

               #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_pending => true).order("node_version DESC")

               else # => same as SEARCH_ACTIVE_VFILE

                 Spinapp::SpinNode.where([

                                           'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND node_name = ? AND is_void = false AND is_pending = false AND in_trash_flag = false', SPIN_NODE_VTREE, 0, dir_loc[Y] + 1, file_name
                                         ]).order('node_version DESC')

                 #            fs = Spinapp::SpinNode.where(:spin_tree_type => SPIN_NODE_VTREE, :node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false, :is_pending => false, :in_trash_flag => false).order("node_version DESC")

               end

               #          if active_file_only

               #            fs = Spinapp::SpinNode.where(:node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name, :is_void => false, :is_pending => false, :in_trash_flag => false).order("node_version DESC")

               #          else

               #            fs = Spinapp::SpinNode.where(:node_x_pr_coord => 0, :node_y_coord => dir_loc[Y]+1, :node_name => file_name).order("node_version DESC")

               #          end

             end
      end

      fs
    end

    # => end of search_virtual_file

    def self.delete_virtual_file(delete_sid, v_delete_file_key, trash_it = true, is_thrown = false) # => the last argument is trash_it flag
      # put it into trash can if trash_it is true

      # trash_itはゴミ箱に入れるときにtrue、ゴミ箱に入れずに削除するときはfalse

      # is_thrownはゴミ箱に一番上のフォルダのみを入れる場合にtrue、（この意味は階層が深いとゴミ箱に入れる時間がかかるため一番上のフォルダだけを入れる為）

      # get files at the same xy

      # lock spin_node_keeper(x,y)

      file_versions = []

      ret = false

      rethash = {}

      # return false if it is not deletable.

      file_is_deletable = Spinapp::SpinAccessControl.deletable?(delete_sid, v_delete_file_key, ANY_TYPE) # => skip deleteing it if it is a sticky file.

      unless file_is_deletable == true

        rethash[:success] = false

        rethash[:status] = ERROR_FAILED_TO_PUT_NODE_INTO_RECYCLER

        rethash[:errors] = '削除できないファイル／フォルダです'

        return rethash

      end

      tn = Spinapp::SpinNode.find_by(spin_node_hashkey: v_delete_file_key)

      if tn.blank?

        rethash[:success] = false

        rethash[:status] = Stat::ERROR_KEY_LIST_IS_EMPTY

        rethash[:errors] = '削除するファイルが指定されていません'

        return rethash

      end

      x = tn[:node_x_coord]

      y = tn[:node_y_coord]

      v = tn[:node_version]

      #      printf "(x,y) = (%d,%d)\n",x,y

      #      #      snklock = Spinapp::SpinNodeKeeper.find(["nx = ? AND ny = ?",x,( y == 0 ? 0 : (-1)*y)])

      #      #      snklock = Spinapp::SpinNodeKeeper.find(["nx = ? AND ny = ?",x,y])

      #      #      snklock.with_lock do

      # Is it a file or diretory?

      ntype = tn[:node_type]

      # get parent node

      pn = SpinLocationManager.get_parent_node(tn)

      pnode = pn[:spin_node_hashkey]

      #      pnode = SpinLocationManager.get_parent_key v_delete_file_key

      # go through delete_files

      if ntype == NODE_FILE

        # get versions of a file

        ret = false

        file_versions = Spinapp::SpinNode.where([

                                                  'spin_tree_type = 0 AND node_x_coord = ? AND node_y_coord = ? AND is_void = false AND node_version <= ?', x, y, v
                                                ]).order('node_version DESC')

        if file_versions.length == 0 # => no file

          rethash[:success] = false

          rethash[:status] = Stat::ERROR_KEY_LIST_IS_EMPTY

          rethash[:errors] = '削除するファイルが指定されていません'

          return rethash

        end

        #        file_versions.push(tn[:spin_node_hashkey])

        #        file_versions_tmp = (Spinapp::SpinNode.select("spin_node_hashkey").where(["node_x_coord = ? AND node_y_coord = ? AND node_version < ? AND is_void = false AND in_trash_flag = false",x,y,v]).order("node_version DESC")).map {|x| x[:spin_node_hashkey]}

        #        file_versions += file_versions_tmp

        Spinapp::RecyclerDatum.set_busy(delete_sid, v_delete_file_key) if is_thrown

        file_versions.each do |fv|
          if trash_it # => put it into recycler

            rethash = Spinapp::RecyclerDatum.put_node_into_recycler delete_sid, fv[:spin_node_hashkey], is_thrown

            # => set spin_updated_at of the parent node

            return rethash unless rethash[:success]

          else # => remove it

            # ret =  Spinapp::SpinNode.delete_node delete_sid, fv

            ret = Spinapp::SpinNode.delete_node delete_sid, fv[:spin_node_hashkey]

            # => set spin_updated_at of the parent node

            unless ret

              rethash[:success] = false

              rethash[:status] = ERROR_FAILED_TO_PUT_NODE_INTO_RECYCLER

              rethash[:errors] = '削除できないファイル／フォルダがあります'

              return rethash

            end

            # delete spinLocation_manager rec

            # slms = Spinapp::SpinLocationMapping.where(["node_x_coord = ? AND node_y_coord = ? AND node_hash_key = ?",x,y,fv]) # Comment By imai at 20150618

            retry_save = Vfs::ACTIVE_RECORD_RETRY_COUNT

            catch(:spin_location_mapping_save_again) do
              Spinapp::SpinLocationMapping.transaction do
                #              SpinLocation<Mapping.find_by_sql("LOCK TABLE spin_location_mappings IN EXCLUSIVE MODE;")

                slms = Spinapp::SpinLocationMapping.where(['node_x_coord = ? AND node_y_coord = ? AND node_hash_key = ?', x,

                                                           y, fv[:spin_node_hashkey]])

                slms.each do |slm|
                  slm[:is_void] = true

                  slm.save

                  #              slm.destroy
                end
              rescue ActiveRecord::StaleObjectError
                if retry_save > 0

                  retry_save -= 1

                  sleep(AR_RETRY_WAIT_MSEC)

                  throw :spin_location_mapping_save_again

                end
              end
            end

          end

          is_thrown = false if is_thrown
        end

        Spinapp::RecyclerDatum.complete_trash_operation delete_sid, v_delete_file_key if trash_it # add if ~ end by imai at 2015/6/18

        Spinapp::FolderDatum.has_updated delete_sid, pnode, DISMISS_CHILD, true

        rethash[:success] = true

        rethash[:status] = INFO_PUT_NODE_INTO_RECYCLER_SUCCESS

        return rethash

      elsif ntype == NODE_DIRECTORY

        if trash_it === true

          Rails.logger.warn('>> delete_virtual_file : select get_active_children_for_trash')

          children = Spinapp::SpinNode.get_active_children_for_trash(delete_sid, v_delete_file_key, ANY_TYPE)

        else

          Rails.logger.warn('>> delete_virtual_file : select get_active_children')

          children = Spinapp::SpinNode.get_active_children(delete_sid, v_delete_file_key, ANY_TYPE)

        end

        Rails.logger.warn('>> delete_virtual_file : n-children = ' + children.length.to_s)

        Rails.logger.warn('>> delete_virtual_file : delete node = ' + tn[:node_name])

        if trash_it # add if ~ end   2015/6/18 by imai

          rethash = Spinapp::RecyclerDatum.put_node_into_recycler delete_sid, v_delete_file_key, is_thrown

          unless rethash[:success] == true

            Rails.logger.warn('>> delete_virtual_file : put_node_into_recycler failed')

            Rails.logger.warn('>> delete_virtual_file : rethash = ' + rethash.to_s)

            rethash[:success] = false

            rethash[:status] = ERROR_FAILED_TO_PUT_NODE_INTO_RECYCLER

            rethash[:errors] = 'ゴミ箱に移動できないフォルダがあります'

            return rethash

          end

        else # ゴミ箱にいれない場合は、フォルダのis_voidフラグを立てるため以下のメソッドを実行する

          reth = Spinapp::SpinNode.delete_node delete_sid, v_delete_file_key

          unless reth == true

            Rails.logger.warn('>> delete_virtual_file : Spinapp::SpinNode.delete_node failed')

            Rails.logger.warn('>> delete_virtual_file : rethash = ' + rethash.to_s)

            rethash[:success] = false

            rethash[:status] = ERROR_FAILED_TO_DELETE_NODE

            rethash[:errors] = '削除できないフォルダがあります'

            return rethash

          end

        end # add if ~ end   2015/6/18 by imai

        Rails.logger.warn('>> delete_virtual_file : before  remove_child_from_parent')

        locations = %w[folder_a folder_b]

        locations.each do |loc|
          Spinapp::FolderDatum.remove_child_from_parent(v_delete_file_key, pnode, delete_sid, loc)
        end

        Rails.logger.warn('>> delete_virtual_file : before  children iterator')

        Spinapp::RecyclerDatum.set_busy(delete_sid, v_delete_file_key) if is_thrown

        count = 0

        rethash[:list] = {}

        children.each do |cn|
          Rails.logger.warn('>> delete_virtual_file : before  delete_virtual_file : node_name = ' + cn['node_name'])

          rethash2 = delete_virtual_file delete_sid, cn['spin_node_hashkey'], trash_it, false

          next if rethash2[:success]

          # rethash[:status] = ERROR_FAILED_TO_PUT_NODE_INTO_RECYCLER

          rethash[:list][count] = {}

          rethash[:list][count][:spin_node_hashkey] = cn['spin_node_hashkey']

          rethash[:list][count][:node_name] = cn['node_name']

          count += 1

          # return rethash

          #          ret =  Spinapp::RecyclerDatum.put_node_into_recycler delete_sid, cn[:spin_node_hashkey], false
        end

        Spinapp::FolderDatum.has_updated delete_sid, pnode, DISMISS_CHILD, true

        rethash[:success] = true

        rethash[:status] = INFO_PUT_NODE_INTO_RECYCLER_SUCCESS

        return rethash

      else # => undefined

        rethash[:success] = false

        rethash[:status] = ERROR_FAILED_TO_PUT_NODE_INTO_RECYCLER

        rethash[:errors] = '削除できないファイル／フォルダがあります'

        return rethash

      end # => ntype == NODE_FILE

      Spinapp::RecyclerDatum.complete_trash_operation delete_sid, v_delete_file_key if trash_it # add if ~ end by imai at 2015/6/18

      Spinapp::FolderDatum.has_updated delete_sid, pnode, DISMISS_CHILD, true

      Spinapp::RecyclerDatum.reset_busy(delete_sid, v_delete_file_key) if is_thrown

      #      end # => end of snlock.with_lock

      rethash[:success] = true

      rethash[:status] = INFO_PUT_NODE_INTO_RECYCLER_SUCCESS

      rethash
    end

    # => end of delete_virtual_file delete_sid, delete_file_key

    def self.retrieve_virtual_files(retrieve_sid, retrieve_file_keys)
      if retrieve_file_keys.length > 0

        retrieve_file_keys_in_recycler = []

        retrieve_file_keys.each do |retf|
          retrieve_file_keys_in_recycler += Spinapp::RecyclerDatum.search_files_in_recycler(retrieve_sid, retf)
        end

      end

      Spinapp::RecyclerDatum.retrieve_node_from_recycler retrieve_sid, retrieve_file_keys_in_recycler
    end

    # => end of self.retrieve_virtual_files retrieve_sid, retrieve_file_keys

    def self.find_directory_node(dirname, depth, parent_x, return_hash_key = false)
      # search spin_domains

      # seach node

      res = nil

      reta = []

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        res = Spinapp::SpinNode.readonly.select('node_x_coord,node_y_coord,node_x_pr_coord,node_version,spin_node_hashkey').find_by(
          spin_tree_type: 0, node_y_coord: depth, node_x_pr_coord: parent_x, node_type: NODE_DIRECTORY, node_name: dirname
        )

        #          res.with_lock do

        return reta if res.blank?

        reta = []

        reta[X] = res[:node_x_coord]

        reta[Y] = res[:node_y_coord]

        reta[PRX] = res[:node_x_pr_coord]

        reta[V] = res[:node_version]

        reta[HASHKEY] = res[:spin_node_hashkey] if return_hash_key

        #          end # => end of res.with_lock do

        return reta
      rescue ActiveRecord::RecordNotFound => e
        S5fLib.print_exception(e, true)

        return [-1, -1, -1, -1]
      end # => end of self.transaction do
    end

    # => end of find_directory_node

    def self.find_node(dirname, depth, parent_x, return_hash_key = false, get_latest = true)
      # search spin_domains

      # seach node

      res = nil

      reta = []

      nodes = []

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        res = if get_latest

                #          nodes = Spinapp::SpinNode.readonly.where(:node_y_coord => depth, :node_x_pr_coord => parent_x, :node_name => dirname).order("node_version DESC")

                Spinapp::SpinNode.readonly.select('node_x_coord,node_y_coord,node_x_pr_coord,node_version,spin_node_hashkey').find_by(
                  spin_tree_type: 0, node_y_coord: depth, node_x_pr_coord: parent_x, node_name: dirname
                ).order(node_version: 'DESC')

              else

                #          nodes = Spinapp::SpinNode.readonly.where(:node_y_coord => depth, :node_x_pr_coord => parent_x, :node_name => dirname)

                Spinapp::SpinNode.readonly.select('node_x_coord,node_y_coord,node_x_pr_coord,node_version,spin_node_hashkey').find_by(
                  spin_tree_type: 0, node_y_coord: depth, node_x_pr_coord: parent_x, node_name: dirname
                )

              end

        return reta if res.blank?

        #          res.with_lock do

        reta = []

        reta[X] = res[:node_x_coord]

        reta[Y] = res[:node_y_coord]

        reta[PRX] = res[:node_x_pr_coord]

        reta[V] = res[:node_version]

        reta[HASHKEY] = res[:spin_node_hashkey] if return_hash_key

        #          end # => end of res.with_lock do

        return reta
      rescue ActiveRecord::RecordNotFoundrd
        return [-1, -1, -1, -1]

        #        res = Spinapp::SpinNode.readonly.find(["node_y_coord = ? AND node_x_pr_coord = ? AND node_type = ? AND node_name = ?", depth, parent_x, NODE_DIRECTORY, dirname],:lock=>true)
      end # => end of self.transaction do
    end

    # => end of find_directory_node

    def self.throw_virtual_files(remove_sid, remove_file_keys, async_mode = false)
      # remove files from recycler and storage

      remove_count = 0

      remove_file_vpaths_in_recycler = []

      spin_uid = SessionManager.get_uid(remove_sid, true)

      if remove_file_keys.length > 0

        remove_file_vpaths_in_recycler = []

        remove_file_keys.each do |rmfk|
          remove_file_vpaths_in_recycler += Spinapp::RecyclerDatum.search_file_vpaths_in_recycler(remove_sid, rmfk)

          remove_query = format("DELETE FROM recycler_data WHERE spin_uid = %d AND spin_node_hashkey = '%s';",
                                spin_uid, rmfk)

          Spinapp::RecyclerDatum.connection.select_all(remove_query)
        rescue ActiveRecord::StaleObjectError
          next
        end

      end

      #      my_uid = SessionManager.get_uid(remove_sid)

      thr = Thread.new do
        remove_file_vpaths_in_recycler.each do |n|
          ret_key = ''

          #    ret = self.destroy_all :spin_uid => uid, :spin_node_hashkey => remove_file_key

          # set in_use_uid in spin_nodes rec

          remove_node = Spinapp::SpinNode.find_by(spin_node_hashkey: n[:spin_node_hashkey])

          next if remove_node.blank?

          #    nt = remove_node[:node_type]

          catch(:throw_virtual_files_set_flags) do
            Spinapp::SpinNode.transaction do
              remove_node[:in_use_uid] = n[:spin_uid]

              remove_node[:in_trash_flag] = false

              remove_node[:is_pending] = false

              next unless remove_node.save
            rescue ActiveRecord::StaleObjectError
              sleep(AR_RETRY_WAIT_MSEC)

              throw :throw_virtual_files_set_flags
            end
          end

          # send remove-request to file manager

          # if nt != NODE_DIRECTORY

          # retf = SpinFileSystem::SpinFileManager.remove_node remove_sid, remove_file_key

          # end

          if remove_node[:node_type] != NODE_DIRECTORY || async_mode

            ret_key = n[:spin_node_hashkey] if Spinapp::SpinNode.delete_node(remove_sid, n[:spin_node_hashkey], true,
                                                                             false)

          elsif Spinapp::SpinNode.delete_node(remove_sid, n[:spin_node_hashkey], true, true)

            ret_key = n[:spin_node_hashkey]

          end # => directory node

          #      retk = Spinapp::SpinNodeKeeper.delete_node_keeper_record(remove_node[:node_x_coord],remove_node[:node_y_coord])

          # remove node

          #              return ret #  removed rec

          remove_count += 1 if ret_key == n[:spin_node_hashkey]
        end
      end

      remove_file_vpaths_in_recycler.length # => array of deleted nodes
    end

    # => end of self.throw_virtual_files remove_sid, remove_file_keys, remove_file_names

    def self.find_spin_domain(domain_root)
      # search spin_domains

      # query = "SELECT \"spin_domains\".\"hash_key\" FROM \"spin_domains\" WHERE \"spin_domains\".\"spin_domain_root\" = \'#{domain_root}\' LIMIT 1"

      # ret_array = virtual_file_system_query query

      res = {}

      Spinapp::SpinDomain.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        res = Spinapp::SpinDomain.readonly.select('hash_key').find_by(spin_domain_root: domain_root)
      end

      if res.present?

        res[:hash_key]

      else # => gfo through ret_array

        nil

      end
    end

    # => end of find_domain

    def self.find_spin_domain_root(domain_hash_key)
      # search spin_domains root vpath

      # query = "SELECT \"spin_domains\".\"hash_key\" FROM \"spin_domains\" WHERE \"spin_domains\".\"spin_domain_root\" = \'#{domain_root}\' LIMIT 1"

      # ret_array = virtual_file_system_query query

      res = {}

      Spinapp::SpinDomain.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        res = Spinapp::SpinDomain.readonly.select('domain_root_node_hashkey').find_by(hash_key: domain_hash_key)
      end

      if res.present?

        res[:domain_root_node_hashkey]

      else # => gfo through ret_array

        nil

      end
    end

    # => end of find_domain

    def self.path_to_key(vpath)
      dirs = vpath.split(%r{/})

      return nil if dirs[0] != '' # => not absolute path!

      key = String.new

      depth = 1

      parent_x = 0

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        dirs[1..-1].each do |d|
          hk = find_directory_node d, depth, parent_x, true

          return nil if hk.blank? || hk == [-1, -1, -1, -1]

          depth += 1

          parent_x = hk[X]

          key = hk[HASHKEY]
        end
      end

      key
    end

    # => end of path_to_key

    def self.key_to_path(key)
      p = {}

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        begin
          p = Spinapp::SpinNode.readonly.select('virtual_path').find_by(spin_node_hashkey: key)
        rescue ActiveRecord::RecordNotFound => e
          S5fLib.print_exception(e, true)

          return nil
        end

        return nil if p.blank?

        #        p = Spinapp::SpinNode.readonly.select("node_x_coord,node_y_coord,node_x_pr_coord,node_version").find_by(_spin_node_hashkey: key)
      end

      p[:virtual_path]

      #      return SpinLocationManager.get_location_vpath [p[:node_x_coord],p[:node_y_coord],p[:node_x_pr_coord],p[:node_version]]
    end

    # => end of key_to_path

    def self.convert_to_timestamp(date_time_string) # => yyyy-mm-ddThh:mm:ss
      ts = date_time_string.to_time

      #      tss = ts.to_s.split(/ /)

      ts.to_i
    end

    def self.search_virtual_file_on_tree(dir_key, dir_x = ANY_VALUE, dir_y = ANY_VALUE)
      # get location of the dir

      file_nodes = []

      fs = []

      dir_loc = []

      if dir_x == ANY_VALUE || dir_y == ANY_VALUE

        dir_loc = SpinLocationManager.key_to_location dir_key

      else

        dir_loc[X] = dir_x

        dir_loc[Y] = dir_y

      end

      Spinapp::SpinNode.transaction do
        # self.find_by_sql('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;')

        fs = if dir_loc[Y] > 0

               Spinapp::SpinNode.where([

                                         'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND is_void = false AND latest = true', SPIN_NODE_VTREE, dir_loc[X], dir_loc[Y] + 1
                                       ]).order('node_name ASC, node_version DESC')

             else

               Spinapp::SpinNode.where([

                                         'spin_tree_type = ? AND node_x_pr_coord = ? AND node_y_coord = ? AND is_void = false AND latest = true', SPIN_NODE_VTREE, 0, dir_loc[Y] + 1
                                       ]).order('node_name ASC, node_version DESC')

             end
      end

      if fs.size > 0

        work_file_name = ''

        fs.each do |f|
          if 1 == f[:node_type]

            # フォルダの場合は再帰的に検索

            file_nodes.concat(search_virtual_file_on_tree(f[:spin_node_hashkey], f[:node_x_coord],
                                                          f[:node_y_coord]))

          elsif work_file_name != f[:node_name]

            # ファイルの場合はリストに追加 (最新バージョンのみ追加)

            file_nodes.push(f)

            work_file_name = f[:node_name]

          end
        end

      end

      file_nodes
    end

    # => end of search_virtual_file_on_tree
  end

  # => end of class VirtualFiuleSystemUtility

  # db utilities

  # transaction, optimistic locking

  # Add new record with optimistic locking.

  # Do nothing with existing record.

  def self.add_new_record_with_autoid(model_class, idfield, new_record_id = Vfs::ANY_VALUE, retry_count = Vfs::ACTIVE_RECORD_RETRY_COUNT, &block)
    rethash = { success: false, status: Stat::ERROR_FAILED_OPT_TRANSACTION, errors: Vfs::BLANK_STRING, result: [] }

    retry_save_count = retry_count

    catch(:try_add_new_record) do
      model_class.transaction do
        new_record_id = model_class.maximum(idfield) + 1 if new_record_id == Vfs::ANY_VALUE
        new_rec = model_class.new(&block)
        yield(new_rec)
        new_rec[idfield] = new_record_id
        new_rec.save!
        rethash[:success] = true
        rethash[:status] = Stat::INFO_OPT_TRANSACTION_SUCCESS
        rethash[:result] = new_rec
        rethash[:errors] = Vfs::BLANK_STRING
      rescue ActiveRecord::StaleObjectError
        retry_save_count -= 1
        if retry_save_count.positive?
          throw :try_add_new_record
        else
          rethash[:success] = false
          rethash[:errors] = "Failed to add record to #{model_class.name}"
        end
      rescue ActiveRecord::RecordNotUnique
        retry_save_count -= 1
        if retry_save_count.positive?
          new_record_id += 1
          throw :try_add_new_record
        else
          rethash[:success] = false
          rethash[:errors] = "Failed to add unique_record to #{model_class.name}"
        end
      end
    end
    rethash
  end

  # end of add_new_record

  # Add new record with optimistic locking.

  # Do nothing with existing record.

  def self.add_new_record(model_class, retry_count = Vfs::ACTIVE_RECORD_RETRY_COUNT, &block)
    rethash = { success: false, status: Stat::ERROR_FAILED_OPT_TRANSACTION, errors: Vfs::BLANK_STRING, result: [] }

    retry_save_count = retry_count

    catch(:try_add_new_record) do
      model_class.transaction do
        new_rec = model_class.new(&block)
        yield(new_rec)
        new_rec.save!
        rethash[:success] = true
        rethash[:status] = Stat::INFO_OPT_TRANSACTION_SUCCESS
        rethash[:result] = new_rec
        rethash[:errors] = Vfs::BLANK_STRING
      rescue ActiveRecord::StaleObjectError
        retry_save_count -= 1
        if retry_save_count.positive?
          throw :try_add_new_record
        else
          rethash[:success] = false
          rethash[:errors] = "Failed to add record to #{model_class.name}"
        end
      rescue ActiveRecord::RecordNotUnique
        retry_save_count -= 1
        if retry_save_count.positive?
          throw :try_add_new_record
        else
          rethash[:success] = false
          rethash[:errors] = "Failed to add unique_record to #{model_class.name}"
        end
      end
    end
    rethash
  end

  # end of add_new_record

  # Update or Add new record with optimistic locking.

  # Increment :revision when specified record exists.

  def self.update_record(model_class, query_hash, retry_count, dump_query_hash = false)
    rethash = { success: false, status: Stat::ERROR_FAILED_OPT_TRANSACTION, errors: Vfs::BLANK_STRING, result: {} }
    S5fLib.dump("#{__method__} : query_hash : #{query_hash}") if dump_query_hash

    retry_save_count = retry_count

    catch(:find_or_create_again) do
      model_class.transaction do
        new_rec = model_class.find_by!(query_hash)
        yield(new_rec)
        new_rec[:revision] += 1 unless new_rec.new_record?
        new_rec.save!
        rethash[:success] = true
        rethash[:status] = Stat::INFO_UPDATE_RECORD_SUCCESS
        rethash[:result] = new_rec
        rethash[:errors] = Vfs::BLANK_STRING
      rescue ActiveRecord::RecordNotFound
        rethash[:success] = false
        raise ActiveRecord::RecordNotFound, "Failed to update record of #{model_class.name}"
      rescue ActiveRecord::StaleObjectError
        retry_save_count -= 1
        if retry_save_count.positive?
          throw :find_or_create_again
        else
          rethash[:success] = false
          rethash[:errors] = "Failed to update record of #{model_class.name} by StaleObjectError"
        end
      end
    rescue StandardError => e
      S5fLib.print_exception(e, true)
      raise "update_record failed to add/update #{model_class.name}"
    end
    rethash
  end

  # end of update_record

  def self.update_or_create_record(model_class, query_hash, retry_count, &block)
    rethash = { success: false, status: Stat::ERROR_FAILED_OPT_TRANSACTION, errors: Vfs::BLANK_STRING, result: {} }

    retry_save_count = retry_count

    catch(:find_or_create_again) do
      model_class.transaction do
        new_rec = model_class.find_by!(query_hash)
        yield(new_rec)
        new_rec[:revision] += 1 unless new_rec.new_record?
        new_rec.save!
        rethash[:success] = true
        rethash[:status] = Stat::INFO_UPDATE_RECORD_SUCCESS
        rethash[:result] = new_rec
        rethash[:errors] = Vfs::BLANK_STRING
      rescue ActiveRecord::RecordNotFound => e
        # S5fLib.print_exception(e, true)
        rethash = add_new_record(model_class, retry_save_count, &block)
      rescue ActiveRecord::StaleObjectError
        retry_save_count -= 1
        if retry_save_count.positive?
          throw :find_or_create_again
        else
          rethash[:success] = false
          rethash[:errors] = "Failed to add record to #{model_class.name}"
        end
      end
    rescue StandardError => e
      S5fLib.print_exception(e, true)
      raise "update_or_create_record failed to add/update #{model_class.name}"
    end
    rethash
  end

  # end of update_or_create_record

  # Update records with optimistic locking.

  # Increment :revision when specified record exists.

  def self.update_records(model_class, query_hash, retry_count)
    rethash = { success: false, status: [], errors: [], result: [] }

    retry_save_count = retry_count

    update_recs = model_class.where(query_hash)

    update_recs.each do |update_rec|
      catch(:try_update_again) do
        model_class.transaction do
          yield(update_rec)
          update_rec[:revision] += 1 unless update_rec.new_record?
          update_rec.save!
          rethash[:status].push(Stat::INFO_UPDATE_RECORD_SUCCESS)
          rethash[:result].push(update_rec)
        rescue ActiveRecord::StaleObjectError
          retry_save_count -= 1
          if retry_save_count.positive?
            throw :try_update_again
          else
            rethash[:success] = false
            rethash[:errors] = "Failed to update record of #{model_class.name}"
          end
        end
      rescue StandardError => e
        S5fLib.print_exception(e, true)
        raise "update_records failed to update records of #{model_class.name}"
      end
    end
    rethash
  end

  # end of update_record

  # Deete record with optimistic locking.

  def self.delete_record(model_class, query_hash, retry_count = Vfs::ACTIVE_RECORD_RETRY_COUNT)
    rethash = { success: false, status: Stat::ERROR_FAILED_OPT_TRANSACTION, errors: Vfs::BLANK_STRING }

    retry_save_count = retry_count

    del_rec = {}

    catch(:try_destroy_again) do
      model_class.transaction do
        del_rec = model_class.find_by!(query_hash)

        del_rec.destroy
      rescue ActiveRecord::StaleObjectError
        retry_save_count -= 1

        if retry_save_count.positive?

          throw :try_destroy_again

        else

          rethash[:success] = false

          rethash[:errors] = "Failed to delete record in #{model_class.name}.#{__method__}"

          return rethash

        end
      rescue ActiveRecord::RecordNotFound => e
        S5fLib.print_exception(e, true)

        rethash[:success] = true

        rethash[:status] = Stat::INFO_NO_RECORDS_DELETED

        return rethash
      rescue StandardError => e
        S5fLib.print_exception(e, true)

        raise "delete_record failed in #{model_class.name}.#{__method__}"
      end

      rethash[:success] = true

      rethash[:status] = del_rec.blank? ? Stat::INFO_NO_RECORDS_DELETED : Stat::INFO_DELETE_RECORD_SUCCESS
    end

    rethash
  end

  # end of delete_record
end

# => end of module DatabaseUtility

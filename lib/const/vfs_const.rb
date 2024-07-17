# frozen_string_literal: true

# require 'const/acl_const'
module Vfs
  # constants internal
  X = 0         # => position of X coordinate value
  Y = 1         # => position of Y coordinate value
  PRX = 2       # => position of prX coordinate value
  V = 3         # => position of version value
  K = 4         # => position of spin_node_hashkey value
  T = 5         # => position of node type value
  VNAME = 6     # => position of vfile_name
  EXP = 6       # => position of expiration time_TYPE
  VTREE = 7     # => position of spin_tree_type value
  PUID = 8      # => position of spin_uid
  PGID = 9      # => position of spin_gid
  VPATH = 10    # => position of spin_gid

  # integer value for boolean
  I_TRUE = 1
  I_FALSE = 0

  ANY_X = -1
  ANY_PRX = -1
  ANY_Y = -1
  ANY_VERSION = -1
  ANY_TYPE = -1
  ANY_VALUE = -1
  ANY_GID = -1
  ANY_UID = -1
  MIN_GID = 1_000_000
  MAX_GID = 1_000_000_000
  MIN_UID = 1000
  MAX_UID = 1_000_000_000
  CREATE_NEW = -1

  ORIGIN_X = 0
  ORIGIN_Y = 0
  ORIGIN_PRX = ORIGIN_X

  IDX_FIRST_INDEX = -0
  IDX_LAST_INDEX = -1

  HASHKEY = 4 # => spin_node_hashkey
  CONST_DOMAIN = 32_768 # => indicates domain types

  # spin domain class
  DOMAIN_FOR_SYSTEM = 0
  DOMAIN_FOR_CLIENT = 2
  DOMAIN_FOR_ACCOUNT_USER = 128
  DOMAIN_FOR_SHARED = 1024
  DOMAIN_FOR_USER_DEFAULT = 2048
  SYSTEM_DOMAIN_CLASS_RANGE = (DOMAIN_FOR_SYSTEM...DOMAIN_FOR_ACCOUNT_USER)

  # spin_domain type : visibilty in conf file
  DOMAIN_VISIBLE = 1
  DOMAIN_INVISIBLE = 0

  NODE_DIRECTORY = 1      # => node is a directory
  NODE_FILE = 2           # => node is a file
  NODE_SYMBOLIC_LINK = 4  # => node is a symbolic link
  NODE_THUMBNAIL = 8      # => node is thumbnail image
  NODE_PREVIEW = 16       # => node is preview data
  NODE_PROXY_MOVIE = 32   # => node is proxy movie
  NODE_IS_INVISIBLE = 64  # => node is set invisible
  # NODE_DOMAIN = CONST_DOMAIN
  NODE_DOMAIN = NODE_DIRECTORY + CONST_DOMAIN

  # for BI TruePivot data tree
  NODE_CUBE = 32
  NODE_DIMENSION = 64
  NODE_MEASURE = 128
  NODE_FACT = 256

  # for spin_objects
  NODE_TRANSPORT_OBJECT = 1024
  NODE_SUPPORT_OBJECT = 2048
  NODE_RENTAL_OBJECT = 4096
  NODE_COOP_OBJECT = 8192
  NODE_PROJECT_OBJECT = 32_768
  NODE_WALLET_OBJECT = 65_536
  NODE_UNIVERSAL_OBJECT = 131_072

  SPIN_NODE_VTREE = 0
  SPIN_THUMBNAIL_VTREE = NODE_THUMBNAIL
  SPIN_PREVIEW_VTREE = NODE_PREVIEW
  SPIN_SYMBOLIC_LINK_VTREE = NODE_SYMBOLIC_LINK

  DEFAULT_SPIN_NODE_TREE = 0 # => default spin_node_tree number

  C_PICTURE_TYPE = 1
  C_VIDEO_TYPE = 2
  C_OTHER_TYPE = 3

  # node value indicates no directory
  NoDirectoryNode = [-1, -1, -1, -1, nil]
  NoFileNode = [-1, -1, -1, -1, nil]
  NodeDoesNotExist = [-1, -1, -1, -1, nil]
  NoThumbnailNode = [-1, -1, -1, -1, nil]
  NoXY = [-1, -1]
  NoXYP = [-1, -1, -1]
  NoXYPV = [-1, -1, -1, -1]
  NoXYPVK = [-1, -1, -1, -1, nil]
  EMPTY_KEY = ''

  # flag to indicate that it is a hard link
  LINKED_NODE_FLAG = 32_768 # => 17th bit is 1

  # lock status
  FSTAT_NOT_LOCKED_YET = -1 # => initial state. 2015/4/24 by K.O.
  FSTAT_UNLOCKED = 0
  # Myロック 追加 2015/04/07 西内
  FSTAT_LOCKED = 1
  # 排他ロック 追加 2015/04/07 西内
  FSTAT_LOCKED_EXCLUSIVE = 2

  # lock status
  FSTAT_WRITE_LOCKED = 1
  FSTAT_WRITE_LOCKED_EXCLUSIVE = 2
  FSTAT_READ_LOCKED = 4
  FSTAT_READ_LOCKED_EXCLUSIVE = 8
  FSTAT_CHECKED_OUT = 16
  FSTAT_CHECKED_OUT_EXCLUSIVE = 32

  # masks for n NODE
  MASK_CONST_DOMAIN = 0b1000000000000000 # => 32768 indicates domain types
  MASK_NODE_DIRECTORY = 0b1 # => node is a directory
  MASK_NODE_FILE = 0b10 # => node is a file
  MASK_NODE_SYMBOLIC_LINK = 0b100 # => node is a symbolic link
  MASK_NODE_THUMBNAIL = 0b1000 # => node is a thumbnail

  # for BI TruePivot data tree
  MASK_NODE_CUBE = 0b100000 # => 32
  MASK_NODE_DIMENSION = 0b1000000 # => 64
  MASK_NODE_MEASURE = 0b10000000 # => 128
  MASK_NODE_FACT = 0b100000000 # => 256

  # masks for ACL
  MASK_ACL_CONTROL = 0b1000
  MASK_ACL_DELETE = 0b100
  MASK_ACL_WRITE = 0b10
  MASK_ACL_READ = 0b1
  MASK_ACL_SYMBOLIC_LINK = 0b100
  MASK_ACL_THUMBNAIL = 0b1000

  # default values
  DEFAULT_PAGE_SIZE = 25
  DEFAULT_OFFSET = 0

  # wait interval
  AR_RETRY_WAIT_MSEC = 0.01 # => about 10 msec

  # # error code
  # ERROR_NOT_WRITABLE = -1001
  # ERROR_NOT_ACCESSIBLE = -1002

  # location and session
  LOCATION_A = 'folder_a'
  LOCATION_B = 'folder_b'
  LOCATION_ANY = 'folder_x_any'
  DOMAIN_ANY = '__ANY_DOMAIN__'
  SESSION_ANY = 'ffffffffffffffffffffffffffffffffffffffff'
  SESSION_NONE = '0000000000000000000000000000000000000000'
  NO_LOGIN_DIR = '0000000000000000000000000000000000000000'

  INITIALIZE_SESSION = '1111111111111111111111111111111111111111'

  END_OF_DATA_MARK = '__END_OF_DATA__'

  # cut, copy and paste operations
  OPERATION_BASE = 1024
  OPERATION_CUT = OPERATION_BASE + 1
  OPERATION_COPY = OPERATION_BASE + 2
  OPERATION_DUP = OPERATION_BASE + 3
  OPERATION_PASTE = OPERATION_BASE + 4

  # internal requests
  PROCESS_BASE = 2048
  PROCESS_FOR_EXPAND_FOLDER = PROCESS_BASE + 1
  PROCESS_FOR_SFL_DATA = PROCESS_BASE + 2
  PROCESS_FOR_UNIVERSAL_REQUEST = PROCESS_BASE + 1023

  # ADMIN special
  ADMIN_DEFAULT_PATH = '/'

  # special uid
  NO_USER = -1
  NO_GROUP = -1

  # for sysadmin work
  ROOT_USER_ID = 0
  ROOT_GROUP_ID = 0
  ROOT_DOMAIN_ID = 0

  # login options
  LOGIN_WITH_SESSION = 0
  LOGIN_FRESH_LOGIN = 1
  LOGIN_FRESH_LOGIN_AND_CLEAR_SESSIONS = 2
  LOGIN_DEFAULT_LOGIN = LOGIN_WITH_SESSION
  #  LOGIN_DEFAULT_LOGIN =Vfs::LOGIN_FRESH_LOGIN_AND_CLEAR_SESSIONS

  # max integer
  MAX_INTEGER = 1_073_741_824
  # max integer for split big number to upper and lower
  MAX_INTEGER_MASK_FOR_SPLIT = 2_147_483_647                    # 2^31 -1
  MAX_INTEGER_FOR_SPLIT = (MAX_INTEGER_MASK_FOR_SPLIT + 1) / 2  # 2^30
  # units
  ONE_KILO_BYTE = 1024
  ONE_MEGA_BYTE = ONE_KILO_BYTE * 1024
  ONE_GIGA_BYTE = ONE_MEGA_BYTE * 1024
  ONE_TERA_BYTE = ONE_GIGA_BYTE * 1024
  ONE_PETA_BYTE = ONE_TERA_BYTE * 1024
  ONE_EX_BYTE = ONE_PETA_BYTE * 1024
  UNLIMITED_SIZE = -1
  INITIAL_SIZE = 0

  # how many layers does it travers?
  TREE_TRAVERSE_DEPTH = 10
  INITIAL_TREE_TRAVERSE_DEPTH = 5

  # max inline attachment size
  MAX_INLINE_SIZE = 2_097_152

  # user id range
  LOWER_BOUND_FIXED_USER_ID = 1000
  UPPER_BOUND_FIXED_USER_ID = 10_000_000
  LOWER_BOUND_DYNAMCI_USER_ID = UPPER_BOUND_FIXED_USER_ID
  UPPER_BOUND_DYNAMIC_USER_ID = MAX_INTEGER
  # user id range = [lower, upper)
  FIXED_USER_ID_RANGE = LOWER_BOUND_FIXED_USER_ID...LOWER_BOUND_DYNAMCI_USER_ID
  # dynamic user id range = [lower, upper)
  DYNAMIC_USER_ID_RANGE = LOWER_BOUND_DYNAMCI_USER_ID...UPPER_BOUND_DYNAMIC_USER_ID

  # group id range
  LOWER_BOUND_FIXED_GROUP_ID = 1000
  UPPER_BOUND_FIXED_GROUP_ID = 10_000_000
  LOWER_BOUND_DYNAMCI_GROUP_ID = UPPER_BOUND_FIXED_GROUP_ID
  UPPER_BOUND_DYNAMIC_GROUP_ID = MAX_INTEGER
  # group id range = [lower, upper)
  FIXED_GROUP_ID_RANGE = LOWER_BOUND_FIXED_GROUP_ID...LOWER_BOUND_DYNAMCI_GROUP_ID
  # dynamic group id range = [lower, upper)
  DYNAMIC_GROUP_ID_RANGE = LOWER_BOUND_DYNAMCI_GROUP_ID...UPPER_BOUND_DYNAMIC_GROUP_ID

  # domain id range
  LOWER_BOUND_FIXED_DOMAIN_ID = 10_000
  UPPER_BOUND_FIXED_DOMAIN_ID = 10_000_000
  LOWER_BOUND_DYNAMCI_DOMAIN_ID = UPPER_BOUND_FIXED_DOMAIN_ID
  UPPER_BOUND_DYNAMIC_DOMAIN_ID = MAX_INTEGER
  # domain id range = [lower, upper)
  FIXED_DOMAIN_ID_RANGE = LOWER_BOUND_FIXED_DOMAIN_ID...LOWER_BOUND_DYNAMCI_DOMAIN_ID
  # dynamic domain id range = [lower, upper)
  DYNAMIC_DOMAIN_ID_RANGE = LOWER_BOUND_DYNAMCI_DOMAIN_ID...UPPER_BOUND_DYNAMIC_DOMAIN_ID

  # default expiration period
  EXPIRE_100_YEARS_AFTER = 100.years

  # for transaction control
  FLAG_WITH_TRANSACTION = true
  FLAG_WITHOUT_TRANSACTION = false
  DEFAULT_TRANSACTION_UNIT_NUMBER = 1000

  # for virtula file system coordinates
  INITIAL_X_COORD_VALUE = 0
  INITIAL_Y_COORD_VALUE = 1
  INITIAL_VERSION_NUMBER = 1
  REQUEST_COORD_VALUE = -1
  REQUEST_VERSION_NUMBER = -1

  # spin_domain layers
  LAYER0_NY = MAX_INTEGER * -1
  LAYER0_LAYER = 0
  BASE_LAYER = LAYER0_LAYER
  FIRST_LAYER = 1
  SECOND_LAYER = 2
  THIRD_LAYER = 3
  FOURTH_LAYER = 4
  ROOT_LEVEL_LAYER = BASE_LAYER
  SERVICE_LEVEL_LAYER = FIRST_LAYER
  CLIENT_LEVEL_LAYER = SECOND_LAYER
  ACCOUNT_LEVEL_LAYER = THIRD_LAYER
  USER_LEVEL_LAYER = FOURTH_LAYER

  # user management
  ROOT_USER = 0
  ADMIN_USER = 1
  GROUP_USER = 10
  DEFAULT_USER = 100
  ANONYMOUS_USER = 1000

  # values for user management
  DEFAULT_LOGIN_DIRECTORY_PATH = '$SERVER_PATH/$ORG_PATH/$PERSONEL/$UNAME'
  DEFAULT_TEMPLATE_UNAME = 'template-user'
  DEFAULT_TEMPLATE_UID = 500
  DEFAUTL_TEMPLATE_GID = 500
  DEFAUTL_TEMPLATE_PROJID = 500
  DEFAULT_TEMPLATE_USER_LEVEL_X = 100
  DEFAULT_TEMPLATE_USER_LEVEL_Y = 100
  DEFAULT_ADMIN_USER_LEVEL_X = 10_000
  DEFAULT_ADMIN_USER_LEVEL_Y = 10_000
  DEFAULT_USER_LEVEL_X = DEFAULT_TEMPLATE_USER_LEVEL_X
  DEFAULT_USER_LEVEL_Y = DEFAULT_TEMPLATE_USER_LEVEL_Y
  USER_PARAMS_BASE = 1024
  DEFAULT_LOGIN_DIRECTORY = USER_PARAMS_BASE + 1

  # storage server related
  SYSTEM_DEFAULT_LOGIN_DIRECTORY = '/spin/clients/T2L/personal'
  SYSTEM_DEFAULT_SPIN_SERVER = (ENV['RAILS_ENV'] == 'production' ? 'cs.makewavejapan.com:18880' : 'cs.makewavejapan.com:18881')
  SYSTEM_DEFAULT_SPIN_SERVER_PORT = (ENV['RAILS_ENV'] == 'production' ? 443 : 18_880)
  SYSTEM_DEFAULT_HTTP_SERVER_PORT = (ENV['RAILS_ENV'] == 'production' ? 80 : 3000)
  SYSTEM_DEFAULT_HTTPS_SERVER_PORT = 443
  SYSTEM_DEFAULT_URL_SERVER = 'https://society-foundation.securedomainjapan.com'
  SYSTEM_DEFAULT_URL_DOWNLOADER = '/secret_files/urldownloader'
  SYSTEM_DEFAULT_SPIN_FILE_MANAGER_PORT = 18_880
  SYSTEM_DEFAULT_PUBLIC_URL_DOWNLOADER = '/secret_files/public_urldownloader'
  SYSTEM_DEFAULT_TIMESTAMP_STRING = '2000-12-31 15:00:00'
  SYSTEM_DEFAULT_STORAGE_ROOT = (ENV['RAILS_ENV'] == 'production' ? '/webapps/spin/secret_files/spinvfs/root' : '/webapps/spin/secret_files/spinvfs/root_dev')
  SYSTEM_DEFAULT_STORAGE_NAME = 'spin_vfs_storage'
  SYSTEM_DEFAULT_VFS_NAME = 'spin_vfs'
  SYSTEM_DEFAULT_TEMP_DIR = '/var/run/society5foundation/tmp'
  SYSTEM_DEFAULT_USER_HOME_DIRECTORY_NAME = 'users'

  SYSTEM_DEFAULT_COOKIE_NAME = '_s5f_secretfiles_session'

  #  enum spin_vfs_access_types {
  #       spin_vfs_access_round_robin = 0,
  #       spin_vfs_access_least_entries_first,
  #       spin_vfs_access_least_usage_first,
  #       spin_vfs_access_sequential,
  #       spin_vfs_access_random,
  #       spin_vfs_access_most_free_space_first,
  #       spin_vfs_access_most_free_entries_first,
  #       spin_vfs_access_other
  #   };
  METRICS = %w[ROUND_ROBIN SEQUENTIAL LEAST_ENTRIES_FIRST LEAST_USAGE_FIRST LEAST_CONNECTIONS_FIRST RANDOM\
               MOST_FREE_SPACE_FIRST MOST_FREE_ENTRIES_FIRST ACCESS_OTHER]
  LoadBalanceMetrics = METRICS
  DEFAULT_METRICS = METRICS[0]

  #   enum spin_vfs_storage_logics {
  #     spin_vfs_storage_logic_sequential = 0,
  #     spin_vfs_storage_logic_load_balance,
  #     spin_vfs_storage_logic_hsm,
  #     spin_vfs_storage_logic_ilm,
  #     spin_vfs_storage_logic_random
  # };
  #   enum spin_vfs_types {
  #     spin_vfs_posix = 0,
  #     spin_vfs_nfs,
  #     spin_vfs_cifs,
  #     spin_vfs_wos = 100,
  #     spin_vfs_other = 1000
  # };

  FILE_SYSTEM_TYPES = %w[CLUSTER SINGLE OBJECT_STORAGE_AZURE OBJECT_STORAGE_S3]
  STORAGE_FS_TYPE = %w[]
  STORAGE_LOGICS = %w[SEQUENTIAL LOAD_BALANCE HSM ILM RANDOM]
  DEFAULT_STORAGE_LOGIC = STORAGE_LOGICS[0]

  DEFAULT_INDEX = 0

  # # vfs access mode
  # VFS_READ = Acl::ACL_VFS_READ
  # VFS_WRITE = Acl::ACL_VFS_WRITE
  # VFS_READ_WRITE = (VFS_READ | VFS_WRITE)
  # VFS_WORM = Acl::ACL_VFS_WORM

  # cont_location's
  DEFAULT_FOLDER_CONT_LOCATION = 'folder_a'
  CONT_LOCATIONS_LIST = %w[folder_a folder_b folder_at folder_atfi]
  CONT_LOCATIONS_LIST_A = %w[folder_a folder_at folder_atfi]
  CONT_LOCATIONS_LIST_B = %w[folder_b]
  #  CONT_LOCATIONS_LIST = %w[ folder_a folder_b folder_at folder_bt folder_atfi folder_btfi ]
  #  CONT_LOCATIONS_LIST_A = %w[ folder_a folder_at folder_atfi ]
  #  CONT_LOCATIONS_LIST_B = %w[ folder_b folder_bt folder_btfi ]

  # invalid numbers
  INVALID_BASE = -1024
  INVALID_LAYERS = INVALID_BASE - 1

  ADD_NUMBER_OF_LAYERS = 20

  # for node version management
  DEFAULT_MAX_VERSIONS = 3

  # for thread control
  THREAD_TIMEOUT = 7200 # => 7200 sec. = 2 hours

  # remove real files if is_void nodes in spin_nodes exceeds this number
  # MAX_REMOVE_QUEUE_COUNT = 100
  MAX_REMOVE_QUEUE_COUNT = 1
  # agent types
  SPIN_AGENT_BASE = 0
  SPIN_DEFAULT_AGENT = SPIN_AGENT_BASE
  SPIN_BROWSER_TYPE1 = SPIN_AGENT_BASE + 1
  SPIN_BROWSER_TYPE2 = SPIN_AGENT_BASE + 2
  SPIN_BROWSER_TYPE3 = SPIN_AGENT_BASE + 3
  SPIN_BROWSER_TYPE4 = SPIN_AGENT_BASE + 4
  SPIN_BROWSER_TYPE5 = SPIN_AGENT_BASE + 5
  SPIN_BROWSER_TYPE6 = SPIN_AGENT_BASE + 6
  SPIN_BROWSER_TYPE7 = SPIN_AGENT_BASE + 7
  SPIN_BROWSER_TYPE8 = SPIN_AGENT_BASE + 8
  SPIN_BROWSER_TYPE9 = SPIN_AGENT_BASE + 9
  SPIN_BROWSER_TYPE10 = SPIN_AGENT_BASE + 10
  SPIN_API_AGENT_BASE = SPIN_AGENT_BASE + 1024
  SPIN_DEFAULT_API_AGENT = SPIN_AGENT_BASE
  SPIN_API_AGENT_TYPE1 = SPIN_API_AGENT_BASE + 1
  SPIN_API_AGENT_TYPE2 = SPIN_API_AGENT_BASE + 2
  SPIN_API_AGENT_TYPE3 = SPIN_API_AGENT_BASE + 3
  SPIN_API_AGENT_TYPE4 = SPIN_API_AGENT_BASE + 4
  SPIN_API_AGENT_TYPE5 = SPIN_API_AGENT_BASE + 5
  SPIN_API_AGENT_TYPE6 = SPIN_API_AGENT_BASE + 6
  SPIN_API_AGENT_TYPE7 = SPIN_API_AGENT_BASE + 7
  SPIN_API_AGENT_TYPE8 = SPIN_API_AGENT_BASE + 8
  SPIN_API_AGENT_TYPE9 = SPIN_API_AGENT_BASE + 9
  SPIN_API_AGENT_TYPE10 = SPIN_API_AGENT_BASE + 10

  # data classes for group list display data
  GROUP_LIST_DATA_GROUP = 1
  GROUP_LIST_DATA_USER_PRIMARY_GROUP = 2
  PRIMARY_GROUP_MASK = GROUP_LIST_DATA_GROUP | GROUP_LIST_DATA_USER_PRIMARY_GROUP
  GROUP_LIST_DATA_USER = 256
  GROUP_INITIAL_MEMBER_ID_TYPE = 0
  GROUP_UNINITIALIZED_MEMBER_ID_TYPE = -1
  GROUP_MEMBER_ID_TYPE_USER = GROUP_LIST_DATA_USER
  GROUP_MEMBER_ID_TYPE_USER_PRIMARY_GROUP = GROUP_LIST_DATA_USER_PRIMARY_GROUP
  GROUP_MEMBER_ID_TYPE_GROUP = GROUP_LIST_DATA_GROUP
  DEFAULT_GROUP_NAME = 'root'

  # file manager parameters
  MAX_CONCURRENT_FILEMANAGER_PROCS = 200 # => number of procs
  DEFAULT_SPIN_SESSION_TIMEOUT = 86_400 # => 1 day

  # get marker values
  GET_MARKER_STATUS_DONE = 128
  GET_MARKER_CLEAR = 0
  GET_MARKER_SET = 1
  GET_MARKER_PROCESSED = 2
  GET_MARKER_COMPLETED = 4
  GET_MARKER_SET_DONE = GET_MARKER_SET + GET_MARKER_STATUS_DONE
  GET_MARKER_PROCESSED_DONE = GET_MARKER_PROCESSED + GET_MARKER_STATUS_DONE
  GET_MARKER_COMPLETED_DONE = GET_MARKER_COMPLETED + GET_MARKER_STATUS_DONE

  # special purpose hash key
  CALLED_FROM_TRASH_HASH_KEY = 'THIS_WAS_CALLED_FROM_TRASH'

  # update type of folder data
  NO_UPDATE_TYPE = 0
  NEW_CHILD = 1
  UPDATE_PROPERTY = 2
  DISMISS_CHILD = 3
  ACL_CHANGED = 4
  NOTIFY_EVENT = 5
  PENDING_CHILD = 6

  # type of notification
  UPLOAD_NOTIFICATION = 1
  MODIFY_NOTIFICATION = 2
  DELETE_NOTIFICATION = 4
  NO_NOTIFICATION = -1

  # status of files to search
  SEARCH_ACTIVE_VFILE = 0
  SEARCH_EXISTING_VFILE = 1
  SEARCH_IN_TRASH_VFILE = 2
  SEARCH_PENDING_VFILE = 3

  # retry count
  SPIN_NODE_KEEPER_RETRY_COUNT = 20
  ACTIVE_RECORD_RETRY_COUNT = 100
  ENCRYPTION_RETRY_COUNT = 20

  # layers to load
  DEPTH_TO_TRAVERSE = 2

  # logging
  LOG_ERROR = 1
  LOG_WARNING = 2
  LOG_INFO = 3

  # other string and numbers
  BLANK_STRING = ''
end

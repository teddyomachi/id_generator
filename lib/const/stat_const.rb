# coding: utf-8

# status constants
module Stat

  # initial state
  INITIAL_STATE = 0
  
  # information
  INFO_BASE = 1024
  INFO_NO_FILES = INFO_BASE + 1
  INFO_NO_FOLDERS = INFO_BASE + 2
  INFO_UPLOAD_FILE_SUCCESS = INFO_BASE + 3
  INFO_TRASH_FILE_SUCCESS = INFO_BASE + 4
  INFO_RECYCLER_LIST_SUCCESS = INFO_BASE + 5
  INFO_FILE_LIST_SUCCESS = INFO_BASE + 6
  INFO_THROW_FILES_SUCCESS = INFO_BASE + 7
  INFO_RETREIVE_FILES_SUCCESS = INFO_BASE + 8
  INFO_MOVE_FILE_SUCCESS = INFO_BASE + 9
  INFO_GET_GROUP_LIST_SUCCESS = INFO_BASE + 10
  INFO_SEARCH_FILE_RESULT_IS_EMPTY = INFO_BASE + 11
  INFO_SEARCH_FILE_RESULT_IS_NOT_EMPTY = INFO_BASE + 12
  INFO_VPATH_EXISTS = INFO_BASE + 13
  INFO_NO_VPATH = INFO_BASE + 14
  INFO_GET_CURRENT_DIRECTORY_SUCCESS = INFO_BASE + 15
  INFO_SET_CURRENT_DIRECTORY_SUCCESS = INFO_BASE + 16
  INFO_GET_VFILE_ATTRIBUTES_SUCCESS = INFO_BASE + 17
  INFO_GET_DOMAIN_ATTRIBUTES_SUCCESS = INFO_BASE + 18
  INFO_GET_ATTRIBUTES_SUCCESS = INFO_BASE + 19
  INFO_NO_DOMAIN = INFO_BASE + 20
  INFO_COPY_FILE_SUCCESS = INFO_BASE + 21
  INFO_CHANGE_DOMAIN_NAME_SUCCESS = INFO_BASE + 22
  INFO_SELECT_GROUP_SUCCESS = INFO_BASE + 23
  INFO_GET_GROUP_MEMBER_LIST_SUCCESS = INFO_BASE + 24
  INFO_MODIFY_GROUP_INFO_WITH_NO_CHANGE_SUCCESS = INFO_BASE + 25
  INFO_MODIFY_GROUP_INFO_SUCCESS = INFO_BASE + 26
  INFO_DELETE_GROUP_MEMBER_WITH_NO_MEMBER_SUCCESS = INFO_BASE + 27
  INFO_DELETE_GROUP_MEMBER_SUCCESS = INFO_BASE + 28
  INFO_USER_ACOUNT_ACTIVATION_SUCCESS = INFO_BASE + 29
  INFO_CHANGE_USER_INFO_SUCCESS = INFO_BASE + 30
  INFO_COLLAPSE_FOLDER_SUCCESS = INFO_BASE + 31
  INFO_MOVE_FOLDER_SUCCESS = INFO_BASE + 33
  INFO_COPY_FOLDER_SUCCESS = INFO_BASE + 34
  INFO_UPDATE_FILE_LIST_SUCCESS = INFO_BASE + 35
  INFO_UPDATE_FOLDER_LIST_SUCCESS = INFO_BASE + 36
  INFO_SET_FOLDER_PRIVILEGE_SUCCESS = INFO_BASE + 37
  INFO_LOAD_FILE_LIST_REC_SUCCESS = INFO_BASE + 38
  INFO_CHANGE_FILE_SUCCESS = INFO_BASE + 39
  INFO_SEARCH_FILES_SUCCESS = INFO_BASE + 40
  INFO_CHANGE_NODE_NAME_SUCCESS = INFO_BASE + 41
  INFO_PUT_NODES_INTO_CLIPBORD_SUCCESS = INFO_BASE + 42
  INFO_PUT_NODE_INTO_RECYCLER_SUCCESS = INFO_BASE + 43
  INFO_CLEAR_FOLDER_TREE_SUCCESS = INFO_BASE + 44
  INFO_CREATE_THUMBNAIL_SUCCESS = INFO_BASE + 45
  INFO_SET_DIRECTORY_STICKY_SUCCESS = INFO_BASE + 46
  INFO_RESET_DIRECTORY_STICKY_SUCCESS = INFO_BASE + 47
  INFO_REMOVE_THUMBNAIL_SUCCESS = INFO_BASE + 48
  INFO_RECOVER_TRAHSH_ERROR_SUCCESS = INFO_BASE + 49
  INFO_GET_VPATH_SUCCESS = INFO_BASE + 50
  INFO_REMOVE_NODE_REQUEST_ACCEPTED = INFO_BASE + 52
  INFO_CHANGE_FOLDER_SUCCESS = INFO_BASE + 53
  INFO_CHANGE_FILE_PROPERTY_SUCCESS = INFO_BASE + 54
  INFO_LOCK_FILE_SUCCESS = INFO_BASE + 55
  INFO_UNLOCK_FILE_SUCCESS = INFO_BASE + 56
  INFO_MORE_FILES = INFO_BASE + 256
  
  INFO_CLEAR_CLIPBOARD_SUCCESS = INFO_BASE + 60
  
  # user acount activation status  at login
  INFO_USER_ACOUNT_ACTIVATED = 1024
  INFO_USER_ACOUNT_IS_NOT_ACTIVATED = 1025
  
  # sysadmin info
  INFO_SYSADMIN_BASE = INFO_BASE + 1024
  INFO_SYSADMIN_CREATE_LOGIN_DIRECTORY_SUCCESS = INFO_SYSADMIN_BASE + 1
  INFO_SYSADMIN_ADD_USER_RECORD_SUCCESS  = INFO_SYSADMIN_BASE + 2
  INFO_SYSADMIN_ADD_GROUP_RECORD_SUCCESS   = INFO_SYSADMIN_BASE + 3
  INFO_SYSADMIN_ADD_GROUP_MEMBER_ALREADY_A_MEMBER = INFO_SYSADMIN_BASE + 4
  INFO_SYSADMIN_ADD_GROUP_MEMBER_SUCCESS = INFO_SYSADMIN_BASE + 5
  INFO_SYSADMIN_CREATE_CREATE_USER_ATTRIBUTE_SUCCESS = INFO_SYSADMIN_BASE + 6
  INFO_SYSADMIN_CREATE_USER_SUCCESS = INFO_SYSADMIN_BASE + 7
  INFO_SYSADMIN_MODIFY_USER_RECORD_SUCCESS = INFO_SYSADMIN_BASE + 8
  INFO_SYSADMIN_MODIFY_GROUP_RECORD_SUCCESS = INFO_SYSADMIN_BASE + 9
  INFO_SYSADMIN_MODIFY_GROUP_MEMBER_SUCCESS = INFO_SYSADMIN_BASE + 10
  INFO_SYSADMIN_DELETE_USER_SUCCESS = INFO_SYSADMIN_BASE + 11
  INFO_SYSADMIN_DELETE_USER_ATTRIBUTE_SUCCESS = INFO_SYSADMIN_BASE + 12
  INFO_SYSADMIN_DELETE_GROUP_RECORD_SUCCESS = INFO_SYSADMIN_BASE + 13
  INFO_SYSADMIN_DELETE_NO_USER_SUCCESS = INFO_SYSADMIN_BASE + 14
  INFO_SYSADMIN_DELETE_NO_USER_ATTRIBUTE_SUCCESS = INFO_SYSADMIN_BASE + 15
  INFO_SYSADMIN_DELETE_NO_GROUP_MEMBER_SUCCESS = INFO_SYSADMIN_BASE + 16
  INFO_SYSADMIN_DELETE_GROUP_MEMBER_SUCCESS = INFO_SYSADMIN_BASE + 17
  INFO_SYSADMIN_CHANGE_USER_PASSWORD_SUCCESS = INFO_SYSADMIN_BASE + 18
  INFO_SYSADMIN_MODIFY_USER_ATTRIBUTE_SUCCESS = INFO_SYSADMIN_BASE + 19
  INFO_SYSADMIN_GET_USER_INFO_SUCCESS = INFO_SYSADMIN_BASE + 20
  
  # notification only
  INFO_REQUEST_ACCEPTED_BASE = INFO_BASE + 2048
  INFO_REQUEST_DELETE_FOLDER_ACCEPTED = INFO_REQUEST_ACCEPTED_BASE + 1
  INFO_RENDERING_DONE = 8192
  
  # status codes
  STAT_BASE = 2048
  STAT_DATA_ALREADY_LOADED = STAT_BASE + 1
  STAT_DATA_NOT_LOADED_YET = STAT_BASE + 2
  STAT_EXPANDED_ALREADY = STAT_BASE + 3
  STAT_EXPANDED_FIRST_TIME = STAT_BASE + 4
  
  # error status
  ERROR_SYSTEM_BASE = -1
  ERROR_SYSTEM_INIT_NODE_KEEPER = ERROR_SYSTEM_BASE - 1
  ERROR_SYSTEM_FILE_MANAGER_DIED = ERROR_SYSTEM_BASE - 2
  ERROR_SYSTEM_FILE_MANAGER_BUSY = ERROR_SYSTEM_BASE - 3
  ERROR_BASE = -1024
  ERROR_ACCESS_OFFSET = 1024
  ERROR_FAILED_TO_LOGIN = ERROR_BASE
  ERROR_GET_FILE_LIST_FAILED = ERROR_BASE - 1
  ERROR_GET_FOLDERS_FAILED = ERROR_BASE - 2
  ERROR_GET_DOMAINS_FAILED = ERROR_BASE - 3
  ERROR_UPLOAD_FILE = ERROR_BASE - 4
  ERROR_TRASH_FILE = ERROR_BASE - 5
  ERROR_RECYCLER_LIST = ERROR_BASE - 6
  ERROR_THROW_FILES = ERROR_BASE - 7
  ERROR_RETREIVE_FILES = ERROR_BASE - 8
  ERROR_MOVE_FILE = ERROR_BASE - 9
  ERROR_NO_DOMAINS = ERROR_BASE - 10
  ERROR_NO_GROUPS = ERROR_BASE - 11
  ERROR_CREATE_VPATH_FAILED = ERROR_BASE - 12
  ERROR_FAILED_TO_SAVE_EXPANDED = ERROR_BASE - 13
  ERROR_NO_RECORD_FOUND = ERROR_BASE - 14
  ERROR_FAILED_TO_GET_CURRENT_DIRECTORY = ERROR_BASE - 15
  ERROR_FAILED_TO_SET_CURRENT_DIRECTORY = ERROR_BASE - 16
  ERROR_FAILED_TO_GET_VFILE_ATTRIBUTES = ERROR_BASE - 17
  ERROR_FAILED_TO_GET_DOMAIN_ATTRIBUTES = ERROR_BASE - 18
  ERROR_FAILED_TO_GET_ATTRIBUTES = ERROR_BASE - 19
  ERROR_FILE_IS_NOT_IN_LIST_DATA = ERROR_BASE - 20
  ERROR_COPY_FILE = ERROR_BASE - 21
  ERROR_SESSION_TIMEOUT = ERROR_BASE - 22
  ERROR_SESSION_ID_MISSING = ERROR_BASE - 23
  ERROR_FORM_DATA_MISSING = ERROR_BASE - 24
  ERROR_INVALID_SESSION_ID = ERROR_BASE - 25
  ERROR_SYSADMIN_DUPLICATE_GID = ERROR_BASE - 26
  ERROR_SYSADMIN_INVALID_UID = ERROR_BASE - 27
  ERROR_SYSADMIN_NO_SUCH_USER_UID = ERROR_BASE - 28
  ERROR_FAILED_TO_OPEN_FOLDER = ERROR_BASE - 29
  ERROR_FAILED_TO_CHANGE_DOMAIN_NAME = ERROR_BASE - 30
  ERROR_GROUP_NAME_IS_NOT_UNIQUE = ERROR_BASE - 31
  ERROR_GID_EXCEEDS_MAX_GID = ERROR_BASE - 32
  ERROR_GID_IS_NOT_UNIQUE = ERROR_BASE - 33
  ERROR_SELECTED_GROUP_MISSING = ERROR_BASE - 34
  ERROR_FAILED_TO_GET_GROUP_INFO = ERROR_BASE - 35
  ERROR_FAILED_TO_MODIFY_GROUP_INFO = ERROR_BASE - 36
  ERROR_USER_RECORD_NOT_FOUND = ERROR_BASE - 37
  ERROR_FAILED_TO_UPDATE_USER_ATTRIBUTES = ERROR_BASE - 38
  ERROR_FAILED_TO_UPDATE_USER_MANAGEMENT_TABLE = ERROR_BASE - 39
  ERROR_FAILED_TO_RENAME_USER_LOGIN_DIRECTORY = ERROR_BASE - 40
  ERROR_USER_NAME_USED_ALREADY = ERROR_BASE - 41
  ERROR_USER_PRIMARY_GROUP_NOT_FOUND = ERROR_BASE - 42
  ERROR_FAILED_TO_UPDATE_USER_PRIMARY_GROUP = ERROR_BASE - 43
  ERROR_FAILED_TO_COLLAPSE_FOLDER = ERROR_BASE - 44
  ERROR_FAILED_TO_MOVE_FILE = ERROR_BASE - 45
  ERROR_FAILED_TO_MOVE_FOLDER = ERROR_BASE - 46
  ERROR_FAILED_TO_COPY_FILE = ERROR_BASE - 47
  ERROR_FAILED_TO_COPY_FOLDER = ERROR_BASE - 48
  ERROR_FAILED_TO_UPDATE_FILE_LIST = ERROR_BASE - 49
  ERROR_FAILED_TO_FIND_PARENT_FOLDER = ERROR_BASE - 50
  ERROR_FAILED_TO_UPDATE_FOLDER_LIST = ERROR_BASE - 51
  ERROR_FAILED_TO_CREATE_SUB_FOLDER = ERROR_BASE - 52
  ERROR_INVALID_HASH_KEY = ERROR_BASE - 53
  ERROR_FAILED_TO_SET_FOLDER_PRIVILEGE = ERROR_BASE - 54
  ERROR_FAILED_TO_LOAD_FILE_LIST_REC = ERROR_BASE - 55
  ERROR_FAILED_TO_CHANGE_FILE = ERROR_BASE - 56
  ERROR_SAME_FILE_PATH_IN_RECYCLER = ERROR_BASE - 57
  ERROR_TRIED_TO_MOVE_TO_SAME_FOLDER = ERROR_BASE - 58
  ERROR_FAILED_TO_CHANGE_NODE_NAME = ERROR_BASE - 59
  ERROR_SAME_FILE_PATH_IN_DIRECTORY = ERROR_BASE - 60
  ERROR_TRIED_TO_COPY_TO_SAME_FOLDER = ERROR_BASE - 61
  ERROR_FAILED_TO_TRASH_FILE = ERROR_BASE - 62
  ERROR_FAILED_TO_DELETE_NODE = ERROR_BASE - 63
  ERROR_KEY_LIST_IS_EMPTY = ERROR_BASE - 64
  ERROR_FAILED_TO_MOVE_ORIGIN_NODE = ERROR_BASE - 65
  ERROR_FAILED_TO_PUT_NODE_INTO_RECYCLER = ERROR_BASE - 66
  ERROR_NOT_READABLE = ERROR_BASE - 67
  ERROR_FAILED_TO_CLEAR_FOLDER_TREE = ERROR_BASE - 68
  ERROR_FAILED_TO_SET_DIRECTORY_STICKY = ERROR_BASE - 69
  ERROR_FAILED_TO_RESET_DIRECTORY_STICKY = ERROR_BASE - 70
  ERROR_FAILED_TO_RECOVER_TRAHSH_ERROR = ERROR_BASE - 71
  ERROR_DOWNLOAD_FILE = ERROR_BASE - 72
  ERROR_FAILED_TO_CHANGE_FOLDER = ERROR_BASE - 73
  ERROR_FAILED_TO_CHANGE_FILE_PROPERTY = ERROR_BASE - 74
  ERROR_FAILED_TO_SEARCH_FILES = ERROR_BASE - 75
  ERROR_FAILED_TO_CREATE_NEW_NODE_REC = ERROR_BASE - 256
  ERROR_FAILED_TO_CREATE_THUMBNAIL = ERROR_BASE - 257
  ERROR_FAILED_TO_REMOVE_THUMBNAIL = ERROR_BASE - 258
  ERROR_FAILED_TO_GET_VPATH = ERROR_BASE - 259
  ERROR_FAILED_TO_REMOVE_NODE_REQUEST = ERROR_BASE - 261
  ERROR_FAILED_TO_LOCK_FILE = ERROR_BASE - 262
  ERROR_FAILED_TO_REMOVE_UNLOCK_FILE = ERROR_BASE - 263
  
  ERROR_CLEAR_CLIPBOARD = ERROR_BASE - 80
  
  ERROR_SYSADMIN_BASE = -2048
  ERROR_SYSADMIN_DUPLICATE_UID = ERROR_SYSADMIN_BASE - 1
  ERROR_SYSADMIN_INVALID_PASSWORD = ERROR_SYSADMIN_BASE - 2
  ERROR_SYSADMIN_FAILED_TO_CREATE_USER_RECORD = ERROR_SYSADMIN_BASE - 3
  ERROR_SYSADMIN_INSUFFICIENT_USER_PRIVILEGE = ERROR_SYSADMIN_BASE - 4
  ERROR_SYSADMIN_NO_SUCH_USER = ERROR_SYSADMIN_BASE - 5
  ERROR_SYSADMIN_FAILED_TO_CREATE_USER_LOGIN_DIRECTORY = ERROR_SYSADMIN_BASE - 6
  ERROR_SYSADMIN_FAILED_TO_ADD_USER_RECORD = ERROR_SYSADMIN_BASE - 7
  ERROR_SYSADMIN_FAILED_TO_ADD_GROUP_RECORD = ERROR_SYSADMIN_BASE - 8
  ERROR_SYSADMIN_FAILED_TO_ADD_GROUP_MEMBER = ERROR_SYSADMIN_BASE - 9
  ERROR_SYSADMIN_FAILED_TO_CREATE_USER_ATTRIBUTE = ERROR_SYSADMIN_BASE - 10
  ERROR_SYSADMIN_FAILED_TO_MODIFY_USER_RECORD = ERROR_SYSADMIN_BASE - 11
  ERROR_SYSADMIN_FAILED_TO_MODIFY_GROUP_MEMBER = ERROR_SYSADMIN_BASE - 12
  ERROR_SYSADMIN_FAILED_TO_MODIFY_USER_ATTRIBUTE = ERROR_SYSADMIN_BASE - 13
  ERROR_SYSADMIN_FAILED_TO_DELETE_USER_ATTRIBUTE = ERROR_SYSADMIN_BASE - 14
  ERROR_SYSADMIN_FAILED_TO_DELETE_GROUP_RECORD = ERROR_SYSADMIN_BASE - 15
  ERROR_SYSADMIN_FAILED_TO_DELETE_USER = ERROR_SYSADMIN_BASE - 16
  ERROR_SYSADMIN_FAILED_TO_DELETE_GROUP_MEMBER = ERROR_SYSADMIN_BASE - 17
  ERROR_SYSADMIN_FAILED_TO_CHANGE_USER_PASSWORD = ERROR_SYSADMIN_BASE - 18
  ERROR_SYSADMIN_FAILED_TO_CHANGE_USER_LOGIN_DIRECTORY = ERROR_SYSADMIN_BASE - 19
  ERROR_SYSADMIN_FAILED_TO_GET_USER_INFO = ERROR_SYSADMIN_BASE - 20
  ERROR_SYSADMIN_FAILED_TO_SYSTEM_DELETE_USER = ERROR_SYSADMIN_BASE - 21
  
#  ERROR_CREATE_VPATH_FAILED = ERROR_BASE - 12
  # error code
  ERROR_NOT_WRITABLE = ERROR_BASE - 1001
  ERROR_NOT_ACCESSIBLE = ERROR_BASE - 1002
  
  # acl error
  ERROR_ACCESS_DENIED = ERROR_BASE - ERROR_ACCESS_OFFSET - 1
  
  #SECRET FILES API
  #SUCCESS
  INFO_BOOMBOX_API_BASE = 4096
  INFO_BOOMBOX_API_IHAB_LS_SUCCESS = INFO_BOOMBOX_API_BASE + 1
  INFO_BOOMBOX_API_GET_DOMAIN_LIST_SUCCESS = INFO_BOOMBOX_API_BASE + 2
  INFO_BOOMBOX_API_ADD_DOMAIN_LIST_SUCCESS = INFO_BOOMBOX_API_BASE + 3
  INFO_BOOMBOX_API_DELETE_DOMAIN_LIST_SUCCESS = INFO_BOOMBOX_API_BASE + 4
  INFO_BOOMBOX_API_GET_GROUP_LIST_SUCCESS = INFO_BOOMBOX_API_BASE + 5
  INFO_BOOMBOX_API_GET_MEMBER_GROUP_LIST_SUCCESS = INFO_BOOMBOX_API_BASE + 6
  INFO_BOOMBOX_API_ADD_MEMBER_MY_GROUP_SUCCESS = INFO_BOOMBOX_API_BASE + 7
  INFO_BOOMBOX_API_GET_MAPPING_DATA_SLM_COUNT = INFO_BOOMBOX_API_BASE + 100
  #ERROR
  ERROR_BOOMBOX_API_BASE = -4096
  #IHAB LS: ノードハッシュからメタ情報を取得できませんでした
  ERROR_BOOMBOX_API_IHAB_LS_LIST_NOT_FOUND = ERROR_BOOMBOX_API_BASE - 1
  ERROR_BOOMBOX_API_GET_DOMAIN_LIST_GET_SESSION = ERROR_BOOMBOX_API_BASE - 22
  ERROR_BOOMBOX_API_GET_DOMAIN_LIST_GET_DOMAINS = ERROR_BOOMBOX_API_BASE - 23
  ERROR_BOOMBOX_API_GET_DOMAIN_LIST_GET_GROUPMEMBER = ERROR_BOOMBOX_API_BASE - 24
  ERROR_BOOMBOX_API_GET_DOMAIN_LIST_GET_USERINFO = ERROR_BOOMBOX_API_BASE - 25
  ERROR_BOOMBOX_API_ADD_DOMAIN_LIST_FAILED = ERROR_BOOMBOX_API_BASE - 26
  ERROR_BOOMBOX_API_DELETE_DOMAIN_LIST_FAILED = ERROR_BOOMBOX_API_BASE - 27
  ERROR_BOOMBOX_API_GET_GROUP_LIST = ERROR_BOOMBOX_API_BASE - 41
  ERROR_BOOMBOX_API_GET_MEMBER_GROUP_LIST = ERROR_BOOMBOX_API_BASE - 61
  ERROR_BOOMBOX_API_ADD_MEMBER_MY_GROUP = ERROR_BOOMBOX_API_BASE - 81
  
  ERROR_BOOMBOX_API_GET_MAPPING_DATA_SLM_COUNT = ERROR_BOOMBOX_API_BASE - 101
  
end # => end of module
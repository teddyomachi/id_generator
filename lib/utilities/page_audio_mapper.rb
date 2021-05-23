module PageAudioMapper
  require 'const/page_audio_mappings'

  class AudioGetter

    def self.get_audio(page_name)
      PageAudioMapping::PAGE_AUDIO_MAPPINGS.each {|pgoh|
        if pgoh[:audio] == page_name
          return pgoh[:audio]
        end
      }
      return nil
    end
  end
end
require 'openssl'
require 'base64'
require 'const/ssl_const'


module MathUtility

  def self.random_numbers nstart, nend, ntimes, narray
    narray = Array.new(ntimes)
    myrandom = Random.new()

    for n in 0..ntimes do
      narray[n] = myrandom.rand(nstart..nend)
    end

    narray
  end

  def self.random_numbers_f nstart, nend, ntimes, fname
    myrandom = Random.new()
    fo = File.open(fname, mode = 'w')
    nl = nend.to_s.length
    format_string = '%0' + nl.to_s + 'd'

    while ntimes > 0
      rn = myrandom.rand(nstart..nend)
      fo.write(sprintf("#{format_string}\n", rn))
      # fo.write(sprintf("%08d\n", rn))
      --ntimes
    end

    fo.close
    fname
  end

end

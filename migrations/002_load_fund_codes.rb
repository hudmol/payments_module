require 'db/migrations/utils'
require 'csv'

def write_fund_translations(file, fund_codes)
  lines = []
  File.open(file).each do |line|
    lines << line

    if line =~ /\A(\s+)payment_fund_code:$/
      indent = "#{$1}  "
      fund_codes.each do |fund_code|
        new_line = indent
        new_line += [fund_code[:code], fund_code[:description]].map {|s| sprintf('"%s"', s.gsub(/"/, '\\"'))}.join(": ")
        new_line += "\n"

        lines << new_line
      end
    end
  end

  File.write(file, lines.join(""))
end


Sequel.migration do

  up do
    if !defined?(ASpaceEnvironment) || ASpaceEnvironment.environment == :production
      $stderr.puts <<EOF

You seem to be setting up the ArchivesSpace payment module for the first time.

At this point, you can pre-load the system with a set of fund codes.  To do
that, you will need to provide a tab-delimited file (TSV file) containing two
colums:

  fund code [tab] fund description

For example, your file might contain entries like:

  ASPACE [tab] ArchivesSpace Fund
  SMCDFUND [tab] Scrooge McDuck Fund

You can always add and remove fund codes later on using the ArchivesSpace user
interface.

EOF

      while true
        $stderr.puts "Enter a full path of a TSV file to load (or blank to skip): "
        $stderr.flush
        file = $stdin.readline.to_s.strip

        break if file.empty?

        begin
          fund_codes = []

          self.transaction do
            CSV.foreach(file, :col_sep => "\t") do |row|
              (code, description) = row.map {|s| s.to_s.strip}

              # Empty line
              next if code.nil?

              if description.to_s.empty?
                raise "Missing description for code: #{code}"
              end

              fund_codes << {:code => code, :description => description}
            end

            enum_id = self[:enumeration][:name => 'payment_fund_code'][:id]
            fund_codes.each_with_index do |fund_code, i|
              self[:enumeration_value].insert(:enumeration_id => enum_id,
                                              :value => fund_code[:code],
                                              :position => i,
                                              :readonly => 0)
            end

            write_fund_translations(File.join(File.dirname(__FILE__), '../frontend/locales/en.yml'),
                                    fund_codes)
          end

          break
        rescue
          $stderr.puts "File '#{file}' doesn't exist or couldn't be opened: #{$!}"
          sleep 1
        end
      end
    end
  end

end


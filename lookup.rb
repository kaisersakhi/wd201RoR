def get_command_line_argument
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  dns_records = {}
  dns_raw.each do |line|
    if line.strip.length <= 0 || line.strip[0] == "#"
      next
    end
    record_type, source, destination = line.split(",")
    dns_records[source.strip] = { "record_type" => record_type.strip, "destination" => destination.strip }
  end
  dns_records
end

def resolve(dns_records, lookup_chain, domain)
  if dns_records[domain].nil?
    lookup_chain = ["Error: record not found for #{domain}"]
  elsif dns_records[domain]["record_type"] == "A"
    lookup_chain.push dns_records[domain]["destination"]
  else
    lookup_chain.push dns_records[domain]["destination"]
    resolve(dns_records, lookup_chain, dns_records[domain]["destination"])
  end
end

dns_records = parse_dns(dns_raw)
# p dns_records
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")

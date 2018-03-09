require 'xkeys'

def generate_keys(depth, num_keys)
  return (1..num_keys).to_a if depth <= 0

  (1..num_keys).map do |i|
    if depth.even?
      generate_keys(depth - 1, num_keys).map {|stub| "#{i}.#{stub}" }
    else
      word = "#{Faker::Lorem.word}-#{i}"
      generate_keys(depth - 1, num_keys).map {|stub| "#{word}.#{stub}" }
    end
  end.flatten
end

def clean_key(key)
  key.split('.').map do |piece|
    if piece.to_i.to_s == piece
      piece.to_i
    else
      piece
    end
  end
end

def generate_deep_token_hash(value)
  max_depth = 5
  num_keys = 5

  keys = generate_keys(max_depth, num_keys)
  chosen_key = keys.sample

  assembled_hash = {}.extend XKeys::Auto

  keys.each_with_index do |key, i|

    assembled_hash[*clean_key(key)] = "#{Faker::Lorem.words(5).join(' ')}-#{i}"
  end
  assembled_hash[*clean_key(chosen_key)] = value

  xslt = clean_key(chosen_key)
  xslt = xslt.map do |piece|
    if piece.is_a? Fixnum
      "[#{piece}]"
    else
      "/#{piece}"
    end
  end.join
  {
    response: assembled_hash,
    xslt: xslt
  }
end

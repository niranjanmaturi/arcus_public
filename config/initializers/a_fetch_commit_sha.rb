Rails.application.config.commit_sha = '-UNKNOWN-'

filename = File.join(Rails.root, 'vendor', '.git-sha')
if File.exist?(filename)
  Rails.application.config.commit_sha = File.read(filename).strip
end

if File.exist?(File.join(Rails.root, '.git'))
  Rails.application.config.commit_sha = `git rev-parse --verify HEAD`
end


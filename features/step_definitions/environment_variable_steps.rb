Given(/^the environment variable "(.*?)" is set to "(.*?)"$/) do |arg1, arg2|
  ENV[arg1] = arg2
end
